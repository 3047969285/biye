package com.ruoyi.web.controller.meter.dto;

import java.util.List;

/**
 * HTTP/TCP 上报寄存器块
 */
public class MeterIngestPayload {

    private Integer slaveId = 1;
    /** 0 保持寄存器 FC03，1 输入寄存器 FC04 */
    private Integer registerType = 0;
    /** 本帧寄存器块起始地址（与点表 addr_offset 同一坐标系） */
    private Integer baseAddress = 0;
    private List<Integer> registers;
    /** ISO-8601 或 yyyy-MM-dd HH:mm:ss，可空为服务器时间 */
    private String readTime;

    public Integer getSlaveId() {
        return slaveId;
    }

    public void setSlaveId(Integer slaveId) {
        this.slaveId = slaveId;
    }

    public Integer getRegisterType() {
        return registerType;
    }

    public void setRegisterType(Integer registerType) {
        this.registerType = registerType;
    }

    public Integer getBaseAddress() {
        return baseAddress;
    }

    public void setBaseAddress(Integer baseAddress) {
        this.baseAddress = baseAddress;
    }

    public List<Integer> getRegisters() {
        return registers;
    }

    public void setRegisters(List<Integer> registers) {
        this.registers = registers;
    }

    public String getReadTime() {
        return readTime;
    }

    public void setReadTime(String readTime) {
        this.readTime = readTime;
    }
}

