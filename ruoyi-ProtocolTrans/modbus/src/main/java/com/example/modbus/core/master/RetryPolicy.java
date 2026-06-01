package com.example.modbus.core.master;

import com.example.modbus.exception.ModbusClientException;

import java.util.function.Supplier;

/**
 * @author wangchangzhen
 * 重试策略
 */
public interface RetryPolicy {
    <T> T execute(Supplier<T> operation, String operationName) throws ModbusClientException;
}
