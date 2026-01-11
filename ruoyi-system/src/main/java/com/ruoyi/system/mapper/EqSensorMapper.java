package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.EqSensor;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface EqSensorMapper {
    List<EqSensor> selectEqSensorList(EqSensor eqSensor);
    EqSensor selectEqSensorBySensorId(@Param("sensorId") Long sensorId);
    List<EqSensor> selectEqSensorListByDeviceId(@Param("deviceId") Long deviceId);
    int insertEqSensor(EqSensor eqSensor);
    int updateEqSensor(EqSensor eqSensor);
    int deleteEqSensorBySensorId(@Param("sensorId") Long sensorId);
    int deleteEqSensorBySensorIds(@Param("sensorIds") Long[] sensorIds);
    int deleteEqSensorByDeviceId(@Param("deviceId") Long deviceId);
    int deleteEqSensorByDeviceIds(@Param("deviceIds") Long[] deviceIds);
}
