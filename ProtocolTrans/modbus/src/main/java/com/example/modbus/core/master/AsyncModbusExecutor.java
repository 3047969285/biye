package com.example.modbus.core.master;

import com.example.modbus.exception.ModbusClientException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.util.concurrent.*;
import java.util.function.Supplier;

/**
 * 异步执行器
 * 使用装饰器模式增强同步操作
 *
 * @author wangchangzhen
 */
@Slf4j
@RequiredArgsConstructor
public class AsyncModbusExecutor {
    private final ModbusOperations operations;
    private final ExecutorService executorService;
    private final ScheduledExecutorService scheduledExecutorService;

    /**
     * 默认线程池
     */
    public AsyncModbusExecutor(ModbusOperations operations) {
        this.operations = operations;
        this.executorService = Executors.newCachedThreadPool(
                r -> new Thread(r, "modbus-async-" + ThreadLocalRandom.current().nextInt(1000))
        );
        this.scheduledExecutorService = Executors.newSingleThreadScheduledExecutor(
                r -> new Thread(r, "modbus-timeout-scheduler")
        );
    }

    /**
     * 异步读取线圈
     */
    public CompletableFuture<boolean[]> readCoilsAsync(
            String host, int port, int slaveId, int start, int length) {

        return CompletableFuture.supplyAsync(() -> {
            try {
                return operations.readCoils(host, port, slaveId, start, length);
            } catch (ModbusClientException e) {
                throw new CompletionException(e);
            }
        }, executorService);
    }

    /**
     * 异步写入线圈
     */
    public CompletableFuture<Void> writeCoilAsync(
            String host, int port, int slaveId, int address, boolean value) {

        return CompletableFuture.runAsync(() -> {
            try {
                operations.writeCoil(host, port, slaveId, address, value);
            } catch (ModbusClientException e) {
                throw new CompletionException(e);
            }
        }, executorService);
    }

    /**
     * 异步读取保持寄存器
     */
    public CompletableFuture<short[]> readHoldingRegistersAsync(
            String host, int port, int slaveId, int start, int length) {

        return CompletableFuture.supplyAsync(() -> {
            try {
                return operations.readHoldingRegisters(host, port, slaveId, start, length);
            } catch (ModbusClientException e) {
                throw new CompletionException(e);
            }
        }, executorService);
    }

    /**
     * 带超时的异步操作
     */
    public <T> CompletableFuture<T> executeWithTimeout(
            Supplier<T> operation, long timeout, TimeUnit unit) {

        CompletableFuture<T> future = new CompletableFuture<>();

        // 提交任务
        executorService.submit(() -> {
            try {
                T result = operation.get();
                future.complete(result);
            } catch (Exception e) {
                future.completeExceptionally(e);
            }
        });

        // 设置超时调度
        scheduledExecutorService.schedule(() -> {
            if (!future.isDone()) {
                future.completeExceptionally(
                        new TimeoutException("操作超时: " + timeout + " " + unit)
                );
            }
        }, timeout, unit);

        return future;

    }

    /**
     * 关闭线程池
     */
    public void shutdown() {
        executorService.shutdown();
        scheduledExecutorService.shutdown();

        try {
            if (!executorService.awaitTermination(5, TimeUnit.SECONDS)) {
                executorService.shutdownNow();
            }
            if (!scheduledExecutorService.awaitTermination(5, TimeUnit.SECONDS)) {
                scheduledExecutorService.shutdownNow();
            }
        } catch (InterruptedException e) {
            executorService.shutdownNow();
            scheduledExecutorService.shutdownNow();
            Thread.currentThread().interrupt();
        }
    }
}
