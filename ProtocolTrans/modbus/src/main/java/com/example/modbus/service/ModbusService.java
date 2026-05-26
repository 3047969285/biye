package com.example.modbus.service;

import com.example.modbus.web.dto.ModbusReadRequest;
import com.example.modbus.web.dto.ModbusReadBitsRequest;
import com.example.modbus.web.dto.ModbusWriteRegisterRequest;
import com.example.modbus.web.dto.ModbusWriteCoilRequest;
import com.example.modbus.web.dto.ModbusWriteCoilsRequest;
import com.example.modbus.web.dto.ModbusWriteRegistersRequest;

import java.util.Map;

/**
 * Modbus服务接口，面向控制层提供标准化能力。
 *
 * @author wangchangzhen
 */
public interface ModbusService {

    /**
     * 检查目标设备连接状态。
     *
     * @param host 设备地址
     * @param port 设备端口
     * @return true-可达，false-不可达
     */
    boolean checkConnection(String host, int port);

    /**
     * 读取保持寄存器数据（功能码0x03）。
     *
     * @param request 读取请求参数
     * @return 寄存器值数组
     */
    short[] readHoldingRegisters(ModbusReadRequest request);

    /**
     * 读取输入寄存器数据（功能码0x04）。
     *
     * @param request 读取请求参数
     * @return 寄存器值数组
     */
    short[] readInputRegisters(ModbusReadRequest request);

    /**
     * 读取线圈状态（功能码0x01）。
     *
     * @param request 读取请求参数
     * @return 线圈状态数组
     */
    boolean[] readCoils(ModbusReadBitsRequest request);

    /**
     * 读取离散输入（功能码0x02）。
     *
     * @param request 读取请求参数
     * @return 离散输入状态数组
     */
    boolean[] readDiscreteInputs(ModbusReadBitsRequest request);

    /**
     * 写入单个保持寄存器（功能码0x06）。
     *
     * @param request 写入请求参数
     */
    void writeRegister(ModbusWriteRegisterRequest request);

    /**
     * 写入单个线圈（功能码0x05）。
     *
     * @param request 写入请求参数
     */
    void writeCoil(ModbusWriteCoilRequest request);

    /**
     * 批量写入线圈（功能码0x0F）。
     *
     * @param request 写入请求参数
     */
    void writeCoils(ModbusWriteCoilsRequest request);

    /**
     * 批量写入保持寄存器（功能码0x10）。
     *
     * @param request 写入请求参数
     */
    void writeRegisters(ModbusWriteRegistersRequest request);

    /**
     * 获取连接池状态。
     *
     * @return 连接池状态信息
     */
    Map<String, Object> getPoolStatus();
}
