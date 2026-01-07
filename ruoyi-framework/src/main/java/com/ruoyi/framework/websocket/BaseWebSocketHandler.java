package com.ruoyi.framework.websocket;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

/**
 * Minimal WebSocket handler used for notification or future extensions.
 */
@Component
public class BaseWebSocketHandler extends TextWebSocketHandler
{
    private static final Logger log = LoggerFactory.getLogger(BaseWebSocketHandler.class);

    @Override
    public void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception
    {
        log.debug("Received WebSocket message ({}): {}", session.getId(), message.getPayload());
        session.sendMessage(new TextMessage("{\"status\":\"ok\"}"));
    }
}
