package com.example.modbus.tcp;

import com.example.modbus.model.InputRegisters;
import com.serotonin.modbus4j.ProcessImage;
import com.serotonin.modbus4j.exception.IllegalDataAddressException;
import lombok.extern.slf4j.Slf4j;

/**
 * 基于输入寄存器的Modbus从站进程映像 (只读)
 */
@Slf4j
public class RegisterBankProcessImage implements ProcessImage {

    private final int slaveId;
    private final InputRegisters inputRegisters;

    public RegisterBankProcessImage(int slaveId, InputRegisters inputRegisters) {
        this.slaveId = slaveId;
        this.inputRegisters = inputRegisters;
    }

    @Override
    public int getSlaveId() {
        return slaveId;
    }

    @Override
    public boolean getCoil(int offset) throws IllegalDataAddressException {
        if (offset < 0 || offset >= 65536) {
            throw new IllegalDataAddressException();
        }
        return false;
    }

    @Override
    public void setCoil(int offset, boolean value) {
        // 无线圈功能，忽略
    }

    @Override
    public void writeCoil(int offset, boolean value) throws IllegalDataAddressException {
        if (offset < 0 || offset >= 65536) {
            throw new IllegalDataAddressException();
        }
    }

    @Override
    public boolean getInput(int offset) throws IllegalDataAddressException {
        if (offset < 0 || offset >= 65536) {
            throw new IllegalDataAddressException();
        }
        return false;
    }

    @Override
    public void setInput(int offset, boolean value) {
        // 无离散输入，忽略
    }

    @Override
    public short getHoldingRegister(int offset) throws IllegalDataAddressException {
        // 保持寄存器不支持，返回异常
        throw new IllegalDataAddressException();
    }

    @Override
    public void setHoldingRegister(int offset, short value) {
        // 保持寄存器不可写
    }

    @Override
    public void writeHoldingRegister(int offset, short value) throws IllegalDataAddressException {
        // 保持寄存器不可写
        throw new IllegalDataAddressException();
    }

    @Override
    public short getInputRegister(int offset) throws IllegalDataAddressException {
        if (offset < 0 || offset >= 10000) {
            throw new IllegalDataAddressException();
        }
        return inputRegisters.readRegisters(offset, 1)[0];
    }

    @Override
    public void setInputRegister(int offset, short value) {
        // 输入寄存器不可写 (只读)
        log.debug("输入寄存器不可写: 地址={}", offset + 30001);
    }

    @Override
    public byte getExceptionStatus() {
        return 0;
    }

    @Override
    public byte[] getReportSlaveIdData() {
        return new byte[]{(byte) slaveId, 0x00, 0x00};
    }
}
