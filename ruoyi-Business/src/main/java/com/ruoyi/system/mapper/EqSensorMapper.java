package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.EqSensor;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 传感器Mapper接口
 *
 * @author wangchangzhen
 * @date 2026-01-07
 */
@Mapper
public interface EqSensorMapper
{
    /**
     * 查询传感器列表
     *
     * @param eqSensor 传感器
     * @return 传感器集合
     */
    public List<EqSensor> selectEqSensorList(EqSensor eqSensor);

    /**
     * 根据传感器ID查询传感器
     *
     * @param sensorId 传感器ID
     * @return 传感器
     */
    public EqSensor selectEqSensorBySensorId(@Param("sensorId") Long sensorId);

    /**
     * 根据设备ID查询传感器列表
     *
     * @param deviceId 设备ID
     * @return 传感器集合
     */
    public List<EqSensor> selectEqSensorListByDeviceId(@Param("deviceId") String deviceId);

    /**
     * 新增传感器
     *
     * @param eqSensor 传感器
     * @return 结果
     */
    public int insertEqSensor(EqSensor eqSensor);

    /**
     * 修改传感器
     *
     * @param eqSensor 传感器
     * @return 结果
     */
    public int updateEqSensor(EqSensor eqSensor);

    /**
     * 删除传感器信息
     *
     * @param sensorId 传感器主键
     * @return 结果
     */
    public int deleteEqSensorBySensorId(@Param("sensorId") Long sensorId);

    /**
     * 批量删除传感器
     *
     * @param sensorIds 需要删除的传感器主键集合
     * @return 结果
     */
    public int deleteEqSensorBySensorIds(@Param("sensorIds") Long[] sensorIds);

    /**
     * 根据设备ID删除传感器
     *
     * @param deviceId 设备ID
     * @return 结果
     */
    public int deleteEqSensorByDeviceId(@Param("deviceId") String deviceId);

    /**
     * 批量根据设备ID删除传感器
     *
     * @param deviceIds 设备ID数组
     * @return 结果
     */
    public int deleteEqSensorByDeviceIds(@Param("deviceIds") String[] deviceIds);
}
