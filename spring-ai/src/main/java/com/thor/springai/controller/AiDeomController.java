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

    private String cleanMarkdown(String text) {
        if (text == null) return "";
        return text
            .replaceAll("^#+\\s*", "")
            .replaceAll("\\*\\*(.*?)\\*\\*", "$1")
            .replaceAll("\\*(.*?)\\*", "$1")
            .replaceAll("`([^`]+)`", "$1")
            .replaceAll("```[\\s\\S]*?```", "")
            .replaceAll("\\[([^\\]]+)\\]\\([^\\)]+\\)", "$1")
            .replaceAll("^\\s*[-*+]\\s+", "")
            .replaceAll("^\\s*\\d+\\.\\s+", "")
            .trim();
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

    @GetMapping("/chat")
    public AjaxResult chat(@RequestParam(name = "input") String input) {
        try {
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

            String cleanedReply = cleanMarkdown(reply);

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

    @GetMapping(value = "/chat/stream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public SseEmitter chatStream(@RequestParam(name = "input") String input) {
        SseEmitter emitter = new SseEmitter(0L);

        AiChatRecord record = new AiChatRecord();
        Long recordId = null;
        try {
            Long userId = getUserIdSafely();
            String userName = getUsernameSafely();

            if (userId == null) {
                userId = 0L;
                logger.warn("用户ID为null，使用默认值0（匿名用户）");
            }

            logger.info("准备保存基础对话记录，用户ID: {}, 用户名: {}, 消息: {}", userId, userName, input != null ? input.substring(0, Math.min(50, input.length())) : "null");

            record.setUserId(userId);
            record.setUserName(userName != null ? userName : "匿名用户");
            record.setChatType("basic");
            record.setUserMessage(input);

            int result = aiChatRecordService.insertAiChatRecord(record);
            recordId = record.getRecordId();
            logger.info("保存基础对话记录成功，记录ID: {}, 插入结果: {}", recordId, result);
        } catch (Exception e) {
            logger.error("保存对话记录失败: ", e);
            recordId = null;
        }

        final Long finalRecordId = recordId;
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
                            if (finalRecordId != null) {
                                try {
                                    String aiMessage = cleanMarkdown(fullResponse.get());
                                    logger.info("流式输出错误，尝试更新AI回复，记录ID: {}, 回复长度: {}", finalRecordId, aiMessage != null ? aiMessage.length() : 0);
                                    int result = aiChatRecordService.updateAiMessage(finalRecordId, aiMessage);
                                    logger.info("更新AI回复结果: {}", result);
                                } catch (Exception e) {
                                    logger.error("更新AI回复失败: ", e);
                                }
                            } else {
                                logger.warn("记录ID为空，无法更新AI回复");
                            }
                            emitter.completeWithError(error);
                        },
                        () -> {
                            if (finalRecordId != null) {
                                try {
                                    String aiMessage = cleanMarkdown(fullResponse.get());
                                    logger.info("流式输出完成，更新AI回复，记录ID: {}, 回复长度: {}", finalRecordId, aiMessage != null ? aiMessage.length() : 0);
                                    int result = aiChatRecordService.updateAiMessage(finalRecordId, aiMessage);
                                    logger.info("更新AI回复结果: {}", result);
                                } catch (Exception e) {
                                    logger.error("更新AI回复失败: ", e);
                                }
                            } else {
                                logger.warn("记录ID为空，无法更新AI回复");
                            }
                            emitter.complete();
                        }
                );

        return emitter;
    }
}
