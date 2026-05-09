package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.EqClimateData;

/**
 * 气象数据Service接口
 *
 * @author wangchangzhen
 * @date 2026-01-07
 */
public interface IEqClimateDataService
{
    /**
     * 查询气象数据列表
     *
     * @param eqClimateData 气象数据
     * @return 气象数据集合
     */
    public List<EqClimateData> selectEqClimateDataList(EqClimateData eqClimateData);

    /**
     * 根据气象数据ID查询气象数据
     *
     * @param climateId 气象数据ID
     * @return 气象数据
     */
    public EqClimateData selectEqClimateDataByClimateId(Long climateId);

    /**
     * 根据设备ID查询气象数据列表
     *
     * @param deviceId 设备ID
     * @return 气象数据集合
     */
    public List<EqClimateData> selectEqClimateDataListByDeviceId(String deviceId);

    /**
     * 新增气象数据
     *
     * @param eqClimateData 气象数据
     * @return 结果
     */
    public int insertEqClimateData(EqClimateData eqClimateData);

    /**
     * 修改气象数据
     *
     * @param eqClimateData 气象数据
     * @return 结果
     */
    public int updateEqClimateData(EqClimateData eqClimateData);

    /**
     * 批量删除气象数据
     *
     * @param climateIds 需要删除的气象数据主键集合
     * @return 结果
     */
    public int deleteEqClimateDataByClimateIds(Long[] climateIds);

    /**
     * 删除气象数据信息
     *
     * @param climateId 气象数据主键
     * @return 结果
     */
    public int deleteEqClimateDataByClimateId(Long climateId);

    /**
     * 根据设备ID删除气象数据
     *
     * @param deviceId 设备ID
     * @return 结果
     */
    public int deleteEqClimateDataByDeviceId(String deviceId);

    /**
     * 批量根据设备ID删除气象数据
     *
     * @param deviceIds 设备ID数组
     * @return 结果
     */
    public int deleteEqClimateDataByDeviceIds(String[] deviceIds);
}
