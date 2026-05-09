package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.EqFaultRecordMapper;
import com.ruoyi.system.domain.EqFaultRecord;
import com.ruoyi.system.service.IEqFaultRecordService;

/**
 * 故障记录Service业务层处理
 *
 * @author wangchangzhen
 * @date 2026-01-07
 */
@Service
public class EqFaultRecordServiceImpl implements IEqFaultRecordService
{
    @Autowired
    private EqFaultRecordMapper eqFaultRecordMapper;

    /**
     * 查询故障记录列表
     *
     * @param eqFaultRecord 故障记录
     * @return 故障记录集合
     */
    @Override
    public List<EqFaultRecord> selectEqFaultRecordList(EqFaultRecord eqFaultRecord)
    {
        return eqFaultRecordMapper.selectEqFaultRecordList(eqFaultRecord);
    }

    /**
     * 根据故障记录ID查询故障记录
     *
     * @param faultId 故障记录ID
     * @return 故障记录
     */
    @Override
    public EqFaultRecord selectEqFaultRecordByFaultId(Long faultId)
    {
        return eqFaultRecordMapper.selectEqFaultRecordByFaultId(faultId);
    }

    /**
     * 根据设备ID查询故障记录列表
     *
     * @param deviceId 设备ID
     * @return 故障记录集合
     */
    @Override
    public List<EqFaultRecord> selectEqFaultRecordListByDeviceId(String deviceId)
    {
        return eqFaultRecordMapper.selectEqFaultRecordListByDeviceId(deviceId);
    }

    /**
     * 新增故障记录
     *
     * @param eqFaultRecord 故障记录
     * @return 结果
     */
    @Override
    public int insertEqFaultRecord(EqFaultRecord eqFaultRecord)
    {
        return eqFaultRecordMapper.insertEqFaultRecord(eqFaultRecord);
    }

    /**
     * 修改故障记录
     *
     * @param eqFaultRecord 故障记录
     * @return 结果
     */
    @Override
    public int updateEqFaultRecord(EqFaultRecord eqFaultRecord)
    {
        return eqFaultRecordMapper.updateEqFaultRecord(eqFaultRecord);
    }

    /**
     * 批量删除故障记录
     *
     * @param faultIds 需要删除的故障记录主键
     * @return 结果
     */
    @Override
    public int deleteEqFaultRecordByFaultIds(Long[] faultIds)
    {
        return eqFaultRecordMapper.deleteEqFaultRecordByFaultIds(faultIds);
    }

    /**
     * 删除故障记录信息
     *
     * @param faultId 故障记录主键
     * @return 结果
     */
    @Override
    public int deleteEqFaultRecordByFaultId(Long faultId)
    {
        return eqFaultRecordMapper.deleteEqFaultRecordByFaultId(faultId);
    }

    /**
     * 根据设备ID删除故障记录
     *
     * @param deviceId 设备ID
     * @return 结果
     */
    @Override
    public int deleteEqFaultRecordByDeviceId(String deviceId)
    {
        return eqFaultRecordMapper.deleteEqFaultRecordByDeviceId(deviceId);
    }

    /**
     * 批量根据设备ID删除故障记录
     *
     * @param deviceIds 设备ID数组
     * @return 结果
     */
    @Override
    public int deleteEqFaultRecordByDeviceIds(String[] deviceIds)
    {
        return eqFaultRecordMapper.deleteEqFaultRecordByDeviceIds(deviceIds);
    }
}
