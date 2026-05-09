package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.EqTechnologyDataMapper;
import com.ruoyi.system.domain.EqTechnologyData;
import com.ruoyi.system.service.IEqTechnologyDataService;

/**
 * 技术数据Service业务层处理
 *
 * @author wangchangzhen
 * @date 2026-01-07
 */
@Service
public class EqTechnologyDataServiceImpl implements IEqTechnologyDataService
{
    @Autowired
    private EqTechnologyDataMapper eqTechnologyDataMapper;

    /**
     * 查询技术数据列表
     *
     * @param eqTechnologyData 技术数据
     * @return 技术数据集合
     */
    @Override
    public List<EqTechnologyData> selectEqTechnologyDataList(EqTechnologyData eqTechnologyData)
    {
        return eqTechnologyDataMapper.selectEqTechnologyDataList(eqTechnologyData);
    }

    /**
     * 根据技术数据ID查询技术数据
     *
     * @param techId 技术数据ID
     * @return 技术数据
     */
    @Override
    public EqTechnologyData selectEqTechnologyDataByTechId(Long techId)
    {
        return eqTechnologyDataMapper.selectEqTechnologyDataByTechId(techId);
    }

    /**
     * 根据设备ID查询技术数据列表
     *
     * @param deviceId 设备ID
     * @return 技术数据集合
     */
    @Override
    public List<EqTechnologyData> selectEqTechnologyDataListByDeviceId(String deviceId)
    {
        return eqTechnologyDataMapper.selectEqTechnologyDataListByDeviceId(deviceId);
    }

    /**
     * 新增技术数据
     *
     * @param eqTechnologyData 技术数据
     * @return 结果
     */
    @Override
    public int insertEqTechnologyData(EqTechnologyData eqTechnologyData)
    {
        return eqTechnologyDataMapper.insertEqTechnologyData(eqTechnologyData);
    }

    /**
     * 修改技术数据
     *
     * @param eqTechnologyData 技术数据
     * @return 结果
     */
    @Override
    public int updateEqTechnologyData(EqTechnologyData eqTechnologyData)
    {
        return eqTechnologyDataMapper.updateEqTechnologyData(eqTechnologyData);
    }

    /**
     * 批量删除技术数据
     *
     * @param techIds 需要删除的技术数据主键
     * @return 结果
     */
    @Override
    public int deleteEqTechnologyDataByTechIds(Long[] techIds)
    {
        return eqTechnologyDataMapper.deleteEqTechnologyDataByTechIds(techIds);
    }

    /**
     * 删除技术数据信息
     *
     * @param techId 技术数据主键
     * @return 结果
     */
    @Override
    public int deleteEqTechnologyDataByTechId(Long techId)
    {
        return eqTechnologyDataMapper.deleteEqTechnologyDataByTechId(techId);
    }

    /**
     * 根据设备ID删除技术数据
     *
     * @param deviceId 设备ID
     * @return 结果
     */
    @Override
    public int deleteEqTechnologyDataByDeviceId(String deviceId)
    {
        return eqTechnologyDataMapper.deleteEqTechnologyDataByDeviceId(deviceId);
    }

    /**
     * 批量根据设备ID删除技术数据
     *
     * @param deviceIds 设备ID数组
     * @return 结果
     */
    @Override
    public int deleteEqTechnologyDataByDeviceIds(String[] deviceIds)
    {
        return eqTechnologyDataMapper.deleteEqTechnologyDataByDeviceIds(deviceIds);
    }
}
