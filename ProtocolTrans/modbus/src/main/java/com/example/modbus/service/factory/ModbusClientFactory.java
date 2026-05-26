package com.example.modbus.service.factory;


import com.example.modbus.config.ConnectionConfig;
import com.example.modbus.service.ModbusClient;
import com.example.modbus.service.impl.ModbusClientImpl;

/**
 * Modbus客户端工厂
 * 使用工厂模式创建客户端实例
 *
 * @author wangchangzhen
 */
public class ModbusClientFactory {

    /**
     * 创建默认配置的客户端
     */
    public static ModbusClient createDefaultClient() {
        ConnectionConfig config = new ConnectionConfig();
        config.setTimeout(3000);
        config.setRetries(3);
        config.setMaxConnections(10);
        config.setIdleTimeout(300000);

        return new ModbusClientImpl(config);
    }

    /**
     * 根据配置创建客户端
     */
    public static ModbusClient createClient(ConnectionConfig config) {
        return new ModbusClientImpl(config);
    }

    /**
     * 创建高性能客户端（适合大量并发）
     */
    public static ModbusClient createHighPerformanceClient() {
        ConnectionConfig config = new ConnectionConfig();
        config.setTimeout(5000);
        config.setRetries(2);
        config.setMaxConnections(50);
        config.setIdleTimeout(60000); // 1分钟空闲就清理

        return new ModbusClientImpl(config);
    }

    /**
     * 创建高可用客户端（适合不稳定网络）
     */
    public static ModbusClient createHighAvailabilityClient() {
        ConnectionConfig config = new ConnectionConfig();
        config.setTimeout(10000);
        config.setRetries(5);
        config.setMaxConnections(5);
        config.setIdleTimeout(600000); // 10分钟空闲才清理

        return new ModbusClientImpl(config);
    }
}
