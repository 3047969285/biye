package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.EqMaintenanceRecordMapper;
import com.ruoyi.system.domain.EqMaintenanceRecord;
import com.ruoyi.system.service.IEqMaintenanceRecordService;

/**
 * 维保记录Service业务层处理
 *
 * @author wangchangzhen
 * @date 2026-01-07
 */
@Service
public class EqMaintenanceRecordServiceImpl implements IEqMaintenanceRecordService
{
    @Autowired
    private EqMaintenanceRecordMapper eqMaintenanceRecordMapper;

    /**
     * 查询维保记录列表
     *
     * @param eqMaintenanceRecord 维保记录
     * @return 维保记录集合
     */
    @Override
    public List<EqMaintenanceRecord> selectEqMaintenanceRecordList(EqMaintenanceRecord eqMaintenanceRecord)
    {
        return eqMaintenanceRecordMapper.selectEqMaintenanceRecordList(eqMaintenanceRecord);
    }

    /**
     * 根据维保记录ID查询维保记录
     *
     * @param recordId 维保记录ID
     * @return 维保记录
     */
    @Override
    public EqMaintenanceRecord selectEqMaintenanceRecordByRecordId(Long recordId)
    {
        return eqMaintenanceRecordMapper.selectEqMaintenanceRecordByRecordId(recordId);
    }

    /**
     * 根据设备ID查询维保记录列表
     *
     * @param deviceId 设备ID
     * @return 维保记录集合
     */
    @Override
    public List<EqMaintenanceRecord> selectEqMaintenanceRecordListByDeviceId(String deviceId)
    {
        return eqMaintenanceRecordMapper.selectEqMaintenanceRecordListByDeviceId(deviceId);
    }

    /**
     * 新增维保记录
     *
     * @param eqMaintenanceRecord 维保记录
     * @return 结果
     */
    @Override
    public int insertEqMaintenanceRecord(EqMaintenanceRecord eqMaintenanceRecord)
    {
        return eqMaintenanceRecordMapper.insertEqMaintenanceRecord(eqMaintenanceRecord);
    }

    /**
     * 修改维保记录
     *
     * @param eqMaintenanceRecord 维保记录
     * @return 结果
     */
    @Override
    public int updateEqMaintenanceRecord(EqMaintenanceRecord eqMaintenanceRecord)
    {
        return eqMaintenanceRecordMapper.updateEqMaintenanceRecord(eqMaintenanceRecord);
    }

    /**
     * 批量删除维保记录
     *
     * @param recordIds 需要删除的维保记录主键
     * @return 结果
     */
    @Override
    public int deleteEqMaintenanceRecordByRecordIds(Long[] recordIds)
    {
        return eqMaintenanceRecordMapper.deleteEqMaintenanceRecordByRecordIds(recordIds);
    }

    /**
     * 删除维保记录信息
     *
     * @param recordId 维保记录主键
     * @return 结果
     */
    @Override
    public int deleteEqMaintenanceRecordByRecordId(Long recordId)
    {
        return eqMaintenanceRecordMapper.deleteEqMaintenanceRecordByRecordId(recordId);
    }

    /**
     * 根据设备ID删除维保记录
     *
     * @param deviceId 设备ID
     * @return 结果
     */
    @Override
    public int deleteEqMaintenanceRecordByDeviceId(String deviceId)
    {
        return eqMaintenanceRecordMapper.deleteEqMaintenanceRecordByDeviceId(deviceId);
    }

    /**
     * 批量根据设备ID删除维保记录
     *
     * @param deviceIds 设备ID数组
     * @return 结果
     */
    @Override
    public int deleteEqMaintenanceRecordByDeviceIds(String[] deviceIds)
    {
        return eqMaintenanceRecordMapper.deleteEqMaintenanceRecordByDeviceIds(deviceIds);
    }
}
