package com.thor.springai.service;

import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.system.domain.AiChatRecord;
import com.ruoyi.system.service.IAiChatRecordService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.UUID;
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
    private final int memoryTurns;

    public AiChatAppService(ChatClient.Builder builder, IAiChatRecordService aiChatRecordService,
                            @Value("${app.chat.memory-turns:6}") int memoryTurns) {
        this.chatClient = builder.build();
        this.aiChatRecordService = aiChatRecordService;
        this.memoryTurns = memoryTurns;
    }

    /**
     * 普通对话
     *
     * @param input 用户输入
     * @param userId 用户ID
     * @param userName 用户名
     * @return 对话结果
     */
    public AjaxResult chat(String input, Long userId, String userName, String conversationId) {
        try {
            String normalizedConversationId = normalizeConversationId(conversationId, userId, "basic");
            AiChatRecord record = new AiChatRecord();
            record.setUserId(userId);
            record.setUserName(userName);
            record.setChatType("basic");
            record.setConversationId(normalizedConversationId);
            record.setUserMessage(input);
            try {
                aiChatRecordService.insertAiChatRecord(record);
            } catch (Exception e) {
                logger.warn("保存对话记录失败: {}", e.getMessage());
            }

            String promptWithHistory = buildPromptWithHistory(userId, "basic", normalizedConversationId, record.getRecordId(), input);
            String reply = chatClient.prompt()
                .system(SYSTEM_PROMPT)
                .user(promptWithHistory)
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
    public SseEmitter chatStream(String input, Long userId, String userName, String conversationId) {
        SseEmitter emitter = new SseEmitter(0L);
        Long safeUserId = userId == null ? 0L : userId;
        String safeUserName = userName == null ? "匿名用户" : userName;
        String normalizedConversationId = normalizeConversationId(conversationId, safeUserId, "basic");

        AiChatRecord record = new AiChatRecord();
        Long recordId = null;
        try {
            record.setUserId(safeUserId);
            record.setUserName(safeUserName);
            record.setChatType("basic");
            record.setConversationId(normalizedConversationId);
            record.setUserMessage(input);
            aiChatRecordService.insertAiChatRecord(record);
            recordId = record.getRecordId();
        } catch (Exception e) {
            logger.error("保存对话记录失败: ", e);
        }

        final Long finalRecordId = recordId;
        final AtomicReference<String> fullResponse = new AtomicReference<>("");
        String promptWithHistory = buildPromptWithHistory(safeUserId, "basic", normalizedConversationId, finalRecordId, input);
        chatClient.prompt()
            .system(SYSTEM_PROMPT)
            .user(promptWithHistory)
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

    private String buildPromptWithHistory(Long userId, String chatType, String conversationId, Long currentRecordId, String currentInput) {
        String input = currentInput == null ? "" : currentInput;
        if (memoryTurns <= 0) {
            return input;
        }
        List<AiChatRecord> records = fetchRecentHistory(userId, chatType, conversationId, currentRecordId, memoryTurns);
        if (records.isEmpty()) {
            return input;
        }
        StringBuilder sb = new StringBuilder();
        sb.append("以下是最近对话上下文，请结合上下文连续回答。\n");
        for (AiChatRecord r : records) {
            if (r.getUserMessage() != null && !r.getUserMessage().trim().isEmpty()) {
                sb.append("用户：").append(r.getUserMessage().trim()).append("\n");
            }
            if (r.getAiMessage() != null && !r.getAiMessage().trim().isEmpty()) {
                sb.append("助手：").append(r.getAiMessage().trim()).append("\n");
            }
        }
        sb.append("\n当前用户问题：").append(input);
        return sb.toString();
    }

    private List<AiChatRecord> fetchRecentHistory(Long userId, String chatType, String conversationId, Long currentRecordId, int maxTurns) {
        AiChatRecord query = new AiChatRecord();
        query.setUserId(userId == null ? 0L : userId);
        query.setChatType(chatType);
        query.setConversationId(conversationId);
        List<AiChatRecord> all = aiChatRecordService.selectAiChatRecordList(query);
        if (all == null || all.isEmpty()) {
            return Collections.emptyList();
        }
        List<AiChatRecord> selected = new ArrayList<>();
        for (AiChatRecord item : all) {
            if (item == null) {
                continue;
            }
            if (currentRecordId != null && currentRecordId.equals(item.getRecordId())) {
                continue;
            }
            if (selected.size() >= maxTurns) {
                break;
            }
            selected.add(item);
        }
        Collections.reverse(selected);
        return selected;
    }

    private String normalizeConversationId(String conversationId, Long userId, String chatType) {
        if (conversationId != null && !conversationId.trim().isEmpty()) {
            return conversationId.trim();
        }
        Long safeUserId = userId == null ? 0L : userId;
        return "legacy-" + chatType + "-" + safeUserId + "-" + UUID.randomUUID();
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
