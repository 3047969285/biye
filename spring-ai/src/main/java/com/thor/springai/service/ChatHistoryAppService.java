package com.thor.springai.service;

import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.system.domain.AiChatRecord;
import com.ruoyi.system.service.IAiChatRecordService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 对话历史应用服务
 *
 * @author thor
 */
@Service
public class ChatHistoryAppService {

    private static final Logger logger = LoggerFactory.getLogger(ChatHistoryAppService.class);
    private final IAiChatRecordService aiChatRecordService;

    public ChatHistoryAppService(IAiChatRecordService aiChatRecordService) {
        this.aiChatRecordService = aiChatRecordService;
    }

    /**
     * 获取对话历史列表
     *
     * @param userId 用户ID
     * @param chatType 对话类型
     * @return 历史记录
     */
    public AjaxResult getHistoryList(Long userId, String chatType) {
        try {
            List<AiChatRecord> allRecords = new ArrayList<>();
            if (userId != null) {
                AiChatRecord query = new AiChatRecord();
                query.setUserId(userId);
                if (chatType != null && !chatType.trim().isEmpty()) {
                    query.setChatType(chatType);
                }
                allRecords.addAll(aiChatRecordService.selectAiChatRecordList(query));
            }

            AiChatRecord anonymousQuery = new AiChatRecord();
            anonymousQuery.setUserId(0L);
            if (chatType != null && !chatType.trim().isEmpty()) {
                anonymousQuery.setChatType(chatType);
            }
            allRecords.addAll(aiChatRecordService.selectAiChatRecordList(anonymousQuery));

            Map<Long, AiChatRecord> recordMap = new LinkedHashMap<>();
            for (AiChatRecord record : allRecords) {
                recordMap.put(record.getRecordId(), record);
            }
            List<AiChatRecord> records = new ArrayList<>(recordMap.values());
            records.sort((a, b) -> {
                if (a.getCreateTime() == null && b.getCreateTime() == null) return 0;
                if (a.getCreateTime() == null) return 1;
                if (b.getCreateTime() == null) return -1;
                return b.getCreateTime().compareTo(a.getCreateTime());
            });
            if (records.size() > 50) {
                records = records.subList(0, 50);
            }
            AjaxResult result = new AjaxResult();
            result.put(AjaxResult.CODE_TAG, 200);
            result.put(AjaxResult.MSG_TAG, "操作成功");
            result.put(AjaxResult.DATA_TAG, records);
            return result;
        } catch (Exception e) {
            logger.error("获取对话历史记录失败: ", e);
            return AjaxResult.error("获取失败: " + e.getMessage());
        }
    }

    /**
     * 获取对话历史详情
     *
     * @param recordId 记录ID
     * @return 记录详情
     */
    public AjaxResult getHistoryById(Long recordId) {
        try {
            AiChatRecord record = aiChatRecordService.selectAiChatRecordByRecordId(recordId);
            if (record == null) {
                return AjaxResult.error("记录不存在");
            }
            return AjaxResult.success(record);
        } catch (Exception e) {
            logger.error("获取对话记录失败: ", e);
            return AjaxResult.error("获取失败: " + e.getMessage());
        }
    }

    /**
     * 删除对话历史
     *
     * @param userId 用户ID
     * @param recordIds 记录ID数组
     * @return 删除结果
     */
    public AjaxResult deleteRecords(Long userId, Long[] recordIds) {
        try {
            if (recordIds == null || recordIds.length == 0) {
                return AjaxResult.error("请选择要删除的记录");
            }
            logger.info("用户 {} 请求删除 {} 条记录", userId, recordIds.length);
            int result = aiChatRecordService.deleteAiChatRecordByRecordIds(recordIds);
            return AjaxResult.success("删除成功，共删除 " + result + " 条记录");
        } catch (Exception e) {
            logger.error("删除对话记录失败: ", e);
            return AjaxResult.error("删除失败: " + e.getMessage());
        }
    }
}
