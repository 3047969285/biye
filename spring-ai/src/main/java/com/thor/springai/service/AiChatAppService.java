package com.thor.springai.service;

import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.system.domain.AiChatRecord;
import com.ruoyi.system.service.IAiChatRecordService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.util.concurrent.atomic.AtomicReference;

/**
 * AI 对话应用服务
 *
 * @author thor
 */
@Service
public class AiChatAppService {

    private static final Logger logger = LoggerFactory.getLogger(AiChatAppService.class);
    private static final String SYSTEM_PROMPT =
        "你是智能电网运维专家，回答时简洁、专业，可给出步骤和风险提示。回答时不要使用Markdown格式，不要使用#、*、**等符号，直接使用纯文本。";

    private final ChatClient chatClient;
    private final IAiChatRecordService aiChatRecordService;

    public AiChatAppService(ChatClient.Builder builder, IAiChatRecordService aiChatRecordService) {
        this.chatClient = builder.build();
        this.aiChatRecordService = aiChatRecordService;
    }

    /**
     * 普通对话
     *
     * @param input 用户输入
     * @param userId 用户ID
     * @param userName 用户名
     * @return 对话结果
     */
    public AjaxResult chat(String input, Long userId, String userName) {
        try {
            AiChatRecord record = new AiChatRecord();
            record.setUserId(userId);
            record.setUserName(userName);
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
            return AjaxResult.success(cleanedReply != null ? cleanedReply : "AI未返回内容");
        } catch (Exception e) {
            logger.error("AI对话异常: ", e);
            return AjaxResult.error("AI服务异常: " + e.getMessage());
        }
    }

    /**
     * 流式对话
     *
     * @param input 用户输入
     * @param userId 用户ID
     * @param userName 用户名
     * @return SSE 推送器
     */
    public SseEmitter chatStream(String input, Long userId, String userName) {
        SseEmitter emitter = new SseEmitter(0L);
        Long safeUserId = userId == null ? 0L : userId;
        String safeUserName = userName == null ? "匿名用户" : userName;

        AiChatRecord record = new AiChatRecord();
        Long recordId = null;
        try {
            record.setUserId(safeUserId);
            record.setUserName(safeUserName);
            record.setChatType("basic");
            record.setUserMessage(input);
            aiChatRecordService.insertAiChatRecord(record);
            recordId = record.getRecordId();
        } catch (Exception e) {
            logger.error("保存对话记录失败: ", e);
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
                    if (finalRecordId != null) {
                        updateAiReplyQuietly(finalRecordId, cleanMarkdown(fullResponse.get()));
                    }
                    emitter.completeWithError(error);
                },
                () -> {
                    if (finalRecordId != null) {
                        updateAiReplyQuietly(finalRecordId, cleanMarkdown(fullResponse.get()));
                    }
                    emitter.complete();
                }
            );
        return emitter;
    }

    private void updateAiReplyQuietly(Long recordId, String aiMessage) {
        try {
            aiChatRecordService.updateAiMessage(recordId, aiMessage);
        } catch (Exception e) {
            logger.warn("更新AI回复失败: {}", e.getMessage());
        }
    }

    private String cleanMarkdown(String text) {
        if (text == null) {
            return "";
        }
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
}
