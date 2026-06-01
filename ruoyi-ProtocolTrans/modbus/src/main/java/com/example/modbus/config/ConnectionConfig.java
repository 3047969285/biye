package com.example.modbus.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

/**
 * @Author wangchangzhen
 * @Date 2025 12 23 10 30
 * @description
 **/
@Data
@Component
@ConfigurationProperties(prefix = "protocol-trans.modbus.client")
public class ConnectionConfig {

    /**
     * Modbus设备IP地址 127.0.0.1
     */
    private String host;

    /**
     * Modbus设备TCP端口 502
     */
    private int port;

    /**
     * TCP连接超时时间
     */
    private int timeout = 3000;

    /**
     * 操作失败重试次数
     */
    private int retries = 3;

    /**
     * false：标准 ModbusTCP
     * true：封装/RTU 风格 走EncapMessageParser
     */
    private boolean encapsulated = true;

    /**
     * 连接池最大连接数
     */
    private int maxConnections = 10;

    /**
     * 获取连接超时时间
     */
    private long connectionTimeout = 10000;

    /**
     * 连接空闲超时时间
     */
    private long idleTimeout = 300000;

    /**
     * 连接类型：tcp / serial
     */
    private String connectionType = "tcp";

    /**
     * 串口号（仅串口模式）
     */
    private String serialPort;

    /**
     * 波特率（仅串口模式）
     */
    private int baudRate = 9600;

    /**
     * 数据位（仅串口模式，默认8）
     */
    private int dataBits = 8;

    /**
     * 停止位（仅串口模式，默认1）
     */
    private int stopBits = 1;

    /**
     * 校验位（仅串口模式，0=无, 1=奇, 2=偶）
     */
    private int parity = 0;
}
