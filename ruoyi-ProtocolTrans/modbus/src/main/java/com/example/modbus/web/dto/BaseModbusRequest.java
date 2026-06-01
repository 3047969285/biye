package com.example.modbus.web.dto;

import lombok.Data;

/**
 * 通用 Modbus 请求基类。
 *
 * @author wangchangzhen
 */
@Data
public class BaseModbusRequest {

    private String host;
    private int port;
    private int slaveId;
}
