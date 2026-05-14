package com.ruoyi.system.domain;

import com.ruoyi.common.core.domain.BaseEntity;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.springframework.format.annotation.DateTimeFormat;

import java.math.BigDecimal;
import java.util.Date;

/**
 * 设备运行状态(包括温度、湿度、压力、振动、电流、电压、功率、转速、流量、液位）  eq_device_status
 *
 * @author wangchangzhen
 * @date 2025-12-19
 */
public class EqDeviceStatus extends BaseEntity {
    private Long statusId; //状态ID
    private String deviceId; //设备ID
    private String deviceNo; //设备编号（关联查询）
    private String deviceName; //设备名称（关联查询）
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date timestamp;  //采集时间
    private BigDecimal temperature; //温度
    private BigDecimal humidity; //湿度
    private BigDecimal pressure; //压力
    private BigDecimal vibration; //振动
    private BigDecimal current; //电流
    private BigDecimal voltage; //电压
    private BigDecimal power; //功率
    private BigDecimal rpm; //转速
    private BigDecimal flowRate; //流量
    private BigDecimal liquidLevel; //液位
    private Integer status; //运行状态1正常 2警告 3错误 4离线
    private BigDecimal runtimeHours;//累计运行小时数
    private Integer startCount; //启动次数
    private Integer faultCount; //故障次数
    private Integer alarmCount; //报警次数
    private BigDecimal efficiency; //效率
    private BigDecimal loadFactor; //负载系数
    private BigDecimal ambientTemp; //环境温度
    private BigDecimal ambientHumidity; //环境湿度
    private BigDecimal noiseLevel; //噪音水平
    private BigDecimal airQuality; //空气质量指数
    private String faultCode; //故障代码
    private String faultDescription; //故障描述
    private Integer maintenanceRequired; //是否需要维护 0-否 1-是
    // remark 字段继承自 BaseEntity

    public Long getStatusId() {
        return statusId;
    }

    public void setStatusId(Long statusId) {
        this.statusId = statusId;
    }

    public String getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(String deviceId) {
        this.deviceId = deviceId;
    }

    public String getDeviceNo() {
        return deviceNo;
    }

    public void setDeviceNo(String deviceNo) {
        this.deviceNo = deviceNo;
    }

    public String getDeviceName() {
        return deviceName;
    }

    public void setDeviceName(String deviceName) {
        this.deviceName = deviceName;
    }

    public Date getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Date timestamp) {
        this.timestamp = timestamp;
    }

    public BigDecimal getTemperature() {
        return temperature;
    }

    public void setTemperature(BigDecimal temperature) {
        this.temperature = temperature;
    }

    public BigDecimal getHumidity() {
        return humidity;
    }

    public void setHumidity(BigDecimal humidity) {
        this.humidity = humidity;
    }

    public BigDecimal getPressure() {
        return pressure;
    }

    public void setPressure(BigDecimal pressure) {
        this.pressure = pressure;
    }

    public BigDecimal getVibration() {
        return vibration;
    }

    public void setVibration(BigDecimal vibration) {
        this.vibration = vibration;
    }

    public BigDecimal getCurrent() {
        return current;
    }

    public void setCurrent(BigDecimal current) {
        this.current = current;
    }

    public BigDecimal getVoltage() {
        return voltage;
    }

    public void setVoltage(BigDecimal voltage) {
        this.voltage = voltage;
    }

    public BigDecimal getPower() {
        return power;
    }

    public void setPower(BigDecimal power) {
        this.power = power;
    }

    public BigDecimal getRpm() {
        return rpm;
    }

    public void setRpm(BigDecimal rpm) {
        this.rpm = rpm;
    }

    public BigDecimal getFlowRate() {
        return flowRate;
    }

    public void setFlowRate(BigDecimal flowRate) {
        this.flowRate = flowRate;
    }

    public BigDecimal getLiquidLevel() {
        return liquidLevel;
    }

    public void setLiquidLevel(BigDecimal liquidLevel) {
        this.liquidLevel = liquidLevel;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public BigDecimal getRuntimeHours() {
        return runtimeHours;
    }

    public void setRuntimeHours(BigDecimal runtimeHours) {
        this.runtimeHours = runtimeHours;
    }

    public Integer getStartCount() {
        return startCount;
    }

    public void setStartCount(Integer startCount) {
        this.startCount = startCount;
    }

    public Integer getFaultCount() {
        return faultCount;
    }

    public void setFaultCount(Integer faultCount) {
        this.faultCount = faultCount;
    }

    public Integer getAlarmCount() {
        return alarmCount;
    }

    public void setAlarmCount(Integer alarmCount) {
        this.alarmCount = alarmCount;
    }

    public BigDecimal getEfficiency() {
        return efficiency;
    }

    public void setEfficiency(BigDecimal efficiency) {
        this.efficiency = efficiency;
    }

    public BigDecimal getLoadFactor() {
        return loadFactor;
    }

    public void setLoadFactor(BigDecimal loadFactor) {
        this.loadFactor = loadFactor;
    }

    public BigDecimal getAmbientTemp() {
        return ambientTemp;
    }

    public void setAmbientTemp(BigDecimal ambientTemp) {
        this.ambientTemp = ambientTemp;
    }

    public BigDecimal getAmbientHumidity() {
        return ambientHumidity;
    }

    public void setAmbientHumidity(BigDecimal ambientHumidity) {
        this.ambientHumidity = ambientHumidity;
    }

    public BigDecimal getNoiseLevel() {
        return noiseLevel;
    }

    public void setNoiseLevel(BigDecimal noiseLevel) {
        this.noiseLevel = noiseLevel;
    }

    public BigDecimal getAirQuality() {
        return airQuality;
    }

    public void setAirQuality(BigDecimal airQuality) {
        this.airQuality = airQuality;
    }

    public String getFaultCode() {
        return faultCode;
    }

    public void setFaultCode(String faultCode) {
        this.faultCode = faultCode;
    }

    public String getFaultDescription() {
        return faultDescription;
    }

    public void setFaultDescription(String faultDescription) {
        this.faultDescription = faultDescription;
    }

    public Integer getMaintenanceRequired() {
        return maintenanceRequired;
    }

    public void setMaintenanceRequired(Integer maintenanceRequired) {
        this.maintenanceRequired = maintenanceRequired;
    }
}
