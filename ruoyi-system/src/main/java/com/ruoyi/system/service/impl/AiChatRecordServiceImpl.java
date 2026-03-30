package com.ruoyi.system.service.impl;

import com.ruoyi.system.domain.AiChatRecord;
import com.ruoyi.system.mapper.AiChatRecordMapper;
import com.ruoyi.system.service.IAiChatRecordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AiChatRecordServiceImpl implements IAiChatRecordService {
    @Autowired
    private AiChatRecordMapper aiChatRecordMapper;

    @Override
    public List<AiChatRecord> selectAiChatRecordList(AiChatRecord aiChatRecord) {
        return aiChatRecordMapper.selectAiChatRecordList(aiChatRecord);
    }

    @Override
    public AiChatRecord selectAiChatRecordByRecordId(Long recordId) {
        return aiChatRecordMapper.selectAiChatRecordByRecordId(recordId);
    }

    @Override
    public int insertAiChatRecord(AiChatRecord aiChatRecord) {
        return aiChatRecordMapper.insertAiChatRecord(aiChatRecord);
    }

    @Override
    public int updateAiMessage(Long recordId, String aiMessage) {
        return aiChatRecordMapper.updateAiMessage(recordId, aiMessage);
    }

    @Override
    public int deleteAiChatRecordByRecordId(Long recordId) {
        return aiChatRecordMapper.deleteAiChatRecordByRecordId(recordId);
    }

    @Override
    public int deleteAiChatRecordByRecordIds(Long[] recordIds) {
        return aiChatRecordMapper.deleteAiChatRecordByRecordIds(recordIds);
    }
}
