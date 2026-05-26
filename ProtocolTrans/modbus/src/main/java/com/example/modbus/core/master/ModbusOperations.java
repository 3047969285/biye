package com.example.modbus.core.master;


import com.example.modbus.config.ModbusConnectionPool;
import com.example.modbus.exception.ModbusClientException;
import com.serotonin.modbus4j.ModbusMaster;
import com.serotonin.modbus4j.msg.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * Modbus核心操作实现
 * 负责Modbus协议操作
 *
 * @author wangchangzhen
 */
@Slf4j
@RequiredArgsConstructor
public class ModbusOperations {
    private final ModbusConnectionPool connectionPool;
    private final RetryPolicy retryPolicy;

    /**
     * 读取线圈
     */
    public boolean[] readCoils(String host, int port, int slaveId, int start, int length) throws ModbusClientException {

        return retryPolicy.execute(() -> {
            try {
                ModbusMaster master = connectionPool.getConnection(host, port);
                ReadCoilsRequest request = new ReadCoilsRequest(slaveId, start, length);
                ReadCoilsResponse response = (ReadCoilsResponse) master.send(request);

                if (response.isException()) {
                    throw new ModbusClientException("读取线圈异常: " + response.getExceptionMessage());
                }

                return response.getBooleanData();

            } catch (Exception e) {
                Throwable toThrow = e;
                if (!(e instanceof ModbusClientException)) {
                    toThrow = new ModbusClientException("读取线圈异常: " + e.getMessage(), e);
                }
                throw new RuntimeException(toThrow);

            } finally {
                connectionPool.releaseConnection(host, port);
            }
        }, "读取线圈");
    }

    /**
     * 读取离散输入
     */
    public boolean[] readDiscreteInputs(String host, int port, int slaveId, int start, int length) throws ModbusClientException {

        return retryPolicy.execute(() -> {
            try {
                ModbusMaster master = connectionPool.getConnection(host, port);
                ReadDiscreteInputsRequest request = new ReadDiscreteInputsRequest(slaveId, start, length);
                ReadDiscreteInputsResponse response = (ReadDiscreteInputsResponse) master.send(request);

                if (response.isException()) {
                    throw new ModbusClientException("读取离散输入异常: " + response.getExceptionMessage());
                }

                return response.getBooleanData();

            } catch (Exception e) {
                Throwable toThrow = e;
                if (!(e instanceof ModbusClientException)) {
                    toThrow = new ModbusClientException("读取离散输入异常: " + e.getMessage(), e);
                }
                throw new RuntimeException(toThrow);

            } finally {
                connectionPool.releaseConnection(host, port);
            }
        }, "读取离散输入");
    }

    /**
     * 读取保持寄存器
     */
    public short[] readHoldingRegisters(String host, int port, int slaveId, int start, int length) throws ModbusClientException {

        return retryPolicy.execute(() -> {
            try {
                ModbusMaster master = connectionPool.getConnection(host, port);
                ReadHoldingRegistersRequest request = new ReadHoldingRegistersRequest(slaveId, start, length);
                ReadHoldingRegistersResponse response = (ReadHoldingRegistersResponse) master.send(request);

                if (response.isException()) {
                    throw new ModbusClientException("读取保持寄存器异常: " + response.getExceptionMessage());
                }

                return response.getShortData();

            } catch (Exception e) {
                Throwable toThrow = e;
                if (!(e instanceof ModbusClientException)) {
                    toThrow = new ModbusClientException("读取保持寄存器异常: " + e.getMessage(), e);
                }
                throw new RuntimeException(toThrow);

            } finally {
                connectionPool.releaseConnection(host, port);
            }
        }, "读取保持寄存器");
    }

    /**
     * 读取输入寄存器
     */
    public short[] readInputRegisters(String host, int port, int slaveId, int start, int length) throws ModbusClientException {

        return retryPolicy.execute(() -> {
            try {
                ModbusMaster master = connectionPool.getConnection(host, port);
                ReadInputRegistersRequest request = new ReadInputRegistersRequest(slaveId, start, length);
                ReadInputRegistersResponse response = (ReadInputRegistersResponse) master.send(request);

                if (response.isException()) {
                    throw new ModbusClientException("读取输入寄存器异常: " + response.getExceptionMessage());
                }

                return response.getShortData();

            } catch (Exception e) {
                Throwable toThrow = e;
                if (!(e instanceof ModbusClientException)) {
                    toThrow = new ModbusClientException("读取输入寄存器异常: " + e.getMessage(), e);
                }
                throw new RuntimeException(toThrow);

            } finally {
                connectionPool.releaseConnection(host, port);
            }
        }, "读取输入寄存器");
    }

    /**
     * 写入单个线圈
     */
    public void writeCoil(String host, int port, int slaveId, int address, boolean value) throws ModbusClientException {

        retryPolicy.execute(() -> {
            try {
                ModbusMaster master = connectionPool.getConnection(host, port);
                WriteCoilRequest request = new WriteCoilRequest(slaveId, address, value);
                WriteCoilResponse response = (WriteCoilResponse) master.send(request);

                if (response.isException()) {
                    throw new ModbusClientException("写入线圈异常: " + response.getExceptionMessage());
                }

                return null;

            } catch (Exception e) {
                Throwable toThrow = e;
                if (!(e instanceof ModbusClientException)) {
                    toThrow = new ModbusClientException("写入线圈异常: " + e.getMessage(), e);
                }
                throw new RuntimeException(toThrow);

            } finally {
                connectionPool.releaseConnection(host, port);
            }
        }, "写入线圈");
    }

    /**
     * 写入单个寄存器
     */
    public void writeRegister(String host, int port, int slaveId, int address, int value) throws ModbusClientException {

        retryPolicy.execute(() -> {
            try {
                ModbusMaster master = connectionPool.getConnection(host, port);
                WriteRegisterRequest request = new WriteRegisterRequest(slaveId, address, value);
                WriteRegisterResponse response = (WriteRegisterResponse) master.send(request);

                if (response.isException()) {
                    throw new ModbusClientException("写入寄存器异常: " + response.getExceptionMessage());
                }

                return null;

            } catch (Exception e) {
                Throwable toThrow = e;
                if (!(e instanceof ModbusClientException)) {
                    toThrow = new ModbusClientException("写入寄存器异常: " + e.getMessage(), e);
                }
                throw new RuntimeException(toThrow);

            } finally {
                connectionPool.releaseConnection(host, port);
            }
        }, "写入寄存器");
    }

    /**
     * 批量写入线圈
     */
    public void writeCoils(String host, int port, int slaveId, int start, boolean[] values) throws ModbusClientException {

        retryPolicy.execute(() -> {
            try {
                ModbusMaster master = connectionPool.getConnection(host, port);
                WriteCoilsRequest request = new WriteCoilsRequest(slaveId, start, values);
                WriteCoilsResponse response = (WriteCoilsResponse) master.send(request);

                if (response.isException()) {
                    throw new ModbusClientException("批量写入线圈异常: " + response.getExceptionMessage());
                }

                return null;

            } catch (Exception e) {
                Throwable toThrow = e;
                if (!(e instanceof ModbusClientException)) {
                    toThrow = new ModbusClientException("批量写入线圈异常: " + e.getMessage(), e);
                }
                throw new RuntimeException(toThrow);

            } finally {
                connectionPool.releaseConnection(host, port);
            }
        }, "批量写入线圈");
    }

    /**
     * 批量写入寄存器
     */
    public void writeRegisters(String host, int port, int slaveId, int start, short[] values) throws ModbusClientException {

        retryPolicy.execute(() -> {
            try {
                ModbusMaster master = connectionPool.getConnection(host, port);
                WriteRegistersRequest request = new WriteRegistersRequest(slaveId, start, values);
                WriteRegistersResponse response = (WriteRegistersResponse) master.send(request);

                if (response.isException()) {
                    throw new ModbusClientException("批量写入寄存器异常: " + response.getExceptionMessage());
                }

                return null;

            } catch (Exception e) {
                Throwable toThrow = e;
                if (!(e instanceof ModbusClientException)) {
                    toThrow = new ModbusClientException("批量写入寄存器异常: " + e.getMessage(), e);
                }
                throw new RuntimeException(toThrow);

            } finally {
                connectionPool.releaseConnection(host, port);
            }
        }, "批量写入寄存器");
    }

    // ==================== Modbus RTU 串口操作方法 ====================

    /**
     * 读取保持寄存器 - 串口模式
     */
    public short[] readHoldingRegistersSerial(String serialPort, int baudRate, int slaveId,
                                              int start, int length, int dataBits,
                                              int stopBits, int parity) throws ModbusClientException {
        return retryPolicy.execute(() -> {
            try {
                ModbusMaster master = connectionPool.getSerialConnection(serialPort, baudRate,
                        dataBits, stopBits, parity);
                ReadHoldingRegistersRequest request = new ReadHoldingRegistersRequest(slaveId, start, length);
                ReadHoldingRegistersResponse response = (ReadHoldingRegistersResponse) master.send(request);

                if (response.isException()) {
                    throw new ModbusClientException("读取保持寄存器异常: " + response.getExceptionMessage());
                }

                return response.getShortData();

            } catch (Exception e) {
                Throwable toThrow = e;
                if (!(e instanceof ModbusClientException)) {
                    toThrow = new ModbusClientException("读取保持寄存器(串口)异常: " + e.getMessage(), e);
                }
                throw new RuntimeException(toThrow);

            } finally {
                connectionPool.releaseSerialConnection(serialPort, baudRate, dataBits, stopBits, parity);
            }
        }, "读取保持寄存器(串口)");
    }

    /**
     * 读取输入寄存器 - 串口模式
     */
    public short[] readInputRegistersSerial(String serialPort, int baudRate, int slaveId,
                                            int start, int length, int dataBits,
                                            int stopBits, int parity) throws ModbusClientException {
        return retryPolicy.execute(() -> {
            try {
                ModbusMaster master = connectionPool.getSerialConnection(serialPort, baudRate,
                        dataBits, stopBits, parity);
                ReadInputRegistersRequest request = new ReadInputRegistersRequest(slaveId, start, length);
                ReadInputRegistersResponse response = (ReadInputRegistersResponse) master.send(request);

                if (response.isException()) {
                    throw new ModbusClientException("读取输入寄存器异常: " + response.getExceptionMessage());
                }

                return response.getShortData();

            } catch (Exception e) {
                Throwable toThrow = e;
                if (!(e instanceof ModbusClientException)) {
                    toThrow = new ModbusClientException("读取输入寄存器(串口)异常: " + e.getMessage(), e);
                }
                throw new RuntimeException(toThrow);

            } finally {
                connectionPool.releaseSerialConnection(serialPort, baudRate, dataBits, stopBits, parity);
            }
        }, "读取输入寄存器(串口)");
    }

    /**
     * 写入单个寄存器 - 串口模式
     */
    public void writeRegisterSerial(String serialPort, int baudRate, int slaveId,
                                    int address, int value, int dataBits,
                                    int stopBits, int parity) throws ModbusClientException {
        retryPolicy.execute(() -> {
            try {
                ModbusMaster master = connectionPool.getSerialConnection(serialPort, baudRate,
                        dataBits, stopBits, parity);
                WriteRegisterRequest request = new WriteRegisterRequest(slaveId, address, value);
                WriteRegisterResponse response = (WriteRegisterResponse) master.send(request);

                if (response.isException()) {
                    throw new ModbusClientException("写入寄存器异常: " + response.getExceptionMessage());
                }

                return null;

            } catch (Exception e) {
                Throwable toThrow = e;
                if (!(e instanceof ModbusClientException)) {
                    toThrow = new ModbusClientException("写入寄存器(串口)异常: " + e.getMessage(), e);
                }
                throw new RuntimeException(toThrow);

            } finally {
                connectionPool.releaseSerialConnection(serialPort, baudRate, dataBits, stopBits, parity);
            }
        }, "写入寄存器(串口)");
    }
}
