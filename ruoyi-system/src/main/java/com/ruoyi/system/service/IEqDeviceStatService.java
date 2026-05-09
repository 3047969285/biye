package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.EqDeviceStat;

/**
 * 设备统计Service接口
 *
 * @author wangchangzhen
 * @date 2026-01-07
 */
public interface IEqDeviceStatService
{
    /**
     * 查询设备统计列表
     *
     * @param eqDeviceStat 设备统计
     * @return 设备统计集合
     */
    public List<EqDeviceStat> selectEqDeviceStatList(EqDeviceStat eqDeviceStat);

    /**
     * 根据统计记录ID查询设备统计
     *
     * @param statId 统计记录ID
     * @return 设备统计
     */
    public EqDeviceStat selectEqDeviceStatByStatId(Long statId);

    /**
     * 根据设备ID查询设备统计列表
     *
     * @param deviceId 设备ID
     * @return 设备统计集合
     */
    public List<EqDeviceStat> selectEqDeviceStatListByDeviceId(String deviceId);

    /**
     * 按设备从故障、维护、环境、电气、操作等表聚合一行汇总（不写 eq_device_stat）
     *
     * @param deviceId 设备ID
     * @return 汇总行；设备不存在时为 null
     */
    EqDeviceStat selectComputedAggregateByDeviceId(String deviceId);

    /**
     * 新增设备统计
     *
     * @param eqDeviceStat 设备统计
     * @return 结果
     */
    public int insertEqDeviceStat(EqDeviceStat eqDeviceStat);

    /**
     * 修改设备统计
     *
     * @param eqDeviceStat 设备统计
     * @return 结果
     */
    public int updateEqDeviceStat(EqDeviceStat eqDeviceStat);

    /**
     * 批量删除设备统计
     *
     * @param statIds 需要删除的设备统计主键集合
     * @return 结果
     */
    public int deleteEqDeviceStatByStatIds(Long[] statIds);

    /**
     * 删除设备统计信息
     *
     * @param statId 设备统计主键
     * @return 结果
     */
    public int deleteEqDeviceStatByStatId(Long statId);

    /**
     * 根据设备ID删除设备统计
     *
     * @param deviceId 设备ID
     * @return 结果
     */
    public int deleteEqDeviceStatByDeviceId(String deviceId);

    /**
     * 批量根据设备ID删除设备统计
     *
     * @param deviceIds 设备ID数组
     * @return 结果
     */
    public int deleteEqDeviceStatByDeviceIds(String[] deviceIds);
}
