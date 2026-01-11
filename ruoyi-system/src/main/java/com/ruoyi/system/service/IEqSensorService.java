package com.ruoyi.system.service;
import java.util.List;
import com.ruoyi.system.domain.EqSensor;
public interface IEqSensorService {
    List<EqSensor> selectEqSensorList(EqSensor eqSensor);
    EqSensor selectEqSensorBySensorId(Long sensorId);
    List<EqSensor> selectEqSensorListByDeviceId(Long deviceId);
    int insertEqSensor(EqSensor eqSensor);
    int updateEqSensor(EqSensor eqSensor);
    int deleteEqSensorBySensorIds(Long[] sensorIds);
    int deleteEqSensorBySensorId(Long sensorId);
    int deleteEqSensorByDeviceId(Long deviceId);
    int deleteEqSensorByDeviceIds(Long[] deviceIds);
}
