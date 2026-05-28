package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.EqEnvironmentData;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 环境数据Mapper接口
 * 
 * @author wangchangzhen
 * @date 2026-01-08
 */
@Mapper
public interface EqEnvironmentDataMapper 
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
    public EqEnvironmentData selectEqEnvironmentDataByEnvId(@Param("envId") Long envId);

    /**
     * 根据设备ID查询环境数据列表
     * 
     * @param deviceId 设备ID
     * @return 环境数据集合
     */
    public List<EqEnvironmentData> selectEqEnvironmentDataListByDeviceId(@Param("deviceId") String deviceId);

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
     * 删除环境数据
     * 
     * @param envId 环境数据主键
     * @return 结果
     */
    public int deleteEqEnvironmentDataByEnvId(@Param("envId") Long envId);

    /**
     * 批量删除环境数据
     * 
     * @param envIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteEqEnvironmentDataByEnvIds(@Param("envIds") Long[] envIds);

    /**
     * 根据设备ID删除环境数据
     * 
     * @param deviceId 设备ID
     * @return 结果
     */
    public int deleteEqEnvironmentDataByDeviceId(@Param("deviceId") String deviceId);

    /**
     * 批量根据设备ID删除环境数据
     * 
     * @param deviceIds 设备ID数组
     * @return 结果
     */
    public int deleteEqEnvironmentDataByDeviceIds(@Param("deviceIds") String[] deviceIds);
}
