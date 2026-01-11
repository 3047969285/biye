package com.ruoyi.system.service.impl;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.EqDeviceStatMapper;
import com.ruoyi.system.domain.EqDeviceStat;
import com.ruoyi.system.service.IEqDeviceStatService;
@Service
public class EqDeviceStatServiceImpl implements IEqDeviceStatService {
    @Autowired
    private EqDeviceStatMapper eqDeviceStatMapper;
    @Override
    public List<EqDeviceStat> selectEqDeviceStatList(EqDeviceStat eqDeviceStat) {
        return eqDeviceStatMapper.selectEqDeviceStatList(eqDeviceStat);
    }
    @Override
    public EqDeviceStat selectEqDeviceStatByStatId(Long statId) {
        return eqDeviceStatMapper.selectEqDeviceStatByStatId(statId);
    }
    @Override
    public List<EqDeviceStat> selectEqDeviceStatListByDeviceId(Long deviceId) {
        return eqDeviceStatMapper.selectEqDeviceStatListByDeviceId(deviceId);
    }
    @Override
    public int insertEqDeviceStat(EqDeviceStat eqDeviceStat) {
        return eqDeviceStatMapper.insertEqDeviceStat(eqDeviceStat);
    }
    @Override
    public int updateEqDeviceStat(EqDeviceStat eqDeviceStat) {
        return eqDeviceStatMapper.updateEqDeviceStat(eqDeviceStat);
    }
    @Override
    public int deleteEqDeviceStatByStatIds(Long[] statIds) {
        return eqDeviceStatMapper.deleteEqDeviceStatByStatIds(statIds);
    }
    @Override
    public int deleteEqDeviceStatByStatId(Long statId) {
        return eqDeviceStatMapper.deleteEqDeviceStatByStatId(statId);
    }
    @Override
    public int deleteEqDeviceStatByDeviceId(Long deviceId) {
        return eqDeviceStatMapper.deleteEqDeviceStatByDeviceId(deviceId);
    }
    @Override
    public int deleteEqDeviceStatByDeviceIds(Long[] deviceIds) {
        return eqDeviceStatMapper.deleteEqDeviceStatByDeviceIds(deviceIds);
    }
}
