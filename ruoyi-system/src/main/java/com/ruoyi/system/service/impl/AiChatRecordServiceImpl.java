package com.ruoyi.system.service.impl;

import com.ruoyi.system.domain.AiChatRecord;
import com.ruoyi.system.mapper.AiChatRecordMapper;
import com.ruoyi.system.service.IAiChatRecordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 智能问答对话记录 Service业务层处理
 * 
 * @author ruoyi
 * @date 2025-01-01
 */
@Service
public class AiChatRecordServiceImpl implements IAiChatRecordService {
    @Autowired
    private AiChatRecordMapper aiChatRecordMapper;

    /**
     * 查询对话记录列表
     * 
     * @param aiChatRecord 对话记录
     * @return 对话记录集合
     */
    @Override
    public List<AiChatRecord> selectAiChatRecordList(AiChatRecord aiChatRecord) {
        return aiChatRecordMapper.selectAiChatRecordList(aiChatRecord);
    }

    /**
     * 根据记录ID查询对话记录
     * 
     * @param recordId 记录ID
     * @return 对话记录
     */
    @Override
    public AiChatRecord selectAiChatRecordByRecordId(Long recordId) {
        return aiChatRecordMapper.selectAiChatRecordByRecordId(recordId);
    }

    /**
     * 新增对话记录
     * 
     * @param aiChatRecord 对话记录
     * @return 结果
     */
    @Override
    public int insertAiChatRecord(AiChatRecord aiChatRecord) {
        return aiChatRecordMapper.insertAiChatRecord(aiChatRecord);
    }

    /**
     * 更新AI回复消息
     * 
     * @param recordId 记录ID
     * @param aiMessage AI回复消息
     * @return 结果
     */
    @Override
    public int updateAiMessage(Long recordId, String aiMessage) {
        return aiChatRecordMapper.updateAiMessage(recordId, aiMessage);
    }

    /**
     * 删除对话记录
     * 
     * @param recordId 记录ID
     * @return 结果
     */
    @Override
    public int deleteAiChatRecordByRecordId(Long recordId) {
        return aiChatRecordMapper.deleteAiChatRecordByRecordId(recordId);
    }

    /**
     * 批量删除对话记录
     * 
     * @param recordIds 需要删除的记录ID
     * @return 结果
     */
    @Override
    public int deleteAiChatRecordByRecordIds(Long[] recordIds) {
        return aiChatRecordMapper.deleteAiChatRecordByRecordIds(recordIds);
    }
}
