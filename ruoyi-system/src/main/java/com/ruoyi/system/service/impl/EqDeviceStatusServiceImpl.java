package com.ruoyi.system.service.impl;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.ruoyi.system.domain.EqDeviceStatus;
import com.ruoyi.system.mapper.EqDeviceStatusMapper;
import com.ruoyi.system.service.IEqDeviceRuleEvaluationService;
import com.ruoyi.system.service.IEqDeviceStatusService;

@Service
public class EqDeviceStatusServiceImpl implements IEqDeviceStatusService {

    private static final Logger log = LoggerFactory.getLogger(EqDeviceStatusServiceImpl.class);

    private final EqDeviceStatusMapper eqDeviceStatusMapper;
    private final IEqDeviceRuleEvaluationService eqDeviceRuleEvaluationService;

    public EqDeviceStatusServiceImpl(EqDeviceStatusMapper eqDeviceStatusMapper,
                                     IEqDeviceRuleEvaluationService eqDeviceRuleEvaluationService) {
        this.eqDeviceStatusMapper = eqDeviceStatusMapper;
        this.eqDeviceRuleEvaluationService = eqDeviceRuleEvaluationService;
    }

    @Override
    public EqDeviceStatus selectEqDeviceStatusByStatusId(Long statusId) {
        return eqDeviceStatusMapper.selectEqDeviceStatusByStatusId(statusId);
    }

    @Override
    public List<EqDeviceStatus> selectEqDeviceStatusList(EqDeviceStatus eqDeviceStatus) {
        return eqDeviceStatusMapper.selectEqDeviceStatusList(eqDeviceStatus);
    }

    @Override
    public int insertEqDeviceStatus(EqDeviceStatus eqDeviceStatus) {
        int rows = eqDeviceStatusMapper.insertEqDeviceStatus(eqDeviceStatus);
        if (rows > 0) {
            runRuleEvaluation(eqDeviceStatus);
        }
        return rows;
    }

    @Override
    public int updateEqDeviceStatus(EqDeviceStatus eqDeviceStatus) {
        int rows = eqDeviceStatusMapper.updateEqDeviceStatus(eqDeviceStatus);
        if (rows > 0) {
            runRuleEvaluation(eqDeviceStatus);
        }
        return rows;
    }

    @Override
    public void reevaluateRulesByDeviceId(Long deviceId) {
        eqDeviceRuleEvaluationService.evaluateLatestStatusForDevice(deviceId);
    }

    @Override
    public int deleteEqDeviceStatusByStatusIds(Long[] statusIds) {
        return eqDeviceStatusMapper.deleteEqDeviceStatusByStatusIds(statusIds);
    }

    @Override
    public int deleteEqDeviceStatusByStatusId(Long statusId) {
        return eqDeviceStatusMapper.deleteEqDeviceStatusByStatusId(statusId);
    }

    private void runRuleEvaluation(EqDeviceStatus eqDeviceStatus) {
        try {
            eqDeviceRuleEvaluationService.evaluateAfterStatusChange(eqDeviceStatus);
        } catch (Exception e) {
            log.warn("设备规则评估失败 deviceId={}: {}", eqDeviceStatus.getDeviceId(), e.getMessage());
        }
    }
}
