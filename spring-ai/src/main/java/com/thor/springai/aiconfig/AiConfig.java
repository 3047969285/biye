package com.thor.springai.aiconfig;

import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.document.Document;
import org.springframework.ai.embedding.EmbeddingModel;
import org.springframework.ai.reader.TextReader;
import org.springframework.ai.transformer.splitter.TokenTextSplitter;
import org.springframework.ai.vectorstore.SimpleVectorStore;
import org.springframework.ai.vectorstore.VectorStore;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.Resource;

import java.io.File;
import java.util.List;

/**
 * Spring AI 配置类 - 使用内存向量存储
 * 
 * @author ruoyi
 */
@Configuration
public class AiConfig {

    @Value("${spring.ai.vectorstore.simple.store-file:data/vector-store.json}")
    private String vectorStoreFile;

    /**
     * 配置 ChatClient
     */
    @Bean
    public ChatClient chatClient(ChatClient.Builder builder) {
        return builder.build();
    }

    /**
     * 配置 SimpleVectorStore（内存向量存储，支持持久化）
     */
    @Bean
    public VectorStore vectorStore(@Autowired(required = false) EmbeddingModel embeddingModel) {
        if (embeddingModel == null) {
            // 如果没有 EmbeddingModel，返回 null
            // RAG 服务会降级到直接使用 AI 对话
            return null;
        }
        
        // 创建存储文件目录
        File storeFile = new File(vectorStoreFile);
        File parentDir = storeFile.getParentFile();
        if (parentDir != null && !parentDir.exists()) {
            parentDir.mkdirs();
        }
        
        // 创建 SimpleVectorStore
        SimpleVectorStore vectorStore = SimpleVectorStore.builder(embeddingModel).build();
        
        // 如果存储文件存在，加载数据
        if (storeFile.exists()) {
            try {
                vectorStore.load(storeFile);
            } catch (Exception e) {
                // 加载失败，使用空的向量存储
            }
        }
        
        return vectorStore;
    }

    /**
     * 配置文本分割器
     */
    @Bean
    public TokenTextSplitter textSplitter() {
        return new TokenTextSplitter();
    }
}