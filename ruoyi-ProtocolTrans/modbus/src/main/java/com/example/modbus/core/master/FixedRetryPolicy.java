package com.example.modbus.core.master;

import com.example.modbus.exception.ModbusClientException;
import lombok.extern.slf4j.Slf4j;

import java.util.function.Supplier;

/**
 * 固定重试策略
 *
 * @author wangchangzhen
 */
@Slf4j
public class FixedRetryPolicy implements RetryPolicy {
    private final int maxRetries;
    private final long delayMs;

    public FixedRetryPolicy(int maxRetries, long delayMs) {
        this.maxRetries = maxRetries;
        this.delayMs = delayMs;
    }

    @Override
    public <T> T execute(Supplier<T> operation, String operationName) throws ModbusClientException {
        int attempt = 0;

        while (true) {
            attempt++;
            try {
                return operation.get();

            } catch (RuntimeException e) {
                // 关键：解包RuntimeException
                Throwable cause = e.getCause();

                if (cause instanceof ModbusClientException) {
                    ModbusClientException modbusException = (ModbusClientException) cause;

                    if (attempt > maxRetries) {
                        throw new ModbusClientException(
                                operationName + "失败，重试" + maxRetries + "次后放弃",
                                modbusException);
                    }

                    log.error("{}失败，第{}次重试... 原因: {}",
                            operationName, attempt, modbusException.getMessage());
                    if (delayMs > 0) {
                        try {
                            Thread.sleep(delayMs);
                        } catch (InterruptedException ie) {
                            Thread.currentThread().interrupt();
                            throw new ModbusClientException("重试被中断", ie);
                        }
                    }

                } else {
                    // 其他RuntimeException
                    throw new ModbusClientException(
                            operationName + "失败: " + e.getMessage(), e);
                }

            } catch (Exception e) {
                // 理论上不会走到这里，因为所有异常都被包装为RuntimeException了
                throw new ModbusClientException(operationName + "失败: " + e.getMessage(), e);
            }
        }
    }
}
