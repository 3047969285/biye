package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.EqSensorMapper;
import com.ruoyi.system.domain.EqSensor;
import com.ruoyi.system.service.IEqSensorService;

/**
 * 传感器Service业务层处理
 *
 * @author wangchangzhen
 * @date 2026-01-07
 */
@Service
public class EqSensorServiceImpl implements IEqSensorService
{
    @Autowired
    private EqSensorMapper eqSensorMapper;

    /**
     * 查询传感器列表
     *
     * @param eqSensor 传感器
     * @return 传感器集合
     */
    @Override
    public List<EqSensor> selectEqSensorList(EqSensor eqSensor)
    {
        return eqSensorMapper.selectEqSensorList(eqSensor);
    }

    /**
     * 根据传感器ID查询传感器
     *
     * @param sensorId 传感器ID
     * @return 传感器
     */
    @Override
    public EqSensor selectEqSensorBySensorId(Long sensorId)
    {
        return eqSensorMapper.selectEqSensorBySensorId(sensorId);
    }

    /**
     * 根据设备ID查询传感器列表
     *
     * @param deviceId 设备ID
     * @return 传感器集合
     */
    @Override
    public List<EqSensor> selectEqSensorListByDeviceId(String deviceId)
    {
        return eqSensorMapper.selectEqSensorListByDeviceId(deviceId);
    }

    /**
     * 新增传感器
     *
     * @param eqSensor 传感器
     * @return 结果
     */
    @Override
    public int insertEqSensor(EqSensor eqSensor)
    {
        return eqSensorMapper.insertEqSensor(eqSensor);
    }

    /**
     * 修改传感器
     *
     * @param eqSensor 传感器
     * @return 结果
     */
    @Override
    public int updateEqSensor(EqSensor eqSensor)
    {
        return eqSensorMapper.updateEqSensor(eqSensor);
    }

    /**
     * 批量删除传感器
     *
     * @param sensorIds 需要删除的传感器主键
     * @return 结果
     */
    @Override
    public int deleteEqSensorBySensorIds(Long[] sensorIds)
    {
        return eqSensorMapper.deleteEqSensorBySensorIds(sensorIds);
    }

    /**
     * 删除传感器信息
     *
     * @param sensorId 传感器主键
     * @return 结果
     */
    @Override
    public int deleteEqSensorBySensorId(Long sensorId)
    {
        return eqSensorMapper.deleteEqSensorBySensorId(sensorId);
    }

    /**
     * 根据设备ID删除传感器
     *
     * @param deviceId 设备ID
     * @return 结果
     */
    @Override
    public int deleteEqSensorByDeviceId(String deviceId)
    {
        return eqSensorMapper.deleteEqSensorByDeviceId(deviceId);
    }

    /**
     * 批量根据设备ID删除传感器
     *
     * @param deviceIds 设备ID数组
     * @return 结果
     */
    @Override
    public int deleteEqSensorByDeviceIds(String[] deviceIds)
    {
        return eqSensorMapper.deleteEqSensorByDeviceIds(deviceIds);
    }
}
