package com.ruoyi.system.domain;

import com.ruoyi.common.core.domain.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.util.Date;

/**
 * 设备告警记录对象 eq_alert_record
 *
 * @author wcz
 * @date 2025-12-19
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = false)
public class EqAlertRecord extends BaseEntity {
    private Long alertId;
    private Long deviceId;
    
    /** 设备编号（关联查询） */
    private String deviceNo;
    
    /** 设备名称（关联查询） */
    private String deviceName;
    
    private Long ruleId;
    private Integer alertLevel;
    private String alertMessage;
    private Date   triggeredTime;
    private Date   resolvedTime;
    private Integer status;  //1已经触发 2已经解决 3已确认
    private Long  resolvedBy;
    private String resolutionNotes;
    private String remark;
}
