package com.ruoyi.system.service;
import java.util.List;
import com.ruoyi.system.domain.EqOperationalData;
public interface IEqOperationalDataService {
    List<EqOperationalData> selectEqOperationalDataList(EqOperationalData eqOperationalData);
    EqOperationalData selectEqOperationalDataByOperationalId(Long operationalId);
    List<EqOperationalData> selectEqOperationalDataListByDeviceId(Long deviceId);
    int insertEqOperationalData(EqOperationalData eqOperationalData);
    int updateEqOperationalData(EqOperationalData eqOperationalData);
    int deleteEqOperationalDataByOperationalIds(Long[] operationalIds);
    int deleteEqOperationalDataByOperationalId(Long operationalId);
    int deleteEqOperationalDataByDeviceId(Long deviceId);
    int deleteEqOperationalDataByDeviceIds(Long[] deviceIds);
}
