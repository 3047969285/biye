package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.EqDeviceStat;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 设备统计Mapper接口
 *
 * @author wangchangzhen
 * @date 2026-01-07
 */
@Mapper
public interface EqDeviceStatMapper
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
    public EqDeviceStat selectEqDeviceStatByStatId(@Param("statId") Long statId);

    /**
     * 根据设备ID查询设备统计列表
     *
     * @param deviceId 设备ID
     * @return 设备统计集合
     */
    public List<EqDeviceStat> selectEqDeviceStatListByDeviceId(@Param("deviceId") String deviceId);

    /**
     * 按设备从故障/维护/环境/电气/操作等表聚合一行汇总（不写 eq_device_stat）
     *
     * @param deviceId 设备ID
     * @return 汇总行，设备不存在时 null
     */
    EqDeviceStat selectComputedAggregateByDeviceId(@Param("deviceId") String deviceId);

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
     * 删除设备统计信息
     *
     * @param statId 设备统计主键
     * @return 结果
     */
    public int deleteEqDeviceStatByStatId(@Param("statId") Long statId);

    /**
     * 批量删除设备统计
     *
     * @param statIds 需要删除的设备统计主键集合
     * @return 结果
     */
    public int deleteEqDeviceStatByStatIds(@Param("statIds") Long[] statIds);

    /**
     * 根据设备ID删除设备统计
     *
     * @param deviceId 设备ID
     * @return 结果
     */
    public int deleteEqDeviceStatByDeviceId(@Param("deviceId") String deviceId);

    /**
     * 批量根据设备ID删除设备统计
     *
     * @param deviceIds 设备ID数组
     * @return 结果
     */
    public int deleteEqDeviceStatByDeviceIds(@Param("deviceIds") String[] deviceIds);
}
