package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.EqDeviceStatus;

/**
 * 设备状态Service接口
 *
 * @author wangchangzhen
 * @date 2026-01-07
 */
public interface IEqDeviceStatusService
{
    /**
     * 根据状态记录ID查询设备状态
     *
     * @param statusId 状态记录ID
     * @return 设备状态
     */
    public EqDeviceStatus selectEqDeviceStatusByStatusId(Long statusId);

    /**
     * 查询设备状态列表
     *
     * @param eqDeviceStatus 设备状态
     * @return 设备状态集合
     */
    public List<EqDeviceStatus> selectEqDeviceStatusList(EqDeviceStatus eqDeviceStatus);

    /**
     * 新增设备状态
     *
     * @param eqDeviceStatus 设备状态
     * @return 结果
     */
    public int insertEqDeviceStatus(EqDeviceStatus eqDeviceStatus);

    /**
     * 修改设备状态
     *
     * @param eqDeviceStatus 设备状态
     * @return 结果
     */
    public int updateEqDeviceStatus(EqDeviceStatus eqDeviceStatus);

    /**
     * 批量删除设备状态
     *
     * @param statusIds 需要删除的设备状态主键集合
     * @return 结果
     */
    public int deleteEqDeviceStatusByStatusIds(Long[] statusIds);

    /**
     * 删除设备状态信息
     *
     * @param statusId 设备状态主键
     * @return 结果
     */
    public int deleteEqDeviceStatusByStatusId(Long statusId);

    /**
     * 按设备ID重新评估最新设备状态对应的规则
     *
     * @param deviceId 设备ID
     */
    public void reevaluateRulesByDeviceId(String deviceId);
}
