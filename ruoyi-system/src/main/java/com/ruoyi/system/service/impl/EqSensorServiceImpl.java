package com.ruoyi.system.service.impl;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.EqSensorMapper;
import com.ruoyi.system.domain.EqSensor;
import com.ruoyi.system.service.IEqSensorService;
@Service
public class EqSensorServiceImpl implements IEqSensorService {
    @Autowired
    private EqSensorMapper eqSensorMapper;
    @Override
    public List<EqSensor> selectEqSensorList(EqSensor eqSensor) {
        return eqSensorMapper.selectEqSensorList(eqSensor);
    }
    @Override
    public EqSensor selectEqSensorBySensorId(Long sensorId) {
        return eqSensorMapper.selectEqSensorBySensorId(sensorId);
    }
    @Override
    public List<EqSensor> selectEqSensorListByDeviceId(Long deviceId) {
        return eqSensorMapper.selectEqSensorListByDeviceId(deviceId);
    }
    @Override
    public int insertEqSensor(EqSensor eqSensor) {
        return eqSensorMapper.insertEqSensor(eqSensor);
    }
    @Override
    public int updateEqSensor(EqSensor eqSensor) {
        return eqSensorMapper.updateEqSensor(eqSensor);
    }
    @Override
    public int deleteEqSensorBySensorIds(Long[] sensorIds) {
        return eqSensorMapper.deleteEqSensorBySensorIds(sensorIds);
    }
    @Override
    public int deleteEqSensorBySensorId(Long sensorId) {
        return eqSensorMapper.deleteEqSensorBySensorId(sensorId);
    }
    @Override
    public int deleteEqSensorByDeviceId(Long deviceId) {
        return eqSensorMapper.deleteEqSensorByDeviceId(deviceId);
    }
    @Override
    public int deleteEqSensorByDeviceIds(Long[] deviceIds) {
        return eqSensorMapper.deleteEqSensorByDeviceIds(deviceIds);
    }
}
