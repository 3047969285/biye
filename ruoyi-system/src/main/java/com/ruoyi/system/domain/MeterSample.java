package com.ruoyi.system.domain;

import com.ruoyi.common.core.domain.BaseEntity;

import java.util.Date;

/**
 * 电表采样 meter_sample
 */
public class MeterSample extends BaseEntity {

    private static final long serialVersionUID = 1L;

    private Long sampleId;
    private Long pointId;
    private Date readTime;
    private Long valueRaw;
    private Double valueScaled;
    private String source;

    public Long getSampleId() {
        return sampleId;
    }

    public void setSampleId(Long sampleId) {
        this.sampleId = sampleId;
    }

    public Long getPointId() {
        return pointId;
    }

    public void setPointId(Long pointId) {
        this.pointId = pointId;
    }

    public Date getReadTime() {
        return readTime;
    }

    public void setReadTime(Date readTime) {
        this.readTime = readTime;
    }

    public Long getValueRaw() {
        return valueRaw;
    }

    public void setValueRaw(Long valueRaw) {
        this.valueRaw = valueRaw;
    }

    public Double getValueScaled() {
        return valueScaled;
    }

    public void setValueScaled(Double valueScaled) {
        this.valueScaled = valueScaled;
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }
}
