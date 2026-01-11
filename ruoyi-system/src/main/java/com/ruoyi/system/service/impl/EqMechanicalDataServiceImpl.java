package com.ruoyi.system.service.impl;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.EqMechanicalDataMapper;
import com.ruoyi.system.domain.EqMechanicalData;
import com.ruoyi.system.service.IEqMechanicalDataService;
@Service
public class EqMechanicalDataServiceImpl implements IEqMechanicalDataService {
    @Autowired
    private EqMechanicalDataMapper eqMechanicalDataMapper;
    @Override
    public List<EqMechanicalData> selectEqMechanicalDataList(EqMechanicalData eqMechanicalData) {
        return eqMechanicalDataMapper.selectEqMechanicalDataList(eqMechanicalData);
    }
    @Override
    public EqMechanicalData selectEqMechanicalDataByMechanicalId(Long mechanicalId) {
        return eqMechanicalDataMapper.selectEqMechanicalDataByMechanicalId(mechanicalId);
    }
    @Override
    public List<EqMechanicalData> selectEqMechanicalDataListByDeviceId(Long deviceId) {
        return eqMechanicalDataMapper.selectEqMechanicalDataListByDeviceId(deviceId);
    }
    @Override
    public int insertEqMechanicalData(EqMechanicalData eqMechanicalData) {
        return eqMechanicalDataMapper.insertEqMechanicalData(eqMechanicalData);
    }
    @Override
    public int updateEqMechanicalData(EqMechanicalData eqMechanicalData) {
        return eqMechanicalDataMapper.updateEqMechanicalData(eqMechanicalData);
    }
    @Override
    public int deleteEqMechanicalDataByMechanicalIds(Long[] mechanicalIds) {
        return eqMechanicalDataMapper.deleteEqMechanicalDataByMechanicalIds(mechanicalIds);
    }
    @Override
    public int deleteEqMechanicalDataByMechanicalId(Long mechanicalId) {
        return eqMechanicalDataMapper.deleteEqMechanicalDataByMechanicalId(mechanicalId);
    }
    @Override
    public int deleteEqMechanicalDataByDeviceId(Long deviceId) {
        return eqMechanicalDataMapper.deleteEqMechanicalDataByDeviceId(deviceId);
    }
    @Override
    public int deleteEqMechanicalDataByDeviceIds(Long[] deviceIds) {
        return eqMechanicalDataMapper.deleteEqMechanicalDataByDeviceIds(deviceIds);
    }
}
