package com.example.modbus.web.dto;

import lombok.Data;
/**
 * 通用请求参数
 *
 * @author wangchangzhen
 */
@Data
public class ModbusWriteRegistersRequest extends BaseModbusRequest {

    private int start;
    private short[] values;
}
