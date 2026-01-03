package com.ruoyi.deparment.domain.Model;

import com.ruoyi.common.core.domain.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
/**
 * 设备规则  eq_device_rule
 *
 * @author wcz
 * @date 2025-12-19
 */

@Data
@NoArgsConstructor
@AllArgsConstructor
public class EqDeviceRule extends BaseEntity {
    private  Long ruleId;  //规则 ID
    private  Long deviceId; //设备 ID
    private  String ruleName; //规则名称
    private  String parameterName; //参数名称
    private  int conditionType; //条件类型1大于 2小于 3等于 4区间
    private  BigDecimal thresholdValue; //阈值
    private  String thresholdUnit; //阈值单位
    private  Integer alertLevel; //报警等级 1警报 2严重 3紧急
    private  Integer enabled;  //是否启用 1启用 0禁用
    private  Object notificationChannels; //通知渠道

}
