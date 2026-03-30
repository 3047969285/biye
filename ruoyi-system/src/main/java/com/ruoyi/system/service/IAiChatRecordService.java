package com.ruoyi.system.service;

import com.ruoyi.system.domain.AiChatRecord;
import java.util.List;

public interface IAiChatRecordService {

    List<AiChatRecord> selectAiChatRecordList(AiChatRecord aiChatRecord);

    AiChatRecord selectAiChatRecordByRecordId(Long recordId);

    int insertAiChatRecord(AiChatRecord aiChatRecord);

    int updateAiMessage(Long recordId, String aiMessage);

    int deleteAiChatRecordByRecordId(Long recordId);

    int deleteAiChatRecordByRecordIds(Long[] recordIds);
}
