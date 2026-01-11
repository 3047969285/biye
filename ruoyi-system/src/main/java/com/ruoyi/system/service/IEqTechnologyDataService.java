package com.ruoyi.system.service;
import java.util.List;
import com.ruoyi.system.domain.EqTechnologyData;
public interface IEqTechnologyDataService {
    List<EqTechnologyData> selectEqTechnologyDataList(EqTechnologyData eqTechnologyData);
    EqTechnologyData selectEqTechnologyDataByTechId(Long techId);
    List<EqTechnologyData> selectEqTechnologyDataListByDeviceId(Long deviceId);
    int insertEqTechnologyData(EqTechnologyData eqTechnologyData);
    int updateEqTechnologyData(EqTechnologyData eqTechnologyData);
    int deleteEqTechnologyDataByTechIds(Long[] techIds);
    int deleteEqTechnologyDataByTechId(Long techId);
    int deleteEqTechnologyDataByDeviceId(Long deviceId);
    int deleteEqTechnologyDataByDeviceIds(Long[] deviceIds);
}
