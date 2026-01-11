package com.ruoyi.system.service.impl;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.EqOperationalDataMapper;
import com.ruoyi.system.domain.EqOperationalData;
import com.ruoyi.system.service.IEqOperationalDataService;
@Service
public class EqOperationalDataServiceImpl implements IEqOperationalDataService {
    @Autowired
    private EqOperationalDataMapper eqOperationalDataMapper;
    @Override
    public List<EqOperationalData> selectEqOperationalDataList(EqOperationalData eqOperationalData) {
        return eqOperationalDataMapper.selectEqOperationalDataList(eqOperationalData);
    }
    @Override
    public EqOperationalData selectEqOperationalDataByOperationalId(Long operationalId) {
        return eqOperationalDataMapper.selectEqOperationalDataByOperationalId(operationalId);
    }
    @Override
    public List<EqOperationalData> selectEqOperationalDataListByDeviceId(Long deviceId) {
        return eqOperationalDataMapper.selectEqOperationalDataListByDeviceId(deviceId);
    }
    @Override
    public int insertEqOperationalData(EqOperationalData eqOperationalData) {
        return eqOperationalDataMapper.insertEqOperationalData(eqOperationalData);
    }
    @Override
    public int updateEqOperationalData(EqOperationalData eqOperationalData) {
        return eqOperationalDataMapper.updateEqOperationalData(eqOperationalData);
    }
    @Override
    public int deleteEqOperationalDataByOperationalIds(Long[] operationalIds) {
        return eqOperationalDataMapper.deleteEqOperationalDataByOperationalIds(operationalIds);
    }
    @Override
    public int deleteEqOperationalDataByOperationalId(Long operationalId) {
        return eqOperationalDataMapper.deleteEqOperationalDataByOperationalId(operationalId);
    }
    @Override
    public int deleteEqOperationalDataByDeviceId(Long deviceId) {
        return eqOperationalDataMapper.deleteEqOperationalDataByDeviceId(deviceId);
    }
    @Override
    public int deleteEqOperationalDataByDeviceIds(Long[] deviceIds) {
        return eqOperationalDataMapper.deleteEqOperationalDataByDeviceIds(deviceIds);
    }
}
