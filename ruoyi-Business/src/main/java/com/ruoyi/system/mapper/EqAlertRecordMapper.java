package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.EqAlertRecord;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 告警记录Mapper接口
 * 
 * @author wangchangzhen
 * @date 2026-01-07
 */
@Mapper
public interface EqAlertRecordMapper 
{
    /**
     * 查询告警记录列表
     * 
     * @param eqAlertRecord 告警记录
     * @return 告警记录集合
     */
    public List<EqAlertRecord> selectEqAlertRecordList(EqAlertRecord eqAlertRecord);

    /**
     * 根据告警ID查询告警记录
     * 
     * @param alertId 告警ID
     * @return 告警记录
     */
    public EqAlertRecord selectEqAlertRecordByAlertId(@Param("alertId") Long alertId);

    /**
     * 根据设备ID查询告警记录列表
     * 
     * @param deviceId 设备ID
     * @return 告警记录集合
     */
    public List<EqAlertRecord> selectEqAlertRecordListByDeviceId(@Param("deviceId") String deviceId);

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
     * 删除告警记录
     * 
     * @param alertId 告警记录主键
     * @return 结果
     */
    public int deleteEqAlertRecordByAlertId(@Param("alertId") Long alertId);

    /**
     * 批量删除告警记录
     * 
     * @param alertIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteEqAlertRecordByAlertIds(@Param("alertIds") Long[] alertIds);

    /**
     * 根据设备ID删除告警记录
     * 
     * @param deviceId 设备ID
     * @return 结果
     */
    public int deleteEqAlertRecordByDeviceId(@Param("deviceId") String deviceId);

    /**
     * 批量根据设备ID删除告警记录
     * 
     * @param deviceIds 设备ID数组
     * @return 结果
     */
    public int deleteEqAlertRecordByDeviceIds(@Param("deviceIds") String[] deviceIds);

    /**
     * 未解决且同一规则下是否已有告警（去重）
     */
    int countUnresolvedByDeviceAndRule(@Param("deviceId") String deviceId, @Param("ruleId") Long ruleId);
}
