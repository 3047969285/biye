package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.EqElectricalDataMapper;
import com.ruoyi.system.domain.EqElectricalData;
import com.ruoyi.system.service.IEqElectricalDataService;

/**
 * 电气数据Service业务层处理
 *
 * @author wangchangzhen
 * @date 2026-01-07
 */
@Service
public class EqElectricalDataServiceImpl implements IEqElectricalDataService
{
    @Autowired
    private EqElectricalDataMapper eqElectricalDataMapper;

    /**
     * 查询电气数据列表
     *
     * @param eqElectricalData 电气数据
     * @return 电气数据集合
     */
    @Override
    public List<EqElectricalData> selectEqElectricalDataList(EqElectricalData eqElectricalData)
    {
        return eqElectricalDataMapper.selectEqElectricalDataList(eqElectricalData);
    }

    /**
     * 根据电气数据ID查询电气数据
     *
     * @param electricalId 电气数据ID
     * @return 电气数据
     */
    @Override
    public EqElectricalData selectEqElectricalDataByElectricalId(Long electricalId)
    {
        return eqElectricalDataMapper.selectEqElectricalDataByElectricalId(electricalId);
    }

    /**
     * 根据设备ID查询电气数据列表
     *
     * @param deviceId 设备ID
     * @return 电气数据集合
     */
    @Override
    public List<EqElectricalData> selectEqElectricalDataListByDeviceId(String deviceId)
    {
        return eqElectricalDataMapper.selectEqElectricalDataListByDeviceId(deviceId);
    }

    /**
     * 新增电气数据
     *
     * @param eqElectricalData 电气数据
     * @return 结果
     */
    @Override
    public int insertEqElectricalData(EqElectricalData eqElectricalData)
    {
        return eqElectricalDataMapper.insertEqElectricalData(eqElectricalData);
    }

    /**
     * 修改电气数据
     *
     * @param eqElectricalData 电气数据
     * @return 结果
     */
    @Override
    public int updateEqElectricalData(EqElectricalData eqElectricalData)
    {
        return eqElectricalDataMapper.updateEqElectricalData(eqElectricalData);
    }

    /**
     * 批量删除电气数据
     *
     * @param electricalIds 需要删除的电气数据主键
     * @return 结果
     */
    @Override
    public int deleteEqElectricalDataByElectricalIds(Long[] electricalIds)
    {
        return eqElectricalDataMapper.deleteEqElectricalDataByElectricalIds(electricalIds);
    }

    /**
     * 删除电气数据信息
     *
     * @param electricalId 电气数据主键
     * @return 结果
     */
    @Override
    public int deleteEqElectricalDataByElectricalId(Long electricalId)
    {
        return eqElectricalDataMapper.deleteEqElectricalDataByElectricalId(electricalId);
    }

    /**
     * 根据设备ID删除电气数据
     *
     * @param deviceId 设备ID
     * @return 结果
     */
    @Override
    public int deleteEqElectricalDataByDeviceId(String deviceId)
    {
        return eqElectricalDataMapper.deleteEqElectricalDataByDeviceId(deviceId);
    }

    /**
     * 批量根据设备ID删除电气数据
     *
     * @param deviceIds 设备ID数组
     * @return 结果
     */
    @Override
    public int deleteEqElectricalDataByDeviceIds(String[] deviceIds)
    {
        return eqElectricalDataMapper.deleteEqElectricalDataByDeviceIds(deviceIds);
    }
}
