package com.example.protocoltrans.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import java.util.LinkedHashMap;
import java.util.Map;

/**
 * 寄存器数据类型配置（顶级配置）
 */
@Data
@Component
@ConfigurationProperties(prefix = "protocol-trans")
public class RegisterTypeConfig {

    /**
     * Modbus 寄存器数据类型配置
     * key: 点位编码
     * value: 数据类型（float32、uint32、int32、uint16、int16、float64/double64、uint64、int64）
     */
    private Map<String, String> registerTypes = new LinkedHashMap<>();

    public Map<String, String> getEffectiveRegisterTypes() {
        if (registerTypes == null) {
            throw new RuntimeException("寄存器数据类型配置读取失败");
        }
        return registerTypes;
    }
}
