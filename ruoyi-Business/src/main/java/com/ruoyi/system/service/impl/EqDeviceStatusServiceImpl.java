package com.ruoyi.system.service.impl;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.ruoyi.system.domain.EqDeviceStatus;
import com.ruoyi.system.mapper.EqDeviceStatusMapper;
import com.ruoyi.system.service.IEqDeviceRuleEvaluationService;
import com.ruoyi.system.service.IEqDeviceStatusService;

/**
 * 设备状态Service业务层处理
 *
 * @author wangchangzhen
 * @date 2026-01-07
 */
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

    /**
     * 根据状态记录ID查询设备状态
     *
     * @param statusId 状态记录ID
     * @return 设备状态
     */
    @Override
    public EqDeviceStatus selectEqDeviceStatusByStatusId(Long statusId) {
        return eqDeviceStatusMapper.selectEqDeviceStatusByStatusId(statusId);
    }

    /**
     * 查询设备状态列表
     *
     * @param eqDeviceStatus 设备状态
     * @return 设备状态集合
     */
    @Override
    public List<EqDeviceStatus> selectEqDeviceStatusList(EqDeviceStatus eqDeviceStatus) {
        return eqDeviceStatusMapper.selectEqDeviceStatusList(eqDeviceStatus);
    }

    /**
     * 新增设备状态（成功后异步触发规则评估）
     *
     * @param eqDeviceStatus 设备状态
     * @return 结果
     */
    @Override
    public int insertEqDeviceStatus(EqDeviceStatus eqDeviceStatus) {
        int rows = eqDeviceStatusMapper.insertEqDeviceStatus(eqDeviceStatus);
        if (rows > 0) {
            runRuleEvaluation(eqDeviceStatus);
        }
        return rows;
    }

    /**
     * 修改设备状态（成功后异步触发规则评估）
     *
     * @param eqDeviceStatus 设备状态
     * @return 结果
     */
    @Override
    public int updateEqDeviceStatus(EqDeviceStatus eqDeviceStatus) {
        int rows = eqDeviceStatusMapper.updateEqDeviceStatus(eqDeviceStatus);
        if (rows > 0) {
            runRuleEvaluation(eqDeviceStatus);
        }
        return rows;
    }

    /**
     * 按设备ID重新评估最新状态对应的规则
     *
     * @param deviceId 设备ID
     */
    @Override
    public void reevaluateRulesByDeviceId(String deviceId) {
        eqDeviceRuleEvaluationService.evaluateLatestStatusForDevice(deviceId);
    }

    /**
     * 批量删除设备状态
     *
     * @param statusIds 需要删除的设备状态主键集合
     * @return 结果
     */
    @Override
    public int deleteEqDeviceStatusByStatusIds(Long[] statusIds) {
        return eqDeviceStatusMapper.deleteEqDeviceStatusByStatusIds(statusIds);
    }

    /**
     * 删除设备状态信息
     *
     * @param statusId 设备状态主键
     * @return 结果
     */
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
