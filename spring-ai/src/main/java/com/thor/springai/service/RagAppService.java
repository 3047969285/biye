package com.thor.springai.service;

import com.alibaba.fastjson2.JSON;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.system.domain.AiChatRecord;
import com.ruoyi.system.domain.AiMaintenanceForm;
import com.ruoyi.system.mapper.AiMaintenanceFormMapper;
import com.ruoyi.system.service.IAiChatRecordService;
import com.ruoyi.system.service.ISysUserMessageService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.atomic.AtomicReference;

/**
 * RAG 应用服务
 *
 * @author wangchangzhen
 */
@Service
public class RagAppService {

    private static final Logger logger = LoggerFactory.getLogger(RagAppService.class);

    private final ChromaRagService chromaRagService;
    private final AiMaintenanceFormMapper maintenanceFormMapper;
    private final IAiChatRecordService aiChatRecordService;
    private final ISysUserMessageService sysUserMessageService;
    private final ChatClient chatClient;
    private final int memoryTurns;

    public RagAppService(ChromaRagService chromaRagService, AiMaintenanceFormMapper maintenanceFormMapper,
        IAiChatRecordService aiChatRecordService, ISysUserMessageService sysUserMessageService, ChatClient.Builder builder,
        @Value("${app.chat.memory-turns:6}") int memoryTurns) {
        this.chromaRagService = chromaRagService;
        this.maintenanceFormMapper = maintenanceFormMapper;
        this.aiChatRecordService = aiChatRecordService;
        this.sysUserMessageService = sysUserMessageService;
        this.chatClient = builder.build();
        this.memoryTurns = memoryTurns;
    }

    /**
     * 新增知识库文档
     *
     * @param content 文档内容
     * @param title 文档标题
     * @param category 文档分类
     * @return 处理结果
     */
    public AjaxResult addDocument(String content, String title, String category) {
        try {
            String documentId = UUID.randomUUID().toString();
            Map<String, String> metadata = new HashMap<>();
            if (title != null) metadata.put("title", title);
            if (category != null) metadata.put("category", category);
            metadata.put("timestamp", String.valueOf(System.currentTimeMillis()));
            chromaRagService.addDocument(documentId, content, metadata);
            return AjaxResult.success("文档添加成功", documentId);
        } catch (Exception e) {
            logger.error("添加文档失败: ", e);
            return AjaxResult.error("添加文档失败: " + e.getMessage());
        }
    }

    /**
     * RAG 问答
     *
     * @param question 问题
     * @param topK 召回条数
     * @param userId 用户ID
     * @param userName 用户名
     * @return 回答结果
     */
    public AjaxResult askWithRag(String question, int topK, Long userId, String userName, String conversationId) {
        try {
            String normalizedConversationId = normalizeConversationId(conversationId, userId, "rag");
            AiChatRecord record = new AiChatRecord();
            record.setUserId(userId);
            record.setUserName(userName);
            record.setChatType("rag");
            record.setConversationId(normalizedConversationId);
            record.setUserMessage(question);
            try {
                aiChatRecordService.insertAiChatRecord(record);
            } catch (Exception e) {
                logger.warn("保存对话记录失败: {}", e.getMessage());
            }

            String prompt = chromaRagService.buildRagPrompt(
                buildQuestionWithHistory(userId, "rag", normalizedConversationId, record.getRecordId(), question), topK
            );
            String systemPrompt = "你是智能电网运维专家，请基于提供的资料回答，先简述结论，再给步骤/注意事项。回答时不要使用Markdown格式，不要使用#、*、**等符号，直接使用纯文本。";
            String cleanedAnswer = cleanMarkdown(chatClient.prompt()
                .system(systemPrompt)
                .user(prompt)
                .call()
                .content());
            if (record.getRecordId() != null) {
                try {
                    aiChatRecordService.updateAiMessage(record.getRecordId(), cleanedAnswer);
                } catch (Exception e) {
                    logger.warn("更新AI回复失败: {}", e.getMessage());
                }
            }
            return AjaxResult.success(cleanedAnswer);
        } catch (Exception e) {
            logger.error("RAG问答失败: ", e);
            return AjaxResult.error("问答失败: " + e.getMessage());
        }
    }

    /**
     * RAG 问答（流式）
     *
     * @param question 问题
     * @param topK 召回条数
     * @param userId 用户ID
     * @param userName 用户名
     * @return SSE 推送器
     */
    public SseEmitter askWithRagStream(String question, int topK, Long userId, String userName, String conversationId) {
        SseEmitter emitter = new SseEmitter(0L);
        Long safeUserId = userId == null ? 0L : userId;
        String safeUserName = userName == null ? "匿名用户" : userName;
        String normalizedConversationId = normalizeConversationId(conversationId, safeUserId, "rag");

        AiChatRecord record = new AiChatRecord();
        Long recordId = null;
        try {
            record.setUserId(safeUserId);
            record.setUserName(safeUserName);
            record.setChatType("rag");
            record.setConversationId(normalizedConversationId);
            record.setUserMessage(question);
            aiChatRecordService.insertAiChatRecord(record);
            recordId = record.getRecordId();
        } catch (Exception e) {
            logger.error("保存对话记录失败: ", e);
        }

        final Long finalRecordId = recordId;
        final AtomicReference<String> fullResponse = new AtomicReference<>("");
        try {
            String prompt = chromaRagService.buildRagPrompt(
                buildQuestionWithHistory(safeUserId, "rag", normalizedConversationId, finalRecordId, question), topK
            );
            String systemPrompt = "你是智能电网运维专家，请基于提供的资料回答，先简述结论，再给步骤/注意事项。回答时不要使用Markdown格式，不要使用#、*、**等符号，直接使用纯文本。";
            chatClient.prompt()
                .system(systemPrompt)
                .user(prompt)
                .stream()
                .content()
                .subscribe(
                    chunk -> {
                        try {
                            String cleanedChunk = cleanMarkdown(chunk);
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
        } catch (Exception e) {
            emitter.completeWithError(e);
        }
        return emitter;
    }

    /**
     * 生成运维表单
     *
     * @param question 问题
     * @param topK 召回条数
     * @param saveToDb 是否保存到数据库
     * @return 生成结果
     */
    public AjaxResult generateMaintenanceForm(String question, int topK, boolean saveToDb) {
        try {
            ChromaRagService.MaintenanceFormResponse response = chromaRagService.askWithFixedFormat(question, topK);
            if (!saveToDb) {
                return AjaxResult.success("运维表单生成成功", response);
            }
            AiMaintenanceForm form = new AiMaintenanceForm();
            form.setDeviceName(response.getDeviceName());
            form.setFaultDescription(response.getFaultDescription());
            form.setMaintenanceType(response.getMaintenanceType());
            form.setPriorityLevel(response.getPriorityLevel());
            form.setEstimatedTime(response.getEstimatedTime());
            form.setRequiredTools(JSON.toJSONString(response.getRequiredTools()));
            form.setSafetyPrecautions(response.getSafetyPrecautions());
            form.setStepByStepGuide(JSON.toJSONString(response.getSteps()));
            form.setExpectedOutcome(response.getExpectedOutcome());
            form.setFormStatus("approved");
            form.setCreatedBy("AI");
            maintenanceFormMapper.insertAiMaintenanceForm(form);
            if (sysUserMessageService != null) {
                sysUserMessageService.notifyMaintenanceFormPending(form);
            }
            Map<String, Object> result = new HashMap<>();
            result.put("form", response);
            result.put("formId", form.getFormId());
            return AjaxResult.success("运维表单生成并保存成功", result);
        } catch (Exception e) {
            logger.error("生成运维表单失败: ", e);
            return AjaxResult.error("生成失败: " + e.getMessage());
        }
    }

    /**
     * 删除知识库文档
     *
     * @param documentId 文档ID
     * @return 删除结果
     */
    public AjaxResult deleteDocument(String documentId) {
        try {
            chromaRagService.deleteDocument(documentId);
            return AjaxResult.success("文档删除成功");
        } catch (Exception e) {
            return AjaxResult.error("删除失败: " + e.getMessage());
        }
    }

    /**
     * 清空知识库
     *
     * @return 清空结果
     */
    public AjaxResult clearKnowledgeBase() {
        try {
            chromaRagService.clearKnowledgeBase();
            return AjaxResult.success("知识库已清空");
        } catch (Exception e) {
            return AjaxResult.error("清空失败: " + e.getMessage());
        }
    }

    /**
     * 获取 RAG 运行状态
     *
     * @return 运行状态
     */
    public AjaxResult getRagRuntimeStatus() {
        try {
            return AjaxResult.success(chromaRagService.getRuntimeStatus());
        } catch (Exception e) {
            logger.error("获取 RAG 运行状态失败: ", e);
            return AjaxResult.error("获取运行状态失败: " + e.getMessage());
        }
    }

    /**
     * 查询运维表单列表
     *
     * @param form 查询条件
     * @return 表单列表
     */
    public List<AiMaintenanceForm> selectForms(AiMaintenanceForm form) {
        return maintenanceFormMapper.selectAiMaintenanceFormList(form);
    }

    /**
     * 查询运维表单详情
     *
     * @param formId 表单ID
     * @return 表单详情
     */
    public AjaxResult getForm(Long formId) {
        try {
            AiMaintenanceForm form = maintenanceFormMapper.selectAiMaintenanceFormById(formId);
            if (form == null) return AjaxResult.error("表单不存在");
            return AjaxResult.success(form);
        } catch (Exception e) {
            return AjaxResult.error("查询失败: " + e.getMessage());
        }
    }

    private void updateAiReplyQuietly(Long recordId, String aiMessage) {
        try {
            aiChatRecordService.updateAiMessage(recordId, aiMessage);
        } catch (Exception e) {
            logger.warn("更新AI回复失败: {}", e.getMessage());
        }
    }

    private String buildQuestionWithHistory(Long userId, String chatType, String conversationId, Long currentRecordId, String currentQuestion) {
        String question = currentQuestion == null ? "" : currentQuestion;
        if (memoryTurns <= 0) {
            return question;
        }
        List<AiChatRecord> records = fetchRecentHistory(userId, chatType, conversationId, currentRecordId, memoryTurns);
        if (records.isEmpty()) {
            return question;
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
        sb.append("\n当前用户问题：").append(question);
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
}
