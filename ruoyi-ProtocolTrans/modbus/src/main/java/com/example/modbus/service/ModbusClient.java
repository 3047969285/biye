package com.example.modbus.service;


import com.example.modbus.exception.ModbusClientException;

import java.util.Map;
import java.util.concurrent.CompletableFuture;

/**
 * Modbus客户端接口
 *
 * @author wangchangzhen
 */
public interface ModbusClient {

    /**
     * 读取线圈状态（功能码 0x01）
     * 从Modbus设备读取指定数量的线圈状态
     *
     * @param host    设备IP地址，如 "192.168.1.100"
     * @param port    设备端口，标准Modbus端口为502
     * @param slaveId 从站设备ID，范围 1-247
     * @param start   起始地址，范围 0-65535
     * @param length  读取数量，范围 1-2000（Modbus协议限制）
     * @return 线圈状态数组，true表示ON/1，false表示OFF/0
     * @throws ModbusClientException 当通信失败、从站返回异常或参数无效时抛出
     */
    boolean[] readCoils(String host, int port, int slaveId, int start, int length)
            throws ModbusClientException;

    /**
     * 读取保持寄存器（功能码 0x03）
     * 从Modbus设备读取指定数量的保持寄存器值
     *
     * @param host    设备IP地址
     * @param port    设备端口
     * @param slaveId 从站设备ID
     * @param start   起始地址，范围 0-65535
     * @param length  读取数量，范围 1-125（Modbus协议限制）
     * @return 寄存器值数组，每个值为16位有符号整数（short类型）
     * @throws ModbusClientException 当通信失败、从站返回异常或参数无效时抛出
     */
    short[] readHoldingRegisters(String host, int port, int slaveId, int start, int length)
            throws ModbusClientException;

    /**
     * 读取输入寄存器（功能码 0x04）
     * 从Modbus设备读取指定数量的输入寄存器值
     * 注：输入寄存器通常是只读的模拟量输入
     *
     * @param host    设备IP地址
     * @param port    设备端口
     * @param slaveId 从站设备ID
     * @param start   起始地址，范围 0-65535
     * @param length  读取数量，范围 1-125（Modbus协议限制）
     * @return 寄存器值数组，每个值为16位有符号整数（short类型）
     * @throws ModbusClientException 当通信失败、从站返回异常或参数无效时抛出
     */
    short[] readInputRegisters(String host, int port, int slaveId, int start, int length)
            throws ModbusClientException;

    /**
     * 读取离散输入（功能码 0x02）
     * 从Modbus设备读取指定数量的离散输入状态
     * 注：离散输入通常是只读的开关量输入
     *
     * @param host    设备IP地址
     * @param port    设备端口
     * @param slaveId 从站设备ID
     * @param start   起始地址，范围 0-65535
     * @param length  读取数量，范围 1-2000（Modbus协议限制）
     * @return 离散输入状态数组，true表示ON/1，false表示OFF/0
     * @throws ModbusClientException 当通信失败、从站返回异常或参数无效时抛出
     */
    boolean[] readDiscreteInputs(String host, int port, int slaveId, int start, int length)
            throws ModbusClientException;


    /**
     * 写入单个线圈（功能码 0x05）
     * 向Modbus设备写入单个线圈状态
     *
     * @param host    设备IP地址
     * @param port    设备端口
     * @param slaveId 从站设备ID
     * @param address 线圈地址，范围 0-65535
     * @param value   要写入的值，true表示ON/1，false表示OFF/0
     * @throws ModbusClientException 当通信失败、从站返回异常或参数无效时抛出
     */
    void writeCoil(String host, int port, int slaveId, int address, boolean value)
            throws ModbusClientException;

    /**
     * 写入单个寄存器（功能码 0x06）
     * 向Modbus设备写入单个保持寄存器值
     *
     * @param host    设备IP地址
     * @param port    设备端口
     * @param slaveId 从站设备ID
     * @param address 寄存器地址，范围 0-65535
     * @param value   要写入的值，范围为 0-65535（16位无符号整数）
     * @throws ModbusClientException 当通信失败、从站返回异常或参数无效时抛出
     */
    void writeRegister(String host, int port, int slaveId, int address, int value)
            throws ModbusClientException;

    /**
     * 批量写入线圈（功能码 0x0F）
     * 向Modbus设备批量写入多个线圈状态
     *
     * @param host    设备IP地址
     * @param port    设备端口
     * @param slaveId 从站设备ID
     * @param start   起始地址，范围 0-65535
     * @param values  要写入的值数组，长度范围 1-1968（Modbus协议限制）
     * @throws ModbusClientException 当通信失败、从站返回异常或参数无效时抛出
     */
    void writeCoils(String host, int port, int slaveId, int start, boolean[] values)
            throws ModbusClientException;

    /**
     * 批量写入寄存器（功能码 0x10）
     * 向Modbus设备批量写入多个保持寄存器值
     *
     * @param host    设备IP地址
     * @param port    设备端口
     * @param slaveId 从站设备ID
     * @param start   起始地址，范围 0-65535
     * @param values  要写入的值数组，每个值为16位有符号整数，长度范围 1-123（Modbus协议限制）
     * @throws ModbusClientException 当通信失败、从站返回异常或参数无效时抛出
     */
    void writeRegisters(String host, int port, int slaveId, int start, short[] values)
            throws ModbusClientException;


    /**
     * 异步读取线圈状态
     * 非阻塞方式读取线圈状态，返回CompletableFuture
     *
     * @param host    设备IP地址
     * @param port    设备端口
     * @param slaveId 从站设备ID
     * @param start   起始地址
     * @param length  读取数量
     * @return CompletableFuture，成功时返回线圈状态数组，失败时抛出异常
     */
    CompletableFuture<boolean[]> readCoilsAsync(
            String host, int port, int slaveId, int start, int length);

    /**
     * 异步写入单个线圈
     * 非阻塞方式写入单个线圈状态，返回CompletableFuture
     *
     * @param host    设备IP地址
     * @param port    设备端口
     * @param slaveId 从站设备ID
     * @param address 线圈地址
     * @param value   要写入的值
     * @return CompletableFuture，成功时返回Void，失败时抛出异常
     */
    CompletableFuture<Void> writeCoilAsync(
            String host, int port, int slaveId, int address, boolean value);

    /**
     * 异步读取保持寄存器
     * 非阻塞方式读取保持寄存器值，返回CompletableFuture
     *
     * @param host    设备IP地址
     * @param port    设备端口
     * @param slaveId 从站设备ID
     * @param start   起始地址
     * @param length  读取数量
     * @return CompletableFuture，成功时返回寄存器值数组，失败时抛出异常
     */
    CompletableFuture<short[]> readHoldingRegistersAsync(
            String host, int port, int slaveId, int start, int length);


    /**
     * 检查连接状态
     * 测试指定设备的Modbus连接是否正常
     *
     * @param host 设备IP地址
     * @param port 设备端口
     * @return true表示连接正常，false表示连接失败
     * @apiNote 此方法会实际发送一个测试请求来验证连接
     */
    boolean checkConnection(String host, int port);

    /**
     * 获取连接池状态
     * 返回当前连接池的统计信息和状态
     *
     * @return 连接池状态Map
     */
    Map<String, Object> getPoolStatus();


    /**
     * 关闭客户端
     * 优雅关闭Modbus客户端，释放所有资源：
     * 1. 关闭所有活跃的Modbus连接
     * 2. 停止异步执行线程池
     * 3. 清理连接池
     */
    void shutdown();
}
