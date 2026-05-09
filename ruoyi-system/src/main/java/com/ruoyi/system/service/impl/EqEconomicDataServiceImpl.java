package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.EqEconomicDataMapper;
import com.ruoyi.system.domain.EqEconomicData;
import com.ruoyi.system.service.IEqEconomicDataService;

/**
 * 经济数据Service业务层处理
 *
 * @author wangchangzhen
 * @date 2026-01-07
 */
@Service
public class EqEconomicDataServiceImpl implements IEqEconomicDataService
{
    @Autowired
    private EqEconomicDataMapper eqEconomicDataMapper;

    /**
     * 查询经济数据列表
     *
     * @param eqEconomicData 经济数据
     * @return 经济数据集合
     */
    @Override
    public List<EqEconomicData> selectEqEconomicDataList(EqEconomicData eqEconomicData)
    {
        return eqEconomicDataMapper.selectEqEconomicDataList(eqEconomicData);
    }

    /**
     * 根据经济数据ID查询经济数据
     *
     * @param economicId 经济数据ID
     * @return 经济数据
     */
    @Override
    public EqEconomicData selectEqEconomicDataByEconomicId(Long economicId)
    {
        return eqEconomicDataMapper.selectEqEconomicDataByEconomicId(economicId);
    }

    /**
     * 根据设备ID查询经济数据列表
     *
     * @param deviceId 设备ID
     * @return 经济数据集合
     */
    @Override
    public List<EqEconomicData> selectEqEconomicDataListByDeviceId(String deviceId)
    {
        return eqEconomicDataMapper.selectEqEconomicDataListByDeviceId(deviceId);
    }

    /**
     * 新增经济数据
     *
     * @param eqEconomicData 经济数据
     * @return 结果
     */
    @Override
    public int insertEqEconomicData(EqEconomicData eqEconomicData)
    {
        return eqEconomicDataMapper.insertEqEconomicData(eqEconomicData);
    }

    /**
     * 修改经济数据
     *
     * @param eqEconomicData 经济数据
     * @return 结果
     */
    @Override
    public int updateEqEconomicData(EqEconomicData eqEconomicData)
    {
        return eqEconomicDataMapper.updateEqEconomicData(eqEconomicData);
    }

    /**
     * 批量删除经济数据
     *
     * @param economicIds 需要删除的经济数据主键
     * @return 结果
     */
    @Override
    public int deleteEqEconomicDataByEconomicIds(Long[] economicIds)
    {
        return eqEconomicDataMapper.deleteEqEconomicDataByEconomicIds(economicIds);
    }

    /**
     * 删除经济数据信息
     *
     * @param economicId 经济数据主键
     * @return 结果
     */
    @Override
    public int deleteEqEconomicDataByEconomicId(Long economicId)
    {
        return eqEconomicDataMapper.deleteEqEconomicDataByEconomicId(economicId);
    }

    /**
     * 根据设备ID删除经济数据
     *
     * @param deviceId 设备ID
     * @return 结果
     */
    @Override
    public int deleteEqEconomicDataByDeviceId(String deviceId)
    {
        return eqEconomicDataMapper.deleteEqEconomicDataByDeviceId(deviceId);
    }

    /**
     * 批量根据设备ID删除经济数据
     *
     * @param deviceIds 设备ID数组
     * @return 结果
     */
    @Override
    public int deleteEqEconomicDataByDeviceIds(String[] deviceIds)
    {
        return eqEconomicDataMapper.deleteEqEconomicDataByDeviceIds(deviceIds);
    }
}
