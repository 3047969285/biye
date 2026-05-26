package com.example.modbus.service.factory;

import com.example.modbus.config.ConnectionConfig;
import com.example.modbus.service.ModbusClient;
import com.example.modbus.service.factory.ModbusClientFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;

/**
 * Modbus 服务工厂，负责客户端生命周期管理。
 *
 * @author wangchangzhen
 */
@Component
@ConditionalOnProperty(prefix = "protocol-trans.modbus.client", name = "enabled", havingValue = "true")
public class ModbusServiceFactory {

    @Value("${protocol-trans.modbus.client.timeout:3000}")
    private int timeout;

    @Value("${protocol-trans.modbus.client.retries:3}")
    private int retries;

    @Value("${protocol-trans.modbus.client.max-connections:10}")
    private int maxConnections;

    @Value("${protocol-trans.modbus.client.idle-timeout:300000}")
    private long idleTimeout;

    private final ModbusClient modbusClient;

    public ModbusServiceFactory() {
        this.modbusClient = ModbusClientFactory.createClient(buildDefaultConfig());
    }

    private ConnectionConfig buildDefaultConfig() {
        ConnectionConfig config = new ConnectionConfig();
        config.setTimeout(timeout);
        config.setRetries(retries);
        config.setMaxConnections(maxConnections);
        config.setIdleTimeout(idleTimeout);
        config.setEncapsulated(false);
        return config;
    }
}
