package com.ruoyi.system.service;

import com.ruoyi.system.domain.EqDeviceStatus;
import com.ruoyi.system.domain.dto.RuleTriggerResult;

/**
 * 设备规则触发Service接口
 *
 * @author wangchangzhen
 * @date 2026-01-07
 */
public interface IEqDeviceRuleTriggerService
{
    /**
     * 根据设备状态快照匹配规则，计算目标运行状态并产生告警等副作用
     *
     * @param data 设备状态快照
     * @return 规则触发汇总结果
     */
    public RuleTriggerResult fireRulesForSnapshot(EqDeviceStatus data);
}
