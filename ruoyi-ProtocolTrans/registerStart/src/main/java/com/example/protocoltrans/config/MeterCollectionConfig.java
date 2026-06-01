package com.example.protocoltrans.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Data
@Component
@ConfigurationProperties(prefix = "protocol-trans.collection")
public class MeterCollectionConfig {
        private String cron = "0/30 * * * * ?";
        private List<DeviceConfig> devices;

    @Data
    public static class DeviceConfig {
        /**
         * 设备名称
         */
        private String name;

        /**
         * 连接类型：tcp / serial
         */
        private String type;

        /**
         * 协议类型：dl645 / dl698 / modbus
         */
        private String protocol;

        /**
         * 电表索引（用于计算寄存器基址）
         */
        private int index;

        // TCP 配置
        private String ip;
        private int port;

        // 串口配置
        private String comPort;
        private int baudRate = 9600;
        private int dataBits = 8;
        private int stopBits = 1;
        private int parity = 0;

        // 通用配置
        private String address;
        private int timeout = 3000;
        private Integer clientAddress;

        /**
         * DL645 设备专属的 DI 映射（覆盖全局配置）
         * key: 点位编码
         * value: DI（十六进制字符串）
         */
        private Map<String, String> diMapping;

        /**
         * DL698 设备专属的 OAD 映射（覆盖全局配置）
         * key: 点位编码
         * value: OAD（十六进制字符串）
         */
        private Map<String, String> oadMapping;

        /**
         * Modbus RTU 设备专属的寄存器地址映射
         * key: 点位编码
         * value: 寄存器地址（十六进制字符串，如 "0000H"）
         */
        private Map<String, String> addrMapping;
    }
}
