package com.ruoyi.system.domain;

import com.ruoyi.common.core.domain.BaseEntity;

import java.math.BigDecimal;

/**
 * 电表 Modbus 点表 meter_point
 */
public class MeterPoint extends BaseEntity {

    private static final long serialVersionUID = 1L;

    private Long pointId;
    private String pointCode;
    private String pointName;
    private Integer slaveId;
    private Integer addrOffset;
    private Integer registerType;
    private String dataType;
    private String wordSwap;
    private BigDecimal scale;
    private BigDecimal valueOffset;
    private String unit;
    private Integer sortOrder;
    private String status;
    private String delFlag;

    public Long getPointId() {
        return pointId;
    }

    public void setPointId(Long pointId) {
        this.pointId = pointId;
    }

    public String getPointCode() {
        return pointCode;
    }

    public void setPointCode(String pointCode) {
        this.pointCode = pointCode;
    }

    public String getPointName() {
        return pointName;
    }

    public void setPointName(String pointName) {
        this.pointName = pointName;
    }

    public Integer getSlaveId() {
        return slaveId;
    }

    public void setSlaveId(Integer slaveId) {
        this.slaveId = slaveId;
    }

    public Integer getAddrOffset() {
        return addrOffset;
    }

    public void setAddrOffset(Integer addrOffset) {
        this.addrOffset = addrOffset;
    }

    public Integer getRegisterType() {
        return registerType;
    }

    public void setRegisterType(Integer registerType) {
        this.registerType = registerType;
    }

    public String getDataType() {
        return dataType;
    }

    public void setDataType(String dataType) {
        this.dataType = dataType;
    }

    public String getWordSwap() {
        return wordSwap;
    }

    public void setWordSwap(String wordSwap) {
        this.wordSwap = wordSwap;
    }

    public BigDecimal getScale() {
        return scale;
    }

    public void setScale(BigDecimal scale) {
        this.scale = scale;
    }

    public BigDecimal getValueOffset() {
        return valueOffset;
    }

    public void setValueOffset(BigDecimal valueOffset) {
        this.valueOffset = valueOffset;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public Integer getSortOrder() {
        return sortOrder;
    }

    public void setSortOrder(Integer sortOrder) {
        this.sortOrder = sortOrder;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getDelFlag() {
        return delFlag;
    }

    public void setDelFlag(String delFlag) {
        this.delFlag = delFlag;
    }
}
