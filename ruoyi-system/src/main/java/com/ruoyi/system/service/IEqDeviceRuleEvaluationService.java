package com.ruoyi.system.service;

import com.ruoyi.system.domain.EqDeviceStatus;

/**
 * 设备规则评估编排：在状态变更后加载最新快照、调用规则触发服务，并将建议运行状态与维护标记写回数据库。
 */
public interface IEqDeviceRuleEvaluationService {

    /**
     * 在设备状态新增或更新后调用：按该设备启用的规则逐条比对当前状态，命中则写入告警（去重），并视结果升高运行状态 / 标记需维护。
     *
     * @param status 当前这条设备状态（含 deviceId、各测点及运行状态等）；若有 statusId 则优先按库内整行评估
     */
    void evaluateAfterStatusChange(EqDeviceStatus status);

    /**
     * 按设备 ID 取最新一条状态并重算规则（定时任务、规则变更后批量补偿、接口手动刷新等可复用）。
     *
     * @param deviceId 设备主键
     */
    void evaluateLatestStatusForDevice(Long deviceId);
}
