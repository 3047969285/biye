package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.EqPrediction;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface EqPredictionMapper {

    List<EqPrediction> selectEqPredictionList(EqPrediction query);

    EqPrediction selectEqPredictionByPredictionId(@Param("predictionId") Long predictionId);

    List<EqPrediction> selectEqPredictionListByDeviceId(@Param("deviceId") String deviceId);

    int insertEqPrediction(EqPrediction row);

    int updateEqPrediction(EqPrediction row);

    int deleteEqPredictionByPredictionId(@Param("predictionId") Long predictionId);

    int deleteEqPredictionByPredictionIds(@Param("predictionIds") Long[] predictionIds);

    int deleteEqPredictionByDeviceId(@Param("deviceId") String deviceId);

    int deleteEqPredictionByDeviceIds(@Param("deviceIds") String[] deviceIds);
}
