package com.thor.springai.controller;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.system.domain.AiChatRecord;
import com.ruoyi.system.service.IAiChatRecordService;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.concurrent.atomic.AtomicReference;

/**
 * Spring AI 基础对话控制器
 *
 * @author ruoyi
 */
@RestController
@RequestMapping("/springai")
public class AiDeomController extends BaseController {

    private static final Logger logger = LoggerFactory.getLogger(AiDeomController.class);
    private static final String SYSTEM_PROMPT = "你是智能电网运维专家，回答时简洁、专业，可给出步骤和风险提示。回答时不要使用Markdown格式，不要使用#、*、**等符号，直接使用纯文本。";
    
    private final ChatClient chatClient;
    
    @Autowired
    private IAiChatRecordService aiChatRecordService;

    public AiDeomController(ChatClient.Builder builder) {
        this.chatClient = builder.build();
    }
    
    /**
     * 清理Markdown符号
     */
    private String cleanMarkdown(String text) {
        if (text == null) return "";
        return text
            .replaceAll("^#+\\s*", "") // 去除标题符号 #
            .replaceAll("\\*\\*(.*?)\\*\\*", "$1") // 去除粗体 **
            .replaceAll("\\*(.*?)\\*", "$1") // 去除斜体 *
            .replaceAll("`([^`]+)`", "$1") // 去除行内代码 `
            .replaceAll("```[\\s\\S]*?```", "") // 去除代码块
            .replaceAll("\\[([^\\]]+)\\]\\([^\\)]+\\)", "$1") // 去除链接
            .replaceAll("^\\s*[-*+]\\s+", "") // 去除无序列表
            .replaceAll("^\\s*\\d+\\.\\s+", "") // 去除有序列表
            .trim();
    }

    /**
     * 安全获取用户ID
     */
    private Long getUserIdSafely() {
        try {
            return getUserId();
        } catch (Exception e) {
            logger.warn("无法获取用户ID: {}", e.getMessage());
            return null;
        }
    }

    /**
     * 安全获取用户名
     */
    private String getUsernameSafely() {
        try {
            return getUsername();
        } catch (Exception e) {
            logger.warn("无法获取用户名: {}", e.getMessage());
            return "匿名用户";
        }
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
            // 保存用户消息
            AiChatRecord record = new AiChatRecord();
            record.setUserId(getUserIdSafely());
            record.setUserName(getUsernameSafely());
            record.setChatType("basic");
            record.setUserMessage(input);
            try {
                aiChatRecordService.insertAiChatRecord(record);
            } catch (Exception e) {
                logger.warn("保存对话记录失败: {}", e.getMessage());
            }
            
            String reply = chatClient.prompt()
                    .system(SYSTEM_PROMPT)
                    .user(input == null ? "" : input)
                    .call()
                    .content();
            
            // 清理Markdown符号
            String cleanedReply = cleanMarkdown(reply);
            
            // 更新AI回复
            if (record.getRecordId() != null) {
                try {
                    aiChatRecordService.updateAiMessage(record.getRecordId(), cleanedReply);
                } catch (Exception e) {
                    logger.warn("更新AI回复失败: {}", e.getMessage());
                }
            }

            logger.info("AI对话 - 问题: {}, 回复长度: {}", input, cleanedReply != null ? cleanedReply.length() : 0);
            return AjaxResult.success(cleanedReply != null ? cleanedReply : "AI未返回内容");
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
        
        // 保存用户消息
        AiChatRecord record = new AiChatRecord();
        try {
            record.setUserId(getUserIdSafely());
            record.setUserName(getUsernameSafely());
            record.setChatType("basic");
            record.setUserMessage(input);
            aiChatRecordService.insertAiChatRecord(record);
        } catch (Exception e) {
            logger.warn("保存对话记录失败: {}", e.getMessage());
        }
        
        final Long recordId = record.getRecordId();
        final AtomicReference<String> fullResponse = new AtomicReference<>("");

        chatClient.prompt()
                .system(SYSTEM_PROMPT)
                .user(input == null ? "" : input)
                .stream()
                .content()
                .subscribe(
                        chunk -> {
                            try {
                                String cleanedChunk = cleanMarkdown(chunk == null ? "" : chunk);
                                fullResponse.updateAndGet(v -> v + cleanedChunk);
                                emitter.send(SseEmitter.event().data(cleanedChunk));
                            } catch (Exception ex) {
                                emitter.completeWithError(ex);
                            }
                        },
                        error -> {
                            logger.error("流式输出错误: ", error);
                            // 保存AI回复
                            if (recordId != null) {
                                try {
                                    aiChatRecordService.updateAiMessage(recordId, cleanMarkdown(fullResponse.get()));
                                } catch (Exception e) {
                                    logger.warn("更新AI回复失败: {}", e.getMessage());
                                }
                            }
                            emitter.completeWithError(error);
                        },
                        () -> {
                            // 流式输出完成，保存AI回复
                            if (recordId != null) {
                                try {
                                    aiChatRecordService.updateAiMessage(recordId, cleanMarkdown(fullResponse.get()));
                                } catch (Exception e) {
                                    logger.warn("更新AI回复失败: {}", e.getMessage());
                                }
                            }
                            emitter.complete();
                        }
                );

        return emitter;
    }
}