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
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;

/**
 * Spring AI 配置
 *
 * @author wangchangzhen
 */
@Configuration
public class AiConfig {
    private static final Logger logger = LoggerFactory.getLogger(AiConfig.class);

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
            logger.warn("未注入 EmbeddingModel，VectorStore 不可用，RAG 将退化为无检索回答");
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
                logger.warn("向量存储加载失败，将以空库启动: {}", storeFile.getAbsolutePath());
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
