package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.EqAlertRecord;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 告警记录 Mapper 接口
 *
 * @author wcz
 * @date 2025-12-19
 */
@Mapper
public interface EqAlertRecordMapper {

    /**
     * 查询告警记录列表
     *
     * @param eqAlertRecord 告警记录
     * @return 告警记录集合
     */
    List<EqAlertRecord> selectEqAlertRecordList(EqAlertRecord eqAlertRecord);

    /**
     * 查询告警记录
     *
     * @param alertId 告警记录主键
     * @return 告警记录
     */
    EqAlertRecord selectEqAlertRecordByAlertId(@Param("alertId") Long alertId);

    /**
     * 根据设备ID查询告警记录列表
     *
     * @param deviceId 设备ID
     * @return 告警记录集合
     */
    List<EqAlertRecord> selectEqAlertRecordListByDeviceId(@Param("deviceId") Long deviceId);

    /**
     * 新增告警记录
     *
     * @param eqAlertRecord 告警记录
     * @return 结果
     */
    int insertEqAlertRecord(EqAlertRecord eqAlertRecord);

    /**
     * 修改告警记录
     *
     * @param eqAlertRecord 告警记录
     * @return 结果
     */
    int updateEqAlertRecord(EqAlertRecord eqAlertRecord);

    /**
     * 删除告警记录
     *
     * @param alertId 告警记录主键
     * @return 结果
     */
    int deleteEqAlertRecordByAlertId(@Param("alertId") Long alertId);

    /**
     * 批量删除告警记录
     *
     * @param alertIds 需要删除的数据主键集合
     * @return 结果
     */
    int deleteEqAlertRecordByAlertIds(@Param("alertIds") Long[] alertIds);

    /**
     * 根据设备ID删除告警记录
     *
     * @param deviceId 设备ID
     * @return 结果
     */
    int deleteEqAlertRecordByDeviceId(@Param("deviceId") Long deviceId);

    /**
     * 批量根据设备ID删除告警记录
     *
     * @param deviceIds 设备ID数组
     * @return 结果
     */
    int deleteEqAlertRecordByDeviceIds(@Param("deviceIds") Long[] deviceIds);
}
