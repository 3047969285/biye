package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.EqOperationalData;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 运行数据Mapper接口
 *
 * @author wangchangzhen
 * @date 2026-01-07
 */
@Mapper
public interface EqOperationalDataMapper
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
    public EqOperationalData selectEqOperationalDataByOperationalId(@Param("operationalId") Long operationalId);

    /**
     * 根据设备ID查询运行数据列表
     *
     * @param deviceId 设备ID
     * @return 运行数据集合
     */
    public List<EqOperationalData> selectEqOperationalDataListByDeviceId(@Param("deviceId") String deviceId);

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
     * 删除运行数据信息
     *
     * @param operationalId 运行数据主键
     * @return 结果
     */
    public int deleteEqOperationalDataByOperationalId(@Param("operationalId") Long operationalId);

    /**
     * 批量删除运行数据
     *
     * @param operationalIds 需要删除的运行数据主键集合
     * @return 结果
     */
    public int deleteEqOperationalDataByOperationalIds(@Param("operationalIds") Long[] operationalIds);

    /**
     * 根据设备ID删除运行数据
     *
     * @param deviceId 设备ID
     * @return 结果
     */
    public int deleteEqOperationalDataByDeviceId(@Param("deviceId") String deviceId);

    /**
     * 批量根据设备ID删除运行数据
     *
     * @param deviceIds 设备ID数组
     * @return 结果
     */
    public int deleteEqOperationalDataByDeviceIds(@Param("deviceIds") String[] deviceIds);
}
