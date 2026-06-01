package com.example.modbus.web.dto;

import lombok.Data;

/**
 * 写单个线圈请求参数。
 *
 * @author wangchangzhen
 */
@Data
public class ModbusWriteCoilRequest extends BaseModbusRequest {

    private int address;
    private boolean value;
}
