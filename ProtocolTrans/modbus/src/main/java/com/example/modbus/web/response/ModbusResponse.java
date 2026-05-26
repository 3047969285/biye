package com.example.modbus.web.response;

import lombok.Getter;

import java.io.Serializable;

/**
 * Modbus 模块统一返回对象。
 *
 * @param <T> 数据类型
 */
@Getter
public class ModbusResponse<T> implements Serializable {

    private static final long serialVersionUID = 1L;

    private static final int SUCCESS_CODE = 0;
    private static final int FAIL_CODE = 1;

    private final int code;
    private final String message;
    private final T data;

    private ModbusResponse(int code, String message, T data) {
        this.code = code;
        this.message = message;
        this.data = data;
    }

    public static <T> ModbusResponse<T> success(T data) {
        return new ModbusResponse<>(SUCCESS_CODE, "success", data);
    }

    public static <T> ModbusResponse<T> fail(String message) {
        return new ModbusResponse<>(FAIL_CODE, message, null);
    }
}

