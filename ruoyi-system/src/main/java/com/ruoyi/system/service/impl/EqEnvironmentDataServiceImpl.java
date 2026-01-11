package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.EqEnvironmentDataMapper;
import com.ruoyi.system.domain.EqEnvironmentData;
import com.ruoyi.system.service.IEqEnvironmentDataService;

/**
 * 环境数据Service业务层处理
 * 
 * @author ruoyi
 * @date 2026-01-08
 */
@Service
public class EqEnvironmentDataServiceImpl implements IEqEnvironmentDataService 
{
    @Autowired
    private EqEnvironmentDataMapper eqEnvironmentDataMapper;

    /**
     * 查询环境数据列表
     * 
     * @param eqEnvironmentData 环境数据
     * @return 环境数据
     */
    @Override
    public List<EqEnvironmentData> selectEqEnvironmentDataList(EqEnvironmentData eqEnvironmentData)
    {
        return eqEnvironmentDataMapper.selectEqEnvironmentDataList(eqEnvironmentData);
    }

    /**
     * 根据环境数据ID查询环境数据
     * 
     * @param envId 环境数据ID
     * @return 环境数据
     */
    @Override
    public EqEnvironmentData selectEqEnvironmentDataByEnvId(Long envId)
    {
        return eqEnvironmentDataMapper.selectEqEnvironmentDataByEnvId(envId);
    }

    /**
     * 根据设备ID查询环境数据列表
     * 
     * @param deviceId 设备ID
     * @return 环境数据集合
     */
    @Override
    public List<EqEnvironmentData> selectEqEnvironmentDataListByDeviceId(Long deviceId)
    {
        return eqEnvironmentDataMapper.selectEqEnvironmentDataListByDeviceId(deviceId);
    }

    /**
     * 新增环境数据
     * 
     * @param eqEnvironmentData 环境数据
     * @return 结果
     */
    @Override
    public int insertEqEnvironmentData(EqEnvironmentData eqEnvironmentData)
    {
        return eqEnvironmentDataMapper.insertEqEnvironmentData(eqEnvironmentData);
    }

    /**
     * 修改环境数据
     * 
     * @param eqEnvironmentData 环境数据
     * @return 结果
     */
    @Override
    public int updateEqEnvironmentData(EqEnvironmentData eqEnvironmentData)
    {
        return eqEnvironmentDataMapper.updateEqEnvironmentData(eqEnvironmentData);
    }

    /**
     * 批量删除环境数据
     * 
     * @param envIds 需要删除的环境数据主键
     * @return 结果
     */
    @Override
    public int deleteEqEnvironmentDataByEnvIds(Long[] envIds)
    {
        return eqEnvironmentDataMapper.deleteEqEnvironmentDataByEnvIds(envIds);
    }

    /**
     * 删除环境数据信息
     * 
     * @param envId 环境数据主键
     * @return 结果
     */
    @Override
    public int deleteEqEnvironmentDataByEnvId(Long envId)
    {
        return eqEnvironmentDataMapper.deleteEqEnvironmentDataByEnvId(envId);
    }

    /**
     * 根据设备ID删除环境数据
     * 
     * @param deviceId 设备ID
     * @return 结果
     */
    @Override
    public int deleteEqEnvironmentDataByDeviceId(Long deviceId)
    {
        return eqEnvironmentDataMapper.deleteEqEnvironmentDataByDeviceId(deviceId);
    }

    /**
     * 批量根据设备ID删除环境数据
     * 
     * @param deviceIds 设备ID数组
     * @return 结果
     */
    @Override
    public int deleteEqEnvironmentDataByDeviceIds(Long[] deviceIds)
    {
        return eqEnvironmentDataMapper.deleteEqEnvironmentDataByDeviceIds(deviceIds);
    }
}
