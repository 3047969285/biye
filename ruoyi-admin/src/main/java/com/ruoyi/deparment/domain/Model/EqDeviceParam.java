package com.ruoyi.deparment.domain.Model;

import com.ruoyi.common.core.domain.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.Date;
/**
 * 设备参数  eq_device_param
 *
 * @author wcz
 * @date 2025-12-19
 */

@Data
@NoArgsConstructor
@AllArgsConstructor
public class EqDeviceParam extends BaseEntity {


    private Long paramId;  //参数ID
    private Long deviceId; //设备ID
    private String paramName;  //参数名称
    private String paramValue; //参数值
    private String unit;       //单位
    private BigDecimal defaultValue; //默认值
    private BigDecimal minValue;     //最小值
    private BigDecimal maxValue;     //最大值
    private BigDecimal criticalThreshold; // 临界阈值
    private BigDecimal warningThreshold;  // 警告阈值
    private Date  lastUpdated;            // 最后更新时间
}
