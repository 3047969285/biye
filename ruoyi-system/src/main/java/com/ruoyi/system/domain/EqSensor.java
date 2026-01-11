package com.ruoyi.system.domain;

import com.ruoyi.common.core.domain.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.util.Date;

/**
 * 设备传感器信息 eq_sensor
 *
 * @author wcz
 * @date 2025-12-19
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = false)
public class EqSensor extends BaseEntity {
    private Long sensorId; //传感器ID
    private Long deviceId; //设备ID
    
    /** 设备编号（关联查询） */
    private String deviceNo;
    
    /** 设备名称（关联查询） */
    private String deviceName;
    
    private String sensorType; //传感器类型
    private String sensorName; //传感器名称
    private String location;   //安装位置
    private String unit;      // 单位
    private Date   calibrationTime; //校准时间
    private Date   nextCalibrationTime; //下次校准时间
    private Integer status; //传感器状态 1-启用 2-停用 3校准中
}
