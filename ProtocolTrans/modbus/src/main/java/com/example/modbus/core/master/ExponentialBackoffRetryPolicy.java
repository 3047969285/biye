package com.example.modbus.core.master;

import com.example.modbus.exception.ModbusClientException;
import lombok.extern.slf4j.Slf4j;

import java.util.function.Supplier;

/**
 * 指数退避重试策略
 *
 * @author wangchangzhen
 */
@Slf4j
public class ExponentialBackoffRetryPolicy implements RetryPolicy {
    private final int maxRetries;
    private final long initialDelayMs;
    private final long maxDelayMs;

    public ExponentialBackoffRetryPolicy(int maxRetries, long initialDelayMs, long maxDelayMs) {
        this.maxRetries = maxRetries;
        this.initialDelayMs = initialDelayMs;
        this.maxDelayMs = maxDelayMs;
    }

    @Override
    public <T> T execute(Supplier<T> operation, String operationName) throws ModbusClientException {
        int attempt = 0;
        long delay = initialDelayMs;

        while (true) {
            attempt++;
            try {
                return operation.get();

            } catch (RuntimeException e) {
                Throwable cause = e.getCause();

                if (cause instanceof ModbusClientException) {
                    ModbusClientException modbusException = (ModbusClientException) cause;

                    if (attempt > maxRetries) {
                        throw new ModbusClientException(
                                operationName + "失败，重试" + maxRetries + "次后放弃",
                                modbusException);
                    }

                    log.error("{}失败，第{}次重试，等待{}ms... 原因: {}",
                            operationName, attempt, delay, modbusException.getMessage());
                    try {
                        Thread.sleep(delay);
                        delay = Math.min(delay * 2, maxDelayMs);
                    } catch (InterruptedException ie) {
                        Thread.currentThread().interrupt();
                        throw new ModbusClientException("重试被中断", ie);
                    }

                } else {
                    throw new ModbusClientException(
                            operationName + "失败: " + e.getMessage(), e);
                }

            } catch (Exception e) {
                throw new ModbusClientException(operationName + "失败: " + e.getMessage(), e);
            }
        }
    }

}
