package com.ruoyi.deparment.domain.Model;

import com.ruoyi.common.core.domain.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.apache.commons.math3.ode.nonstiff.GillFieldIntegrator;

import java.math.BigDecimal;
import java.util.Date;

/**
 * 设备统计信息  eq_device_stat
 *
 * @author wcz
 * @date 2025-12-19
 */

@Data
@NoArgsConstructor
@AllArgsConstructor
public class EqDeviceStat extends BaseEntity {
    private Long statId;  //统计ID
    private Long deviceId;//设备ID
    private Date statDate; //统计日期
    private BigDecimal totalRuntimeHours;//总运行时
    private int totalFaultCount; //总故障次数
    private int totalMaintenanceCount;  //总维护次数
    private BigDecimal averageTemperature; //平均温度
    private BigDecimal maximumTemperature; //最高温度
    private BigDecimal minimumTemperature;  //最低温度
    private BigDecimal averagePower;  //平均功率
    private BigDecimal uptimePercentage; //运行率  %
    private int downtimeMinutes; //停机分钟数
    private BigDecimal maintenanceCost; //维修成本
    private BigDecimal faultRatePerHour; //故障率

}
