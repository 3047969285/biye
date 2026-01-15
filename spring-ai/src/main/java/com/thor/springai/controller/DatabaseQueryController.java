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

/**
 * 数据库智能查询控制器 - AI 辅助数据库查询
 * 
 * @author ruoyi
 */
@RestController
@RequestMapping("/springai/db")
public class DatabaseQueryController extends BaseController {

    private static final Logger logger = LoggerFactory.getLogger(DatabaseQueryController.class);

    @Autowired
    private DatabaseQueryService databaseQueryService;

    @Autowired
    private ChatClient chatClient;
    
    @Autowired
    private IAiChatRecordService aiChatRecordService;
    
    /**
     * 清理Markdown符号
     */
    private String cleanMarkdown(String text) {
        if (text == null) return "";
        return text
            .replaceAll("^#+\\s*", "") // 去除标题符号 #
            .replaceAll("\\*\\*(.*?)\\*\\*", "$1") // 去除粗体 **
            .replaceAll("\\*(.*?)\\*", "$1") // 去除斜体 *
            .replaceAll("`([^`]+)`", "$1") // 去除行内代码 `
            .replaceAll("```[\\s\\S]*?```", "") // 去除代码块
            .replaceAll("\\[([^\\]]+)\\]\\([^\\)]+\\)", "$1") // 去除链接
            .replaceAll("^\\s*[-*+]\\s+", "") // 去除无序列表
            .replaceAll("^\\s*\\d+\\.\\s+", "") // 去除有序列表
            .trim();
    }

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
     * 安全获取用户名
     */
    private String getUsernameSafely() {
        try {
            return getUsername();
        } catch (Exception e) {
            logger.warn("无法获取用户名: {}", e.getMessage());
            return "匿名用户";
        }
    }

    /**
     * AI 辅助数据库查询
     * 用自然语言描述查询需求，AI 自动生成 SQL 并执行
     * 
     * @param question 自然语言查询问题
     * @return 查询结果
     */
    @GetMapping("/ask")
    public AjaxResult askDatabase(@RequestParam(name = "question") String question) {
        try {
            // 保存用户消息
            AiChatRecord record = new AiChatRecord();
            Long userId = getUserIdSafely();
            String userName = getUsernameSafely();
            
            // 如果用户ID为null，设置为0（匿名用户）
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
            
            // 获取数据库上下文
            String dbContext = databaseQueryService.getDatabaseContext();
            
            // 构建提示词
            String prompt = String.format(
                "你是一个数据库查询专家。基于以下数据库结构，将用户的问题转换为 SQL 查询语句。\n\n" +
                "%s\n\n" +
                "用户问题：%s\n\n" +
                "请生成对应的 SQL 查询语句（只返回 SQL，不要其他解释，不要使用Markdown格式）：",
                dbContext, question
            );
            
            java.util.Objects.requireNonNull(prompt, "prompt");

            // 让 AI 生成 SQL
            String sql = chatClient.prompt()
                    .user(prompt)
                    .call()
                    .content();
            if (sql == null || sql.trim().isEmpty()) {
                return AjaxResult.error("AI 未能生成 SQL，请重试或检查提示词。");
            }
            sql = sql.trim();
            
            // 清理 SQL（移除 markdown 代码块标记）
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
            
            // 执行查询
            Map<String, Object> result = databaseQueryService.executeQuery(sql);
            Map<String, Object> resp = new java.util.HashMap<>(result);

            // 成功时追加 AI 总结（大模型摘要 + 易读摘要）
            String aiMessage = "";
            if (Boolean.TRUE.equals(result.get("success"))) {
                String summary = databaseQueryService.summarizeResult(question, sql, result);
                String readable = databaseQueryService.buildReadableSummary(result);
                // 优先返回可读摘要，其次 AI 摘要
                String finalSummary = (summary != null && !summary.trim().isEmpty())
                        ? summary.trim()
                        : readable;
                finalSummary = cleanMarkdown(finalSummary);
                resp.put("aiSummary", finalSummary);
                resp.put("readableSummary", readable);
                // 保留原始数据但迁移到 rawData，避免前端直接展示大列表
                resp.put("rawData", result.get("data"));
                resp.remove("data");
                
                // 构建完整的AI回复消息
                aiMessage = String.format("查询结果（%d 条）\n%s", 
                    result.get("rowCount") != null ? ((Number)result.get("rowCount")).intValue() : 0,
                    finalSummary);
            } else {
                aiMessage = "查询失败：" + (result.get("error") != null ? result.get("error").toString() : "未知错误");
            }
            
            // 更新AI回复
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

    /**
     * 直接执行 SQL 查询（仅支持 SELECT）
     * 
     * @param sql SQL 查询语句
     * @return 查询结果
     */
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

    /**
     * 获取所有表名
     */
    @GetMapping("/tables")
    public AjaxResult getTables() {
        try {
            return AjaxResult.success(databaseQueryService.getAllTables());
        } catch (Exception e) {
            logger.error("获取表列表失败: ", e);
            return AjaxResult.error("获取失败: " + e.getMessage());
        }
    }

    /**
     * 获取表结构
     */
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

    /**
     * 获取数据库统计信息
     */
    @GetMapping("/stats")
    public AjaxResult getStats() {
        try {
            logger.info("开始获取数据库统计信息");
            String stats = databaseQueryService.getMaintenanceFormStats();
            logger.info("获取数据库统计信息成功，长度: {}", stats != null ? stats.length() : 0);
            logger.info("统计信息内容预览（前100字符）: {}", stats != null && stats.length() > 100 ? stats.substring(0, 100) : stats);
            
            if (stats == null || stats.trim().isEmpty()) {
                logger.warn("数据库统计信息为空");
                stats = "暂无统计信息";
            }
            
            // 直接创建 AjaxResult 并设置数据，确保数据被正确设置
            AjaxResult result = new AjaxResult();
            result.put(AjaxResult.CODE_TAG, 200);
            result.put(AjaxResult.MSG_TAG, "操作成功");
            result.put(AjaxResult.DATA_TAG, stats); // 直接设置，不经过 StringUtils.isNotNull 检查
            
            logger.info("返回 AjaxResult，data 是否为 null: {}", result.get("data") == null);
            logger.info("返回 AjaxResult，data 类型: {}", result.get("data") != null ? result.get("data").getClass().getName() : "null");
            logger.info("返回 AjaxResult，data 长度: {}", result.get("data") != null && result.get("data") instanceof String ? ((String)result.get("data")).length() : "N/A");
            
            return result;
        } catch (Exception e) {
            logger.error("获取统计信息失败: ", e);
            return AjaxResult.error("获取失败: " + e.getMessage());
        }
    }

    /**
     * 获取数据库上下文信息
     */
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
