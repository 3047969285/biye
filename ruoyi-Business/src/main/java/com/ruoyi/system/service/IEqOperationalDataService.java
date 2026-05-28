package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.EqOperationalData;

/**
 * 运行数据Service接口
 *
 * @author wangchangzhen
 * @date 2026-01-07
 */
public interface IEqOperationalDataService
{
    /**
     * 查询运行数据列表
     *
     * @param eqOperationalData 运行数据
     * @return 运行数据集合
     */
    public List<EqOperationalData> selectEqOperationalDataList(EqOperationalData eqOperationalData);

    /**
     * 根据运行数据ID查询运行数据
     *
     * @param operationalId 运行数据ID
     * @return 运行数据
     */
    public EqOperationalData selectEqOperationalDataByOperationalId(Long operationalId);

    /**
     * 根据设备ID查询运行数据列表
     *
     * @param deviceId 设备ID
     * @return 运行数据集合
     */
    public List<EqOperationalData> selectEqOperationalDataListByDeviceId(String deviceId);

    /**
     * 新增运行数据
     *
     * @param eqOperationalData 运行数据
     * @return 结果
     */
    public int insertEqOperationalData(EqOperationalData eqOperationalData);

    /**
     * 修改运行数据
     *
     * @param eqOperationalData 运行数据
     * @return 结果
     */
    public int updateEqOperationalData(EqOperationalData eqOperationalData);

    /**
     * 批量删除运行数据
     *
     * @param operationalIds 需要删除的运行数据主键集合
     * @return 结果
     */
    public int deleteEqOperationalDataByOperationalIds(Long[] operationalIds);

    /**
     * 删除运行数据信息
     *
     * @param operationalId 运行数据主键
     * @return 结果
     */
    public int deleteEqOperationalDataByOperationalId(Long operationalId);

    /**
     * 根据设备ID删除运行数据
     *
     * @param deviceId 设备ID
     * @return 结果
     */
    public int deleteEqOperationalDataByDeviceId(String deviceId);

    /**
     * 批量根据设备ID删除运行数据
     *
     * @param deviceIds 设备ID数组
     * @return 结果
     */
    public int deleteEqOperationalDataByDeviceIds(String[] deviceIds);
}
