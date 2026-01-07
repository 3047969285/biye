package com.ruoyi.framework.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;
import com.ruoyi.framework.websocket.BaseWebSocketHandler;
import com.ruoyi.framework.websocket.WebSocketInterceptor;

/**
 * 简单的 WebSocket 注册配置（保留基础能力，后续可以拓展）。
 */
@Configuration
@EnableWebSocket
public class WebSocketConfig implements WebSocketConfigurer
{
    @Autowired
    private BaseWebSocketHandler baseWebSocketHandler;

    @Autowired
    private WebSocketInterceptor webSocketInterceptor;

    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry)
    {
        registry.addHandler(baseWebSocketHandler, "/websocket/ws")
            .addInterceptors(webSocketInterceptor)
            .setAllowedOrigins("*");
    }
}
