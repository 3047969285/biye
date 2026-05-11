package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.domain.EqPrediction;
import com.ruoyi.system.mapper.EqPredictionMapper;
import com.ruoyi.system.service.IEqPredictionService;

@Service
public class EqPredictionServiceImpl implements IEqPredictionService {

    @Autowired
    private EqPredictionMapper eqPredictionMapper;

    @Override
    public List<EqPrediction> selectEqPredictionList(EqPrediction query) {
        return eqPredictionMapper.selectEqPredictionList(query);
    }

    @Override
    public EqPrediction selectEqPredictionByPredictionId(Long predictionId) {
        return eqPredictionMapper.selectEqPredictionByPredictionId(predictionId);
    }

    @Override
    public List<EqPrediction> selectEqPredictionListByDeviceId(String deviceId) {
        return eqPredictionMapper.selectEqPredictionListByDeviceId(deviceId);
    }

    @Override
    public int insertEqPrediction(EqPrediction row) {
        return eqPredictionMapper.insertEqPrediction(row);
    }

    @Override
    public int updateEqPrediction(EqPrediction row) {
        return eqPredictionMapper.updateEqPrediction(row);
    }

    @Override
    public int deleteEqPredictionByPredictionIds(Long[] predictionIds) {
        return eqPredictionMapper.deleteEqPredictionByPredictionIds(predictionIds);
    }

    @Override
    public int deleteEqPredictionByPredictionId(Long predictionId) {
        return eqPredictionMapper.deleteEqPredictionByPredictionId(predictionId);
    }

    @Override
    public int deleteEqPredictionByDeviceId(String deviceId) {
        return eqPredictionMapper.deleteEqPredictionByDeviceId(deviceId);
    }

    @Override
    public int deleteEqPredictionByDeviceIds(String[] deviceIds) {
        return eqPredictionMapper.deleteEqPredictionByDeviceIds(deviceIds);
    }
}
