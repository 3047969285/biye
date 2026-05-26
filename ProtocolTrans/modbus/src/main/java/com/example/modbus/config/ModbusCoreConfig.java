package com.example.modbus.config;

import com.example.modbus.core.master.ExponentialBackoffRetryPolicy;
import com.example.modbus.core.master.ModbusOperations;
import com.example.modbus.core.master.RetryPolicy;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class ModbusCoreConfig {

    /**
     * 创建重试策略 Bean
     */
    @Bean
    public RetryPolicy retryPolicy(ConnectionConfig config) {
        return new ExponentialBackoffRetryPolicy(
                config.getRetries(),
                100,
                5000
        );
    }

    /**
     * 创建连接池 Bean
     */
    @Bean
    public ModbusConnectionPool modbusConnectionPool(ConnectionConfig config) {
        return new ModbusConnectionPool(config);
    }

    /**
     * 创建 Modbus 操作 Bean
     */
    @Bean
    public ModbusOperations modbusOperations(ModbusConnectionPool connectionPool, RetryPolicy retryPolicy) {
        return new ModbusOperations(connectionPool, retryPolicy);
    }
}
