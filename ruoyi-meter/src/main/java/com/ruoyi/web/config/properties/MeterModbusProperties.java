package com.ruoyi.web.config.properties;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

/**
 * 电表 Modbus 网口与开放接口配置
 */
@Component
@ConfigurationProperties(prefix = "meter.modbus")
public class MeterModbusProperties {

    /** 是否启用 TCP 网口接收（NDJSON / Modbus TCP 帧） */
    private boolean tcpEnabled = false;

    /** TCP 监听端口（默认 5021，避免与系统 Modbus 502 冲突） */
    private int tcpPort = 5021;

    /** 是否解析二进制 Modbus TCP 帧（false 则仅 NDJSON 行，便于调试） */
    private boolean tcpBinary = false;

    /** HTTP/TCP 写入数据时可选的共享密钥（非空则需在 Header 或首行携带） */
    private String ingestApiKey = "";

    /** 开放汇总接口是否附带点表定义 */
    private boolean summaryIncludePointTable = true;

    public boolean isTcpEnabled() {
        return tcpEnabled;
    }

    public void setTcpEnabled(boolean tcpEnabled) {
        this.tcpEnabled = tcpEnabled;
    }

    public int getTcpPort() {
        return tcpPort;
    }

    public void setTcpPort(int tcpPort) {
        this.tcpPort = tcpPort;
    }

    public boolean isTcpBinary() {
        return tcpBinary;
    }

    public void setTcpBinary(boolean tcpBinary) {
        this.tcpBinary = tcpBinary;
    }

    public String getIngestApiKey() {
        return ingestApiKey;
    }

    public void setIngestApiKey(String ingestApiKey) {
        this.ingestApiKey = ingestApiKey;
    }

    public boolean isSummaryIncludePointTable() {
        return summaryIncludePointTable;
    }

    public void setSummaryIncludePointTable(boolean summaryIncludePointTable) {
        this.summaryIncludePointTable = summaryIncludePointTable;
    }
}

