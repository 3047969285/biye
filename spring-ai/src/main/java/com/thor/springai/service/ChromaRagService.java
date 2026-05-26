package com.thor.springai.service;

import com.alibaba.fastjson2.JSON;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.document.Document;
import org.springframework.ai.reader.TextReader;
import org.springframework.ai.transformer.splitter.TokenTextSplitter;
import org.springframework.ai.vectorstore.VectorStore;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.util.*;
import java.util.Optional;

/**
 * Chroma 向量库 RAG 服务
 *
 * @author thor
 */
@Service
public class ChromaRagService {

    private static final Logger logger = LoggerFactory.getLogger(ChromaRagService.class);

    private final ChatClient chatClient;
    private final VectorStore vectorStore;
    private final TokenTextSplitter textSplitter;

    @Value("${spring.ai.vectorstore.simple.store-file:data/vector-store.json}")
    private String vectorStoreFile;

    public ChromaRagService(ChatClient.Builder builder,
                           @Autowired(required = false) VectorStore vectorStore,
                           TokenTextSplitter textSplitter) {
        this.chatClient = builder.build();
        this.vectorStore = vectorStore;
        this.textSplitter = textSplitter;
    }

    /**
     * 新增文档到向量库
     *
     * @param documentId 文档ID
     * @param content 文档内容
     * @param metadata 文档元数据
     */
    public void addDocument(String documentId, String content, Map<String, String> metadata) {
        if (vectorStore == null) {
            throw new RuntimeException("向量存储未配置，请检查 EmbeddingModel 配置");
        }

        try {
            ByteArrayResource resource = new ByteArrayResource(content.getBytes()) {
                @Override
                public String getFilename() {
                    return metadata != null && metadata.containsKey("title") ?
                           metadata.get("title") : "document.txt";
                }
            };

            TextReader reader = new TextReader(resource);
            List<Document> documents = reader.get();

            if (metadata != null) {
                for (Document doc : documents) {
                    doc.getMetadata().putAll(metadata);
                }
                documents.get(0).getMetadata().put("doc_id", documentId);
            }

            List<Document> splitDocuments = textSplitter.apply(documents);

            vectorStore.add(splitDocuments);

            saveVectorStore();

            logger.info("成功添加 {} 个文档片段到向量存储", splitDocuments.size());
        } catch (Exception e) {
            logger.error("添加文档失败: ", e);
            throw new RuntimeException("添加文档失败: " + e.getMessage());
        }
    }

    /**
     * 执行 RAG 问答
     *
     * @param question 问题
     * @param topK 召回条数
     * @return 回答内容
     */
    public String askWithRag(String question, int topK) {
        String prompt = buildRagPrompt(question, topK);
        String systemPrompt = "你是智能电网运维专家，请基于参考资料回答，先给结论再给步骤和注意事项。";

        try {
            String answer = chatClient.prompt()
                    .system(systemPrompt)
                    .user(prompt)
                    .call()
                    .content();

            logger.info("RAG问答完成 - 问题: {}, prompt长度: {}", question, prompt.length());
            return answer;

        } catch (Exception e) {
            logger.error("RAG 问答失败: ", e);
            throw new RuntimeException("RAG 问答失败: " + e.getMessage());
        }
    }

    /**
     * 构建 RAG 提示词
     *
     * @param question 问题
     * @param topK 召回条数
     * @return 提示词
     */
    public String buildRagPrompt(String question, int topK) {
        if (vectorStore == null) {
            logger.warn("向量存储未配置，使用原始问题作为提示词");
            return question;
        }

        List<Document> relevantDocs = Optional.ofNullable(vectorStore.similaritySearch(question))
                .orElse(Collections.emptyList());

        if (relevantDocs.size() > topK) {
            relevantDocs = relevantDocs.subList(0, topK);
        }

        StringBuilder context = new StringBuilder();
        if (!relevantDocs.isEmpty()) {
            context.append("基于以下参考资料回答问题：\n\n");
            for (int i = 0; i < relevantDocs.size(); i++) {
                context.append("参考资料 ").append(i + 1).append(":\n");
                context.append(relevantDocs.get(i).getText()).append("\n\n");
            }
        }

        if (context.length() > 0) {
            return String.format(
                "%s\n\n用户问题：%s\n\n请基于上述参考资料，提供专业、准确的回答。",
                context.toString(), question
            );
        } else {
            logger.warn("未找到相关文档，使用通用 AI 回答");
            return question;
        }
    }

    /**
     * 按固定结构生成运维表单内容
     *
     * @param question 问题
     * @param topK 召回条数
     * @return 运维表单响应
     */
    public MaintenanceFormResponse askWithFixedFormat(String question, int topK) {
        if (vectorStore == null) {
            logger.warn("向量存储未配置，使用默认 AI 回答");
            return generateDefaultResponse(question);
        }

        try {
            List<Document> relevantDocs = Optional.ofNullable(vectorStore.similaritySearch(question))
                    .orElse(Collections.emptyList());

            if (relevantDocs.size() > topK) {
                relevantDocs = relevantDocs.subList(0, topK);
            }

            StringBuilder context = new StringBuilder();
            if (!relevantDocs.isEmpty()) {
                for (int i = 0; i < relevantDocs.size(); i++) {
                    context.append("参考文档 ").append(i + 1).append(":\n");
                    context.append(relevantDocs.get(i).getText()).append("\n\n");
                }
            }

            if (context.length() == 0) {
                logger.warn("未找到相关文档，使用默认回答");
                return generateDefaultResponse(question);
            }

            String prompt = String.format(
                "你是一个智能电网运维专家。基于以下参考资料，生成标准化的运维操作表单。\n\n" +
                "参考资料：\n%s\n\n" +
                "用户问题：%s\n\n" +
                "请按以下JSON格式输出（必须严格遵循此格式）：\n" +
                "{\n" +
                "  \"deviceName\": \"设备名称\",\n" +
                "  \"faultDescription\": \"故障描述\",\n" +
                "  \"maintenanceType\": \"维护类型（预防性/纠正性/预测性）\",\n" +
                "  \"priorityLevel\": \"优先级（高/中/低）\",\n" +
                "  \"estimatedTime\": 预计耗时的数字（分钟）,\n" +
                "  \"requiredTools\": [\"工具1\", \"工具2\"],\n" +
                "  \"safetyPrecautions\": \"安全注意事项\",\n" +
                "  \"steps\": [\n" +
                "    {\"step\": 1, \"action\": \"操作名称\", \"detail\": \"详细说明\"},\n" +
                "    {\"step\": 2, \"action\": \"操作名称\", \"detail\": \"详细说明\"}\n" +
                "  ],\n" +
                "  \"expectedOutcome\": \"预期结果\"\n" +
                "}",
                context.toString(), question
            );

            String aiResponse = chatClient.prompt()
                    .user(prompt)
                    .call()
                    .content();

            logger.info("AI RAG 回答完成 - 问题: {}, 使用了 {} 个相关文档", question, relevantDocs.size());

            return parseAiResponse(aiResponse);

        } catch (Exception e) {
            logger.error("RAG 问答失败: ", e);
            throw new RuntimeException("RAG 问答失败: " + e.getMessage());
        }
    }

    private MaintenanceFormResponse parseAiResponse(String aiResponse) {
        try {
            String jsonStr = aiResponse.trim();
            if (jsonStr.startsWith("```json")) {
                jsonStr = jsonStr.substring(7);
            }
            if (jsonStr.startsWith("```")) {
                jsonStr = jsonStr.substring(3);
            }
            if (jsonStr.endsWith("```")) {
                jsonStr = jsonStr.substring(0, jsonStr.length() - 3);
            }
            jsonStr = jsonStr.trim();

            return JSON.parseObject(jsonStr, MaintenanceFormResponse.class);
        } catch (Exception e) {
            logger.error("解析 AI 响应失败，返回原始文本: ", e);
            MaintenanceFormResponse response = new MaintenanceFormResponse();
            response.setFaultDescription(aiResponse);
            return response;
        }
    }

    private MaintenanceFormResponse generateDefaultResponse(String question) {
        String defaultPrompt = String.format(
            "用户提问：%s\n\n" +
            "请按以下JSON格式输出运维操作表单：\n" +
            "{\n" +
            "  \"deviceName\": \"设备名称\",\n" +
            "  \"faultDescription\": \"故障描述\",\n" +
            "  \"maintenanceType\": \"维护类型\",\n" +
            "  \"priorityLevel\": \"优先级\",\n" +
            "  \"estimatedTime\": 60,\n" +
            "  \"requiredTools\": [\"工具列表\"],\n" +
            "  \"safetyPrecautions\": \"安全注意事项\",\n" +
            "  \"steps\": [{\"step\": 1, \"action\": \"操作\", \"detail\": \"详情\"}],\n" +
            "  \"expectedOutcome\": \"预期结果\"\n" +
            "}",
            question
        );

        String aiResponse = chatClient.prompt()
                .user(defaultPrompt)
                .call()
                .content();

        return parseAiResponse(aiResponse);
    }

    /**
     * 删除知识库文档
     *
     * @param documentId 文档ID
     */
    public void deleteDocument(String documentId) {
        if (vectorStore == null) {
            throw new RuntimeException("向量存储未配置");
        }

        try {
            vectorStore.delete(Collections.singletonList(documentId));
            saveVectorStore();
            logger.info("成功删除文档: ID={}", documentId);
        } catch (Exception e) {
            logger.error("删除文档失败: ", e);
            throw new RuntimeException("删除文档失败: " + e.getMessage());
        }
    }

    /**
     * 清空知识库
     */
    public void clearKnowledgeBase() {
        if (vectorStore == null) {
            throw new RuntimeException("向量存储未配置");
        }

        try {
            if (vectorStore instanceof org.springframework.ai.vectorstore.SimpleVectorStore) {
                try {
                    File storeFile = new File(vectorStoreFile);
                    if (storeFile.exists()) {
                        storeFile.delete();
                        logger.info("已删除向量存储文件: {}", vectorStoreFile);
                    }
                    storeFile.getParentFile().mkdirs();
                    storeFile.createNewFile();
                    logger.info("知识库已清空");
                } catch (Exception e) {
                    logger.warn("清空向量存储文件失败: {}", e.getMessage());
                    throw new RuntimeException("清空知识库失败: " + e.getMessage());
                }
            } else {
                logger.warn("当前向量存储类型不支持直接清空，请手动删除存储文件");
                throw new RuntimeException("当前向量存储类型不支持清空操作");
            }
        } catch (Exception e) {
            logger.error("清空知识库失败: ", e);
            throw new RuntimeException("清空知识库失败: " + e.getMessage());
        }
    }

    private void saveVectorStore() {
        if (vectorStore instanceof org.springframework.ai.vectorstore.SimpleVectorStore) {
            try {
                File storeFile = new File(vectorStoreFile);
                ((org.springframework.ai.vectorstore.SimpleVectorStore) vectorStore).save(storeFile);
                logger.debug("向量存储已保存到文件: {}", vectorStoreFile);
            } catch (Exception e) {
                logger.warn("保存向量存储失败: {}", e.getMessage());
            }
        }
    }

    /**
     * 获取 RAG 运行时状态（用于健康检查和快速排障）
     *
     * @return 状态信息
     */
    public Map<String, Object> getRuntimeStatus() {
        Map<String, Object> status = new LinkedHashMap<>();
        File storeFile = new File(vectorStoreFile);
        File parentDir = storeFile.getParentFile();
        boolean embeddingEnabled = vectorStore != null;

        status.put("embeddingEnabled", embeddingEnabled);
        status.put("ragMode", embeddingEnabled ? "vector_rag" : "llm_only_fallback");
        status.put("vectorStoreType", vectorStore == null ? "none" : vectorStore.getClass().getName());
        status.put("vectorStoreFile", storeFile.getAbsolutePath());
        status.put("vectorStoreFileExists", storeFile.exists());
        status.put("vectorStoreFileSizeBytes", storeFile.exists() ? storeFile.length() : 0L);
        status.put("vectorStoreParentDirWritable", parentDir == null || parentDir.exists() && parentDir.canWrite());
        status.put("advice", embeddingEnabled
                ? "向量检索已启用，可正常执行 RAG 相似度召回"
                : "未注入 EmbeddingModel，请检查 spring.ai.dashscope.api-key 与自动配置排除项");
        return status;
    }

    public static class MaintenanceFormResponse {
        private String deviceName;
        private String faultDescription;
        private String maintenanceType;
        private String priorityLevel;
        private Integer estimatedTime;
        private List<String> requiredTools;
        private String safetyPrecautions;
        private List<MaintenanceStep> steps;
        private String expectedOutcome;

        public String getDeviceName() { return deviceName; }
        public void setDeviceName(String deviceName) { this.deviceName = deviceName; }

        public String getFaultDescription() { return faultDescription; }
        public void setFaultDescription(String faultDescription) { this.faultDescription = faultDescription; }

        public String getMaintenanceType() { return maintenanceType; }
        public void setMaintenanceType(String maintenanceType) { this.maintenanceType = maintenanceType; }

        public String getPriorityLevel() { return priorityLevel; }
        public void setPriorityLevel(String priorityLevel) { this.priorityLevel = priorityLevel; }

        public Integer getEstimatedTime() { return estimatedTime; }
        public void setEstimatedTime(Integer estimatedTime) { this.estimatedTime = estimatedTime; }

        public List<String> getRequiredTools() { return requiredTools; }
        public void setRequiredTools(List<String> requiredTools) { this.requiredTools = requiredTools; }

        public String getSafetyPrecautions() { return safetyPrecautions; }
        public void setSafetyPrecautions(String safetyPrecautions) { this.safetyPrecautions = safetyPrecautions; }

        public List<MaintenanceStep> getSteps() { return steps; }
        public void setSteps(List<MaintenanceStep> steps) { this.steps = steps; }

        public String getExpectedOutcome() { return expectedOutcome; }
        public void setExpectedOutcome(String expectedOutcome) { this.expectedOutcome = expectedOutcome; }
    }

    public static class MaintenanceStep {
        private Integer step;
        private String action;
        private String detail;

        public Integer getStep() { return step; }
        public void setStep(Integer step) { this.step = step; }

        public String getAction() { return action; }
        public void setAction(String action) { this.action = action; }

        public String getDetail() { return detail; }
        public void setDetail(String detail) { this.detail = detail; }
    }
}
