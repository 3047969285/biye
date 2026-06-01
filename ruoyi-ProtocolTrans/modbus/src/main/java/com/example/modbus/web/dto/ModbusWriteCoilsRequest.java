package com.example.modbus.web.dto;

import lombok.Data;

/**
 * 批量写线圈请求参数。
 *
 * @author wangchangzhen
 */
@Data
public class ModbusWriteCoilsRequest extends BaseModbusRequest {
    private int start;
    private boolean[] values;
}
