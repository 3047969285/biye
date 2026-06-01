package com.thor.springai.service;

import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.system.domain.AiChatRecord;
import com.ruoyi.system.service.IAiChatRecordService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.function.Supplier;

/**
 * 数据库查询应用服务
 *
 * @author wangchangzhen
 */
@Service
public class DatabaseQueryAppService {

    private static final Logger logger = LoggerFactory.getLogger(DatabaseQueryAppService.class);

    private final DatabaseQueryService databaseQueryService;
    private final IAiChatRecordService aiChatRecordService;
    private final ChatClient chatClient;
    private final int memoryTurns;

    public DatabaseQueryAppService(DatabaseQueryService databaseQueryService, IAiChatRecordService aiChatRecordService,
        ChatClient.Builder builder, @Value("${app.chat.memory-turns:6}") int memoryTurns) {
        this.databaseQueryService = databaseQueryService;
        this.aiChatRecordService = aiChatRecordService;
        this.chatClient = builder.build();
        this.memoryTurns = memoryTurns;
    }

    /**
     * 自然语言查询数据库
     *
     * @param question 用户问题
     * @param userId 用户ID
     * @param userName 用户名
     * @return 查询结果
     */
    public AjaxResult askDatabase(String question, Long userId, String userName, String conversationId) {
        try {
            String normalizedConversationId = normalizeConversationId(conversationId, userId);
            AiChatRecord record = new AiChatRecord();
            record.setUserId(userId == null ? 0L : userId);
            record.setUserName(userName == null ? "匿名用户" : userName);
            record.setChatType("db");
            record.setConversationId(normalizedConversationId);
            record.setUserMessage(question);
            try {
                aiChatRecordService.insertAiChatRecord(record);
            } catch (Exception e) {
                logger.warn("保存对话记录失败: {}", e.getMessage());
            }

            String dbContext = databaseQueryService.getDatabaseContext();
            String questionWithHistory = buildQuestionWithHistory(record.getUserId(), normalizedConversationId, record.getRecordId(), question);
            String prompt = String.format(
                "你是一个数据库查询专家。基于以下数据库结构，将用户的问题转换为 SQL 查询语句。\n\n%s\n\n用户问题：%s\n\n请生成对应的 SQL 查询语句（只返回 SQL，不要其他解释，不要使用Markdown格式）：",
                dbContext, questionWithHistory
            );
            String sql = chatClient.prompt().user(prompt).call().content();
            if (sql == null || sql.trim().isEmpty()) {
                return AjaxResult.error("AI 未能生成 SQL，请重试或检查提示词。");
            }
            sql = cleanMarkdown(sql.trim())
                .replaceFirst("^```sql", "")
                .replaceFirst("^```", "")
                .replaceFirst("```$", "")
                .trim();

            Map<String, Object> result = databaseQueryService.executeQuery(sql);
            Map<String, Object> resp = new HashMap<>(result);
            String aiMessage;
            if (Boolean.TRUE.equals(result.get("success"))) {
                String summary = databaseQueryService.summarizeResult(question, sql, result);
                String readable = databaseQueryService.buildReadableSummary(result);
                String finalSummary = (summary != null && !summary.trim().isEmpty()) ? summary.trim() : readable;
                finalSummary = cleanMarkdown(finalSummary);
                resp.put("aiSummary", finalSummary);
                resp.put("readableSummary", readable);
                resp.put("rawData", result.get("data"));
                resp.remove("data");
                aiMessage = String.format("查询结果（%d 条）\n%s",
                    result.get("rowCount") != null ? ((Number) result.get("rowCount")).intValue() : 0,
                    finalSummary);
            } else {
                aiMessage = "查询失败：%s".formatted(result.get("error") != null ? result.get("error").toString() : "未知错误");
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
            return AjaxResult.error("查询失败: %s".formatted(e.getMessage()));
        }
    }

    /**
     * 执行指定 SQL
     *
     * @param sql SQL语句
     * @return 查询结果
     */
    public AjaxResult executeQuery(String sql) {
        try {
            return AjaxResult.success(databaseQueryService.executeQuery(sql));
        } catch (Exception e) {
            logger.error("执行 SQL 失败: ", e);
            return AjaxResult.error("查询失败: %s".formatted(e.getMessage()));
        }
    }

    /**
     * 获取所有表名
     *
     * @return 表列表
     */
    public AjaxResult getTables() {
        return safeExecute(databaseQueryService::getAllTables, "获取表列表失败");
    }

    /**
     * 获取表结构
     *
     * @param tableName 表名
     * @return 表结构
     */
    public AjaxResult getTableStructure(String tableName) {
        return safeExecute(() -> databaseQueryService.getTableStructure(tableName), "获取表结构失败");
    }

    /**
     * 获取数据库统计信息
     *
     * @return 统计信息
     */
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
            return AjaxResult.error("获取失败: %s".formatted(e.getMessage()));
        }
    }

    /**
     * 获取数据库上下文信息
     *
     * @return 上下文内容
     */
    public AjaxResult getDatabaseContext() {
        return safeExecute(databaseQueryService::getDatabaseContext, "获取数据库上下文失败");
    }

    private String buildQuestionWithHistory(Long userId, String conversationId, Long currentRecordId, String currentQuestion) {
        String question = currentQuestion == null ? "" : currentQuestion;
        if (memoryTurns <= 0) {
            return question;
        }
        List<AiChatRecord> records = fetchRecentHistory(userId, conversationId, currentRecordId, memoryTurns);
        if (records.isEmpty()) {
            return question;
        }
        StringBuilder sb = new StringBuilder();
        sb.append("以下是最近对话上下文，请结合上下文连续回答。\n");
        for (AiChatRecord r : records) {
            if (isNotBlank(r.getUserMessage())) {
                sb.append("用户：").append(r.getUserMessage().trim()).append("\n");
            }
            if (isNotBlank(r.getAiMessage())) {
                sb.append("助手：").append(r.getAiMessage().trim()).append("\n");
            }
        }
        sb.append("\n当前用户问题：").append(question);
        return sb.toString();
    }

    private List<AiChatRecord> fetchRecentHistory(Long userId, String conversationId, Long currentRecordId, int maxTurns) {
        AiChatRecord query = new AiChatRecord();
        query.setUserId(userId == null ? 0L : userId);
        query.setChatType("db");
        query.setConversationId(conversationId);
        List<AiChatRecord> all = aiChatRecordService.selectAiChatRecordList(query);
        if (all == null || all.isEmpty()) {
            return Collections.emptyList();
        }
        List<AiChatRecord> selected = new ArrayList<>();
        for (AiChatRecord item : all) {
            if (item == null) {
                continue;
            }
            if (currentRecordId != null && currentRecordId.equals(item.getRecordId())) {
                continue;
            }
            if (selected.size() >= maxTurns) {
                break;
            }
            selected.add(item);
        }
        Collections.reverse(selected);
        return selected;
    }

    private String normalizeConversationId(String conversationId, Long userId) {
        if (isNotBlank(conversationId)) {
            return conversationId.trim();
        }
        long safeUserId = userId == null ? 0L : userId;
        return "legacy-db-%d-%s".formatted(safeUserId, UUID.randomUUID());
    }

    private String cleanMarkdown(String text) {
        if (text == null) {
            return "";
        }
        return text
            .replaceAll("^#+\\s*", "")
            .replaceAll("\\*\\*(.*?)\\*\\*", "$1")
            .replaceAll("\\*(.*?)\\*", "$1")
            .replaceAll("`([^`]+)`", "$1")
            .replaceAll("```[\\s\\S]*?```", "")
            .replaceAll("\\[([^]]+)]\\([^)]+\\)", "$1")
            .replaceAll("^\\s*[-*+]\\s+", "")
            .replaceAll("^\\s*\\d+\\.\\s+", "")
            .trim();
    }

    private AjaxResult safeExecute(Supplier<Object> supplier, String errorLogPrefix) {
        try {
            return AjaxResult.success(supplier.get());
        } catch (Exception e) {
            logger.error("{}: {}", errorLogPrefix, e.getMessage(), e);
            return AjaxResult.error("获取失败: %s".formatted(e.getMessage()));
        }
    }

    private boolean isNotBlank(String value) {
        return value != null && !value.trim().isEmpty();
    }
}
