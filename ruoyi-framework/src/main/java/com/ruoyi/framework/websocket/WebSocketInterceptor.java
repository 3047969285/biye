package com.ruoyi.framework.websocket;

import java.util.Map;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.server.HandshakeInterceptor;

/**
 * WebSocket拦截器，用于在握手时进行身份验证
 * 
 * @author ruoyi
 */
@Component
public class WebSocketInterceptor implements HandshakeInterceptor
{
    @Override
    public boolean beforeHandshake(ServerHttpRequest request, ServerHttpResponse response,
            WebSocketHandler wsHandler, Map<String, Object> attributes) throws Exception
    {
        // 从请求参数中获取token
        String query = request.getURI().getQuery();
        if (query != null && query.contains("token="))
        {
            String token = query.substring(query.indexOf("token=") + 6);
            if (token.contains("&"))
            {
                token = token.substring(0, token.indexOf("&"));
            }
            attributes.put("token", token);
        }
        return true;
    }

    @Override
    public void afterHandshake(ServerHttpRequest request, ServerHttpResponse response,
            WebSocketHandler wsHandler, Exception exception)
    {
        // 握手后的处理
    }
}

