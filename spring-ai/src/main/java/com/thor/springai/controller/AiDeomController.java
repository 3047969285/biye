package com.thor.springai.controller;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.thor.springai.service.AiChatAppService;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * AI 基础对话控制器
 *
 * @author thor
 */
@RestController
@RequestMapping("/springai")
public class AiDeomController extends BaseController {

    private static final Logger logger = LoggerFactory.getLogger(AiDeomController.class);

    private final AiChatAppService aiChatAppService;

    public AiDeomController(AiChatAppService aiChatAppService) {
        this.aiChatAppService = aiChatAppService;
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

    /**
     * 基础对话
     *
     * @param input 用户输入
     * @return 对话结果
     */
    @GetMapping("/chat")
    public AjaxResult chat(@RequestParam(name = "input") String input,
                           @RequestParam(name = "conversationId", required = false) String conversationId) {
        return aiChatAppService.chat(input, getUserIdSafely(), getUsernameSafely(), conversationId);
    }

    /**
     * 基础对话（流式）
     *
     * @param input 用户输入
     * @return SSE 推送器
     */
    @GetMapping(value = "/chat/stream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public SseEmitter chatStream(@RequestParam(name = "input") String input,
                                 @RequestParam(name = "conversationId", required = false) String conversationId) {
        return aiChatAppService.chatStream(input, getUserIdSafely(), getUsernameSafely(), conversationId);
    }
}
