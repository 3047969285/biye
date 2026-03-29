package com.ruoyi.system.service;

import com.ruoyi.system.domain.EqDeviceStatus;
import com.ruoyi.system.domain.dto.RuleTriggerResult;

/**
 * 设备规则触发：仅负责「测点比对 → 命中则写告警」，与运行状态表写库解耦，便于定时任务、手动重算等复用。
 */
public interface IEqDeviceRuleTriggerService {

    /**
     * 对给定状态快照执行该设备全部启用规则；命中则插入告警（去重），并计算建议运行状态与维护标记。
     * 不修改 {@link EqDeviceStatus} 表，返回值供 {@link IEqDeviceRuleEvaluationService} 等统一落库。
     *
     * @param data 已对齐的最新状态行（需含 deviceId；若有 statusId 则用于幂等语义）
     * @return 触发统计与建议状态；无规则时 target=baseline、alertsInserted=0
     */
    RuleTriggerResult fireRulesForSnapshot(EqDeviceStatus data);
}
