package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.EqMaintenanceRecord;

/**
 * 维保记录Service接口
 *
 * @author wangchangzhen
 * @date 2026-01-07
 */
public interface IEqMaintenanceRecordService
{
    /**
     * 查询维保记录列表
     *
     * @param eqMaintenanceRecord 维保记录
     * @return 维保记录集合
     */
    public List<EqMaintenanceRecord> selectEqMaintenanceRecordList(EqMaintenanceRecord eqMaintenanceRecord);

    /**
     * 根据维保记录ID查询维保记录
     *
     * @param recordId 维保记录ID
     * @return 维保记录
     */
    public EqMaintenanceRecord selectEqMaintenanceRecordByRecordId(Long recordId);

    /**
     * 根据设备ID查询维保记录列表
     *
     * @param deviceId 设备ID
     * @return 维保记录集合
     */
    public List<EqMaintenanceRecord> selectEqMaintenanceRecordListByDeviceId(String deviceId);

    /**
     * 新增维保记录
     *
     * @param eqMaintenanceRecord 维保记录
     * @return 结果
     */
    public int insertEqMaintenanceRecord(EqMaintenanceRecord eqMaintenanceRecord);

    /**
     * 修改维保记录
     *
     * @param eqMaintenanceRecord 维保记录
     * @return 结果
     */
    public int updateEqMaintenanceRecord(EqMaintenanceRecord eqMaintenanceRecord);

    /**
     * 批量删除维保记录
     *
     * @param recordIds 需要删除的维保记录主键集合
     * @return 结果
     */
    public int deleteEqMaintenanceRecordByRecordIds(Long[] recordIds);

    /**
     * 删除维保记录信息
     *
     * @param recordId 维保记录主键
     * @return 结果
     */
    public int deleteEqMaintenanceRecordByRecordId(Long recordId);

    /**
     * 根据设备ID删除维保记录
     *
     * @param deviceId 设备ID
     * @return 结果
     */
    public int deleteEqMaintenanceRecordByDeviceId(String deviceId);

    /**
     * 批量根据设备ID删除维保记录
     *
     * @param deviceIds 设备ID数组
     * @return 结果
     */
    public int deleteEqMaintenanceRecordByDeviceIds(String[] deviceIds);
}
