package com.thor.springai.controller;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.system.domain.AiChatRecord;
import com.ruoyi.system.service.IAiChatRecordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;

@RestController
@RequestMapping("/springai/history")
public class ChatHistoryController extends BaseController {

    private static final Logger logger = LoggerFactory.getLogger(ChatHistoryController.class);

    @Autowired
    private IAiChatRecordService aiChatRecordService;

    private Long getUserIdSafely() {
        try {
            return getUserId();
        } catch (Exception e) {
            logger.warn("无法获取用户ID: {}", e.getMessage());
            return null;
        }
    }

    @GetMapping("/list")
    public AjaxResult getHistoryList(@RequestParam(name = "chatType", required = false) String chatType) {
        try {
            Long userId = getUserIdSafely();
            logger.info("获取对话历史记录，用户ID: {}, 类型: {}", userId, chatType);

            List<AiChatRecord> allRecords = new java.util.ArrayList<>();

            if (userId != null) {
                AiChatRecord query = new AiChatRecord();
                query.setUserId(userId);
                if (chatType != null && !chatType.trim().isEmpty()) {
                    query.setChatType(chatType);
                }
                List<AiChatRecord> userRecords = aiChatRecordService.selectAiChatRecordList(query);
                allRecords.addAll(userRecords);
                logger.info("查询到用户 {} 的记录 {} 条", userId, userRecords.size());
            }

            AiChatRecord anonymousQuery = new AiChatRecord();
            anonymousQuery.setUserId(0L);
            if (chatType != null && !chatType.trim().isEmpty()) {
                anonymousQuery.setChatType(chatType);
            }
            List<AiChatRecord> anonymousRecords = aiChatRecordService.selectAiChatRecordList(anonymousQuery);
            allRecords.addAll(anonymousRecords);
            logger.info("查询到匿名用户（user_id=0）的记录 {} 条", anonymousRecords.size());

            java.util.Map<Long, AiChatRecord> recordMap = new java.util.LinkedHashMap<>();
            for (AiChatRecord record : allRecords) {
                recordMap.put(record.getRecordId(), record);
            }
            List<AiChatRecord> records = new java.util.ArrayList<>(recordMap.values());

            records.sort((a, b) -> {
                if (a.getCreateTime() == null && b.getCreateTime() == null) return 0;
                if (a.getCreateTime() == null) return 1;
                if (b.getCreateTime() == null) return -1;
                return b.getCreateTime().compareTo(a.getCreateTime());
            });

            logger.info("去重后共 {} 条记录", records.size());

            if (records.size() > 50) {
                records = records.subList(0, 50);
            }

            if (records.size() > 0) {
                AiChatRecord first = records.get(0);
                logger.info("第一条记录 - ID: {}, 类型: {}, 用户消息: {}, AI消息: {}",
                    first.getRecordId(), first.getChatType(),
                    first.getUserMessage() != null ? first.getUserMessage().substring(0, Math.min(20, first.getUserMessage().length())) : "null",
                    first.getAiMessage() != null ? first.getAiMessage().substring(0, Math.min(20, first.getAiMessage().length())) : "null");
            }

            logger.info("获取对话历史记录成功，类型: {}, 数量: {}", chatType, records.size());

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

    @GetMapping("/{recordId}")
    public AjaxResult getHistoryById(@PathVariable Long recordId) {
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

    @DeleteMapping("/delete")
    public AjaxResult deleteRecords(@RequestBody Long[] recordIds) {
        try {
            if (recordIds == null || recordIds.length == 0) {
                return AjaxResult.error("请选择要删除的记录");
            }

            Long userId = getUserIdSafely();
            logger.info("用户 {} 请求删除 {} 条记录", userId, recordIds.length);

            int result = aiChatRecordService.deleteAiChatRecordByRecordIds(recordIds);
            logger.info("删除成功，删除了 {} 条记录", result);

            return AjaxResult.success("删除成功，共删除 " + result + " 条记录");
        } catch (Exception e) {
            logger.error("删除对话记录失败: ", e);
            return AjaxResult.error("删除失败: " + e.getMessage());
        }
    }
}
