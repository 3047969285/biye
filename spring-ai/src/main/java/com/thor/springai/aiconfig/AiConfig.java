package com.thor.springai.aiconfig;

import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.embedding.EmbeddingModel;
import org.springframework.ai.transformer.splitter.TokenTextSplitter;
import org.springframework.ai.vectorstore.SimpleVectorStore;
import org.springframework.ai.vectorstore.VectorStore;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.io.File;

/**
 * Spring AI 配置
 *
 * @author thor
 */
@Configuration
public class AiConfig {

    @Value("${spring.ai.vectorstore.simple.store-file:data/vector-store.json}")
    private String vectorStoreFile;

    /**
     * 创建 AI 对话客户端
     *
     * @param builder ChatClient 构建器
     * @return ChatClient
     */
    @Bean
    public ChatClient chatClient(ChatClient.Builder builder) {
        return builder.build();
    }

    /**
     * 创建向量存储实例
     *
     * @param embeddingModel 向量模型
     * @return 向量存储
     */
    @Bean
    public VectorStore vectorStore(@Autowired(required = false) EmbeddingModel embeddingModel) {
        if (embeddingModel == null) {
            return null;
        }

        File storeFile = new File(vectorStoreFile);
        File parentDir = storeFile.getParentFile();
        if (parentDir != null && !parentDir.exists()) {
            parentDir.mkdirs();
        }

        SimpleVectorStore vectorStore = SimpleVectorStore.builder(embeddingModel).build();

        if (storeFile.exists()) {
            try {
                vectorStore.load(storeFile);
            } catch (Exception ignored) {
            }
        }

        return vectorStore;
    }

    /**
     * 创建文本切分器
     *
     * @return TokenTextSplitter
     */
    @Bean
    public TokenTextSplitter textSplitter() {
        return new TokenTextSplitter();
    }
}
