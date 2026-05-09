package com.ruoyi.system.service;

import com.ruoyi.system.domain.EqDeviceStatus;

/**
 * 设备规则评估Service接口
 *
 * @author wangchangzhen
 * @date 2026-01-07
 */
public interface IEqDeviceRuleEvaluationService
{
    /**
     * 设备状态变更后触发规则评估并回写运行状态等字段
     *
     * @param status 设备状态（可为快照或含主键的持久化对象）
     */
    public void evaluateAfterStatusChange(EqDeviceStatus status);

    /**
     * 按设备ID加载最新状态快照并执行规则评估
     *
     * @param deviceId 设备ID
     */
    public void evaluateLatestStatusForDevice(String deviceId);
}
