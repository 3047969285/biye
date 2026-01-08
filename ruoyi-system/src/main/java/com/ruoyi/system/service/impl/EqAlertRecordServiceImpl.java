package com.ruoyi.system.service.impl;

import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.system.domain.EqAlertRecord;
import com.ruoyi.system.mapper.EqAlertRecordMapper;
import com.ruoyi.system.service.IEqAlertRecordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 告警记录 Service业务层处理
 *
 * @author wcz
 * @date 2025-12-19
 */
@Service
public class EqAlertRecordServiceImpl implements IEqAlertRecordService {

    @Autowired
    private EqAlertRecordMapper eqAlertRecordMapper;

    /**
     * 查询告警记录列表
     *
     * @param eqAlertRecord 告警记录
     * @return 告警记录
     */
    @Override
    public List<EqAlertRecord> selectEqAlertRecordList(EqAlertRecord eqAlertRecord) {
        return eqAlertRecordMapper.selectEqAlertRecordList(eqAlertRecord);
    }

    /**
     * 查询告警记录
     *
     * @param alertId 告警记录主键
     * @return 告警记录
     */
    @Override
    public EqAlertRecord selectEqAlertRecordByAlertId(Long alertId) {
        return eqAlertRecordMapper.selectEqAlertRecordByAlertId(alertId);
    }

    /**
     * 根据设备ID查询告警记录列表
     *
     * @param deviceId 设备ID
     * @return 告警记录集合
     */
    @Override
    public List<EqAlertRecord> selectEqAlertRecordListByDeviceId(Long deviceId) {
        return eqAlertRecordMapper.selectEqAlertRecordListByDeviceId(deviceId);
    }

    /**
     * 新增告警记录
     *
     * @param eqAlertRecord 告警记录
     * @return 结果
     */
    @Override
    public int insertEqAlertRecord(EqAlertRecord eqAlertRecord) {
        eqAlertRecord.setCreateTime(DateUtils.getNowDate());
        eqAlertRecord.setCreateBy(SecurityUtils.getUsername());
        if (eqAlertRecord.getTriggeredTime() == null) {
            eqAlertRecord.setTriggeredTime(DateUtils.getNowDate());
        }
        return eqAlertRecordMapper.insertEqAlertRecord(eqAlertRecord);
    }

    /**
     * 修改告警记录
     *
     * @param eqAlertRecord 告警记录
     * @return 结果
     */
    @Override
    public int updateEqAlertRecord(EqAlertRecord eqAlertRecord) {
        eqAlertRecord.setUpdateTime(DateUtils.getNowDate());
        eqAlertRecord.setUpdateBy(SecurityUtils.getUsername());
        return eqAlertRecordMapper.updateEqAlertRecord(eqAlertRecord);
    }

    /**
     * 批量删除告警记录
     *
     * @param alertIds 需要删除的告警记录主键
     * @return 结果
     */
    @Override
    public int deleteEqAlertRecordByAlertIds(Long[] alertIds) {
        return eqAlertRecordMapper.deleteEqAlertRecordByAlertIds(alertIds);
    }

    /**
     * 删除告警记录信息
     *
     * @param alertId 告警记录主键
     * @return 结果
     */
    @Override
    public int deleteEqAlertRecordByAlertId(Long alertId) {
        return eqAlertRecordMapper.deleteEqAlertRecordByAlertId(alertId);
    }
}
