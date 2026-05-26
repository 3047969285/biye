package com.thor.springai.aiconfig;

import com.thor.springai.service.ChromaRagService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.stereotype.Component;

import java.util.Map;

/**
 * 应用启动后打印 RAG 运行状态摘要。
 */
@Component
public class RagStartupHealthLogger implements ApplicationRunner {

    private static final Logger logger = LoggerFactory.getLogger(RagStartupHealthLogger.class);

    private final ChromaRagService chromaRagService;

    public RagStartupHealthLogger(ChromaRagService chromaRagService) {
        this.chromaRagService = chromaRagService;
    }

    @Override
    public void run(ApplicationArguments args) {
        try {
            Map<String, Object> status = chromaRagService.getRuntimeStatus();
            logger.info("RAG运行状态: mode={}, embeddingEnabled={}, vectorStoreType={}, storeFileExists={}, storeFile={}",
                    status.get("ragMode"),
                    status.get("embeddingEnabled"),
                    status.get("vectorStoreType"),
                    status.get("vectorStoreFileExists"),
                    status.get("vectorStoreFile"));
        } catch (Exception e) {
            logger.warn("RAG 运行状态自检失败: {}", e.getMessage());
        }
    }
}
