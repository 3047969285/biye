package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.EqFaultRecord;

/**
 * 故障记录Service接口
 *
 * @author wangchangzhen
 * @date 2026-01-07
 */
public interface IEqFaultRecordService
{
    /**
     * 查询故障记录列表
     *
     * @param eqFaultRecord 故障记录
     * @return 故障记录集合
     */
    public List<EqFaultRecord> selectEqFaultRecordList(EqFaultRecord eqFaultRecord);

    /**
     * 根据故障记录ID查询故障记录
     *
     * @param faultId 故障记录ID
     * @return 故障记录
     */
    public EqFaultRecord selectEqFaultRecordByFaultId(Long faultId);

    /**
     * 根据设备ID查询故障记录列表
     *
     * @param deviceId 设备ID
     * @return 故障记录集合
     */
    public List<EqFaultRecord> selectEqFaultRecordListByDeviceId(String deviceId);

    /**
     * 新增故障记录
     *
     * @param eqFaultRecord 故障记录
     * @return 结果
     */
    public int insertEqFaultRecord(EqFaultRecord eqFaultRecord);

    /**
     * 修改故障记录
     *
     * @param eqFaultRecord 故障记录
     * @return 结果
     */
    public int updateEqFaultRecord(EqFaultRecord eqFaultRecord);

    /**
     * 批量删除故障记录
     *
     * @param faultIds 需要删除的故障记录主键集合
     * @return 结果
     */
    public int deleteEqFaultRecordByFaultIds(Long[] faultIds);

    /**
     * 删除故障记录信息
     *
     * @param faultId 故障记录主键
     * @return 结果
     */
    public int deleteEqFaultRecordByFaultId(Long faultId);

    /**
     * 根据设备ID删除故障记录
     *
     * @param deviceId 设备ID
     * @return 结果
     */
    public int deleteEqFaultRecordByDeviceId(String deviceId);

    /**
     * 批量根据设备ID删除故障记录
     *
     * @param deviceIds 设备ID数组
     * @return 结果
     */
    public int deleteEqFaultRecordByDeviceIds(String[] deviceIds);
}
