package com.thor.springai.controller;

import com.alibaba.fastjson2.JSON;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.system.domain.AiChatRecord;
import com.ruoyi.system.domain.AiMaintenanceForm;
import com.ruoyi.system.mapper.AiMaintenanceFormMapper;
import com.ruoyi.system.service.IAiChatRecordService;
import com.thor.springai.service.ChromaRagService;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.atomic.AtomicReference;

/**
 * RAG（检索增强生成）控制器 - 基于 Chroma 向量数据库
 * 
 * @author ruoyi
 */
@RestController
@RequestMapping("/springai/rag")
public class RagController extends BaseController {

    private static final Logger logger = LoggerFactory.getLogger(RagController.class);
    
    private final ChromaRagService chromaRagService;
    private final AiMaintenanceFormMapper maintenanceFormMapper;
    private final ChatClient chatClient;
    
    @Autowired
    private IAiChatRecordService aiChatRecordService;

    public RagController(ChromaRagService chromaRagService,
                         AiMaintenanceFormMapper maintenanceFormMapper,
                         ChatClient.Builder builder) {
        this.chromaRagService = chromaRagService;
        this.maintenanceFormMapper = maintenanceFormMapper;
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
     * 添加文档到 Chroma 知识库
     * 
     * @param content 文档内容
     * @param title 文档标题
     * @param category 文档分类
     * @return 操作结果
     */
    @PostMapping("/document")
    public AjaxResult addDocument(@RequestParam(name = "content") String content, 
                                   @RequestParam(name = "title", required = false) String title,
                                   @RequestParam(name = "category", required = false) String category) {
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
     * 基于 RAG 的智能问答
     * 
     * @param question 用户问题
     * @param topK 检索文档数量（默认3）
     * @return AI回答
     */
    @GetMapping("/ask")
    public AjaxResult askWithRag(@RequestParam(name = "question") String question,
                                  @RequestParam(name = "topK", defaultValue = "3") int topK) {
        try {
            // 保存用户消息
            AiChatRecord record = new AiChatRecord();
            record.setUserId(getUserIdSafely());
            record.setUserName(getUsernameSafely());
            record.setChatType("rag");
            record.setUserMessage(question);
            try {
                aiChatRecordService.insertAiChatRecord(record);
            } catch (Exception e) {
                logger.warn("保存对话记录失败: {}", e.getMessage());
            }
            
            String answer = chromaRagService.askWithRag(question, topK);
            
            // 清理Markdown符号
            String cleanedAnswer = cleanMarkdown(answer);
            
            // 更新AI回复
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
     * 基于 RAG 的智能问答（流式）
     */
    @GetMapping(value = "/ask/stream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public SseEmitter askWithRagStream(@RequestParam(name = "question") String question,
                                       @RequestParam(name = "topK", defaultValue = "3") int topK) {
        SseEmitter emitter = new SseEmitter(0L);

        // 保存用户消息
        AiChatRecord record = new AiChatRecord();
        Long recordId = null;
        try {
            Long userId = getUserIdSafely();
            String userName = getUsernameSafely();
            
            // 如果用户ID为null，设置为0（匿名用户）
            if (userId == null) {
                userId = 0L;
                logger.warn("用户ID为null，使用默认值0（匿名用户）");
            }
            
            logger.info("准备保存RAG对话记录，用户ID: {}, 用户名: {}, 问题: {}", userId, userName, question != null ? question.substring(0, Math.min(50, question.length())) : "null");
            
            record.setUserId(userId);
            record.setUserName(userName != null ? userName : "匿名用户");
            record.setChatType("rag");
            record.setUserMessage(question);
            
            int result = aiChatRecordService.insertAiChatRecord(record);
            recordId = record.getRecordId();
            logger.info("保存RAG对话记录成功，记录ID: {}, 插入结果: {}", recordId, result);
        } catch (Exception e) {
            logger.error("保存对话记录失败: ", e);
            recordId = null;
        }
        
        final Long finalRecordId = recordId;
        final AtomicReference<String> fullResponse = new AtomicReference<>("");

        try {
            String prompt = chromaRagService.buildRagPrompt(question, topK);
            // 给定系统角色，让回答保持运维专家语气，不使用Markdown格式
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
                                logger.error("流式输出错误: ", error);
                                // 保存AI回复
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
                                // 流式输出完成，保存AI回复
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
        } catch (Exception e) {
            emitter.completeWithError(e);
        }

        return emitter;
    }

    /**
     * 基于 RAG 生成运维操作表单（固定格式输出）
     * 
     * @param question 用户问题/故障描述
     * @param topK 检索文档数量（默认3）
     * @param saveToDb 是否保存到数据库（默认false）
     * @return 固定格式的运维表单
     */
    @GetMapping("/generate-form")
    public AjaxResult generateMaintenanceForm(@RequestParam(name = "question") String question,
                                               @RequestParam(name = "topK", defaultValue = "3") int topK,
                                               @RequestParam(name = "saveToDb", defaultValue = "false") boolean saveToDb) {
        try {
            // 使用 RAG 生成固定格式的运维表单
            ChromaRagService.MaintenanceFormResponse response = 
                chromaRagService.askWithFixedFormat(question, topK);
            
            // 如果需要保存到数据库
            if (saveToDb) {
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
                form.setFormStatus("draft");
                form.setCreatedBy("AI");
                
                maintenanceFormMapper.insertAiMaintenanceForm(form);
                logger.info("运维表单已保存到数据库，ID: {}", form.getFormId());
                
                Map<String, Object> result = new HashMap<>();
                result.put("form", response);
                result.put("formId", form.getFormId());
                return AjaxResult.success("运维表单生成并保存成功", result);
            }
            
            return AjaxResult.success("运维表单生成成功", response);
        } catch (Exception e) {
            logger.error("生成运维表单失败: ", e);
            return AjaxResult.error("生成失败: " + e.getMessage());
        }
    }

    /**
     * 删除文档
     * 
     * @param documentId 文档ID
     * @return 操作结果
     */
    @DeleteMapping("/document/{documentId}")
    public AjaxResult deleteDocument(@PathVariable String documentId) {
        try {
            chromaRagService.deleteDocument(documentId);
            return AjaxResult.success("文档删除成功");
        } catch (Exception e) {
            logger.error("删除文档失败: ", e);
            return AjaxResult.error("删除失败: " + e.getMessage());
        }
    }

    /**
     * 清空知识库
     * 
     * @return 操作结果
     */
    @PostMapping("/clear")
    public AjaxResult clearKnowledgeBase() {
        try {
            chromaRagService.clearKnowledgeBase();
            return AjaxResult.success("知识库已清空");
        } catch (Exception e) {
            logger.error("清空知识库失败: ", e);
            return AjaxResult.error("清空失败: " + e.getMessage());
        }
    }

    /**
     * 获取运维表单列表
     * 
     * @param form 查询条件
     * @return 表单列表
     */
    @GetMapping("/forms")
    public AjaxResult listForms(AiMaintenanceForm form) {
        try {
            startPage();
            var list = maintenanceFormMapper.selectAiMaintenanceFormList(form);
            return AjaxResult.success(getDataTable(list));
        } catch (Exception e) {
            logger.error("查询运维表单失败: ", e);
            return AjaxResult.error("查询失败: " + e.getMessage());
        }
    }

    /**
     * 获取运维表单详情
     * 
     * @param formId 表单ID
     * @return 表单详情
     */
    @GetMapping("/forms/{formId}")
    public AjaxResult getForm(@PathVariable Long formId) {
        try {
            AiMaintenanceForm form = maintenanceFormMapper.selectAiMaintenanceFormById(formId);
            if (form == null) {
                return AjaxResult.error("表单不存在");
            }
            return AjaxResult.success(form);
        } catch (Exception e) {
            logger.error("查询运维表单失败: ", e);
            return AjaxResult.error("查询失败: " + e.getMessage());
        }
    }
}
