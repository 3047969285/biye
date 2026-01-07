package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.EqDeviceStatusMapper;
import com.ruoyi.system.domain.EqDeviceStatus;
import com.ruoyi.system.service.IEqDeviceStatusService;

/**
 * 设备运行状态Service业务层处理
 * 
 * @author ruoyi
 * @date 2025-01-07
 */
@Service
public class EqDeviceStatusServiceImpl implements IEqDeviceStatusService 
{
    @Autowired
    private EqDeviceStatusMapper eqDeviceStatusMapper;

    /**
     * 查询设备运行状态
     * 
     * @param statusId 设备运行状态主键
     * @return 设备运行状态
     */
    @Override
    public EqDeviceStatus selectEqDeviceStatusByStatusId(Long statusId)
    {
        return eqDeviceStatusMapper.selectEqDeviceStatusByStatusId(statusId);
    }

    /**
     * 查询设备运行状态列表
     * 
     * @param eqDeviceStatus 设备运行状态
     * @return 设备运行状态
     */
    @Override
    public List<EqDeviceStatus> selectEqDeviceStatusList(EqDeviceStatus eqDeviceStatus)
    {
        return eqDeviceStatusMapper.selectEqDeviceStatusList(eqDeviceStatus);
    }

    /**
     * 新增设备运行状态
     * 
     * @param eqDeviceStatus 设备运行状态
     * @return 结果
     */
    @Override
    public int insertEqDeviceStatus(EqDeviceStatus eqDeviceStatus)
    {
        return eqDeviceStatusMapper.insertEqDeviceStatus(eqDeviceStatus);
    }

    /**
     * 修改设备运行状态
     * 
     * @param eqDeviceStatus 设备运行状态
     * @return 结果
     */
    @Override
    public int updateEqDeviceStatus(EqDeviceStatus eqDeviceStatus)
    {
        return eqDeviceStatusMapper.updateEqDeviceStatus(eqDeviceStatus);
    }

    /**
     * 批量删除设备运行状态
     * 
     * @param statusIds 需要删除的设备运行状态主键
     * @return 结果
     */
    @Override
    public int deleteEqDeviceStatusByStatusIds(Long[] statusIds)
    {
        return eqDeviceStatusMapper.deleteEqDeviceStatusByStatusIds(statusIds);
    }

    /**
     * 删除设备运行状态信息
     * 
     * @param statusId 设备运行状态主键
     * @return 结果
     */
    @Override
    public int deleteEqDeviceStatusByStatusId(Long statusId)
    {
        return eqDeviceStatusMapper.deleteEqDeviceStatusByStatusId(statusId);
    }
}
