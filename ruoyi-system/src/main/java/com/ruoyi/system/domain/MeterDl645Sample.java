package com.ruoyi.system.domain;

import com.ruoyi.common.core.domain.BaseEntity;

import java.util.Date;

/**
 * DL/T645-2007 电表采样记录 meter_dl645_sample
 */
public class MeterDl645Sample extends BaseEntity {

    private static final long serialVersionUID = 1L;

    private Long id;
    private String meterAddress;
    private String diCode;
    private String pointCode;
    private String pointName;
    private Double value;
    private String unit;
    private Date readTime;
    private String source;
    private String rawFrameHex;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getMeterAddress() {
        return meterAddress;
    }

    public void setMeterAddress(String meterAddress) {
        this.meterAddress = meterAddress;
    }

    public String getDiCode() {
        return diCode;
    }

    public void setDiCode(String diCode) {
        this.diCode = diCode;
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

    public Double getValue() {
        return value;
    }

    public void setValue(Double value) {
        this.value = value;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public Date getReadTime() {
        return readTime;
    }

    public void setReadTime(Date readTime) {
        this.readTime = readTime;
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public String getRawFrameHex() {
        return rawFrameHex;
    }

    public void setRawFrameHex(String rawFrameHex) {
        this.rawFrameHex = rawFrameHex;
    }
}
