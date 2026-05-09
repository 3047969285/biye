package com.ruoyi.system.domain;

import com.ruoyi.common.core.domain.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * 设备规则  eq_device_rule
 *
 * @author wangchangzhen
 * @date 2025-12-19
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = false)
public class EqDeviceRule extends BaseEntity {
    private Long ruleId;  //规则 ID
    private String deviceId; //设备 ID
    
    /** 设备编号（关联查询） */
    private String deviceNo;
    
    /** 设备名称（关联查询） */
    private String deviceName;
    
    private String ruleName; //规则名称
    private String parameterName; //参数名称
    private Integer conditionType; //条件类型1大于 2小于 3等于 4区间
    private BigDecimal thresholdValue; //阈值
    private String thresholdUnit; //阈值单位
    private Integer alertLevel; //报警等级 1警报 2严重 3紧急
    private Integer enabled;  //是否启用 1启用 0禁用
    private String notificationChannels; //通知渠道
}
