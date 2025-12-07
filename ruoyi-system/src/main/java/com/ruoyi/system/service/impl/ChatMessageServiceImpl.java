package com.ruoyi.system.service.impl;

import java.util.List;
import java.util.Collections;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.ChatMessageMapper;
import com.ruoyi.system.domain.ChatMessage;
import com.ruoyi.system.service.IChatMessageService;

/**
 * 聊天消息Service业务层处理
 * 
 * @author ruoyi
 * @date 2025-01-01
 */
@Service
public class ChatMessageServiceImpl implements IChatMessageService 
{
    @Autowired
    private ChatMessageMapper chatMessageMapper;

    /**
     * 查询聊天消息
     * 
     * @param id 聊天消息主键
     * @return 聊天消息
     */
    @Override
    public ChatMessage selectChatMessageById(Long id)
    {
        return chatMessageMapper.selectChatMessageById(id);
    }

    /**
     * 查询聊天消息列表
     * 
     * @param chatMessage 聊天消息
     * @return 聊天消息
     */
    @Override
    public List<ChatMessage> selectChatMessageList(ChatMessage chatMessage)
    {
        return chatMessageMapper.selectChatMessageList(chatMessage);
    }

    /**
     * 查询最近的聊天消息
     * 
     * @param limit 查询数量
     * @return 聊天消息集合
     */
    @Override
    public List<ChatMessage> selectRecentChatMessages(int limit)
    {
        List<ChatMessage> messages = chatMessageMapper.selectRecentChatMessages(limit);
        // 反转顺序，使最新的消息在最后
        Collections.reverse(messages);
        return messages;
    }

    /**
     * 新增聊天消息
     * 
     * @param chatMessage 聊天消息
     * @return 结果
     */
    @Override
    public int insertChatMessage(ChatMessage chatMessage)
    {
        return chatMessageMapper.insertChatMessage(chatMessage);
    }

    /**
     * 修改聊天消息
     * 
     * @param chatMessage 聊天消息
     * @return 结果
     */
    @Override
    public int updateChatMessage(ChatMessage chatMessage)
    {
        return chatMessageMapper.updateChatMessage(chatMessage);
    }

    /**
     * 批量删除聊天消息
     * 
     * @param ids 需要删除的聊天消息主键
     * @return 结果
     */
    @Override
    public int deleteChatMessageByIds(Long[] ids)
    {
        return chatMessageMapper.deleteChatMessageByIds(ids);
    }

    /**
     * 删除聊天消息信息
     * 
     * @param id 聊天消息主键
     * @return 结果
     */
    @Override
    public int deleteChatMessageById(Long id)
    {
        return chatMessageMapper.deleteChatMessageById(id);
    }
}

