package com.example.modbus.model;

import lombok.Data;
import org.springframework.stereotype.Component;

import java.util.concurrent.locks.ReentrantLock;

/**
 * 线圈共享缓存（预留，暂未启用）
 */
@Data
@Component
public class Coils {

    private byte[] coils = new byte[20];

    private ReentrantLock lock = new ReentrantLock();

    /**
     * 写入数据
     *
     * @param offset 偏移量 (0 代表 1, 1 代表 2)
     * @param value  要写入的值
     */
    public void writeCoil(int offset, boolean value) {
        lock.lock();
        try {
            if (offset >= 0 && offset < coils.length) {
                coils[offset] = (byte) (value ? 0xFF : 0x00);
            }
        } finally {
            lock.unlock();
        }
    }
    /**
     * 读取数据
     *
     * @param offset 偏移量 (0 代表 1, 1 代表 2)
     * @param count  要读取的线圈数量
     *
     * @return 读取的线圈数据
     */
    public byte[] readCoils(int offset, int count) {
        lock.lock();
        try {
            byte[] result = new byte[count];
            System.arraycopy(coils, offset, result, 0, count);
            return result;
        } finally {
            lock.unlock();
        }
    }
}
