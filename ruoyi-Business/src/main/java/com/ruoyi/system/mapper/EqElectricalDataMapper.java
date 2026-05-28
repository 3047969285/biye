package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.EqElectricalData;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 电气数据Mapper接口
 *
 * @author wangchangzhen
 * @date 2026-01-07
 */
@Mapper
public interface EqElectricalDataMapper
{
    /**
     * 查询电气数据列表
     *
     * @param eqElectricalData 电气数据
     * @return 电气数据集合
     */
    public List<EqElectricalData> selectEqElectricalDataList(EqElectricalData eqElectricalData);

    /**
     * 根据电气数据ID查询电气数据
     *
     * @param electricalId 电气数据ID
     * @return 电气数据
     */
    public EqElectricalData selectEqElectricalDataByElectricalId(@Param("electricalId") Long electricalId);

    /**
     * 根据设备ID查询电气数据列表
     *
     * @param deviceId 设备ID
     * @return 电气数据集合
     */
    public List<EqElectricalData> selectEqElectricalDataListByDeviceId(@Param("deviceId") String deviceId);

    /**
     * 新增电气数据
     *
     * @param eqElectricalData 电气数据
     * @return 结果
     */
    public int insertEqElectricalData(EqElectricalData eqElectricalData);

    /**
     * 修改电气数据
     *
     * @param eqElectricalData 电气数据
     * @return 结果
     */
    public int updateEqElectricalData(EqElectricalData eqElectricalData);

    /**
     * 删除电气数据信息
     *
     * @param electricalId 电气数据主键
     * @return 结果
     */
    public int deleteEqElectricalDataByElectricalId(@Param("electricalId") Long electricalId);

    /**
     * 批量删除电气数据
     *
     * @param electricalIds 需要删除的电气数据主键集合
     * @return 结果
     */
    public int deleteEqElectricalDataByElectricalIds(@Param("electricalIds") Long[] electricalIds);

    /**
     * 根据设备ID删除电气数据
     *
     * @param deviceId 设备ID
     * @return 结果
     */
    public int deleteEqElectricalDataByDeviceId(@Param("deviceId") String deviceId);

    /**
     * 批量根据设备ID删除电气数据
     *
     * @param deviceIds 设备ID数组
     * @return 结果
     */
    public int deleteEqElectricalDataByDeviceIds(@Param("deviceIds") String[] deviceIds);
}
