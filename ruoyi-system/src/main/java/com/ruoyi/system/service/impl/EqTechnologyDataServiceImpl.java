package com.ruoyi.system.service.impl;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.EqTechnologyDataMapper;
import com.ruoyi.system.domain.EqTechnologyData;
import com.ruoyi.system.service.IEqTechnologyDataService;
@Service
public class EqTechnologyDataServiceImpl implements IEqTechnologyDataService {
    @Autowired
    private EqTechnologyDataMapper eqTechnologyDataMapper;
    @Override
    public List<EqTechnologyData> selectEqTechnologyDataList(EqTechnologyData eqTechnologyData) {
        return eqTechnologyDataMapper.selectEqTechnologyDataList(eqTechnologyData);
    }
    @Override
    public EqTechnologyData selectEqTechnologyDataByTechId(Long techId) {
        return eqTechnologyDataMapper.selectEqTechnologyDataByTechId(techId);
    }
    @Override
    public List<EqTechnologyData> selectEqTechnologyDataListByDeviceId(Long deviceId) {
        return eqTechnologyDataMapper.selectEqTechnologyDataListByDeviceId(deviceId);
    }
    @Override
    public int insertEqTechnologyData(EqTechnologyData eqTechnologyData) {
        return eqTechnologyDataMapper.insertEqTechnologyData(eqTechnologyData);
    }
    @Override
    public int updateEqTechnologyData(EqTechnologyData eqTechnologyData) {
        return eqTechnologyDataMapper.updateEqTechnologyData(eqTechnologyData);
    }
    @Override
    public int deleteEqTechnologyDataByTechIds(Long[] techIds) {
        return eqTechnologyDataMapper.deleteEqTechnologyDataByTechIds(techIds);
    }
    @Override
    public int deleteEqTechnologyDataByTechId(Long techId) {
        return eqTechnologyDataMapper.deleteEqTechnologyDataByTechId(techId);
    }
    @Override
    public int deleteEqTechnologyDataByDeviceId(Long deviceId) {
        return eqTechnologyDataMapper.deleteEqTechnologyDataByDeviceId(deviceId);
    }
    @Override
    public int deleteEqTechnologyDataByDeviceIds(Long[] deviceIds) {
        return eqTechnologyDataMapper.deleteEqTechnologyDataByDeviceIds(deviceIds);
    }
}
