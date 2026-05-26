package com.example.modbus.web.dto;

import lombok.Data;

/**
 * 读取保持寄存器请求参数。
 *
 * @author wangchangzhen
 */
@Data
public class ModbusReadRequest extends BaseModbusRequest {

    private int start;
    private int length;
}
