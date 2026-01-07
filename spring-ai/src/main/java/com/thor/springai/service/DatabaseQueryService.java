package com.thor.springai.service;

import com.alibaba.fastjson2.JSON;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
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

    @Autowired
    private JdbcTemplate jdbcTemplate;

    /**
     * 执行查询 SQL（安全模式，只允许 SELECT）
     * 
     * @param sql SQL 查询语句
     * @return 查询结果（JSON 格式）
     */
    public String executeQuery(String sql) {
        try {
            // 安全检查：只允许 SELECT 语句
            String sqlLower = sql.trim().toLowerCase();
            if (!sqlLower.startsWith("select")) {
                return JSON.toJSONString(Map.of(
                    "success", false,
                    "error", "只允许执行 SELECT 查询语句"
                ));
            }

            // 执行查询
            List<Map<String, Object>> results = jdbcTemplate.queryForList(sql);
            
            logger.info("数据库查询成功，返回 {} 条记录", results.size());
            
            return JSON.toJSONString(Map.of(
                "success", true,
                "rowCount", results.size(),
                "data", results
            ));
            
        } catch (Exception e) {
            logger.error("数据库查询失败: SQL={}, Error={}", sql, e.getMessage());
            return JSON.toJSONString(Map.of(
                "success", false,
                "error", e.getMessage()
            ));
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
        
        // 添加运维表单表的详细结构
        if (tables.contains("ai_maintenance_form")) {
            context.append("\n运维表单表 (ai_maintenance_form) 结构:\n");
            try {
                List<Map<String, Object>> structure = jdbcTemplate.queryForList(
                    "DESC ai_maintenance_form");
                for (Map<String, Object> column : structure) {
                    context.append("  - ").append(column.get("Field"))
                           .append(" (").append(column.get("Type")).append(")\n");
                }
            } catch (Exception e) {
                logger.error("获取表结构失败", e);
            }
        }
        
        return context.toString();
    }
}
