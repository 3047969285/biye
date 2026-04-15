package com.ruoyi.framework.websocket;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.io.IOException;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

/**
 * Minimal WebSocket handler used for notification or future extensions.
 */
@Component
public class BaseWebSocketHandler extends TextWebSocketHandler
{
    private static final Logger log = LoggerFactory.getLogger(BaseWebSocketHandler.class);

    /** 当前在线的会话集合，用于广播通知 */
    private static final Set<WebSocketSession> SESSIONS = Collections.synchronizedSet(new HashSet<>());

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception
    {
        SESSIONS.add(session);
        log.info("WebSocket connected: {}", session.getId());
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, org.springframework.web.socket.CloseStatus status) throws Exception
    {
        SESSIONS.remove(session);
        log.info("WebSocket closed: {} - {}", session.getId(), status);
    }

    @Override
    public void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception
    {
        log.debug("Received WebSocket message ({}): {}", session.getId(), message.getPayload());
        session.sendMessage(new TextMessage("{\"status\":\"ok\"}"));
    }

    /**
     * 向所有在线 WebSocket 客户端广播一条文本消息
     */
    public void broadcast(String payload)
    {
        TextMessage textMessage = new TextMessage(payload);
        synchronized (SESSIONS)
        {
            for (WebSocketSession session : SESSIONS)
            {
                try
                {
                    if (session.isOpen())
                    {
                        session.sendMessage(textMessage);
                    }
                }
                catch (IOException e)
                {
                    log.warn("Failed to send WebSocket message to {}: {}", session.getId(), e.getMessage());
                }
            }
        }
    }
}
