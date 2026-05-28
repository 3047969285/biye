package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.EqClimateDataMapper;
import com.ruoyi.system.domain.EqClimateData;
import com.ruoyi.system.service.IEqClimateDataService;

/**
 * 气象数据Service业务层处理
 *
 * @author wangchangzhen
 * @date 2026-01-07
 */
@Service
public class EqClimateDataServiceImpl implements IEqClimateDataService
{
    @Autowired
    private EqClimateDataMapper eqClimateDataMapper;

    /**
     * 查询气象数据列表
     *
     * @param eqClimateData 气象数据
     * @return 气象数据集合
     */
    @Override
    public List<EqClimateData> selectEqClimateDataList(EqClimateData eqClimateData)
    {
        return eqClimateDataMapper.selectEqClimateDataList(eqClimateData);
    }

    /**
     * 根据气象数据ID查询气象数据
     *
     * @param climateId 气象数据ID
     * @return 气象数据
     */
    @Override
    public EqClimateData selectEqClimateDataByClimateId(Long climateId)
    {
        return eqClimateDataMapper.selectEqClimateDataByClimateId(climateId);
    }

    /**
     * 根据设备ID查询气象数据列表
     *
     * @param deviceId 设备ID
     * @return 气象数据集合
     */
    @Override
    public List<EqClimateData> selectEqClimateDataListByDeviceId(String deviceId)
    {
        return eqClimateDataMapper.selectEqClimateDataListByDeviceId(deviceId);
    }

    /**
     * 新增气象数据
     *
     * @param eqClimateData 气象数据
     * @return 结果
     */
    @Override
    public int insertEqClimateData(EqClimateData eqClimateData)
    {
        return eqClimateDataMapper.insertEqClimateData(eqClimateData);
    }

    /**
     * 修改气象数据
     *
     * @param eqClimateData 气象数据
     * @return 结果
     */
    @Override
    public int updateEqClimateData(EqClimateData eqClimateData)
    {
        return eqClimateDataMapper.updateEqClimateData(eqClimateData);
    }

    /**
     * 批量删除气象数据
     *
     * @param climateIds 需要删除的气象数据主键
     * @return 结果
     */
    @Override
    public int deleteEqClimateDataByClimateIds(Long[] climateIds)
    {
        return eqClimateDataMapper.deleteEqClimateDataByClimateIds(climateIds);
    }

    /**
     * 删除气象数据信息
     *
     * @param climateId 气象数据主键
     * @return 结果
     */
    @Override
    public int deleteEqClimateDataByClimateId(Long climateId)
    {
        return eqClimateDataMapper.deleteEqClimateDataByClimateId(climateId);
    }

    /**
     * 根据设备ID删除气象数据
     *
     * @param deviceId 设备ID
     * @return 结果
     */
    @Override
    public int deleteEqClimateDataByDeviceId(String deviceId)
    {
        return eqClimateDataMapper.deleteEqClimateDataByDeviceId(deviceId);
    }

    /**
     * 批量根据设备ID删除气象数据
     *
     * @param deviceIds 设备ID数组
     * @return 结果
     */
    @Override
    public int deleteEqClimateDataByDeviceIds(String[] deviceIds)
    {
        return eqClimateDataMapper.deleteEqClimateDataByDeviceIds(deviceIds);
    }
}
