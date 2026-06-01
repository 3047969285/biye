package com.example.modbus.service.impl;

import com.example.modbus.model.InputRegisters;
import com.example.modbus.service.ModbusService;
import com.example.modbus.web.dto.ModbusReadBitsRequest;
import com.example.modbus.web.dto.ModbusReadRequest;
import com.example.modbus.web.dto.ModbusWriteCoilRequest;
import com.example.modbus.web.dto.ModbusWriteCoilsRequest;
import com.example.modbus.web.dto.ModbusWriteRegisterRequest;
import com.example.modbus.web.dto.ModbusWriteRegistersRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.Map;

/**
 * 通用的modbus功能实现，基于HoldingRegisters寄存器区
 *
 * @author wangchangzhen
 */
@Slf4j
@Service
public class ModbusServiceImpl implements ModbusService {

    @Autowired
    @Qualifier("modbusInputRegisters")
    private InputRegisters inputRegisters;

    @Override
    public boolean checkConnection(String host, int port) {
        return inputRegisters != null;
    }

    @Override
    public short[] readHoldingRegisters(ModbusReadRequest request) {
        throw new UnsupportedOperationException("readHoldingRegisters 暂未实现");
    }

    @Override
    public short[] readInputRegisters(ModbusReadRequest request) {
        int start = request.getStart();
        int length = request.getLength();
        
        if (start < 0 || length <= 0 || start + length > 10000) {
            log.error("输入寄存器地址越界: start={}, length={}", start, length);
            return new short[0];
        }
        
        log.debug("读取输入寄存器: 起始地址={}, 数量={}", start, length);
        return inputRegisters.readRegisters(start, length);
    }

    @Override
    public boolean[] readCoils(ModbusReadBitsRequest request) {
        int len = request.getLength();
        boolean[] r = new boolean[len];
        return r;
    }

    @Override
    public boolean[] readDiscreteInputs(ModbusReadBitsRequest request) {
        int len = request.getLength();
        return new boolean[len];
    }

    @Override
    public void writeRegister(ModbusWriteRegisterRequest request) {
        // 输入寄存器为只读，不支持写入
        log.error("输入寄存器(功能码04)为只读，不支持写入操作");
    }

    @Override
    public void writeCoil(ModbusWriteCoilRequest request) {
        // 无线圈点
    }

    @Override
    public void writeCoils(ModbusWriteCoilsRequest request) {
        // 无线圈点
    }

    @Override
    public void writeRegisters(ModbusWriteRegistersRequest request) {
        // 输入寄存器为只读，不支持批量写入
        log.error("输入寄存器(功能码04)为只读，不支持批量写入操作");
    }

    @Override
    public Map<String, Object> getPoolStatus() {
        return Collections.singletonMap("mode", "holding_registers");
    }
}
