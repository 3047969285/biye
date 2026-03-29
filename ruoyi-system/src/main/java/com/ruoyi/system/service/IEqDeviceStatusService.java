package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.EqDeviceStatus;

/**
 * 设备运行状态Service接口
 * 
 * @author ruoyi
 * @date 2025-01-07
 */
public interface IEqDeviceStatusService 
{
    /**
     * 查询设备运行状态
     * 
     * @param statusId 设备运行状态主键
     * @return 设备运行状态
     */
    public EqDeviceStatus selectEqDeviceStatusByStatusId(Long statusId);

    /**
     * 查询设备运行状态列表
     * 
     * @param eqDeviceStatus 设备运行状态
     * @return 设备运行状态集合
     */
    public List<EqDeviceStatus> selectEqDeviceStatusList(EqDeviceStatus eqDeviceStatus);

    /**
     * 新增设备运行状态
     * 
     * @param eqDeviceStatus 设备运行状态
     * @return 结果
     */
    public int insertEqDeviceStatus(EqDeviceStatus eqDeviceStatus);

    /**
     * 修改设备运行状态
     * 
     * @param eqDeviceStatus 设备运行状态
     * @return 结果
     */
    public int updateEqDeviceStatus(EqDeviceStatus eqDeviceStatus);

    /**
     * 批量删除设备运行状态
     * 
     * @param statusIds 需要删除的设备运行状态主键集合
     * @return 结果
     */
    public int deleteEqDeviceStatusByStatusIds(Long[] statusIds);

    /**
     * 删除设备运行状态信息
     * 
     * @param statusId 设备运行状态主键
     * @return 结果
     */
    public int deleteEqDeviceStatusByStatusId(Long statusId);

    /**
     * 按设备对最新一条运行状态重新执行规则（告警补偿 / 手动刷新）
     *
     * @param deviceId 设备主键
     */
    public void reevaluateRulesByDeviceId(Long deviceId);
}
