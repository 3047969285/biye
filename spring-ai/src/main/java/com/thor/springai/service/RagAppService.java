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
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.atomic.AtomicReference;

@Service
public class RagAppService {

    private static final Logger logger = LoggerFactory.getLogger(RagAppService.class);

    private final ChromaRagService chromaRagService;
    private final AiMaintenanceFormMapper maintenanceFormMapper;
    private final IAiChatRecordService aiChatRecordService;
    private final ISysUserMessageService sysUserMessageService;
    private final ChatClient chatClient;

    public RagAppService(ChromaRagService chromaRagService, AiMaintenanceFormMapper maintenanceFormMapper,
        IAiChatRecordService aiChatRecordService, ISysUserMessageService sysUserMessageService, ChatClient.Builder builder) {
        this.chromaRagService = chromaRagService;
        this.maintenanceFormMapper = maintenanceFormMapper;
        this.aiChatRecordService = aiChatRecordService;
        this.sysUserMessageService = sysUserMessageService;
        this.chatClient = builder.build();
    }

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

    public AjaxResult askWithRag(String question, int topK, Long userId, String userName) {
        try {
            AiChatRecord record = new AiChatRecord();
            record.setUserId(userId);
            record.setUserName(userName);
            record.setChatType("rag");
            record.setUserMessage(question);
            try {
                aiChatRecordService.insertAiChatRecord(record);
            } catch (Exception e) {
                logger.warn("保存对话记录失败: {}", e.getMessage());
            }
            String cleanedAnswer = cleanMarkdown(chromaRagService.askWithRag(question, topK));
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

    public SseEmitter askWithRagStream(String question, int topK, Long userId, String userName) {
        SseEmitter emitter = new SseEmitter(0L);
        Long safeUserId = userId == null ? 0L : userId;
        String safeUserName = userName == null ? "匿名用户" : userName;

        AiChatRecord record = new AiChatRecord();
        Long recordId = null;
        try {
            record.setUserId(safeUserId);
            record.setUserName(safeUserName);
            record.setChatType("rag");
            record.setUserMessage(question);
            aiChatRecordService.insertAiChatRecord(record);
            recordId = record.getRecordId();
        } catch (Exception e) {
            logger.error("保存对话记录失败: ", e);
        }

        final Long finalRecordId = recordId;
        final AtomicReference<String> fullResponse = new AtomicReference<>("");
        try {
            String prompt = chromaRagService.buildRagPrompt(question, topK);
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

    public AjaxResult deleteDocument(String documentId) {
        try {
            chromaRagService.deleteDocument(documentId);
            return AjaxResult.success("文档删除成功");
        } catch (Exception e) {
            return AjaxResult.error("删除失败: " + e.getMessage());
        }
    }

    public AjaxResult clearKnowledgeBase() {
        try {
            chromaRagService.clearKnowledgeBase();
            return AjaxResult.success("知识库已清空");
        } catch (Exception e) {
            return AjaxResult.error("清空失败: " + e.getMessage());
        }
    }

    public List<AiMaintenanceForm> selectForms(AiMaintenanceForm form) {
        return maintenanceFormMapper.selectAiMaintenanceFormList(form);
    }

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
