package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.EqMaintenanceRecord;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 维护记录 Mapper 接口
 *
 * @author ruoyi
 * @date 2026-01-07
 */
@Mapper
public interface EqMaintenanceRecordMapper {

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
    EqMaintenanceRecord selectEqMaintenanceRecordByRecordId(@Param("recordId") Long recordId);

    /**
     * 根据设备ID查询维护记录列表
     *
     * @param deviceId 设备ID
     * @return 维护记录集合
     */
    List<EqMaintenanceRecord> selectEqMaintenanceRecordListByDeviceId(@Param("deviceId") Long deviceId);

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
     * 删除维护记录
     *
     * @param recordId 维护记录主键
     * @return 结果
     */
    int deleteEqMaintenanceRecordByRecordId(@Param("recordId") Long recordId);

    /**
     * 批量删除维护记录
     *
     * @param recordIds 需要删除的数据主键集合
     * @return 结果
     */
    int deleteEqMaintenanceRecordByRecordIds(@Param("recordIds") Long[] recordIds);

    /**
     * 根据设备ID删除维护记录
     *
     * @param deviceId 设备ID
     * @return 结果
     */
    int deleteEqMaintenanceRecordByDeviceId(@Param("deviceId") Long deviceId);

    /**
     * 批量根据设备ID删除维护记录
     *
     * @param deviceIds 设备ID数组
     * @return 结果
     */
    int deleteEqMaintenanceRecordByDeviceIds(@Param("deviceIds") Long[] deviceIds);
}
