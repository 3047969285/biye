package com.example.modbus.model;

import lombok.Data;

import java.util.Arrays;
import java.util.concurrent.locks.ReentrantLock;

/**
 * 输入寄存器共享缓存 (只读)
 * 
 * @author wangchangzhen
 */
@Data
public class InputRegisters {

    /**
     * 寄存器数组 - 10000个输入寄存器
     */
    private final short[] registers = new short[10000];

    /**
     * 线程锁
     */
    private final ReentrantLock lock = new ReentrantLock();

    /**
     * 写入数据 (内部使用，外部不可直接调用)
     * @param offset 偏移量 (0 代表 30001, 1 代表 30002)
     * @param value 要写入的值
     */
    public void writeRegister(int offset, short value) {
        lock.lock();
        try {
            if (offset >= 0 && offset < registers.length) {
                registers[offset] = value;
            }
        } finally {
            lock.unlock();
        }
    }

    /**
     * 读取数据
     * @param offset 偏移量 (0 代表 30001, 1 代表 30002)
     * @param count 要读取的寄存器数量
     *
     * @return 读取的寄存器数据
     */
    public short[] readRegisters(int offset, int count) {
        lock.lock();
        try {
            short[] result = new short[count];
            System.arraycopy(registers, offset, result, 0, count);
            return result;
        } finally {
            lock.unlock();
        }
    }

    public DataConversion getMapper() {
        return new DataConversion();
    }

    /**
     * 把数值转换为寄存器数据
     */
    public class DataConversion {

        /**
         * 写入float32数值 (占用 2 个寄存器)
         * @param startOffset 起始偏移量 (例如 0)
         * @param value 数值 (例如 220.5)
         */
        public void setFloat(int startOffset, float value) {
            int bits = Float.floatToIntBits(value);
            // 高16位 -> 低地址 (ABCD 模式)
            short highWord = (short) ((bits >>> 16) & 0xFFFF);
            // 低16位 -> 高地址
            short lowWord = (short) (bits & 0xFFFF);

            writeRegister(startOffset, highWord);
            writeRegister(startOffset + 1, lowWord);
        }

        /**
         * 写入uint32数值 (占用 2 个寄存器)
         * @param startOffset 起始偏移量 (例如 0)
         * @param value 数值 (例如 123456789)
         */
        public void setUInt32(int startOffset, long value) {
            long uintValue = value & 0xFFFFFFFFL;
            short highWord = (short) ((uintValue >>> 16) & 0xFFFF);
            short lowWord = (short) (uintValue & 0xFFFF);

            writeRegister(startOffset, highWord);
            writeRegister(startOffset + 1, lowWord);
        }

       /**
         * 写入int32数值 (占用 2 个寄存器)
         * @param startOffset 起始偏移量 (例如 0)
         * @param value 数值 (例如 -123456789)
         */
        public void setInt32(int startOffset, long value) {
            long intValue = value & 0xFFFFFFFFL;
            short highWord = (short) ((intValue >>> 16) & 0xFFFF);
            short lowWord = (short) (intValue & 0xFFFF);

            writeRegister(startOffset, highWord);
            writeRegister(startOffset + 1, lowWord);
        }
        /**
         * 写入uint16数值 (占用 1 个寄存器)
         * @param startOffset 起始偏移量 (例如 0)
         * @param value 数值 (例如 12345)
         */
        public void setUInt16(int startOffset, int value) {
            writeRegister(startOffset, (short) (value & 0xFFFF));
        }

        /**
         * 写入int16数值 (占用 1 个寄存器)
         * @param startOffset 起始偏移量 (例如 0)
         * @param value 数值 (例如 -12345)
         */
        public void setInt16(int startOffset, int value) {
            writeRegister(startOffset, (short) value);
        }
    }
    
    /**
     * 获取寄存器数组
     * 
     * @return 寄存器数组副本
     */
    public short[] getArray() {
        lock.lock();
        try {
            short[] copy = new short[registers.length];
            System.arraycopy(registers, 0, copy, 0, registers.length);
            return copy;
        } finally {
            lock.unlock();
        }
    }

    /**
     * 清空所有寄存器
     */
    public void clear() {
        lock.lock();
        try {
            Arrays.fill(registers, (short) 0);
        } finally {
            lock.unlock();
        }
    }
}
