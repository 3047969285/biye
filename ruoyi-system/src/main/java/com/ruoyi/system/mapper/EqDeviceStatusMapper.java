package com.ruoyi.system.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import com.ruoyi.system.domain.EqDeviceStatus;

/**
 * 设备运行状态Mapper接口
 * 
 * @author ruoyi
 * @date 2025-01-07
 */
@Mapper
public interface EqDeviceStatusMapper 
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
     * 删除设备运行状态
     * 
     * @param statusId 设备运行状态主键
     * @return 结果
     */
    public int deleteEqDeviceStatusByStatusId(Long statusId);

    /**
     * 批量删除设备运行状态
     * 
     * @param statusIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteEqDeviceStatusByStatusIds(Long[] statusIds);
}
