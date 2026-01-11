package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.EqEnvironmentData;

/**
 * 环境数据Service接口
 * 
 * @author ruoyi
 * @date 2026-01-08
 */
public interface IEqEnvironmentDataService 
{
    /**
     * 查询环境数据列表
     * 
     * @param eqEnvironmentData 环境数据
     * @return 环境数据集合
     */
    public List<EqEnvironmentData> selectEqEnvironmentDataList(EqEnvironmentData eqEnvironmentData);

    /**
     * 根据环境数据ID查询环境数据
     * 
     * @param envId 环境数据ID
     * @return 环境数据
     */
    public EqEnvironmentData selectEqEnvironmentDataByEnvId(Long envId);

    /**
     * 根据设备ID查询环境数据列表
     * 
     * @param deviceId 设备ID
     * @return 环境数据集合
     */
    public List<EqEnvironmentData> selectEqEnvironmentDataListByDeviceId(Long deviceId);

    /**
     * 新增环境数据
     * 
     * @param eqEnvironmentData 环境数据
     * @return 结果
     */
    public int insertEqEnvironmentData(EqEnvironmentData eqEnvironmentData);

    /**
     * 修改环境数据
     * 
     * @param eqEnvironmentData 环境数据
     * @return 结果
     */
    public int updateEqEnvironmentData(EqEnvironmentData eqEnvironmentData);

    /**
     * 批量删除环境数据
     * 
     * @param envIds 需要删除的环境数据主键集合
     * @return 结果
     */
    public int deleteEqEnvironmentDataByEnvIds(Long[] envIds);

    /**
     * 删除环境数据信息
     * 
     * @param envId 环境数据主键
     * @return 结果
     */
    public int deleteEqEnvironmentDataByEnvId(Long envId);

    /**
     * 根据设备ID删除环境数据
     * 
     * @param deviceId 设备ID
     * @return 结果
     */
    public int deleteEqEnvironmentDataByDeviceId(Long deviceId);

    /**
     * 批量根据设备ID删除环境数据
     * 
     * @param deviceIds 设备ID数组
     * @return 结果
     */
    public int deleteEqEnvironmentDataByDeviceIds(Long[] deviceIds);
}
