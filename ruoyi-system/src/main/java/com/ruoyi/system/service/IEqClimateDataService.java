package com.ruoyi.system.service;
import java.util.List;
import com.ruoyi.system.domain.EqClimateData;
public interface IEqClimateDataService {
    List<EqClimateData> selectEqClimateDataList(EqClimateData eqClimateData);
    EqClimateData selectEqClimateDataByClimateId(Long climateId);
    List<EqClimateData> selectEqClimateDataListByDeviceId(Long deviceId);
    int insertEqClimateData(EqClimateData eqClimateData);
    int updateEqClimateData(EqClimateData eqClimateData);
    int deleteEqClimateDataByClimateIds(Long[] climateIds);
    int deleteEqClimateDataByClimateId(Long climateId);
    int deleteEqClimateDataByDeviceId(Long deviceId);
    int deleteEqClimateDataByDeviceIds(Long[] deviceIds);
}
