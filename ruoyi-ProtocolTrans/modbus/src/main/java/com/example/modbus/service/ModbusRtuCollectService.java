package com.example.modbus.service;

import com.example.modbus.exception.ModbusClientException;

import java.util.Map;

/**
 * Modbus RTU 串口采集服务接口
 *
 * @author wangchangzhen
 */
public interface ModbusRtuCollectService {

    /**
     * 按配置点位顺序采集 Modbus RTU 寄存器数据
     *
     * @param serialPort 串口号，如 "COM3"
     * @param baudRate   波特率
     * @param slaveId    从站地址（十进制）
     * @param dataBits   数据位
     * @param stopBits   停止位
     * @param parity     校验位（0=无, 1=奇, 2=偶）
     * @return 按配置文件点位顺序排列的 short 数组
     * @throws ModbusClientException 采集失败时抛出异常
     */
    short[] collectCommonAddrAndSave(String serialPort, int baudRate, String slaveId,
                                    int dataBits, int stopBits, int parity, Map<String, String> pointMapping)
            throws ModbusClientException;
}
