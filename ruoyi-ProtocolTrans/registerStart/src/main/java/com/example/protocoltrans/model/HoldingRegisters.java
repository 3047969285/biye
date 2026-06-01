package com.example.protocoltrans.model;

import lombok.Data;
import org.springframework.stereotype.Component;

/**
 * 保持寄存器实体（预留，暂未启用）
 */
@Data
@Component
public class HoldingRegisters {

    private final short[] registers = new short[200];

    public short[] readRegisters(int offset, int count) {
        throw new UnsupportedOperationException("HoldingRegisters.readRegisters 暂未实现");
    }

    public void writeRegister(int offset, short value) {
        throw new UnsupportedOperationException("HoldingRegisters.writeRegister 暂未实现");
    }

    public short[] getArray() {
        throw new UnsupportedOperationException("HoldingRegisters.getArray 暂未实现");
    }

    public void clear() {
        throw new UnsupportedOperationException("HoldingRegisters.clear 暂未实现");
    }
}
