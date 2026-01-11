package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.EqDeviceStat;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface EqDeviceStatMapper {
    List<EqDeviceStat> selectEqDeviceStatList(EqDeviceStat eqDeviceStat);
    EqDeviceStat selectEqDeviceStatByStatId(@Param("statId") Long statId);
    List<EqDeviceStat> selectEqDeviceStatListByDeviceId(@Param("deviceId") Long deviceId);
    int insertEqDeviceStat(EqDeviceStat eqDeviceStat);
    int updateEqDeviceStat(EqDeviceStat eqDeviceStat);
    int deleteEqDeviceStatByStatId(@Param("statId") Long statId);
    int deleteEqDeviceStatByStatIds(@Param("statIds") Long[] statIds);
    int deleteEqDeviceStatByDeviceId(@Param("deviceId") Long deviceId);
    int deleteEqDeviceStatByDeviceIds(@Param("deviceIds") Long[] deviceIds);
}
