package com.ruoyi.system.service;
import java.util.List;
import com.ruoyi.system.domain.EqDeviceStat;
public interface IEqDeviceStatService {
    List<EqDeviceStat> selectEqDeviceStatList(EqDeviceStat eqDeviceStat);
    EqDeviceStat selectEqDeviceStatByStatId(Long statId);
    List<EqDeviceStat> selectEqDeviceStatListByDeviceId(Long deviceId);
    int insertEqDeviceStat(EqDeviceStat eqDeviceStat);
    int updateEqDeviceStat(EqDeviceStat eqDeviceStat);
    int deleteEqDeviceStatByStatIds(Long[] statIds);
    int deleteEqDeviceStatByStatId(Long statId);
    int deleteEqDeviceStatByDeviceId(Long deviceId);
    int deleteEqDeviceStatByDeviceIds(Long[] deviceIds);
}
