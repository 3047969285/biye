package com.ruoyi.system.domain.vo;

import java.io.Serializable;
import java.util.Date;

/**
 * 点表汇总（时间窗内统计）
 */
public class MeterPointSummaryVo implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long pointId;
    private String pointCode;
    private String pointName;
    private Integer slaveId;
    private Integer addrOffset;
    private String unit;
    private Long sampleCount;
    private Double minValue;
    private Double maxValue;
    private Double avgValue;
    private Date lastReadTime;

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

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public Long getSampleCount() {
        return sampleCount;
    }

    public void setSampleCount(Long sampleCount) {
        this.sampleCount = sampleCount;
    }

    public Double getMinValue() {
        return minValue;
    }

    public void setMinValue(Double minValue) {
        this.minValue = minValue;
    }

    public Double getMaxValue() {
        return maxValue;
    }

    public void setMaxValue(Double maxValue) {
        this.maxValue = maxValue;
    }

    public Double getAvgValue() {
        return avgValue;
    }

    public void setAvgValue(Double avgValue) {
        this.avgValue = avgValue;
    }

    public Date getLastReadTime() {
        return lastReadTime;
    }

    public void setLastReadTime(Date lastReadTime) {
        this.lastReadTime = lastReadTime;
    }
}
