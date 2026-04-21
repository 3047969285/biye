package com.thor.springai.controller;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.thor.springai.service.DatabaseQueryAppService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

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

    @GetMapping("/ask")
    public AjaxResult askDatabase(@RequestParam(name = "question") String question) {
        return databaseQueryAppService.askDatabase(question, getUserIdSafely(), getUsernameSafely());
    }

    @PostMapping("/query")
    public AjaxResult executeQuery(@RequestParam(name = "sql") String sql) {
        return databaseQueryAppService.executeQuery(sql);
    }

    @GetMapping("/tables")
    public AjaxResult getTables() {
        return databaseQueryAppService.getTables();
    }

    @GetMapping("/tables/{tableName}")
    public AjaxResult getTableStructure(@PathVariable(name = "tableName") String tableName) {
        return databaseQueryAppService.getTableStructure(tableName);
    }

    @GetMapping("/stats")
    public AjaxResult getStats() {
        return databaseQueryAppService.getStats();
    }

    @GetMapping("/context")
    public AjaxResult getDatabaseContext() {
        return databaseQueryAppService.getDatabaseContext();
    }
}
