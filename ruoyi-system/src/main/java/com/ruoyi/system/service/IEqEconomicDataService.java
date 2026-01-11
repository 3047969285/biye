package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.EqEconomicData;

public interface IEqEconomicDataService {
    List<EqEconomicData> selectEqEconomicDataList(EqEconomicData eqEconomicData);
    EqEconomicData selectEqEconomicDataByEconomicId(Long economicId);
    List<EqEconomicData> selectEqEconomicDataListByDeviceId(Long deviceId);
    int insertEqEconomicData(EqEconomicData eqEconomicData);
    int updateEqEconomicData(EqEconomicData eqEconomicData);
    int deleteEqEconomicDataByEconomicIds(Long[] economicIds);
    int deleteEqEconomicDataByEconomicId(Long economicId);
    int deleteEqEconomicDataByDeviceId(Long deviceId);
    int deleteEqEconomicDataByDeviceIds(Long[] deviceIds);
}
