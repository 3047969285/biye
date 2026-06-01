package com.thor.springai.controller;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.thor.springai.service.ChatHistoryAppService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 对话历史管理控制器
 *
 * @author wangchangzhen
 */
@RestController
@RequestMapping("/springai/history")
public class ChatHistoryController extends BaseController {

    private static final Logger logger = LoggerFactory.getLogger(ChatHistoryController.class);

    @Autowired
    private ChatHistoryAppService chatHistoryAppService;

    private Long getUserIdSafely() {
        try {
            return getUserId();
        } catch (Exception e) {
            logger.warn("无法获取用户ID: {}", e.getMessage());
            return null;
        }
    }

    /**
     * 获取对话历史列表
     *
     * @param chatType 对话类型
     * @return 历史记录列表
     */
    @GetMapping("/list")
    public AjaxResult getHistoryList(@RequestParam(name = "chatType", required = false) String chatType) {
        Long userId = getUserIdSafely();
        logger.info("获取对话历史记录，用户ID: {}, 类型: {}", userId, chatType);
        return chatHistoryAppService.getHistoryList(userId, chatType);
    }

    /**
     * 获取对话历史详情
     *
     * @param recordId 记录ID
     * @return 对话详情
     */
    @GetMapping("/{recordId}")
    public AjaxResult getHistoryById(@PathVariable Long recordId) {
        return chatHistoryAppService.getHistoryById(recordId);
    }

    /**
     * 删除对话历史
     *
     * @param recordIds 记录ID数组
     * @return 删除结果
     */
    @DeleteMapping("/delete")
    public AjaxResult deleteRecords(@RequestBody Long[] recordIds) {
        return chatHistoryAppService.deleteRecords(getUserIdSafely(), recordIds);
    }
}
