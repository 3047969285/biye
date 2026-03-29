package com.ruoyi.system.service.impl;

import com.ruoyi.common.constant.EquipmentRuleConstants;
import com.ruoyi.system.domain.EqDeviceStatus;
import com.ruoyi.system.domain.dto.RuleTriggerResult;
import com.ruoyi.system.mapper.EqDeviceStatusMapper;
import com.ruoyi.system.service.IEqDeviceRuleEvaluationService;
import com.ruoyi.system.service.IEqDeviceRuleTriggerService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

/**
 * 设备状态变更后的规则评估编排：拉快照 → 触发规则 → 回写运行状态/需维护。
 */
@Service
public class EqDeviceRuleEvaluationServiceImpl implements IEqDeviceRuleEvaluationService {

    private static final Logger log = LoggerFactory.getLogger(EqDeviceRuleEvaluationServiceImpl.class);

    private final EqDeviceStatusMapper eqDeviceStatusMapper;
    private final IEqDeviceRuleTriggerService eqDeviceRuleTriggerService;

    public EqDeviceRuleEvaluationServiceImpl(EqDeviceStatusMapper eqDeviceStatusMapper,
                                             IEqDeviceRuleTriggerService eqDeviceRuleTriggerService) {
        this.eqDeviceStatusMapper = eqDeviceStatusMapper;
        this.eqDeviceRuleTriggerService = eqDeviceRuleTriggerService;
    }

    @Override
    public void evaluateAfterStatusChange(EqDeviceStatus status) {
        if (status == null || status.getDeviceId() == null) {
            return;
        }
        EqDeviceStatus data = resolveSnapshot(status);
        if (data == null || data.getDeviceId() == null) {
            return;
        }

        RuleTriggerResult trigger = eqDeviceRuleTriggerService.fireRulesForSnapshot(data);
        /* 无 statusId 时仍可落告警；运行状态/维护标记仅在有主键时回写 */
        if (data.getStatusId() != null) {
            applyRunningStateFromTrigger(data, trigger);
        }
    }

    @Override
    public void evaluateLatestStatusForDevice(Long deviceId) {
        if (deviceId == null) {
            return;
        }
        EqDeviceStatus latest = eqDeviceStatusMapper.selectLatestByDeviceId(deviceId);
        if (latest == null) {
            return;
        }
        RuleTriggerResult trigger = eqDeviceRuleTriggerService.fireRulesForSnapshot(latest);
        applyRunningStateFromTrigger(latest, trigger);
    }

    private EqDeviceStatus resolveSnapshot(EqDeviceStatus status) {
        if (status.getStatusId() != null) {
            EqDeviceStatus loaded = eqDeviceStatusMapper.selectEqDeviceStatusByStatusId(status.getStatusId());
            if (loaded != null) {
                return loaded;
            }
        }
        EqDeviceStatus latest = eqDeviceStatusMapper.selectLatestByDeviceId(status.getDeviceId());
        if (latest != null) {
            return latest;
        }
        return status;
    }

    /**
     * 规则触发后一次性写回运行状态与需维护标记（避免多次 update）
     */
    private void applyRunningStateFromTrigger(EqDeviceStatus data, RuleTriggerResult trigger) {
        if (data.getStatusId() == null || trigger == null) {
            return;
        }

        boolean elevateStatus = trigger.getTargetRunningStatus() > trigger.getBaselineRunningStatus();
        boolean markMaintenance = trigger.isNeedMaintenance()
            && (data.getMaintenanceRequired() == null
            || data.getMaintenanceRequired() == EquipmentRuleConstants.MAINTENANCE_NO);

        if (!elevateStatus && !markMaintenance) {
            return;
        }

        EqDeviceStatus patch = new EqDeviceStatus();
        patch.setStatusId(data.getStatusId());
        if (elevateStatus) {
            patch.setStatus(trigger.getTargetRunningStatus());
        }
        if (markMaintenance) {
            patch.setMaintenanceRequired(EquipmentRuleConstants.MAINTENANCE_YES);
        }
        eqDeviceStatusMapper.updateEqDeviceStatus(patch);

        if (log.isDebugEnabled()) {
            log.debug("规则评估已同步状态 statusId={} elevateStatus={} markMaintenance={} rulesHit={} alertsInserted={}",
                data.getStatusId(), elevateStatus, markMaintenance, trigger.getRulesHit(), trigger.getAlertsInserted());
        }
    }
}
