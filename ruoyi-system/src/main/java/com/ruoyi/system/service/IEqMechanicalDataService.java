package com.ruoyi.system.service;
import java.util.List;
import com.ruoyi.system.domain.EqMechanicalData;
public interface IEqMechanicalDataService {
    List<EqMechanicalData> selectEqMechanicalDataList(EqMechanicalData eqMechanicalData);
    EqMechanicalData selectEqMechanicalDataByMechanicalId(Long mechanicalId);
    List<EqMechanicalData> selectEqMechanicalDataListByDeviceId(Long deviceId);
    int insertEqMechanicalData(EqMechanicalData eqMechanicalData);
    int updateEqMechanicalData(EqMechanicalData eqMechanicalData);
    int deleteEqMechanicalDataByMechanicalIds(Long[] mechanicalIds);
    int deleteEqMechanicalDataByMechanicalId(Long mechanicalId);
    int deleteEqMechanicalDataByDeviceId(Long deviceId);
    int deleteEqMechanicalDataByDeviceIds(Long[] deviceIds);
}
