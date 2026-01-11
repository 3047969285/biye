package com.ruoyi.system.service;
import java.util.List;
import com.ruoyi.system.domain.EqElectricalData;
public interface IEqElectricalDataService {
    List<EqElectricalData> selectEqElectricalDataList(EqElectricalData eqElectricalData);
    EqElectricalData selectEqElectricalDataByElectricalId(Long electricalId);
    List<EqElectricalData> selectEqElectricalDataListByDeviceId(Long deviceId);
    int insertEqElectricalData(EqElectricalData eqElectricalData);
    int updateEqElectricalData(EqElectricalData eqElectricalData);
    int deleteEqElectricalDataByElectricalIds(Long[] electricalIds);
    int deleteEqElectricalDataByElectricalId(Long electricalId);
    int deleteEqElectricalDataByDeviceId(Long deviceId);
    int deleteEqElectricalDataByDeviceIds(Long[] deviceIds);
}
