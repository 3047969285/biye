package com.ruoyi.deparment.domain.Model;

import com.ruoyi.common.core.domain.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
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
public class EqAlertRecord extends BaseEntity {
    private Long alertId;
    private Long deviceId;
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
