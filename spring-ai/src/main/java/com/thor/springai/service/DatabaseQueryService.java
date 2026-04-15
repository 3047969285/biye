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

    public Map<String, Object> executeQuery(String sql) {
        try {
            String sqlLower = sql.trim().toLowerCase();
            if (!sqlLower.startsWith("select")) {
                return Map.of(
                    "success", false,
                    "error", "只允许执行 SELECT 查询语句"
                );
            }

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

    public List<String> getAllTables() {
        try {
            String sql = "SHOW TABLES";
            List<Map<String, Object>> results = jdbcTemplate.queryForList(sql);

            List<String> tables = new ArrayList<>();
            for (Map<String, Object> row : results) {
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

    public String getMaintenanceFormStats() {
        try {
            StringBuilder stats = new StringBuilder();
            stats.append("=== 数据库统计信息 ===\n\n");

            List<String> tables = getAllTables();

            stats.append("【设备管理相关表】\n");
            int deviceTableCount = 0;
            for (String table : tables) {
                if (table.startsWith("eq_")) {
                    deviceTableCount++;
                    try {
                        Integer count = jdbcTemplate.queryForObject(
                            "SELECT COUNT(*) FROM " + table, Integer.class);
                        stats.append("  ").append(table).append(": ").append(count != null ? count : 0).append(" 条记录\n");
                    } catch (Exception e) {
                        stats.append("  ").append(table).append(": 查询失败\n");
                    }
                }
            }
            if (deviceTableCount == 0) {
                stats.append("  暂无设备相关表\n");
            }

            stats.append("\n【系统管理相关表】\n");
            String[] systemTables = {"sys_user", "sys_role", "sys_menu", "sys_dept", "sys_post"};
            for (String table : systemTables) {
                if (tables.contains(table)) {
                    try {
                        Integer count = jdbcTemplate.queryForObject(
                            "SELECT COUNT(*) FROM " + table, Integer.class);
                        stats.append("  ").append(table).append(": ").append(count != null ? count : 0).append(" 条记录\n");
                    } catch (Exception e) {
                        stats.append("  ").append(table).append(": 查询失败\n");
                    }
                }
            }

            stats.append("\n【AI相关表】\n");
            String[] aiTables = {"ai_maintenance_form", "ai_chat_record"};
            for (String table : aiTables) {
                if (tables.contains(table)) {
                    try {
                        Integer count = jdbcTemplate.queryForObject(
                            "SELECT COUNT(*) FROM " + table, Integer.class);
                        stats.append("  ").append(table).append(": ").append(count != null ? count : 0).append(" 条记录\n");
                    } catch (Exception e) {
                        stats.append("  ").append(table).append(": 查询失败\n");
                    }
                } else {
                    stats.append("  ").append(table).append(": 表不存在\n");
                }
            }

            if (tables.contains("ai_maintenance_form")) {
                try {
                    stats.append("\n【运维表单详细统计】\n");
                    Integer total = jdbcTemplate.queryForObject(
                        "SELECT COUNT(*) FROM ai_maintenance_form", Integer.class);
                    stats.append("  总表单数: ").append(total != null ? total : 0).append("\n");

                    List<Map<String, Object>> statusStats = jdbcTemplate.queryForList(
                        "SELECT form_status, COUNT(*) as count FROM ai_maintenance_form GROUP BY form_status");
                    if (!statusStats.isEmpty()) {
                        stats.append("  按状态统计:\n");
                        for (Map<String, Object> row : statusStats) {
                            stats.append("    - ").append(row.get("form_status"))
                                 .append(": ").append(row.get("count")).append("\n");
                        }
                    }
                } catch (Exception e) {
                    stats.append("  获取详细统计失败: ").append(e.getMessage()).append("\n");
                }
            }

            if (tables.contains("ai_chat_record")) {
                try {
                    stats.append("\n【对话记录统计】\n");
                    Integer total = jdbcTemplate.queryForObject(
                        "SELECT COUNT(*) FROM ai_chat_record", Integer.class);
                    stats.append("  总对话记录数: ").append(total != null ? total : 0).append("\n");

                    List<Map<String, Object>> typeStats = jdbcTemplate.queryForList(
                        "SELECT chat_type, COUNT(*) as count FROM ai_chat_record GROUP BY chat_type");
                    if (!typeStats.isEmpty()) {
                        stats.append("  按类型统计:\n");
                        for (Map<String, Object> row : typeStats) {
                            String type = (String) row.get("chat_type");
                            String typeName = "basic".equals(type) ? "基础对话" :
                                            "rag".equals(type) ? "知识库问答" :
                                            "db".equals(type) ? "数据库查询" : type;
                            stats.append("    - ").append(typeName)
                                 .append(": ").append(row.get("count")).append(" 条\n");
                        }
                    }
                } catch (Exception e) {
                    stats.append("  获取对话记录统计失败: ").append(e.getMessage()).append("\n");
                }
            }

            stats.append("\n【数据库总览】\n");
            stats.append("  总表数: ").append(tables.size()).append("\n");

            return stats.toString();

        } catch (Exception e) {
            logger.error("获取统计信息失败: ", e);
            return "获取统计信息失败: " + e.getMessage();
        }
    }

    public String getDatabaseContext() {
        StringBuilder context = new StringBuilder();
        context.append("=== 数据库结构信息 ===\n\n");

        List<String> tables = getAllTables();
        context.append("可用的表:\n");
        for (String table : tables) {
            context.append("- ").append(table).append("\n");
        }

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
                    "你是数据库分析助手，请用中文简要总结查询结果，最多7条要点，给出关键数据量。\n" +
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

            String name = firstNonNull(row, "device_name", "deviceName", "name");
            String no = firstNonNull(row, "device_no", "deviceNo", "code", "id");
            if (name != null) sb.append(name);
            if (no != null) {
                sb.append("（").append(no).append("）");
            }

            String loc = firstNonNull(row, "location", "loc");
            if (loc != null) sb.append("，位置：").append(loc);

            String status = humanStatus(firstNonNull(row, "status", "online_status", "onlineStatus"));
            if (status != null) sb.append("，状态：").append(status);

            String warranty = firstNonNull(row, "warranty_expiration", "warrantyExpiration");
            if (warranty != null) sb.append("，保修至：").append(warranty);

            String resp = firstNonNull(row, "responsible_person", "responsiblePerson", "owner");
            if (resp != null) sb.append("，责任人：").append(resp);

            String remark = firstNonNull(row, "remark", "remarks");
            if (remark != null) sb.append("，备注：").append(remark);

            sb.append("\n");
        }

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
