package com.ruoyi.deparment.domain.Model;

import com.ruoyi.common.core.domain.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.Date;

/**
 * 设备运行状态(包括温度、湿度、压力、振动、电流、电压、功率、转速、流量、液位）  eq_device_status
 *
 * @author wcz
 * @date 2025-12-19
 */

@Data
@NoArgsConstructor
@AllArgsConstructor
public class EqDeviceStatus extends BaseEntity {
    private Long statusId; //状态ID
    private Long deviceId; //设备ID
    private Date timestamp;  //采集时间
    private BigDecimal temperature; //温度
    private BigDecimal humidity; //湿度
    private BigDecimal pressure; //压力
    private BigDecimal vibration; //振动
    private BigDecimal current; //电流
    private BigDecimal voltage; //电压
    private BigDecimal power; //功率
    private BigDecimal rpm; //转速
    private BigDecimal flow_rate; //流量
    private BigDecimal liquid_level; //液位
    private Integer status; //运行状态1正常 2警告 3错误 4离线
    private BigDecimal runtimeHours;//累计运行小时数
    private int startCount; //启动次数
    private int faultCount; //故障次数
    private int alarmCount; //报警次数

}
