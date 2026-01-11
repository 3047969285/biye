package com.ruoyi.system.service;
import java.util.List;
import com.ruoyi.system.domain.EqFaultRecord;
public interface IEqFaultRecordService {
    List<EqFaultRecord> selectEqFaultRecordList(EqFaultRecord eqFaultRecord);
    EqFaultRecord selectEqFaultRecordByFaultId(Long faultId);
    List<EqFaultRecord> selectEqFaultRecordListByDeviceId(Long deviceId);
    int insertEqFaultRecord(EqFaultRecord eqFaultRecord);
    int updateEqFaultRecord(EqFaultRecord eqFaultRecord);
    int deleteEqFaultRecordByFaultIds(Long[] faultIds);
    int deleteEqFaultRecordByFaultId(Long faultId);
    int deleteEqFaultRecordByDeviceId(Long deviceId);
    int deleteEqFaultRecordByDeviceIds(Long[] deviceIds);
}
