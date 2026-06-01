package com.example.modbus.exception;

/**
 * @Author wangchangzhen
 * @Date 2025 12 23 10 31
 * @description
 **/
public class ModbusClientException extends Exception {
    public ModbusClientException(String message) {
        super(message);
    }

    public ModbusClientException(String message, Throwable cause) {
        super(message, cause);
    }
}
