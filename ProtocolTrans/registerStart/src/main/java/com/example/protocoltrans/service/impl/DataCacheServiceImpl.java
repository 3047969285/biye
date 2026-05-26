package com.example.protocoltrans.service.impl;

import com.example.modbus.model.InputRegisters;
import com.example.protocoltrans.config.RegisterTypeConfig;
import com.example.protocoltrans.service.DataCacheService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.BigInteger;
import java.math.RoundingMode;
import java.util.Map;

/**
 * 数据缓存服务实现 - Modbus寄存器映射层
 *
 * 寄存器地址分配规则:
 * - 电表1: 0-199   (基址0)
 * - 电表2: 200-399 (基址200)
 * - 电表3: 400-599 (基址400)
 * - ...
 * 每个电表内点位顺序由 protocol.register-types 决定
 */
@Slf4j
@Service
public class DataCacheServiceImpl implements DataCacheService {

    @Autowired
    private InputRegisters inputRegisters;

    @Autowired
    private RegisterTypeConfig mappingConfig;

    /**
     * 每个电表的寄存器偏移量
     */
    private static final int METER_OFFSET = 200;

    /**
     * 获取寄存器数组
     *
     * @return 寄存器数组 short[10000]
     */
    @Override
    public short[] getRegisterArray() {
        return inputRegisters.getArray();
    }

    /**
     * 从 DL645 协议数据转换并更新到 Modbus 寄存器
     *
     * @param meterIndex 电表索引
     * @param dl645Data DL645 协议解析后的数据 Map
     */
    public int convertFromDL645(int meterIndex, Map<String, Object> dl645Data) {
        try {
            updateByRegisterTypeConfig(meterIndex, dl645Data, "DL645");
            return 1;

        } catch (Exception e) {
            log.error("电表{} DL645 数据转换失败: {}", meterIndex + 1, e.getMessage(), e);
        }
        return 0;
    }

    /**
     * 从 DL698 协议数据转换并更新到 Modbus 寄存器
     *
     * @param meterIndex 电表索引
     * @param dl698Data DL698 协议解析后的数据 Map
     */
    public int convertFromDL698(int meterIndex, Map<String, Object> dl698Data) {
        try {
            updateByRegisterTypeConfig(meterIndex, dl698Data, "DL698");
            return 1;

        } catch (Exception e) {
            log.error("DL698 电表{} 数据转换失败: {}", meterIndex + 1, e.getMessage(), e);
        }
        return 0;
    }

    /**
     * 从 Modbus RTU 协议数据更新到 Modbus 寄存器
     * @param meterIndex
     * @param raw
     * @return
     */
    public int convertFromModbusRtu(int meterIndex, short[] raw) {
        try {
            int baseAddress = meterIndex * METER_OFFSET;
            int offset = 0;
            for (short value : raw) {
                inputRegisters.writeRegister(baseAddress + offset, value);
                offset++;
            }
            return 1;
        } catch (Exception e) {
            log.error("Modbus RTU 电表{} 数据转换失败: {}", meterIndex + 1, e.getMessage(), e);
        }
        return 0;
    }

    /**根据配置register-types的点位更新到寄存器
     *
     * @param meterIndex 电表索引
     * @param protocolData  数据
     * @param protocolName 协议名称
     */
    private void updateByRegisterTypeConfig(int meterIndex, Map<String, Object> protocolData, String protocolName) {
        int baseAddress = meterIndex * METER_OFFSET;
        int offset = 0;

        Map<String, String> registerTypeMap = mappingConfig.getRegisterTypes();
        int mappedCount = 0;
        for (Map.Entry<String, Object> entry : protocolData.entrySet()) {
            String pointCode = entry.getKey();
            Object rawValue = entry.getValue();
            String type = registerTypeMap.get(pointCode);
            if (type == null) {
                continue;
            }
            int registerAddress = baseAddress + offset;
            offset += writeByType(registerAddress, type, rawValue);
            mappedCount++;
        }
        log.info("{} 电表{} 数据更新完成 | 映射点位数: {} | 占用寄存器数: {}",
                protocolName, meterIndex + 1, mappedCount, offset);
    }
    /**
     * 根据数据类型写入寄存器
     *
     * @param registerAddress 寄存器地址
     * @param type 数据类型
     * @param rawValue 原始数据
     * @return 占用的寄存器数
     */
    private int writeByType(int registerAddress, String type, Object rawValue) {
        String normalizedType = type == null ? "uint32" : type.trim().toLowerCase();
        switch (normalizedType) {
            case "float32":
            case "float":
                inputRegisters.getMapper().setFloat(registerAddress, extractFloatValue(rawValue));
                return 2;
            case "uint32":
            case "uint":
            case "dword":
                inputRegisters.getMapper().setUInt32(registerAddress, extractUInt32Value(rawValue));
                return 2;
            case "int32":
            case "int":
                inputRegisters.getMapper().setInt32(registerAddress, extractInt32Value(rawValue));
                return 2;
            case "uint16":
            case "word":
                inputRegisters.getMapper().setUInt16(registerAddress, extractUInt16Value(rawValue));
                return 1;
            case "int16":
            case "short":
                inputRegisters.getMapper().setInt16(registerAddress, extractInt16Value(rawValue));
                return 1;
            case "float64":
            case "double64":
            case "double":
                writeFloat64(registerAddress, extractDoubleValue(rawValue));
                return 4;
            case "uint64":
            case "double64_unsigned":
                writeUInt64(registerAddress, extractUInt64Value(rawValue));
                return 4;
            case "int64":
            case "long":
                writeInt64(registerAddress, extractInt64Value(rawValue));
                return 4;
            default:
                log.error("未支持的数据类型: {}，按 uint32 处理", type);
                inputRegisters.getMapper().setUInt32(registerAddress, extractUInt32Value(rawValue));
                return 2;
        }
    }

    /**
     * 安全提取float值
     */
    private float extractFloatValue(Object value) {
        if (value == null) {
            return 0.0f;
        }
        if (value instanceof Number) {
            return ((Number) value).floatValue();
        }
        try {
            return Float.parseFloat(value.toString());
        } catch (NumberFormatException e) {
            return 0.0f;
        }
    }

    /**
     * 安全提取uint32值
     */
    private long extractUInt32Value(Object value) {
        if (value == null) {
            return 0L;
        }
        try {
            String text = value.toString();
            if (text == null) {
                return 0L;
            }
            text = text.trim();
            if (text.isEmpty()) {
                return 0L;
            }
            BigDecimal decimal = new BigDecimal(text);
            long longValue = decimal.setScale(0, RoundingMode.HALF_UP).longValue();
            return longValue & 0xFFFFFFFFL;
        } catch (NumberFormatException e) {
            log.error("uint32数值转换失败: {}", value);
            return 0L;
        } catch (Exception e) {
            log.error("uint32数值转换失败: {}", value);
            return 0L;
        }
    }
    /**
     * 安全提取int32值
     */
    private int extractInt32Value(Object value) {
        if (value == null) {
            return 0;
        }
        try {
            BigDecimal decimal = new BigDecimal(value.toString().trim());
            return decimal.setScale(0, RoundingMode.HALF_UP).intValue();
        } catch (Exception e) {
            log.error("int32数值转换失败: {}", value);
            return 0;
        }
    }
    /**
     * 安全提取uint16值
     */
    private int extractUInt16Value(Object value) {
        if (value == null) {
            return 0;
        }
        try {
            BigDecimal decimal = new BigDecimal(value.toString().trim());
            int raw = decimal.setScale(0, RoundingMode.HALF_UP).intValue();
            return raw & 0xFFFF;
        } catch (Exception e) {
            log.error("uint16数值转换失败: {}", value);
            return 0;
        }
    }
    /**
     * 安全提取int16值
     */
    private int extractInt16Value(Object value) {
        if (value == null) {
            return 0;
        }
        try {
            BigDecimal decimal = new BigDecimal(value.toString().trim());
            return decimal.setScale(0, RoundingMode.HALF_UP).intValue();
        } catch (Exception e) {
            log.error("int16数值转换失败: {}", value);
            return 0;
        }
    }
    /**
     * 安全提取double值
     */
    private double extractDoubleValue(Object value) {
        if (value == null) {
            return 0D;
        }
        try {
            return new BigDecimal(value.toString().trim()).doubleValue();
        } catch (Exception e) {
            log.error("double数值转换失败: {}", value);
            return 0D;
        }
    }
    /**
     * 安全提取int64值
     */
    private long extractInt64Value(Object value) {
        if (value == null) {
            return 0L;
        }
        try {
            BigDecimal decimal = new BigDecimal(value.toString().trim());
            return decimal.setScale(0, RoundingMode.HALF_UP).longValue();
        } catch (Exception e) {
            log.error("int64数值转换失败: {}", value);
            return 0L;
        }
    }
    /**
     * 安全提取uint64值
     */
    private BigInteger extractUInt64Value(Object value) {
        if (value == null) {
            return BigInteger.ZERO;
        }
        try {
            BigDecimal decimal = new BigDecimal(value.toString().trim());
            BigInteger rounded = decimal.setScale(0, RoundingMode.HALF_UP).toBigInteger();
            BigInteger mask = BigInteger.ONE.shiftLeft(64).subtract(BigInteger.ONE);
            return rounded.and(mask);
        } catch (Exception e) {
            log.error("uint64数值转换失败: {}", value);
            return BigInteger.ZERO;
        }
    }
    /**
     * 写入float64值
     */
    private void writeFloat64(int startOffset, double value) {
        long bits = Double.doubleToLongBits(value);
        writeLongBits(startOffset, bits);
    }
    /**
     * 写入int64值
     */
    private void writeInt64(int startOffset, long value) {
        writeLongBits(startOffset, value);
    }
    /**
     * 写入uint64值
     */
    private void writeUInt64(int startOffset, BigInteger value) {
        BigInteger mask16 = BigInteger.valueOf(0xFFFFL);
        inputRegisters.writeRegister(startOffset, value.shiftRight(48).and(mask16).shortValue());
        inputRegisters.writeRegister(startOffset + 1, value.shiftRight(32).and(mask16).shortValue());
        inputRegisters.writeRegister(startOffset + 2, value.shiftRight(16).and(mask16).shortValue());
        inputRegisters.writeRegister(startOffset + 3, value.and(mask16).shortValue());
    }
    /**
     * 写入long位值
     */
    private void writeLongBits(int startOffset, long bits) {
        inputRegisters.writeRegister(startOffset, (short) ((bits >>> 48) & 0xFFFF));
        inputRegisters.writeRegister(startOffset + 1, (short) ((bits >>> 32) & 0xFFFF));
        inputRegisters.writeRegister(startOffset + 2, (short) ((bits >>> 16) & 0xFFFF));
        inputRegisters.writeRegister(startOffset + 3, (short) (bits & 0xFFFF));
    }

}
