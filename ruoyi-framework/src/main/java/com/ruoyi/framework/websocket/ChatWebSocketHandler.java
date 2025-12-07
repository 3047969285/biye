package com.ruoyi.framework.websocket;

import java.io.IOException;
import java.util.Date;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArraySet;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;
import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.common.constant.CacheConstants;
import com.ruoyi.common.constant.Constants;
import com.ruoyi.common.core.domain.model.LoginUser;
import com.ruoyi.common.core.redis.RedisCache;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.framework.web.service.TokenService;
import com.ruoyi.system.domain.ChatMessage;
import com.ruoyi.system.service.IChatMessageService;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import org.springframework.beans.factory.annotation.Value;

/**
 * WebSocket处理器 - 聊天室
 * 
 * @author ruoyi
 */
@Component
public class ChatWebSocketHandler extends TextWebSocketHandler
{
    private static final Logger log = LoggerFactory.getLogger(ChatWebSocketHandler.class);

    // 存储所有在线用户的session
    private static final CopyOnWriteArraySet<WebSocketSession> sessions = new CopyOnWriteArraySet<>();
    
    // 存储用户ID和session的映射（一个用户只能有一个连接）
    private static final ConcurrentHashMap<Long, WebSocketSession> userSessions = new ConcurrentHashMap<>();

    @Autowired
    private TokenService tokenService;
    
    @Autowired
    private RedisCache redisCache;
    
    @Autowired
    private IChatMessageService chatMessageService;
    
    @Value("${token.secret}")
    private String tokenSecret;

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception
    {
        // 连接建立时
        String token = (String) session.getAttributes().get("token");
        LoginUser loginUser = null;
        
        if (StringUtils.isNotEmpty(token))
        {
            try
            {
                // 解析token获取uuid
                Claims claims = Jwts.parser()
                        .setSigningKey(tokenSecret)
                        .parseClaimsJws(token)
                        .getBody();
                String uuid = (String) claims.get(Constants.LOGIN_USER_KEY);
                if (StringUtils.isNotEmpty(uuid))
                {
                    // 从Redis中获取用户信息
                    String userKey = CacheConstants.LOGIN_TOKEN_KEY + uuid;
                    loginUser = redisCache.getCacheObject(userKey);
                }
            }
            catch (Exception e)
            {
                log.error("WebSocket连接验证token失败: {}", e.getMessage());
                session.close();
                return;
            }
        }
        
        if (loginUser == null || loginUser.getUser() == null)
        {
            log.warn("WebSocket连接失败: 用户未登录");
            session.close();
            return;
        }

        Long userId = loginUser.getUserId();
        String userName = loginUser.getUser().getNickName();
        if (StringUtils.isEmpty(userName))
        {
            userName = loginUser.getUser().getUserName();
        }
        
        // 如果用户已存在连接，关闭旧连接
        if (userSessions.containsKey(userId))
        {
            WebSocketSession oldSession = userSessions.get(userId);
            if (oldSession != null && oldSession.isOpen())
            {
                log.info("用户 {} [{}] 已有连接，关闭旧连接", userName, userId);
                // 使用自定义关闭码 4000 表示"被新连接替代"，前端识别后不会重连
                // 4000-4999 是保留给应用程序使用的关闭码范围
                CloseStatus replacementStatus = new CloseStatus(4000, "新连接已建立，旧连接被关闭");
                oldSession.close(replacementStatus);
                sessions.remove(oldSession);
            }
        }
        
        // 添加新连接
        sessions.add(session);
        userSessions.put(userId, session);
        session.getAttributes().put("userId", userId);
        session.getAttributes().put("userName", userName);
        
        log.info("用户 {} [{}] 加入聊天室，当前在线人数: {}", userName, userId, sessions.size());
        
        // 保存系统消息到数据库
        ChatMessage systemMsg = new ChatMessage();
        systemMsg.setUserId(userId);
        systemMsg.setUserName(userName);
        systemMsg.setContent(userName + " 加入了聊天室");
        systemMsg.setMessageType("system");
        systemMsg.setCreateTime(new Date());
        systemMsg.setDelFlag("0");
        
        try
        {
            chatMessageService.insertChatMessage(systemMsg);
        }
        catch (Exception e)
        {
            log.error("保存系统消息到数据库失败: {}", e.getMessage());
        }
        
        // 广播用户上线消息和在线人数更新
        JSONObject onlineMessage = createSystemMessage(userName + " 加入了聊天室", userId);
        onlineMessage.put("onlineCount", sessions.size());
        broadcastMessage(onlineMessage);
        
        // 向新加入的用户发送当前在线人数
        try
        {
            JSONObject welcomeMessage = new JSONObject();
            welcomeMessage.put("type", "welcome");
            welcomeMessage.put("content", "欢迎加入聊天室！");
            welcomeMessage.put("onlineCount", sessions.size());
            welcomeMessage.put("timestamp", System.currentTimeMillis());
            session.sendMessage(new TextMessage(welcomeMessage.toJSONString()));
        }
        catch (IOException e)
        {
            log.error("发送欢迎消息失败: {}", e.getMessage());
        }
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception
    {
        // 处理接收到的消息
        try
        {
            log.info("收到WebSocket消息: {}", message.getPayload());
            JSONObject jsonMessage = JSON.parseObject(message.getPayload());
            String type = jsonMessage.getString("type");
            String content = jsonMessage.getString("content");
            
            log.info("消息类型: {}, 内容: {}", type, content);
            
            Long userId = (Long) session.getAttributes().get("userId");
            String userName = (String) session.getAttributes().get("userName");
            
            log.info("用户信息 - userId: {}, userName: {}", userId, userName);
            
            if (userId == null || userName == null)
            {
                log.warn("用户信息为空，无法发送消息");
                return;
            }
            
            if ("chat".equals(type) && StringUtils.isNotEmpty(content))
            {
                // 保存消息到数据库
                ChatMessage dbMessage = new ChatMessage();
                dbMessage.setUserId(userId);
                dbMessage.setUserName(userName);
                dbMessage.setContent(content);
                dbMessage.setMessageType("chat");
                dbMessage.setCreateTime(new Date());
                dbMessage.setDelFlag("0");
                
                try
                {
                    chatMessageService.insertChatMessage(dbMessage);
                    log.info("聊天消息已保存到数据库，消息ID: {}", dbMessage.getId());
                }
                catch (Exception e)
                {
                    log.error("保存聊天消息到数据库失败: {}", e.getMessage(), e);
                }
                
                // 创建聊天消息
                JSONObject chatMessage = createChatMessage(userId, userName, content);
                log.info("广播聊天消息: {}", chatMessage.toJSONString());
                // 广播消息
                broadcastMessage(chatMessage);
            }
            else
            {
                log.warn("消息类型不匹配或内容为空 - type: {}, content: {}", type, content);
            }
        }
        catch (Exception e)
        {
            log.error("处理WebSocket消息失败: {}", e.getMessage(), e);
        }
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception
    {
        // 连接关闭时
        Long userId = (Long) session.getAttributes().get("userId");
        String userName = (String) session.getAttributes().get("userName");
        
        sessions.remove(session);
        if (userId != null)
        {
            // 只有当前关闭的session是用户的最新session时才移除
            WebSocketSession currentSession = userSessions.get(userId);
            if (currentSession != null && currentSession.equals(session))
            {
                userSessions.remove(userId);
            }
        }
        
        if (userName != null)
        {
            log.info("用户 {} [{}] 离开聊天室，当前在线人数: {}", userName, userId, sessions.size());
            
            // 保存系统消息到数据库
            ChatMessage systemMsg = new ChatMessage();
            systemMsg.setUserId(userId);
            systemMsg.setUserName(userName);
            systemMsg.setContent(userName + " 离开了聊天室");
            systemMsg.setMessageType("system");
            systemMsg.setCreateTime(new Date());
            systemMsg.setDelFlag("0");
            
            try
            {
                chatMessageService.insertChatMessage(systemMsg);
            }
            catch (Exception e)
            {
                log.error("保存系统消息到数据库失败: {}", e.getMessage());
            }
            
            // 广播用户下线消息和在线人数更新
            JSONObject offlineMessage = createSystemMessage(userName + " 离开了聊天室", userId);
            offlineMessage.put("onlineCount", sessions.size());
            broadcastMessage(offlineMessage);
        }
    }

    @Override
    public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception
    {
        // 传输错误处理
        log.error("WebSocket传输错误: {}", exception.getMessage());
        if (session.isOpen())
        {
            session.close();
        }
    }

    /**
     * 广播消息给所有在线用户
     */
    private void broadcastMessage(JSONObject message)
    {
        TextMessage textMessage = new TextMessage(message.toJSONString());
        int successCount = 0;
        int failCount = 0;
        
        log.info("开始广播消息，当前在线人数: {}", sessions.size());
        
        for (WebSocketSession session : sessions)
        {
            try
            {
                if (session.isOpen())
                {
                    session.sendMessage(textMessage);
                    successCount++;
                }
                else
                {
                    log.warn("Session已关闭，跳过发送");
                    failCount++;
                }
            }
            catch (IOException e)
            {
                log.error("发送WebSocket消息失败: {}", e.getMessage());
                failCount++;
            }
        }
        
        log.info("消息广播完成 - 成功: {}, 失败: {}", successCount, failCount);
    }

    /**
     * 创建聊天消息
     */
    private JSONObject createChatMessage(Long userId, String userName, String content)
    {
        JSONObject message = new JSONObject();
        message.put("type", "chat");
        message.put("userId", userId);
        message.put("userName", userName);
        message.put("content", content);
        message.put("timestamp", System.currentTimeMillis());
        message.put("onlineCount", sessions.size()); // 添加在线人数
        return message;
    }

    /**
     * 创建系统消息
     */
    private JSONObject createSystemMessage(String content, Long userId)
    {
        JSONObject message = new JSONObject();
        message.put("type", "system");
        message.put("content", content);
        message.put("userId", userId);
        message.put("timestamp", System.currentTimeMillis());
        message.put("onlineCount", sessions.size()); // 添加在线人数
        return message;
    }

    /**
     * 获取在线用户数量
     */
    public static int getOnlineCount()
    {
        return sessions.size();
    }

    /**
     * 获取所有在线用户ID
     */
    public static java.util.Set<Long> getOnlineUsers()
    {
        return userSessions.keySet();
    }
}

