package com.ruoyi.system.service;

import com.ruoyi.system.domain.EqAlertRecord;
import java.util.List;

/**
 * 告警记录 Service接口
 *
 * @author wcz
 * @date 2025-12-19
 */
public interface IEqAlertRecordService {

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
    EqAlertRecord selectEqAlertRecordByAlertId(Long alertId);

    /**
     * 根据设备ID查询告警记录列表
     *
     * @param deviceId 设备ID
     * @return 告警记录集合
     */
    List<EqAlertRecord> selectEqAlertRecordListByDeviceId(Long deviceId);

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
     * 批量删除告警记录
     *
     * @param alertIds 需要删除的告警记录主键集合
     * @return 结果
     */
    int deleteEqAlertRecordByAlertIds(Long[] alertIds);

    /**
     * 删除告警记录信息
     *
     * @param alertId 告警记录主键
     * @return 结果
     */
    int deleteEqAlertRecordByAlertId(Long alertId);
}
