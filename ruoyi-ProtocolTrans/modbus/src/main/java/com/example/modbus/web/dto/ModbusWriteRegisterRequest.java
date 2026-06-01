package com.example.modbus.web.dto;

import lombok.Data;

/**
 * 写单个保持寄存器请求参数。
 *
 * @author wangchangzhen
 */
@Data
public class ModbusWriteRegisterRequest extends BaseModbusRequest {
    private int address;
    private int value;
}
