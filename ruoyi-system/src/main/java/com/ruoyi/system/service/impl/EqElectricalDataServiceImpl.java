package com.ruoyi.system.service.impl;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.EqElectricalDataMapper;
import com.ruoyi.system.domain.EqElectricalData;
import com.ruoyi.system.service.IEqElectricalDataService;
@Service
public class EqElectricalDataServiceImpl implements IEqElectricalDataService {
    @Autowired
    private EqElectricalDataMapper eqElectricalDataMapper;
    @Override
    public List<EqElectricalData> selectEqElectricalDataList(EqElectricalData eqElectricalData) {
        return eqElectricalDataMapper.selectEqElectricalDataList(eqElectricalData);
    }
    @Override
    public EqElectricalData selectEqElectricalDataByElectricalId(Long electricalId) {
        return eqElectricalDataMapper.selectEqElectricalDataByElectricalId(electricalId);
    }
    @Override
    public List<EqElectricalData> selectEqElectricalDataListByDeviceId(Long deviceId) {
        return eqElectricalDataMapper.selectEqElectricalDataListByDeviceId(deviceId);
    }
    @Override
    public int insertEqElectricalData(EqElectricalData eqElectricalData) {
        return eqElectricalDataMapper.insertEqElectricalData(eqElectricalData);
    }
    @Override
    public int updateEqElectricalData(EqElectricalData eqElectricalData) {
        return eqElectricalDataMapper.updateEqElectricalData(eqElectricalData);
    }
    @Override
    public int deleteEqElectricalDataByElectricalIds(Long[] electricalIds) {
        return eqElectricalDataMapper.deleteEqElectricalDataByElectricalIds(electricalIds);
    }
    @Override
    public int deleteEqElectricalDataByElectricalId(Long electricalId) {
        return eqElectricalDataMapper.deleteEqElectricalDataByElectricalId(electricalId);
    }
    @Override
    public int deleteEqElectricalDataByDeviceId(Long deviceId) {
        return eqElectricalDataMapper.deleteEqElectricalDataByDeviceId(deviceId);
    }
    @Override
    public int deleteEqElectricalDataByDeviceIds(Long[] deviceIds) {
        return eqElectricalDataMapper.deleteEqElectricalDataByDeviceIds(deviceIds);
    }
}
