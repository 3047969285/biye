package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.EqTechnologyData;

/**
 * 技术数据Service接口
 *
 * @author wangchangzhen
 * @date 2026-01-07
 */
public interface IEqTechnologyDataService
{
    /**
     * 查询技术数据列表
     *
     * @param eqTechnologyData 技术数据
     * @return 技术数据集合
     */
    public List<EqTechnologyData> selectEqTechnologyDataList(EqTechnologyData eqTechnologyData);

    /**
     * 根据技术数据ID查询技术数据
     *
     * @param techId 技术数据ID
     * @return 技术数据
     */
    public EqTechnologyData selectEqTechnologyDataByTechId(Long techId);

    /**
     * 根据设备ID查询技术数据列表
     *
     * @param deviceId 设备ID
     * @return 技术数据集合
     */
    public List<EqTechnologyData> selectEqTechnologyDataListByDeviceId(String deviceId);

    /**
     * 新增技术数据
     *
     * @param eqTechnologyData 技术数据
     * @return 结果
     */
    public int insertEqTechnologyData(EqTechnologyData eqTechnologyData);

    /**
     * 修改技术数据
     *
     * @param eqTechnologyData 技术数据
     * @return 结果
     */
    public int updateEqTechnologyData(EqTechnologyData eqTechnologyData);

    /**
     * 批量删除技术数据
     *
     * @param techIds 需要删除的技术数据主键集合
     * @return 结果
     */
    public int deleteEqTechnologyDataByTechIds(Long[] techIds);

    /**
     * 删除技术数据信息
     *
     * @param techId 技术数据主键
     * @return 结果
     */
    public int deleteEqTechnologyDataByTechId(Long techId);

    /**
     * 根据设备ID删除技术数据
     *
     * @param deviceId 设备ID
     * @return 结果
     */
    public int deleteEqTechnologyDataByDeviceId(String deviceId);

    /**
     * 批量根据设备ID删除技术数据
     *
     * @param deviceIds 设备ID数组
     * @return 结果
     */
    public int deleteEqTechnologyDataByDeviceIds(String[] deviceIds);
}
