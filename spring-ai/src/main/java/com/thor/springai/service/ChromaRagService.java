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
import java.util.stream.Collectors;

/**
 * 基于内存向量存储的 RAG 服务
 * 
 * @author ruoyi
 */
@Service
public class ChromaRagService {

    private static final Logger logger = LoggerFactory.getLogger(ChromaRagService.class);
    
    private final ChatClient chatClient;
    private final VectorStore vectorStore;
    private final TokenTextSplitter textSplitter;

    @Value("${spring.ai.vectorstore.simple.store-file:data/vector-store.json}")
    private String vectorStoreFile;

    @Autowired
    public ChromaRagService(ChatClient.Builder builder, 
                           @Autowired(required = false) VectorStore vectorStore,
                           TokenTextSplitter textSplitter) {
        this.chatClient = builder.build();
        this.vectorStore = vectorStore;
        this.textSplitter = textSplitter;
    }

    /**
     * 添加文档到向量数据库
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
            // 创建文档资源
            ByteArrayResource resource = new ByteArrayResource(content.getBytes()) {
                @Override
                public String getFilename() {
                    return metadata != null && metadata.containsKey("title") ? 
                           metadata.get("title") : "document.txt";
                }
            };
            
            // 读取并分割文档
            TextReader reader = new TextReader(resource);
            List<Document> documents = reader.get();
            
            // 添加元数据
            if (metadata != null) {
                for (Document doc : documents) {
                    doc.getMetadata().putAll(metadata);
                }
                documents.get(0).getMetadata().put("doc_id", documentId);
            }
            
            // 分割文档
            List<Document> splitDocuments = textSplitter.apply(documents);
            
            // 添加到向量存储
            vectorStore.add(splitDocuments);
            
            // 持久化到文件
            saveVectorStore();
            
            logger.info("成功添加 {} 个文档片段到向量存储", splitDocuments.size());
        } catch (Exception e) {
            logger.error("添加文档失败: ", e);
            throw new RuntimeException("添加文档失败: " + e.getMessage());
        }
    }

    /**
     * 基于 RAG 的问答（固定输出格式）
     * 
     * @param question 用户问题
     * @param topK 返回最相关的文档数量
     * @return 固定格式的回答
     */
    public MaintenanceFormResponse askWithFixedFormat(String question, int topK) {
        if (vectorStore == null) {
            logger.warn("向量存储未配置，使用默认 AI 回答");
            return generateDefaultResponse(question);
        }
        
        try {
            // 1. 从向量存储检索相关文档
            List<Document> relevantDocs = vectorStore.similaritySearch(question);
            
            // 限制返回数量
            if (relevantDocs.size() > topK) {
                relevantDocs = relevantDocs.subList(0, topK);
            }
            
            // 2. 构建上下文
            StringBuilder context = new StringBuilder();
            if (relevantDocs != null && !relevantDocs.isEmpty()) {
                for (int i = 0; i < relevantDocs.size(); i++) {
                    context.append("参考文档 ").append(i + 1).append(":\n");
                    context.append(relevantDocs.get(i).getText()).append("\n\n");
                }
            }
            
            if (context.length() == 0) {
                logger.warn("未找到相关文档，使用默认回答");
                return generateDefaultResponse(question);
            }
            
            // 3. 构建固定格式的提示词
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
            
            // 4. 调用 AI 生成回答
            String aiResponse = chatClient.prompt()
                    .user(prompt)
                    .call()
                    .content();
            
            logger.info("AI RAG 回答完成 - 问题: {}, 使用了 {} 个相关文档", question, relevantDocs.size());
            
            // 5. 解析 JSON 响应
            return parseAiResponse(aiResponse);
            
        } catch (Exception e) {
            logger.error("RAG 问答失败: ", e);
            throw new RuntimeException("RAG 问答失败: " + e.getMessage());
        }
    }

    /**
     * 解析 AI 响应为固定格式
     */
    private MaintenanceFormResponse parseAiResponse(String aiResponse) {
        try {
            // 提取 JSON 部分（去除可能的 markdown 代码块标记）
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
            
            // 解析 JSON
            return JSON.parseObject(jsonStr, MaintenanceFormResponse.class);
        } catch (Exception e) {
            logger.error("解析 AI 响应失败，返回原始文本: ", e);
            MaintenanceFormResponse response = new MaintenanceFormResponse();
            response.setFaultDescription(aiResponse);
            return response;
        }
    }

    /**
     * 生成默认响应
     */
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
     * 删除文档
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
     * 持久化向量存储到文件
     */
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
     * 固定格式的响应对象
     */
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

        // Getters and Setters
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

    /**
     * 维护步骤对象
     */
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
