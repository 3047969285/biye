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

/**
 * 对话历史记录控制器
 * 
 * @author ruoyi
 */
@RestController
@RequestMapping("/springai/history")
public class ChatHistoryController extends BaseController {

    private static final Logger logger = LoggerFactory.getLogger(ChatHistoryController.class);

    @Autowired
    private IAiChatRecordService aiChatRecordService;

    /**
     * 安全获取用户ID
     */
    private Long getUserIdSafely() {
        try {
            return getUserId();
        } catch (Exception e) {
            logger.warn("无法获取用户ID: {}", e.getMessage());
            return null;
        }
    }

    /**
     * 获取指定类型的对话历史记录列表
     * 
     * @param chatType 对话类型：basic-基础对话，rag-知识库问答，db-数据库查询
     * @return 历史记录列表
     */
    @GetMapping("/list")
    public AjaxResult getHistoryList(@RequestParam(name = "chatType", required = false) String chatType) {
        try {
            Long userId = getUserIdSafely();
            logger.info("获取对话历史记录，用户ID: {}, 类型: {}", userId, chatType);
            
            // 如果用户ID不为null，同时查询当前用户ID和0（匿名用户）的记录
            // 因为保存时如果无法获取用户ID，会使用0作为默认值
            List<AiChatRecord> allRecords = new java.util.ArrayList<>();
            
            if (userId != null) {
                // 查询当前用户的记录
                AiChatRecord query = new AiChatRecord();
                query.setUserId(userId);
                if (chatType != null && !chatType.trim().isEmpty()) {
                    query.setChatType(chatType);
                }
                List<AiChatRecord> userRecords = aiChatRecordService.selectAiChatRecordList(query);
                allRecords.addAll(userRecords);
                logger.info("查询到用户 {} 的记录 {} 条", userId, userRecords.size());
            }
            
            // 同时查询匿名用户（user_id=0）的记录
            // 这样可以找到保存时无法获取用户ID的记录
            AiChatRecord anonymousQuery = new AiChatRecord();
            anonymousQuery.setUserId(0L);
            if (chatType != null && !chatType.trim().isEmpty()) {
                anonymousQuery.setChatType(chatType);
            }
            List<AiChatRecord> anonymousRecords = aiChatRecordService.selectAiChatRecordList(anonymousQuery);
            allRecords.addAll(anonymousRecords);
            logger.info("查询到匿名用户（user_id=0）的记录 {} 条", anonymousRecords.size());
            
            // 去重（按recordId）
            java.util.Map<Long, AiChatRecord> recordMap = new java.util.LinkedHashMap<>();
            for (AiChatRecord record : allRecords) {
                recordMap.put(record.getRecordId(), record);
            }
            List<AiChatRecord> records = new java.util.ArrayList<>(recordMap.values());
            
            // 按创建时间倒序排序
            records.sort((a, b) -> {
                if (a.getCreateTime() == null && b.getCreateTime() == null) return 0;
                if (a.getCreateTime() == null) return 1;
                if (b.getCreateTime() == null) return -1;
                return b.getCreateTime().compareTo(a.getCreateTime());
            });
            
            logger.info("去重后共 {} 条记录", records.size());
            
            // 限制返回最近50条记录
            if (records.size() > 50) {
                records = records.subList(0, 50);
            }
            
            // 打印前几条记录的详细信息用于调试
            if (records.size() > 0) {
                AiChatRecord first = records.get(0);
                logger.info("第一条记录 - ID: {}, 类型: {}, 用户消息: {}, AI消息: {}", 
                    first.getRecordId(), first.getChatType(), 
                    first.getUserMessage() != null ? first.getUserMessage().substring(0, Math.min(20, first.getUserMessage().length())) : "null",
                    first.getAiMessage() != null ? first.getAiMessage().substring(0, Math.min(20, first.getAiMessage().length())) : "null");
            }
            
            logger.info("获取对话历史记录成功，类型: {}, 数量: {}", chatType, records.size());
            
            // 直接创建 AjaxResult 并设置数据，确保数据被正确返回
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
     * 根据记录ID获取单条对话记录
     * 
     * @param recordId 记录ID
     * @return 对话记录
     */
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

    /**
     * 批量删除对话记录
     * 
     * @param recordIds 记录ID数组
     * @return 删除结果
     */
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
