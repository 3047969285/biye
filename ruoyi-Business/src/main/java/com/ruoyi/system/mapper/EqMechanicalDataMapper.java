package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.EqMechanicalData;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 机械数据Mapper接口
 *
 * @author wangchangzhen
 * @date 2026-01-07
 */
@Mapper
public interface EqMechanicalDataMapper
{
    /**
     * 查询机械数据列表
     *
     * @param eqMechanicalData 机械数据
     * @return 机械数据集合
     */
    public List<EqMechanicalData> selectEqMechanicalDataList(EqMechanicalData eqMechanicalData);

    /**
     * 根据机械数据ID查询机械数据
     *
     * @param mechanicalId 机械数据ID
     * @return 机械数据
     */
    public EqMechanicalData selectEqMechanicalDataByMechanicalId(@Param("mechanicalId") Long mechanicalId);

    /**
     * 根据设备ID查询机械数据列表
     *
     * @param deviceId 设备ID
     * @return 机械数据集合
     */
    public List<EqMechanicalData> selectEqMechanicalDataListByDeviceId(@Param("deviceId") String deviceId);

    /**
     * 新增机械数据
     *
     * @param eqMechanicalData 机械数据
     * @return 结果
     */
    public int insertEqMechanicalData(EqMechanicalData eqMechanicalData);

    /**
     * 修改机械数据
     *
     * @param eqMechanicalData 机械数据
     * @return 结果
     */
    public int updateEqMechanicalData(EqMechanicalData eqMechanicalData);

    /**
     * 删除机械数据信息
     *
     * @param mechanicalId 机械数据主键
     * @return 结果
     */
    public int deleteEqMechanicalDataByMechanicalId(@Param("mechanicalId") Long mechanicalId);

    /**
     * 批量删除机械数据
     *
     * @param mechanicalIds 需要删除的机械数据主键集合
     * @return 结果
     */
    public int deleteEqMechanicalDataByMechanicalIds(@Param("mechanicalIds") Long[] mechanicalIds);

    /**
     * 根据设备ID删除机械数据
     *
     * @param deviceId 设备ID
     * @return 结果
     */
    public int deleteEqMechanicalDataByDeviceId(@Param("deviceId") String deviceId);

    /**
     * 批量根据设备ID删除机械数据
     *
     * @param deviceIds 设备ID数组
     * @return 结果
     */
    public int deleteEqMechanicalDataByDeviceIds(@Param("deviceIds") String[] deviceIds);
}
