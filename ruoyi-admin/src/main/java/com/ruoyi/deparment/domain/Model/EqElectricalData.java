package com.ruoyi.deparment.domain.Model;

import com.ruoyi.common.core.domain.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.Date;
/**
 * 电器数据  eq_electrical_data
 *
 * @author wcz
 * @date 2025-12-19
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class EqElectricalData extends BaseEntity {
    private Long electricalId; //电器数据ID
    private Long deviceId; //设备ID
    private Date timestamp; //采集时间
    private BigDecimal voltageL1; //L1相电压
    private BigDecimal voltageL2; //L2相电压
    private BigDecimal voltageL3; //L3相电压
    private BigDecimal voltageUnbalance;//电压不平衡率（%）
    private BigDecimal frequency; //电网频率
    private BigDecimal voltageFluctuation; //电压波动率（%）
    private BigDecimal currentL1; //L1相电流
    private BigDecimal currentL2; //L2相电流
    private BigDecimal currentL3; //L3相电流
    private BigDecimal currentUnbalance; //电流不平衡率（%）
    private BigDecimal totalCurrent; //总电流
    private BigDecimal activePower; //有功功率(kW)
    private BigDecimal reactivePower; //无功功率(kVar)
    private BigDecimal apparentPower; //视在功率(kVA)
    private BigDecimal powerFactor; //功率因数
    private BigDecimal efficiency; //效率(%)
    private Object harmonicsVoltage;//电压谐波含量
    private Object harmonicsCurrent;//电流谐波含量
    private BigDecimal totalHarmonicDistortion; //总谐波失真率（%）
    private BigDecimal voltageThd; //电压总谐波失真率(%)
    private BigDecimal currentThd; //电流总谐波失真率(%)
    private BigDecimal electromagneticInterference; //电磁干扰强度（dB）
    private BigDecimal groundingResistance; //接地电阻（Ω）
    private BigDecimal shieldingEffectiveness; //屏蔽效果（dB）
    private Integer electricalGrade; //电器等级 1-优良 2良好 3一般 4较差
}
