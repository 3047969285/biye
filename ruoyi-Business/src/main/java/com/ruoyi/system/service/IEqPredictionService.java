package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.EqPrediction;

public interface IEqPredictionService {

    List<EqPrediction> selectEqPredictionList(EqPrediction query);

    EqPrediction selectEqPredictionByPredictionId(Long predictionId);

    List<EqPrediction> selectEqPredictionListByDeviceId(String deviceId);

    int insertEqPrediction(EqPrediction row);

    int updateEqPrediction(EqPrediction row);

    int deleteEqPredictionByPredictionIds(Long[] predictionIds);

    int deleteEqPredictionByPredictionId(Long predictionId);

    int deleteEqPredictionByDeviceId(String deviceId);

    int deleteEqPredictionByDeviceIds(String[] deviceIds);
}
