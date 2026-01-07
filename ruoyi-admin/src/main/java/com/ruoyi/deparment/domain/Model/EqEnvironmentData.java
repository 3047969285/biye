package com.ruoyi.deparment.domain.Model;

import com.ruoyi.common.core.domain.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.Date;
/**
 * 环境数据  eq_environment_data
 *
 * @author wcz
 * @date 2025-12-19
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class EqEnvironmentData extends BaseEntity {
    private long envId;                   //环境数据ID
    private long deviceId;                 //设备ID
    private Date timestamp;               //采集时间
    private BigDecimal ambientTemperature;//环境温度(°C)
    private BigDecimal deviceTemperature; //设备温度(°C)
    private BigDecimal temperatureChangeRate;//温度变化率(°C/min)
    private BigDecimal extremeHighTemp;  //高温(°C)
    private BigDecimal extremeLowTemp;  //低温(°C)
    private BigDecimal humidity;        //湿度(%)
    private BigDecimal dewPoint;        //露点(°C)
    private BigDecimal moistureContent; //水分含量
    private BigDecimal humidityFluctuation;//湿度波动率（%）
    private BigDecimal vibrationX;      //振动X(mm/s)
    private BigDecimal vibrationY;      //振动Y(mm/s)
    private BigDecimal vibrationZ;      //振动Z(mm/s)
    private BigDecimal vibrationFrequency; //振动频率(Hz)
    private BigDecimal shockImpact;     //冲击次数
    private BigDecimal maxVibrationLevel; //最大振动等级
    private BigDecimal environmentGrade;  //环境等级 1-优良 2良好 3一般 4较差


}
