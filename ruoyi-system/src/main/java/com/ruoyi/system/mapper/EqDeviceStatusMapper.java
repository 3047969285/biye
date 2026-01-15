package com.ruoyi.system.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
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
    public int deleteEqDeviceStatusByStatusIds(@Param("statusIds") Long[] statusIds);
    
    /**
     * 根据设备ID删除设备运行状态
     * 
     * @param deviceId 设备ID
     * @return 结果
     */
    public int deleteEqDeviceStatusByDeviceId(@Param("deviceId") Long deviceId);
    
    /**
     * 批量根据设备ID删除设备运行状态
     * 
     * @param deviceIds 设备ID数组
     * @return 结果
     */
    public int deleteEqDeviceStatusByDeviceIds(@Param("deviceIds") Long[] deviceIds);
    
    /**
     * 查询需要维护的设备（状态不好）
     * 
     * @return 需要维护的设备状态列表
     */
    public List<EqDeviceStatus> selectDevicesRequiringMaintenance();
}
