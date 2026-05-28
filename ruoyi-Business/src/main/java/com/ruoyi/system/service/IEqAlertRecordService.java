package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.EqAlertRecord;

/**
 * 告警记录Service接口
 *
 * @author wangchangzhen
 * @date 2026-01-07
 */
public interface IEqAlertRecordService
{
    /**
     * 查询告警记录列表
     *
     * @param eqAlertRecord 告警记录
     * @return 告警记录集合
     */
    public List<EqAlertRecord> selectEqAlertRecordList(EqAlertRecord eqAlertRecord);

    /**
     * 根据告警记录ID查询告警记录
     *
     * @param alertId 告警记录ID
     * @return 告警记录
     */
    public EqAlertRecord selectEqAlertRecordByAlertId(Long alertId);

    /**
     * 根据设备ID查询告警记录列表
     *
     * @param deviceId 设备ID
     * @return 告警记录集合
     */
    public List<EqAlertRecord> selectEqAlertRecordListByDeviceId(String deviceId);

    /**
     * 新增告警记录
     *
     * @param eqAlertRecord 告警记录
     * @return 结果
     */
    public int insertEqAlertRecord(EqAlertRecord eqAlertRecord);

    /**
     * 修改告警记录
     *
     * @param eqAlertRecord 告警记录
     * @return 结果
     */
    public int updateEqAlertRecord(EqAlertRecord eqAlertRecord);

    /**
     * 批量删除告警记录
     *
     * @param alertIds 需要删除的告警记录主键集合
     * @return 结果
     */
    public int deleteEqAlertRecordByAlertIds(Long[] alertIds);

    /**
     * 删除告警记录信息
     *
     * @param alertId 告警记录主键
     * @return 结果
     */
    public int deleteEqAlertRecordByAlertId(Long alertId);

    /**
     * 根据设备ID删除告警记录
     *
     * @param deviceId 设备ID
     * @return 结果
     */
    public int deleteEqAlertRecordByDeviceId(String deviceId);

    /**
     * 批量根据设备ID删除告警记录
     *
     * @param deviceIds 设备ID数组
     * @return 结果
     */
    public int deleteEqAlertRecordByDeviceIds(String[] deviceIds);
}
