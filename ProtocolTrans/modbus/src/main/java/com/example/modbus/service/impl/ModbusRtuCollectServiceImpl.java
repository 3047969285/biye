package com.example.modbus.service.impl;

import com.example.modbus.core.master.ModbusOperations;
import com.example.modbus.exception.ModbusClientException;
import com.example.modbus.service.ModbusRtuCollectService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.properties.bind.Bindable;
import org.springframework.boot.context.properties.bind.Binder;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Service;

import java.util.*;

/**
 * Modbus RTU 串口采集服务实现
 * 按配置文件中的点位顺序读取寄存器，返回 short 数组
 *
 * @author wangchangzhen
 */
@Slf4j
@Service
public class ModbusRtuCollectServiceImpl implements ModbusRtuCollectService {

    private final Environment environment;

    @Autowired
    private ModbusOperations modbusOperations;

    private static final int COMMAND_INTERVAL_MS = 50;

    public ModbusRtuCollectServiceImpl(Environment environment) {
        this.environment = environment;
    }

    /**
     * 获取 Modbus RTU 寄存器地址配置（保持插入顺序）
     * 配置路径: protocol.modbusRTU.addr
     */
    private Map<String, String> getModbusAddrMap(Map<String, String> allAddrConfigs) {
        Map<String, String> map = new LinkedHashMap<>();
        if (allAddrConfigs == null || allAddrConfigs.isEmpty()) {
            throw new RuntimeException("未配置 Modbus RTU 寄存器地址配置");
        }

        allAddrConfigs.forEach((pointCode, addrHex) -> {
            try {
                String normalizedAddr = addrHex.trim().toUpperCase().replace("H", "");
                map.put(pointCode, normalizedAddr);
            } catch (Exception e) {
                log.error("解析 Modbus RTU 地址配置失败: pointCode={}, addrHex={}, 错误: {}",
                        pointCode, addrHex, e.getMessage());
            }
        });

        log.info("成功加载{}个 Modbus RTU 点位配置", map.size());
        return Collections.unmodifiableMap(map);
    }

    /**
     * 获取寄存器数据类型配置
     * 配置路径: protocol-trans.register-types
     */
    private Map<String, String> getRegisterTypeMap() {
        Map<String, String> typeMap = Binder.get(environment)
                .bind("protocol-trans.register-types", Bindable.mapOf(String.class, String.class))
                .orElseGet(LinkedHashMap::new);

        if (typeMap == null || typeMap.isEmpty()) {
            throw new RuntimeException("未配置寄存器数据类型配置");
        }

        return Collections.unmodifiableMap(typeMap);
    }

    /**
     * 根据数据类型计算占用的寄存器数量
     */
    private int getRegisterCount(String dataType) {
        if (dataType == null) {
            return 1;
        }
        String normalizedType = dataType.trim().toLowerCase();
        switch (normalizedType) {
            case "float32":
            case "float":
            case "uint32":
            case "uint":
            case "dword":
            case "int32":
            case "int":
                return 2;
            case "uint16":
            case "word":
            case "int16":
            case "short":
                return 1;
            case "float64":
            case "double64":
            case "double":
            case "uint64":
            case "double64_unsigned":
            case "int64":
            case "long":
                return 4;
            default:
                log.warn("未知的数据类型: {}，默认按 1 个寄存器处理", dataType);
                return 1;
        }
    }

    @Override
    public short[] collectCommonAddrAndSave(String serialPort, int baudRate, String slaveId, int dataBits, int stopBits, int parity, Map<String, String> pointMapping)
            throws ModbusClientException {

        if (serialPort == null || serialPort.trim().isEmpty()) {
            throw new IllegalArgumentException("串口端口不能为空");
        }

        int slaveAddress;
        try {
            slaveAddress = Integer.parseInt(slaveId.trim());
            if (slaveAddress < 1 || slaveAddress > 247) {
                throw new IllegalArgumentException("从站地址非法（1-247）");
            }
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("从站地址格式错误: " + slaveId);
        }

        if (baudRate <= 0) {
            throw new IllegalArgumentException("波特率非法");
        }

        try {
            Map<String, String> addrMap = getModbusAddrMap(pointMapping);
            Map<String, String> typeMap = getRegisterTypeMap();

            int totalRegisters = calculateTotalRegisters(addrMap, typeMap);
            short[] result = new short[totalRegisters];

            int currentOffset = 0;
            for (Map.Entry<String, String> entry : addrMap.entrySet()) {
                String pointCode = entry.getKey();
                String addrHex = entry.getValue();

                String dataType = typeMap.getOrDefault(pointCode, "uint16");
                int registerCount = getRegisterCount(dataType);

                int registerAddress = Integer.parseInt(addrHex, 16);
                short[] values = readRegisters(serialPort, baudRate, slaveAddress,
                        registerAddress, registerCount, pointCode,
                        dataBits, stopBits, parity);

                System.arraycopy(values, 0, result, currentOffset, registerCount);
                currentOffset += registerCount;

                log.debug("点位 {} 读取成功: 地址=0x{}, 类型={}, 占用{}个寄存器, 值={}",
                        pointCode, addrHex, dataType, registerCount, Arrays.toString(values));

                if (currentOffset < totalRegisters) {
                    Thread.sleep(COMMAND_INTERVAL_MS);
                }
            }

            log.info("Modbus RTU 从站{} 数据采集完成，共{}个点位，占用{}个寄存器",
                    slaveAddress, addrMap.size(), totalRegisters);
            return result;

        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new ModbusClientException("Modbus RTU 采集中断", e);
        } catch (Exception e) {
            log.error("Modbus RTU 采集失败: {}", e.getMessage(), e);
            throw new ModbusClientException("Modbus RTU 采集失败: " + e.getMessage(), e);
        }
    }

    /**
     * 计算总寄存器数量
     */
    private int calculateTotalRegisters(Map<String, String> addrMap, Map<String, String> typeMap) {
        int total = 0;
        for (String pointCode : addrMap.keySet()) {
            String dataType = typeMap.getOrDefault(pointCode, "uint16");
            total += getRegisterCount(dataType);
        }
        return total;
    }

    /**
     * 寄存器读取
     */
    private short[] readRegisters(String serialPort, int baudRate, int slaveId,
                                           int registerAddress, int registerCount, String pointCode, int dataBits, int stopBits, int parity)
            throws ModbusClientException, InterruptedException {

        ModbusClientException lastException = null;

            try {
                short[] values = modbusOperations.readHoldingRegistersSerial(
                        serialPort, baudRate, slaveId, registerAddress, registerCount,
                        dataBits, stopBits, parity);

                if (values == null || values.length != registerCount) {
                    throw new ModbusClientException("点位 " + pointCode + " 读取返回数据长度不匹配，期望: "
                            + registerCount + ", 实际: " + (values == null ? 0 : values.length));
                }

                return values;

            } catch (ModbusClientException e) {
                lastException = e;
                log.error("点位 {} 读取失败", pointCode);
            }

        throw new ModbusClientException("点位 " + pointCode + " 读取失败: " + lastException.getMessage(), lastException);
    }
}
