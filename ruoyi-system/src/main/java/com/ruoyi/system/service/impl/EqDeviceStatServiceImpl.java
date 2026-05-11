package com.ruoyi.system.service.impl;

import java.util.Collections;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.EqDeviceStat;
import com.ruoyi.system.mapper.EqDeviceStatMapper;
import com.ruoyi.system.service.IEqDeviceStatService;

/**
 * 设备统计Service业务层处理
 *
 * @author wangchangzhen
 * @date 2026-01-07
 */
@Service
public class EqDeviceStatServiceImpl implements IEqDeviceStatService
{
    @Autowired
    private EqDeviceStatMapper eqDeviceStatMapper;

    /**
     * 查询设备统计列表
     *
     * @param eqDeviceStat 设备统计
     * @return 设备统计集合
     */
    @Override
    public List<EqDeviceStat> selectEqDeviceStatList(EqDeviceStat eqDeviceStat)
    {
        return eqDeviceStatMapper.selectEqDeviceStatList(eqDeviceStat);
    }

    /**
     * 根据统计记录ID查询设备统计
     *
     * @param statId 统计记录ID
     * @return 设备统计
     */
    @Override
    public EqDeviceStat selectEqDeviceStatByStatId(Long statId)
    {
        return eqDeviceStatMapper.selectEqDeviceStatByStatId(statId);
    }

    /**
     * 根据设备ID查询设备统计列表
     *
     * @param deviceId 设备ID
     * @return 设备统计集合
     */
    @Override
    public List<EqDeviceStat> selectEqDeviceStatListByDeviceId(String deviceId)
    {
        return eqDeviceStatMapper.selectEqDeviceStatListByDeviceId(deviceId);
    }

    @Override
    public EqDeviceStat selectComputedAggregateByDeviceId(String deviceId)
    {
        if (StringUtils.isEmpty(deviceId))
        {
            return null;
        }
        return eqDeviceStatMapper.selectComputedAggregateByDeviceId(deviceId.trim());
    }

    /**
     * 新增设备统计
     *
     * @param eqDeviceStat 设备统计
     * @return 结果
     */
    @Override
    public int insertEqDeviceStat(EqDeviceStat eqDeviceStat)
    {
        return eqDeviceStatMapper.insertEqDeviceStat(eqDeviceStat);
    }

    /**
     * 修改设备统计
     *
     * @param eqDeviceStat 设备统计
     * @return 结果
     */
    @Override
    public int updateEqDeviceStat(EqDeviceStat eqDeviceStat)
    {
        return eqDeviceStatMapper.updateEqDeviceStat(eqDeviceStat);
    }

    /**
     * 批量删除设备统计
     *
     * @param statIds 需要删除的设备统计主键
     * @return 结果
     */
    @Override
    public int deleteEqDeviceStatByStatIds(Long[] statIds)
    {
        return eqDeviceStatMapper.deleteEqDeviceStatByStatIds(statIds);
    }

    /**
     * 删除设备统计信息
     *
     * @param statId 设备统计主键
     * @return 结果
     */
    @Override
    public int deleteEqDeviceStatByStatId(Long statId)
    {
        return eqDeviceStatMapper.deleteEqDeviceStatByStatId(statId);
    }

    /**
     * 根据设备ID删除设备统计
     *
     * @param deviceId 设备ID
     * @return 结果
     */
    @Override
    public int deleteEqDeviceStatByDeviceId(String deviceId)
    {
        return eqDeviceStatMapper.deleteEqDeviceStatByDeviceId(deviceId);
    }

    /**
     * 批量根据设备ID删除设备统计
     *
     * @param deviceIds 设备ID数组
     * @return 结果
     */
    @Override
    public int deleteEqDeviceStatByDeviceIds(String[] deviceIds)
    {
        return eqDeviceStatMapper.deleteEqDeviceStatByDeviceIds(deviceIds);
    }

    @Override
    public List<EqDeviceStat> selectListOrComputedSummary(EqDeviceStat eqDeviceStat)
    {
        if (Boolean.TRUE.equals(eqDeviceStat.getComputedSummary())
            && StringUtils.isNotEmpty(eqDeviceStat.getDeviceId()))
        {
            EqDeviceStat row = selectComputedAggregateByDeviceId(eqDeviceStat.getDeviceId());
            return row != null ? Collections.singletonList(row) : Collections.emptyList();
        }
        return selectEqDeviceStatList(eqDeviceStat);
    }
}
