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
 * 设备规则评估Service业务层处理
 *
 * @author wangchangzhen
 * @date 2026-01-07
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

    /**
     * 设备状态变更后触发规则评估并回写运行状态等字段
     *
     * @param status 设备状态
     */
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
        if (data.getStatusId() != null) {
            applyRunningStateFromTrigger(data, trigger);
        }
    }

    /**
     * 按设备ID加载最新状态快照并执行规则评估
     *
     * @param deviceId 设备ID
     */
    @Override
    public void evaluateLatestStatusForDevice(String deviceId) {
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

    /**
     * 解析用于规则计算的状态快照
     *
     * @param status 输入状态对象
     * @return 优先返回持久化快照，其次返回设备最新状态，兜底返回原对象
     */
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
     * 将规则触发结果回写到设备状态
     *
     * @param data 状态快照
     * @param trigger 规则触发结果
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
