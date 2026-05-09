package com.ruoyi.system.domain;

import com.ruoyi.common.core.domain.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.Date;

/**
 * 设备机械数据 eq_mechanical_data
 *
 * @author wangchangzhen
 * @date 2025-12-19
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = false)
public class EqMechanicalData extends BaseEntity {
    private Long mechanicalId; //机械数据ID
    private String deviceId;    //设备ID
    
    /** 设备编号（关联查询） */
    private String deviceNo;
    
    /** 设备名称（关联查询） */
    private String deviceName;
    
    private Date timestamp;   //采集时间
    private BigDecimal loadWeight; //载荷重量(kg)
    private BigDecimal loadRatio;  //载荷比率(%)
    private BigDecimal stressLevel; //应力水平(MPa)
    private Integer fatigueCycles;      //疲劳循环次数
    private Integer overloadTimes;      //过载次数
    private BigDecimal vibrationAmplitude; //振动振幅(mm)
    private BigDecimal vibrationVelocity;  //振动速度(mm/s)
    private BigDecimal vibrationAcceleration; //振动加速度(g)
    private String vibrationSpectrum; //振动频谱数据(JSON格式)
    private String vibrationDirection; //振动方向
    private BigDecimal corrosionRate;  //腐蚀速率(mm/year)
    private BigDecimal corrosionDepth; //腐蚀深度(mm)
    private Integer surfaceCondition; //表面状况 1-好 2-一般 3-较差 4-严重
    private BigDecimal coatingThickness; //涂层厚度(mm)
    private BigDecimal materialTemperature; //材料温度(°C)
    private BigDecimal thermalExpansion;    //热膨胀系数
    private BigDecimal materialHardness;  //材料硬度(HRC)
    private Integer mechanicalGrade; //机械等级1-优良 2良好 3一般 4较差
}
