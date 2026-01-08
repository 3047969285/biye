package com.ruoyi.system.domain;

import com.ruoyi.common.core.domain.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.Date;

/**
 * 设备参数对象 eq_device_param
 *
 * @author ruoyi
 * @date 2026-01-07
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = false)
public class EqDeviceParam extends BaseEntity {
    
    private static final long serialVersionUID = 1L;

    /** 参数ID */
    private Long paramId;

    /** 设备ID */
    private Long deviceId;

    /** 参数名称 */
    private String parameterName;

    /** 参数值 */
    private BigDecimal parameterValue;

    /** 单位 */
    private String unit;

    /** 默认值 */
    private BigDecimal defaultValue;

    /** 最小值 */
    private BigDecimal minValue;

    /** 最大值 */
    private BigDecimal maxValue;

    /** 临界阈值 */
    private BigDecimal criticalThreshold;

    /** 警告阈值 */
    private BigDecimal warningThreshold;

    /** 最后更新时间 */
    private Date lastUpdated;
}
