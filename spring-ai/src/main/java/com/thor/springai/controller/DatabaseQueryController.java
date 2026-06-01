package com.thor.springai.controller;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.thor.springai.service.DatabaseQueryAppService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 数据库智能查询控制器
 *
 * @author wangchangzhen
 */
@RestController
@RequestMapping("/springai/db")
public class DatabaseQueryController extends BaseController {

    private static final Logger logger = LoggerFactory.getLogger(DatabaseQueryController.class);

    @Autowired
    private DatabaseQueryAppService databaseQueryAppService;

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

    /**
     * 自然语言查询数据库
     *
     * @param question 用户问题
     * @return 查询结果
     */
    @GetMapping("/ask")
    public AjaxResult askDatabase(@RequestParam(name = "question") String question,
                                  @RequestParam(name = "conversationId", required = false) String conversationId) {
        return databaseQueryAppService.askDatabase(question, getUserIdSafely(), getUsernameSafely(), conversationId);
    }

    /**
     * 执行 SQL 查询
     *
     * @param sql SQL语句
     * @return 查询结果
     */
    @PostMapping("/query")
    public AjaxResult executeQuery(@RequestParam(name = "sql") String sql) {
        return databaseQueryAppService.executeQuery(sql);
    }

    /**
     * 获取数据库表列表
     *
     * @return 表列表
     */
    @GetMapping("/tables")
    public AjaxResult getTables() {
        return databaseQueryAppService.getTables();
    }

    /**
     * 获取数据表结构
     *
     * @param tableName 表名
     * @return 表结构
     */
    @GetMapping("/tables/{tableName}")
    public AjaxResult getTableStructure(@PathVariable(name = "tableName") String tableName) {
        return databaseQueryAppService.getTableStructure(tableName);
    }

    /**
     * 获取数据库统计信息
     *
     * @return 统计信息
     */
    @GetMapping("/stats")
    public AjaxResult getStats() {
        return databaseQueryAppService.getStats();
    }

    /**
     * 获取数据库上下文
     *
     * @return 数据库上下文
     */
    @GetMapping("/context")
    public AjaxResult getDatabaseContext() {
        return databaseQueryAppService.getDatabaseContext();
    }
}
