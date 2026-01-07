package com.thor.springai.controller;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.web.bind.annotation.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Spring AI 基础对话控制器
 *
 * @author ruoyi
 */
@RestController
@RequestMapping("/springai")
public class AiDeomController extends BaseController {

    private static final Logger logger = LoggerFactory.getLogger(AiDeomController.class);
    
    private final ChatClient chatClient;

    public AiDeomController(ChatClient.Builder builder) {
        this.chatClient = builder.build();
    }

    /**
     * 基础 AI 对话接口
     * 
     * @param input 用户输入
     * @return AI 回复
     */
    @GetMapping("/chat")
    public AjaxResult chat(@RequestParam(name = "input") String input) {
        try {
            String reply = chatClient.prompt()
                    .user(input)
                    .call()
                    .content();

            logger.info("AI对话 - 问题: {}, 回复长度: {}", input, reply != null ? reply.length() : 0);
            return AjaxResult.success(reply != null ? reply : "AI未返回内容");
        } catch (Exception e) {
            logger.error("AI对话异常: ", e);
            return AjaxResult.error("AI服务异常: " + e.getMessage());
        }
    }
}