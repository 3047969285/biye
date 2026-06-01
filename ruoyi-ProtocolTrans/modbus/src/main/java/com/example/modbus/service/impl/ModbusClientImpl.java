package com.example.modbus.service.impl;


import com.example.modbus.config.ConnectionConfig;
import com.example.modbus.config.ModbusConnectionPool;
import com.example.modbus.core.master.AsyncModbusExecutor;
import com.example.modbus.core.master.FixedRetryPolicy;
import com.example.modbus.core.master.ModbusOperations;
import com.example.modbus.exception.ModbusClientException;
import com.example.modbus.service.ModbusClient;
import lombok.extern.slf4j.Slf4j;

import java.util.Map;
import java.util.concurrent.CompletableFuture;

/**
 * Modbus客户端实现
 */
@Slf4j
public class ModbusClientImpl implements ModbusClient {
    private final ModbusConnectionPool connectionPool;
    private final ModbusOperations operations;
    private final AsyncModbusExecutor asyncExecutor;
    private volatile boolean shutdown = false;

    public ModbusClientImpl(ConnectionConfig config) {
        this.connectionPool = new ModbusConnectionPool(config);
        this.operations = new ModbusOperations(
            connectionPool,
            new FixedRetryPolicy(config.getRetries(), 500)
        );
        this.asyncExecutor = new AsyncModbusExecutor(operations);
    }

    @Override
    public boolean[] readCoils(String host, int port, int slaveId, int start, int length)
            throws ModbusClientException {
        checkShutdown();
        return operations.readCoils(host, port, slaveId, start, length);
    }

    @Override
    public short[] readHoldingRegisters(String host, int port, int slaveId, int start, int length)
            throws ModbusClientException {
        checkShutdown();
        return operations.readHoldingRegisters(host, port, slaveId, start, length);
    }

    @Override
    public short[] readInputRegisters(String host, int port, int slaveId, int start, int length)
            throws ModbusClientException {
        checkShutdown();
        return operations.readInputRegisters(host, port, slaveId, start, length);
    }

    @Override
    public boolean[] readDiscreteInputs(String host, int port, int slaveId, int start, int length)
            throws ModbusClientException {
        checkShutdown();
        return operations.readDiscreteInputs(host, port, slaveId, start, length);
    }

    @Override
    public void writeCoil(String host, int port, int slaveId, int address, boolean value)
            throws ModbusClientException {
        checkShutdown();
        operations.writeCoil(host, port, slaveId, address, value);
    }

    @Override
    public void writeRegister(String host, int port, int slaveId, int address, int value)
            throws ModbusClientException {
        checkShutdown();
        operations.writeRegister(host, port, slaveId, address, value);
    }

    @Override
    public void writeCoils(String host, int port, int slaveId, int start, boolean[] values)
            throws ModbusClientException {
        checkShutdown();
        operations.writeCoils(host, port, slaveId, start, values);
    }

    @Override
    public void writeRegisters(String host, int port, int slaveId, int start, short[] values)
            throws ModbusClientException {
        checkShutdown();
        operations.writeRegisters(host, port, slaveId, start, values);
    }

    @Override
    public CompletableFuture<boolean[]> readCoilsAsync(
            String host, int port, int slaveId, int start, int length) {
        checkShutdown();
        return asyncExecutor.readCoilsAsync(host, port, slaveId, start, length);
    }

    @Override
    public CompletableFuture<Void> writeCoilAsync(
            String host, int port, int slaveId, int address, boolean value) {
        checkShutdown();
        return asyncExecutor.writeCoilAsync(host, port, slaveId, address, value);
    }

    @Override
    public CompletableFuture<short[]> readHoldingRegistersAsync(
            String host, int port, int slaveId, int start, int length) {
        checkShutdown();
        return asyncExecutor.readHoldingRegistersAsync(host, port, slaveId, start, length);
    }

    @Override
    public boolean checkConnection(String host, int port) {
        try {
            // 尝试读取一个线圈来测试连接
            readCoils(host, port, 1, 0, 1);
            return true;
        } catch (ModbusClientException e) {
            log.debug("连接测试失败: {}:{} - {}", host, port, e.getMessage());
            return false;
        }
    }

    @Override
    public Map<String, Object> getPoolStatus() {
        return connectionPool.getPoolStatus();
    }

    @Override
    public void shutdown() {
        if (shutdown) {
            return;
        }
        shutdown = true;

        log.info("关闭Modbus客户端...");
        asyncExecutor.shutdown();
        connectionPool.shutdown();
        log.info("Modbus客户端已关闭");
    }

    private void checkShutdown() {
        if (shutdown) {
            throw new IllegalStateException("Modbus客户端已关闭");
        }
    }
}
