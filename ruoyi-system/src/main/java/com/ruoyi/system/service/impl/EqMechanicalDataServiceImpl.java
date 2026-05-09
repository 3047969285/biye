package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.EqMechanicalDataMapper;
import com.ruoyi.system.domain.EqMechanicalData;
import com.ruoyi.system.service.IEqMechanicalDataService;

/**
 * 机械数据Service业务层处理
 *
 * @author wangchangzhen
 * @date 2026-01-07
 */
@Service
public class EqMechanicalDataServiceImpl implements IEqMechanicalDataService
{
    @Autowired
    private EqMechanicalDataMapper eqMechanicalDataMapper;

    /**
     * 查询机械数据列表
     *
     * @param eqMechanicalData 机械数据
     * @return 机械数据集合
     */
    @Override
    public List<EqMechanicalData> selectEqMechanicalDataList(EqMechanicalData eqMechanicalData)
    {
        return eqMechanicalDataMapper.selectEqMechanicalDataList(eqMechanicalData);
    }

    /**
     * 根据机械数据ID查询机械数据
     *
     * @param mechanicalId 机械数据ID
     * @return 机械数据
     */
    @Override
    public EqMechanicalData selectEqMechanicalDataByMechanicalId(Long mechanicalId)
    {
        return eqMechanicalDataMapper.selectEqMechanicalDataByMechanicalId(mechanicalId);
    }

    /**
     * 根据设备ID查询机械数据列表
     *
     * @param deviceId 设备ID
     * @return 机械数据集合
     */
    @Override
    public List<EqMechanicalData> selectEqMechanicalDataListByDeviceId(String deviceId)
    {
        return eqMechanicalDataMapper.selectEqMechanicalDataListByDeviceId(deviceId);
    }

    /**
     * 新增机械数据
     *
     * @param eqMechanicalData 机械数据
     * @return 结果
     */
    @Override
    public int insertEqMechanicalData(EqMechanicalData eqMechanicalData)
    {
        return eqMechanicalDataMapper.insertEqMechanicalData(eqMechanicalData);
    }

    /**
     * 修改机械数据
     *
     * @param eqMechanicalData 机械数据
     * @return 结果
     */
    @Override
    public int updateEqMechanicalData(EqMechanicalData eqMechanicalData)
    {
        return eqMechanicalDataMapper.updateEqMechanicalData(eqMechanicalData);
    }

    /**
     * 批量删除机械数据
     *
     * @param mechanicalIds 需要删除的机械数据主键
     * @return 结果
     */
    @Override
    public int deleteEqMechanicalDataByMechanicalIds(Long[] mechanicalIds)
    {
        return eqMechanicalDataMapper.deleteEqMechanicalDataByMechanicalIds(mechanicalIds);
    }

    /**
     * 删除机械数据信息
     *
     * @param mechanicalId 机械数据主键
     * @return 结果
     */
    @Override
    public int deleteEqMechanicalDataByMechanicalId(Long mechanicalId)
    {
        return eqMechanicalDataMapper.deleteEqMechanicalDataByMechanicalId(mechanicalId);
    }

    /**
     * 根据设备ID删除机械数据
     *
     * @param deviceId 设备ID
     * @return 结果
     */
    @Override
    public int deleteEqMechanicalDataByDeviceId(String deviceId)
    {
        return eqMechanicalDataMapper.deleteEqMechanicalDataByDeviceId(deviceId);
    }

    /**
     * 批量根据设备ID删除机械数据
     *
     * @param deviceIds 设备ID数组
     * @return 结果
     */
    @Override
    public int deleteEqMechanicalDataByDeviceIds(String[] deviceIds)
    {
        return eqMechanicalDataMapper.deleteEqMechanicalDataByDeviceIds(deviceIds);
    }
}
