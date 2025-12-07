package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.ChatMessage;

/**
 * 聊天消息Service接口
 * 
 * @author ruoyi
 * @date 2025-01-01
 */
public interface IChatMessageService 
{
    /**
     * 查询聊天消息
     * 
     * @param id 聊天消息主键
     * @return 聊天消息
     */
    public ChatMessage selectChatMessageById(Long id);

    /**
     * 查询聊天消息列表
     * 
     * @param chatMessage 聊天消息
     * @return 聊天消息集合
     */
    public List<ChatMessage> selectChatMessageList(ChatMessage chatMessage);

    /**
     * 查询最近的聊天消息
     * 
     * @param limit 查询数量
     * @return 聊天消息集合
     */
    public List<ChatMessage> selectRecentChatMessages(int limit);

    /**
     * 新增聊天消息
     * 
     * @param chatMessage 聊天消息
     * @return 结果
     */
    public int insertChatMessage(ChatMessage chatMessage);

    /**
     * 修改聊天消息
     * 
     * @param chatMessage 聊天消息
     * @return 结果
     */
    public int updateChatMessage(ChatMessage chatMessage);

    /**
     * 批量删除聊天消息
     * 
     * @param ids 需要删除的聊天消息主键集合
     * @return 结果
     */
    public int deleteChatMessageByIds(Long[] ids);

    /**
     * 删除聊天消息信息
     * 
     * @param id 聊天消息主键
     * @return 结果
     */
    public int deleteChatMessageById(Long id);
}

