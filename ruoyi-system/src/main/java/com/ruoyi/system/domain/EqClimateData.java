package com.ruoyi.system.domain;

import com.ruoyi.common.core.domain.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.Date;

/**
 * 设备气候数据 eq_climate_data
 *
 * @author wcz
 * @date 2025-12-19
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = false)
public class EqClimateData extends BaseEntity {
    private Long climateId; //气候数据ID
    private Long deviceId; //设备ID
    
    /** 设备编号（关联查询） */
    private String deviceNo;
    
    /** 设备名称（关联查询） */
    private String deviceName;
    
    private Date timestamp; //采集时间
    private Integer season; //季节1 春 2夏 3秋 4冬
    private String weatherCondition; //天气情况
    private BigDecimal precipitation; //降水量
    private BigDecimal windSpeed; //风速
    private String windDirection; //风向
    private Integer extremeWeather; //极端天气
    private Integer weatherDuration; //天气持续时间
    private Integer temperatureExtreme; //极端温度
    private Integer naturalDisasters; //自然灾害
    private Integer disasterIntensity; //灾害强度
    private Integer disasterDuration; //灾害持续时间
    private Integer airQualityIndex; //空气质量指数
    private Integer pollutionLevel; //污染等级1-优 2-良 3-轻度污染 4-中度污染 5-重度污染
    private BigDecimal uvIndex; //紫外线指数
}
