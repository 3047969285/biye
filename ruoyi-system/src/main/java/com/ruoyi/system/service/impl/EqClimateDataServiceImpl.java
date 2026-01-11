package com.ruoyi.system.service.impl;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.EqClimateDataMapper;
import com.ruoyi.system.domain.EqClimateData;
import com.ruoyi.system.service.IEqClimateDataService;
@Service
public class EqClimateDataServiceImpl implements IEqClimateDataService {
    @Autowired
    private EqClimateDataMapper eqClimateDataMapper;
    @Override
    public List<EqClimateData> selectEqClimateDataList(EqClimateData eqClimateData) {
        return eqClimateDataMapper.selectEqClimateDataList(eqClimateData);
    }
    @Override
    public EqClimateData selectEqClimateDataByClimateId(Long climateId) {
        return eqClimateDataMapper.selectEqClimateDataByClimateId(climateId);
    }
    @Override
    public List<EqClimateData> selectEqClimateDataListByDeviceId(Long deviceId) {
        return eqClimateDataMapper.selectEqClimateDataListByDeviceId(deviceId);
    }
    @Override
    public int insertEqClimateData(EqClimateData eqClimateData) {
        return eqClimateDataMapper.insertEqClimateData(eqClimateData);
    }
    @Override
    public int updateEqClimateData(EqClimateData eqClimateData) {
        return eqClimateDataMapper.updateEqClimateData(eqClimateData);
    }
    @Override
    public int deleteEqClimateDataByClimateIds(Long[] climateIds) {
        return eqClimateDataMapper.deleteEqClimateDataByClimateIds(climateIds);
    }
    @Override
    public int deleteEqClimateDataByClimateId(Long climateId) {
        return eqClimateDataMapper.deleteEqClimateDataByClimateId(climateId);
    }
    @Override
    public int deleteEqClimateDataByDeviceId(Long deviceId) {
        return eqClimateDataMapper.deleteEqClimateDataByDeviceId(deviceId);
    }
    @Override
    public int deleteEqClimateDataByDeviceIds(Long[] deviceIds) {
        return eqClimateDataMapper.deleteEqClimateDataByDeviceIds(deviceIds);
    }
}
