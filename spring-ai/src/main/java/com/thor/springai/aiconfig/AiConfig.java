package com.thor.springai.aiconfig;

import org.springframework.context.annotation.Configuration;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.context.annotation.Bean;
import org.springframework.beans.factory.annotation.Value;

@Configuration
public class AiConfig {

    @Value("${spring.ai.dashscope.api-key:}")
    private String dashScopeApiKey;

    @Bean
    public ChatClient chatClient(ChatClient.Builder builder) {
        return builder.build();
    }
}