package com.example.modbus.web.dto;

import lombok.Data;

/**
 * 读取线圈/离散输入请求参数（位类型）。
 *
 * @author wangchangzhen
 */
@Data
public class ModbusReadBitsRequest extends BaseModbusRequest {

    private int start;
    private int length;
}
