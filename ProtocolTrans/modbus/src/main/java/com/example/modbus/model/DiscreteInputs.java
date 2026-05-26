package com.example.modbus.model;


import lombok.Data;
import org.springframework.stereotype.Component;

import java.util.concurrent.locks.ReentrantLock;

/**
 * 离散输入共享缓存（预留，暂未启用）
 */
@Data
@Component
public class DiscreteInputs {

    private byte[] inputs = new byte[20];
    private ReentrantLock lock = new ReentrantLock();

    /**
     * 读取数据
     * @param offset 偏移量 (0 代表 1, 1 代表 2)
     * @param count  要读取的离散输入数量
     *
     * @return 读取的离散输入数据
     */
    public byte[] readInputs(int offset, int count) {
        lock.lock();
        try {
            byte[] result = new byte[count];
            System.arraycopy(inputs, offset, result, 0, count);
            return result;
        } finally {
            lock.unlock();
        }
    }
    /**
     * 写入数据
     * @param offset 偏移量 (0 代表 1, 1 代表 2)
     * @param value  要写入的值
     */
    public void writeInput(int offset, byte value) {
        lock.lock();
        try {
            if (offset >= 0 && offset < inputs.length) {
                inputs[offset] = value;
            }
        } finally {
            lock.unlock();
        }
    }
}
