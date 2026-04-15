package com.thor.springai.controller;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.system.domain.AiChatRecord;
import com.ruoyi.system.service.IAiChatRecordService;
import com.thor.springai.service.DatabaseQueryService;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.util.Map;

@RestController
@RequestMapping("/springai/db")
public class DatabaseQueryController extends BaseController {

    private static final Logger logger = LoggerFactory.getLogger(DatabaseQueryController.class);

    @Autowired
    private DatabaseQueryService databaseQueryService;

    private final ChatClient chatClient;
    
    @Autowired
    public DatabaseQueryController(ChatClient.Builder builder) {
        this.chatClient = builder.build();
    }

    @Autowired
    private IAiChatRecordService aiChatRecordService;

    private String cleanMarkdown(String text) {
        if (text == null) return "";
        return text
            .replaceAll("^#+\\s*", "")
            .replaceAll("\\*\\*(.*?)\\*\\*", "$1")
            .replaceAll("\\*(.*?)\\*", "$1")
            .replaceAll("`([^`]+)`", "$1")
            .replaceAll("```[\\s\\S]*?```", "")
            .replaceAll("\\[([^\\]]+)\\]\\([^\\)]+\\)", "$1")
            .replaceAll("^\\s*[-*+]\\s+", "")
            .replaceAll("^\\s*\\d+\\.\\s+", "")
            .trim();
    }

    private Long getUserIdSafely() {
        try {
            return getUserId();
        } catch (Exception e) {
            logger.warn("无法获取用户ID: {}", e.getMessage());
            return null;
        }
    }

    private String getUsernameSafely() {
        try {
            return getUsername();
        } catch (Exception e) {
            logger.warn("无法获取用户名: {}", e.getMessage());
            return "匿名用户";
        }
    }

    @GetMapping("/ask")
    public AjaxResult askDatabase(@RequestParam(name = "question") String question) {
        try {
            AiChatRecord record = new AiChatRecord();
            Long userId = getUserIdSafely();
            String userName = getUsernameSafely();

            if (userId == null) {
                userId = 0L;
                logger.warn("用户ID为null，使用默认值0（匿名用户）");
            }

            record.setUserId(userId);
            record.setUserName(userName != null ? userName : "匿名用户");
            record.setChatType("db");
            record.setUserMessage(question);
            try {
                aiChatRecordService.insertAiChatRecord(record);
            } catch (Exception e) {
                logger.error("保存对话记录失败: ", e);
            }

            String dbContext = databaseQueryService.getDatabaseContext();

            String prompt = String.format(
                "你是一个数据库查询专家。基于以下数据库结构，将用户的问题转换为 SQL 查询语句。\n\n" +
                "%s\n\n" +
                "用户问题：%s\n\n" +
                "请生成对应的 SQL 查询语句（只返回 SQL，不要其他解释，不要使用Markdown格式）：",
                dbContext, question
            );

            java.util.Objects.requireNonNull(prompt, "prompt");

            String sql = chatClient.prompt()
                    .user(prompt)
                    .call()
                    .content();
            if (sql == null || sql.trim().isEmpty()) {
                return AjaxResult.error("AI 未能生成 SQL，请重试或检查提示词。");
            }
            sql = sql.trim();

            sql = cleanMarkdown(sql);
            if (sql.startsWith("```sql")) {
                sql = sql.substring(6);
            }
            if (sql.startsWith("```")) {
                sql = sql.substring(3);
            }
            if (sql.endsWith("```")) {
                sql = sql.substring(0, sql.length() - 3);
            }
            sql = sql.trim();

            logger.info("AI 生成的 SQL: {}", sql);

            Map<String, Object> result = databaseQueryService.executeQuery(sql);
            Map<String, Object> resp = new java.util.HashMap<>(result);

            String aiMessage = "";
            if (Boolean.TRUE.equals(result.get("success"))) {
                String summary = databaseQueryService.summarizeResult(question, sql, result);
                String readable = databaseQueryService.buildReadableSummary(result);
                String finalSummary = (summary != null && !summary.trim().isEmpty())
                        ? summary.trim()
                        : readable;
                finalSummary = cleanMarkdown(finalSummary);
                resp.put("aiSummary", finalSummary);
                resp.put("readableSummary", readable);
                resp.put("rawData", result.get("data"));
                resp.remove("data");

                aiMessage = String.format("查询结果（%d 条）\n%s",
                    result.get("rowCount") != null ? ((Number)result.get("rowCount")).intValue() : 0,
                    finalSummary);
            } else {
                aiMessage = "查询失败：" + (result.get("error") != null ? result.get("error").toString() : "未知错误");
            }

            if (record.getRecordId() != null) {
                try {
                    aiChatRecordService.updateAiMessage(record.getRecordId(), aiMessage);
                } catch (Exception e) {
                    logger.warn("更新AI回复失败: {}", e.getMessage());
                }
            }

            return AjaxResult.success(resp);

        } catch (Exception e) {
            logger.error("AI 数据库查询失败: ", e);
            return AjaxResult.error("查询失败: " + e.getMessage());
        }
    }

    @PostMapping("/query")
    public AjaxResult executeQuery(@RequestParam(name = "sql") String sql) {
        try {
            var result = databaseQueryService.executeQuery(sql);
            return AjaxResult.success(result);
        } catch (Exception e) {
            logger.error("执行 SQL 失败: ", e);
            return AjaxResult.error("查询失败: " + e.getMessage());
        }
    }

    @GetMapping("/tables")
    public AjaxResult getTables() {
        try {
            return AjaxResult.success(databaseQueryService.getAllTables());
        } catch (Exception e) {
            logger.error("获取表列表失败: ", e);
            return AjaxResult.error("获取失败: " + e.getMessage());
        }
    }

    @GetMapping("/tables/{tableName}")
    public AjaxResult getTableStructure(@PathVariable(name = "tableName") String tableName) {
        try {
            String result = databaseQueryService.getTableStructure(tableName);
            return AjaxResult.success(result);
        } catch (Exception e) {
            logger.error("获取表结构失败: ", e);
            return AjaxResult.error("获取失败: " + e.getMessage());
        }
    }

    @GetMapping("/stats")
    public AjaxResult getStats() {
        try {
            String stats = databaseQueryService.getMaintenanceFormStats();
            if (stats == null || stats.trim().isEmpty()) {
                stats = "暂无统计信息";
            }
            AjaxResult result = new AjaxResult();
            result.put(AjaxResult.CODE_TAG, 200);
            result.put(AjaxResult.MSG_TAG, "操作成功");
            result.put(AjaxResult.DATA_TAG, stats);
            return result;
        } catch (Exception e) {
            logger.error("获取统计信息失败: ", e);
            return AjaxResult.error("获取失败: " + e.getMessage());
        }
    }

    @GetMapping("/context")
    public AjaxResult getDatabaseContext() {
        try {
            String context = databaseQueryService.getDatabaseContext();
            return AjaxResult.success(context);
        } catch (Exception e) {
            logger.error("获取数据库上下文失败: ", e);
            return AjaxResult.error("获取失败: " + e.getMessage());
        }
    }
}
