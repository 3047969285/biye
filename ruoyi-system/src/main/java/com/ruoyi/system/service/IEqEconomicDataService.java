package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.EqEconomicData;

/**
 * 经济数据Service接口
 *
 * @author wangchangzhen
 * @date 2026-01-07
 */
public interface IEqEconomicDataService
{
    /**
     * 查询经济数据列表
     *
     * @param eqEconomicData 经济数据
     * @return 经济数据集合
     */
    public List<EqEconomicData> selectEqEconomicDataList(EqEconomicData eqEconomicData);

    /**
     * 根据经济数据ID查询经济数据
     *
     * @param economicId 经济数据ID
     * @return 经济数据
     */
    public EqEconomicData selectEqEconomicDataByEconomicId(Long economicId);

    /**
     * 根据设备ID查询经济数据列表
     *
     * @param deviceId 设备ID
     * @return 经济数据集合
     */
    public List<EqEconomicData> selectEqEconomicDataListByDeviceId(String deviceId);

    /**
     * 新增经济数据
     *
     * @param eqEconomicData 经济数据
     * @return 结果
     */
    public int insertEqEconomicData(EqEconomicData eqEconomicData);

    /**
     * 修改经济数据
     *
     * @param eqEconomicData 经济数据
     * @return 结果
     */
    public int updateEqEconomicData(EqEconomicData eqEconomicData);

    /**
     * 批量删除经济数据
     *
     * @param economicIds 需要删除的经济数据主键集合
     * @return 结果
     */
    public int deleteEqEconomicDataByEconomicIds(Long[] economicIds);

    /**
     * 删除经济数据信息
     *
     * @param economicId 经济数据主键
     * @return 结果
     */
    public int deleteEqEconomicDataByEconomicId(Long economicId);

    /**
     * 根据设备ID删除经济数据
     *
     * @param deviceId 设备ID
     * @return 结果
     */
    public int deleteEqEconomicDataByDeviceId(String deviceId);

    /**
     * 批量根据设备ID删除经济数据
     *
     * @param deviceIds 设备ID数组
     * @return 结果
     */
    public int deleteEqEconomicDataByDeviceIds(String[] deviceIds);
}
