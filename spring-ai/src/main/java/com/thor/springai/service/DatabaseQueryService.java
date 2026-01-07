package com.thor.springai.service;

import com.alibaba.fastjson2.JSON;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.fasterxml.jackson.databind.SerializationFeature;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.util.*;

/**
 * 数据库查询服务 - 为 AI 提供数据库查询能力
 * 
 * @author ruoyi
 */
@Service
public class DatabaseQueryService {

    private static final Logger logger = LoggerFactory.getLogger(DatabaseQueryService.class);
    private static final ObjectMapper MAPPER = new ObjectMapper()
            .registerModule(new JavaTimeModule())
            .disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);

    private final JdbcTemplate jdbcTemplate;
    private final ChatClient chatClient;

    public DatabaseQueryService(JdbcTemplate jdbcTemplate, ChatClient.Builder chatClientBuilder) {
        this.jdbcTemplate = jdbcTemplate;
        this.chatClient = chatClientBuilder.build();
    }

    /**
     * 执行查询 SQL（安全模式，只允许 SELECT）
     * 
     * @param sql SQL 查询语句
     * @return 查询结果（JSON 格式）
     */
    public Map<String, Object> executeQuery(String sql) {
        try {
            // 安全检查：只允许 SELECT 语句
            String sqlLower = sql.trim().toLowerCase();
            if (!sqlLower.startsWith("select")) {
                return Map.of(
                    "success", false,
                    "error", "只允许执行 SELECT 查询语句"
                );
            }

            // 执行查询
            List<Map<String, Object>> results = jdbcTemplate.queryForList(sql);
            
            logger.info("数据库查询成功，返回 {} 条记录", results.size());
            
            return Map.of(
                "success", true,
                "rowCount", results.size(),
                "data", results
            );
            
        } catch (Exception e) {
            logger.error("数据库查询失败: SQL={}, Error={}", sql, e.getMessage());
            return Map.of(
                "success", false,
                "error", e.getMessage()
            );
        }
    }

    /**
     * 获取所有表名
     */
    public List<String> getAllTables() {
        try {
            String sql = "SHOW TABLES";
            List<Map<String, Object>> results = jdbcTemplate.queryForList(sql);
            
            List<String> tables = new ArrayList<>();
            for (Map<String, Object> row : results) {
                // 获取第一列的值（表名）
                Object tableName = row.values().iterator().next();
                if (tableName != null) {
                    tables.add(tableName.toString());
                }
            }
            
            return tables;
        } catch (Exception e) {
            logger.error("获取表列表失败: ", e);
            return Collections.emptyList();
        }
    }

    /**
     * 获取表结构信息
     */
    public String getTableStructure(String tableName) {
        try {
            String sql = "DESC " + tableName;
            List<Map<String, Object>> results = jdbcTemplate.queryForList(sql);
            
            return JSON.toJSONString(Map.of(
                "success", true,
                "table", tableName,
                "structure", results
            ));
            
        } catch (Exception e) {
            logger.error("获取表结构失败: Table={}, Error={}", tableName, e.getMessage());
            return JSON.toJSONString(Map.of(
                "success", false,
                "error", e.getMessage()
            ));
        }
    }

    /**
     * 查询运维表单统计信息
     */
    public String getMaintenanceFormStats() {
        try {
            // 先检查表是否存在
            List<String> tables = getAllTables();
            if (!tables.contains("ai_maintenance_form")) {
                return "⚠️ 运维表单表 (ai_maintenance_form) 尚未创建\n\n" +
                       "请执行 sql/create_maintenance_form.sql 创建表。\n" +
                       "详细步骤请参考: SETUP_AI_TABLE.md";
            }
            
            StringBuilder stats = new StringBuilder();
            
            // 总表单数
            Integer total = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM ai_maintenance_form", Integer.class);
            stats.append("总表单数: ").append(total).append("\n");
            
            // 按状态分组统计
            List<Map<String, Object>> statusStats = jdbcTemplate.queryForList(
                "SELECT form_status, COUNT(*) as count FROM ai_maintenance_form GROUP BY form_status");
            stats.append("\n按状态统计:\n");
            for (Map<String, Object> row : statusStats) {
                stats.append("  - ").append(row.get("form_status"))
                     .append(": ").append(row.get("count")).append("\n");
            }
            
            // 按维护类型统计
            List<Map<String, Object>> typeStats = jdbcTemplate.queryForList(
                "SELECT maintenance_type, COUNT(*) as count FROM ai_maintenance_form GROUP BY maintenance_type");
            stats.append("\n按维护类型统计:\n");
            for (Map<String, Object> row : typeStats) {
                stats.append("  - ").append(row.get("maintenance_type"))
                     .append(": ").append(row.get("count")).append("\n");
            }
            
            return stats.toString();
            
        } catch (Exception e) {
            logger.error("获取统计信息失败: ", e);
            return "获取统计信息失败: " + e.getMessage() + "\n\n" +
                   "提示：如果是表不存在的错误，请先执行 sql/create_maintenance_form.sql 创建表。";
        }
    }

    /**
     * 构建数据库上下文信息（供 AI 使用）
     */
    public String getDatabaseContext() {
        StringBuilder context = new StringBuilder();
        context.append("=== 数据库结构信息 ===\n\n");
        
        List<String> tables = getAllTables();
        context.append("可用的表:\n");
        for (String table : tables) {
            context.append("- ").append(table).append("\n");
        }
        
        // 针对 eq_* 相关表和 ai_maintenance_form 提供详细结构，避免模型猜列名
        Set<String> detailedTables = new HashSet<>();
        for (String table : tables) {
            if (table.startsWith("eq_") || "ai_maintenance_form".equals(table)) {
                detailedTables.add(table);
            }
        }

        for (String table : detailedTables) {
            context.append("\n表 ").append(table).append(" 结构:\n");
            try {
                List<Map<String, Object>> structure = jdbcTemplate.queryForList("DESC " + table);
                for (Map<String, Object> column : structure) {
                    context.append("  - ").append(column.get("Field"))
                           .append(" (").append(column.get("Type")).append(")\n");
                }
            } catch (Exception e) {
                logger.error("获取表结构失败: {}", table, e);
            }
        }
        
        return context.toString();
    }

    /**
     * 让 AI 对查询结果做简要中文总结
     */
    @SuppressWarnings({ "DataFlowIssue", "null" })
    public String summarizeResult(String question, String sql, Map<String, Object> result) {
        try {
            if (!Boolean.TRUE.equals(result.get("success"))) {
                return "";
            }
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> rows = (List<Map<String, Object>>) result.getOrDefault("data", Collections.emptyList());
            int rowCount = rows.size();
            List<Map<String, Object>> preview = rows.size() > 50 ? rows.subList(0, 50) : rows;
            String json = MAPPER.writeValueAsString(preview);

            String prompt = String.format(
                    "你是数据库分析助手，请用中文简要总结查询结果，最多3条要点，给出关键数据量。\n" +
                    "用户问题: %s\n" +
                    "SQL: %s\n" +
                    "结果行数: %d\n" +
                    "示例数据(JSON，最多50行): %s\n" +
                    "请输出：\n" +
                    "- 总结（核心结论）\n" +
                    "- 关键字段值（如有）\n" +
                    "- 建议或风险（可选）",
                    question, sql, rowCount, json
            );

            String summary = chatClient.prompt()
                    .user(prompt)
                    .call()
                    .content();
            if (summary == null) {
                summary = "";
            }
            return summary.trim();
        } catch (Exception e) {
            logger.warn("结果摘要失败: {}", e.getMessage());
            return "";
        }
    }

    /**
     * 生成易读的简短中文摘要（无需再次调用大模型）
     */
    public String buildReadableSummary(Map<String, Object> result) {
        if (!Boolean.TRUE.equals(result.get("success"))) {
            return "查询失败：" + result.getOrDefault("error", "未知错误");
        }
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> rows = (List<Map<String, Object>>) result.getOrDefault("data", Collections.emptyList());
        int rowCount = rows.size();
        if (rowCount == 0) {
            return "未查询到数据。";
        }

        StringBuilder sb = new StringBuilder();
        sb.append("共 ").append(rowCount).append(" 条记录");
        sb.append("（仅展示前 ").append(Math.min(5, rowCount)).append(" 条）").append("\n");

        int limit = Math.min(5, rowCount);
        for (int i = 0; i < limit; i++) {
            Map<String, Object> row = rows.get(i);
            sb.append(i + 1).append(". ");

            // 设备名称 / 编号
            String name = firstNonNull(row, "device_name", "deviceName", "name");
            String no = firstNonNull(row, "device_no", "deviceNo", "code", "id");
            if (name != null) sb.append(name);
            if (no != null) {
                sb.append("（").append(no).append("）");
            }

            // 位置
            String loc = firstNonNull(row, "location", "loc");
            if (loc != null) sb.append("，位置：").append(loc);

            // 状态
            String status = humanStatus(firstNonNull(row, "status", "online_status", "onlineStatus"));
            if (status != null) sb.append("，状态：").append(status);

            // 保修到期
            String warranty = firstNonNull(row, "warranty_expiration", "warrantyExpiration");
            if (warranty != null) sb.append("，保修至：").append(warranty);

            // 责任人
            String resp = firstNonNull(row, "responsible_person", "responsiblePerson", "owner");
            if (resp != null) sb.append("，责任人：").append(resp);

            // 备注
            String remark = firstNonNull(row, "remark", "remarks");
            if (remark != null) sb.append("，备注：").append(remark);

            sb.append("\n");
        }

        // 简单的维护提示：如果有保修日期，提醒关注最近到期的
        String earliestWarranty = earliestDate(rows, "warranty_expiration", "warrantyExpiration");
        if (earliestWarranty != null) {
            sb.append("提示：关注近期保修到期（最近到期：").append(earliestWarranty).append("）。");
        }
        return sb.toString().trim();
    }

    private String firstNonNull(Map<String, Object> row, String... keys) {
        for (String k : keys) {
            Object v = row.get(k);
            if (v != null) return v.toString();
        }
        return null;
    }

    private String humanStatus(String raw) {
        if (raw == null) return null;
        switch (raw) {
            case "1": return "正常";
            case "2": return "停用";
            case "3": return "维护";
            case "4": return "报废";
            default: return raw;
        }
    }

    private String earliestDate(List<Map<String, Object>> rows, String... keys) {
        String earliest = null;
        for (Map<String, Object> row : rows) {
            for (String k : keys) {
                Object v = row.get(k);
                if (v == null) continue;
                String s = v.toString();
                if (s.isEmpty()) continue;
                if (earliest == null || s.compareTo(earliest) < 0) {
                    earliest = s;
                }
            }
        }
        return earliest;
    }
}
