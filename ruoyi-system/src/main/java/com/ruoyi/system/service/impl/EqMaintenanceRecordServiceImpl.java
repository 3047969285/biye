package com.ruoyi.system.service.impl;

import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.system.domain.EqMaintenanceRecord;
import com.ruoyi.system.mapper.EqMaintenanceRecordMapper;
import com.ruoyi.system.service.IEqMaintenanceRecordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 维护记录 Service业务层处理
 *
 * @author ruoyi
 * @date 2026-01-07
 */
@Service
public class EqMaintenanceRecordServiceImpl implements IEqMaintenanceRecordService {

    @Autowired
    private EqMaintenanceRecordMapper eqMaintenanceRecordMapper;

    /**
     * 查询维护记录列表
     *
     * @param eqMaintenanceRecord 维护记录
     * @return 维护记录
     */
    @Override
    public List<EqMaintenanceRecord> selectEqMaintenanceRecordList(EqMaintenanceRecord eqMaintenanceRecord) {
        return eqMaintenanceRecordMapper.selectEqMaintenanceRecordList(eqMaintenanceRecord);
    }

    /**
     * 查询维护记录
     *
     * @param recordId 维护记录主键
     * @return 维护记录
     */
    @Override
    public EqMaintenanceRecord selectEqMaintenanceRecordByRecordId(Long recordId) {
        return eqMaintenanceRecordMapper.selectEqMaintenanceRecordByRecordId(recordId);
    }

    /**
     * 根据设备ID查询维护记录列表
     *
     * @param deviceId 设备ID
     * @return 维护记录集合
     */
    @Override
    public List<EqMaintenanceRecord> selectEqMaintenanceRecordListByDeviceId(Long deviceId) {
        return eqMaintenanceRecordMapper.selectEqMaintenanceRecordListByDeviceId(deviceId);
    }

    /**
     * 新增维护记录
     *
     * @param eqMaintenanceRecord 维护记录
     * @return 结果
     */
    @Override
    public int insertEqMaintenanceRecord(EqMaintenanceRecord eqMaintenanceRecord) {
        eqMaintenanceRecord.setCreateTime(DateUtils.getNowDate());
        eqMaintenanceRecord.setCreateBy(SecurityUtils.getUsername());
        return eqMaintenanceRecordMapper.insertEqMaintenanceRecord(eqMaintenanceRecord);
    }

    /**
     * 修改维护记录
     *
     * @param eqMaintenanceRecord 维护记录
     * @return 结果
     */
    @Override
    public int updateEqMaintenanceRecord(EqMaintenanceRecord eqMaintenanceRecord) {
        eqMaintenanceRecord.setUpdateTime(DateUtils.getNowDate());
        eqMaintenanceRecord.setUpdateBy(SecurityUtils.getUsername());
        return eqMaintenanceRecordMapper.updateEqMaintenanceRecord(eqMaintenanceRecord);
    }

    /**
     * 批量删除维护记录
     *
     * @param recordIds 需要删除的维护记录主键
     * @return 结果
     */
    @Override
    public int deleteEqMaintenanceRecordByRecordIds(Long[] recordIds) {
        return eqMaintenanceRecordMapper.deleteEqMaintenanceRecordByRecordIds(recordIds);
    }

    /**
     * 删除维护记录信息
     *
     * @param recordId 维护记录主键
     * @return 结果
     */
    @Override
    public int deleteEqMaintenanceRecordByRecordId(Long recordId) {
        return eqMaintenanceRecordMapper.deleteEqMaintenanceRecordByRecordId(recordId);
    }
}
