package com.ruoyi.system.domain;

import com.ruoyi.common.core.domain.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

/**
 * 设备统计信息  eq_device_stat
 *
 * @author wangchangzhen
 * @date 2025-12-19
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = false)
public class EqDeviceStat extends BaseEntity {
    private Long statId;  //统计ID
    private String deviceId;//设备ID
    
    /** 设备编号（关联查询） */
    private String deviceNo;
    
    /** 设备名称（关联查询） */
    private String deviceName;
    
    /** 统计日期（汇总接口为实时计算时刻） */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date statDate;
    private BigDecimal totalRuntimeHours;//总运行时间
    private Integer totalFaultCount; //总故障次数
    private Integer totalMaintenanceCount;  //总维护次数
    private BigDecimal averageTemperature; //平均温度
    private BigDecimal maximumTemperature; //最高温度
    private BigDecimal minimumTemperature;  //最低温度
    private BigDecimal averagePower;  //平均功率
    private BigDecimal uptimePercentage; //运行率  %
    private Integer downtimeMinutes; //停机分钟数
    private BigDecimal maintenanceCost; //维修成本
    private BigDecimal faultRatePerHour; //故障率

    /** 查询条件：仅风力预测写入（remark 以 WIND_FORECAST 开头），非表字段 */
    private Boolean windForecastOnly;

    /** 查询条件：为 true 且带 deviceId 时，列表返回业务表实时汇总一行（设备统计页），非表字段 */
    private Boolean computedSummary;
}
