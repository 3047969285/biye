package com.ruoyi.framework.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;
import org.springframework.web.socket.server.standard.ServerEndpointExporter;
import com.ruoyi.framework.websocket.ChatWebSocketHandler;
import com.ruoyi.framework.websocket.WebSocketInterceptor;

/**
 * WebSocket配置类
 * 
 * @author ruoyi
 */
@Configuration
@EnableWebSocket
public class WebSocketConfig implements WebSocketConfigurer
{
    @Autowired
    private ChatWebSocketHandler chatWebSocketHandler;
    
    @Autowired
    private WebSocketInterceptor webSocketInterceptor;

    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry)
    {
        // 注册WebSocket处理器
        registry.addHandler(chatWebSocketHandler, "/websocket/chat")
                .addInterceptors(webSocketInterceptor)
                .setAllowedOrigins("*"); // 允许跨域
    }

    /**
     * 注入ServerEndpointExporter，这个bean会自动注册使用了@ServerEndpoint注解声明的WebSocket endpoint
     */
    @Bean
    public ServerEndpointExporter serverEndpointExporter()
    {
        return new ServerEndpointExporter();
    }
}

