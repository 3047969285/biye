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

@Configuration
public class AiConfig {

    @Value("${spring.ai.vectorstore.simple.store-file:data/vector-store.json}")
    private String vectorStoreFile;

    @Bean
    public ChatClient chatClient(ChatClient.Builder builder) {
        return builder.build();
    }

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

    @Bean
    public TokenTextSplitter textSplitter() {
        return new TokenTextSplitter();
    }
}
