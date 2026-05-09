package com.ruoyi.system.service;

import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.system.domain.EqDevice;

import java.util.List;
import java.util.Map;

/**
 * 设备信息Service接口
 *
 * @author wangchangzhen
 * @date 2026-01-07
 */
public interface IEqDeviceService
{
    /**
     * 查询设备信息列表
     *
     * @param eqDevice 设备信息
     * @return 设备信息集合
     */
    public List<EqDevice> selectEqDeviceList(EqDevice eqDevice);

    /**
     * 查询设备信息
     *
     * @param deviceId 设备ID
     * @return 设备信息
     */
    public EqDevice selectEqDeviceByDeviceId(String deviceId);

    /**
     * 根据设备编号查询设备
     *
     * @param deviceNo 设备编号
     * @return 设备信息
     */
    public EqDevice selectEqDeviceByDeviceNo(String deviceNo);

    /**
     * 新增设备信息
     *
     * @param eqDevice 设备信息
     * @return 结果
     */
    public int insertEqDevice(EqDevice eqDevice);

    /**
     * 修改设备信息
     *
     * @param eqDevice 设备信息
     * @return 结果
     */
    public int updateEqDevice(EqDevice eqDevice);

    /**
     * 更新设备状态（单个）
     *
     * @param deviceId 设备ID
     * @param status 状态 (1-正常, 2-停用, 3-维护, 4-报废)
     * @return 操作结果
     */
    public AjaxResult updateDeviceStatus(String deviceId, Integer status);

    /**
     * 批量更新设备状态
     *
     * @param deviceIds 设备ID数组
     * @param status 状态
     * @return 操作结果
     */
    public AjaxResult updateDeviceStatusBatch(String[] deviceIds, Integer status);

    /**
     * 批量删除设备信息
     *
     * @param deviceIds 需要删除的设备ID
     * @return 结果
     */
    public int deleteEqDeviceByDeviceIds(String[] deviceIds);

    /**
     * 删除设备信息
     *
     * @param deviceId 设备ID
     * @return 结果
     */
    public int deleteEqDeviceByDeviceId(String deviceId);

    /**
     * 获取设备统计信息
     *
     * @return 统计结果
     */
    public Map<String, Object> getDeviceStatistics();

    /**
     * 获取所有设备的汇总数据（用于首页仪表板）
     *
     * @return 仪表板数据
     */
    public Map<String, Object> getDeviceDashboardData();

    /**
     * 校验设备编号是否唯一
     *
     * @param deviceNo 设备编号
     * @return true表示唯一可用
     */
    public boolean checkDeviceNoUnique(String deviceNo);
}
