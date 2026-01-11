package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.EqEconomicDataMapper;
import com.ruoyi.system.domain.EqEconomicData;
import com.ruoyi.system.service.IEqEconomicDataService;

@Service
public class EqEconomicDataServiceImpl implements IEqEconomicDataService {
    @Autowired
    private EqEconomicDataMapper eqEconomicDataMapper;

    @Override
    public List<EqEconomicData> selectEqEconomicDataList(EqEconomicData eqEconomicData) {
        return eqEconomicDataMapper.selectEqEconomicDataList(eqEconomicData);
    }

    @Override
    public EqEconomicData selectEqEconomicDataByEconomicId(Long economicId) {
        return eqEconomicDataMapper.selectEqEconomicDataByEconomicId(economicId);
    }

    @Override
    public List<EqEconomicData> selectEqEconomicDataListByDeviceId(Long deviceId) {
        return eqEconomicDataMapper.selectEqEconomicDataListByDeviceId(deviceId);
    }

    @Override
    public int insertEqEconomicData(EqEconomicData eqEconomicData) {
        return eqEconomicDataMapper.insertEqEconomicData(eqEconomicData);
    }

    @Override
    public int updateEqEconomicData(EqEconomicData eqEconomicData) {
        return eqEconomicDataMapper.updateEqEconomicData(eqEconomicData);
    }

    @Override
    public int deleteEqEconomicDataByEconomicIds(Long[] economicIds) {
        return eqEconomicDataMapper.deleteEqEconomicDataByEconomicIds(economicIds);
    }

    @Override
    public int deleteEqEconomicDataByEconomicId(Long economicId) {
        return eqEconomicDataMapper.deleteEqEconomicDataByEconomicId(economicId);
    }

    @Override
    public int deleteEqEconomicDataByDeviceId(Long deviceId) {
        return eqEconomicDataMapper.deleteEqEconomicDataByDeviceId(deviceId);
    }

    @Override
    public int deleteEqEconomicDataByDeviceIds(Long[] deviceIds) {
        return eqEconomicDataMapper.deleteEqEconomicDataByDeviceIds(deviceIds);
    }
}
