package com.ruoyi.system.service;

import com.ruoyi.system.domain.EqMaintenanceRecord;
import java.util.List;

/**
 * 维护记录 Service接口
 *
 * @author ruoyi
 * @date 2026-01-07
 */
public interface IEqMaintenanceRecordService {

    /**
     * 查询维护记录列表
     *
     * @param eqMaintenanceRecord 维护记录
     * @return 维护记录集合
     */
    List<EqMaintenanceRecord> selectEqMaintenanceRecordList(EqMaintenanceRecord eqMaintenanceRecord);

    /**
     * 查询维护记录
     *
     * @param recordId 维护记录主键
     * @return 维护记录
     */
    EqMaintenanceRecord selectEqMaintenanceRecordByRecordId(Long recordId);

    /**
     * 根据设备ID查询维护记录列表
     *
     * @param deviceId 设备ID
     * @return 维护记录集合
     */
    List<EqMaintenanceRecord> selectEqMaintenanceRecordListByDeviceId(Long deviceId);

    /**
     * 新增维护记录
     *
     * @param eqMaintenanceRecord 维护记录
     * @return 结果
     */
    int insertEqMaintenanceRecord(EqMaintenanceRecord eqMaintenanceRecord);

    /**
     * 修改维护记录
     *
     * @param eqMaintenanceRecord 维护记录
     * @return 结果
     */
    int updateEqMaintenanceRecord(EqMaintenanceRecord eqMaintenanceRecord);

    /**
     * 批量删除维护记录
     *
     * @param recordIds 需要删除的维护记录主键集合
     * @return 结果
     */
    int deleteEqMaintenanceRecordByRecordIds(Long[] recordIds);

    /**
     * 删除维护记录信息
     *
     * @param recordId 维护记录主键
     * @return 结果
     */
    int deleteEqMaintenanceRecordByRecordId(Long recordId);
}
