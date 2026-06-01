package com.example.modbus.config;

import com.example.modbus.model.InputRegisters;
import com.example.modbus.model.HoldingRegisters;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * Modbus输入寄存器配置
 */
@Configuration
public class InputRegistersConfig {

    @Bean("modbusInputRegisters")
    public InputRegisters modbusInputRegisters() {
        return new InputRegisters();
    }

    @Bean("modbusHoldingRegisters")
    public HoldingRegisters modbusHoldingRegisters() {
        return new HoldingRegisters();
    }
}
