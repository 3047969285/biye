package com.thor.springai.controller;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;
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
    private static final String SYSTEM_PROMPT = "你是智能电网运维专家，回答时简洁、专业，可给出步骤和风险提示。";
    
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
                    .system(SYSTEM_PROMPT)
                    .user(input == null ? "" : input)
                    .call()
                    .content();

            logger.info("AI对话 - 问题: {}, 回复长度: {}", input, reply != null ? reply.length() : 0);
            return AjaxResult.success(reply != null ? reply : "AI未返回内容");
        } catch (Exception e) {
            logger.error("AI对话异常: ", e);
            return AjaxResult.error("AI服务异常: " + e.getMessage());
        }
    }

    /**
     * 基础 AI 对话 - 流式输出
     */
    @GetMapping(value = "/chat/stream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public SseEmitter chatStream(@RequestParam(name = "input") String input) {
        SseEmitter emitter = new SseEmitter(0L);

        chatClient.prompt()
                .system(SYSTEM_PROMPT)
                .user(input == null ? "" : input)
                .stream()
                .content()
                .subscribe(
                        chunk -> {
                            try {
                                emitter.send(SseEmitter.event().data(chunk == null ? "" : chunk));
                            } catch (Exception ex) {
                                emitter.completeWithError(ex);
                            }
                        },
                        emitter::completeWithError,
                        emitter::complete
                );

        return emitter;
    }
}