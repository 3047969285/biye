package com.ruoyi.deparment.domain.Model;

import com.ruoyi.common.core.domain.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;
/**
 * 设备传感器信息
 */

@Data
@NoArgsConstructor
@AllArgsConstructor
public class EqSensor extends BaseEntity {
    private long sensorId; //传感器ID
    private long deviceId; //设备ID
    private String sensorType; //传感器类型
    private String sensorName; //传感器名称
    private String location;   //安装位置
    private String unit;      // 单位
    private Date   calibrationTime; //校准时间
    private Date   nextCalibrationTime; //下次校准时间
    private Integer status; //传感器状态 1-启用 2-停用 3校准中
}
