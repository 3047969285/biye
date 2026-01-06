package com.thor.springai.controller;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Spring AI 阿里巴巴通义千问集成控制器
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

    @GetMapping("/chat")
    public AjaxResult chat(@RequestParam("input") String input) {
        try {


            String reply = this.chatClient
                    .prompt()
                    .user(input)
                    .call()
                    .content();

            logger.info("AI对话请求: {}, 回复: {}", input, reply);
            return AjaxResult.success(reply != null ? reply : "AI未返回内容");
        } catch (Exception e) {
            logger.error("AI对话服务异常: ", e);
            return AjaxResult.error("AI服务异常: " + e.getMessage());
        }
    }
}