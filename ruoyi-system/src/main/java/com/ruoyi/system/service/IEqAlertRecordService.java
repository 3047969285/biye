package com.ruoyi.system.service;
import java.util.List;
import com.ruoyi.system.domain.EqAlertRecord;
public interface IEqAlertRecordService {
    List<EqAlertRecord> selectEqAlertRecordList(EqAlertRecord eqAlertRecord);
    EqAlertRecord selectEqAlertRecordByAlertId(Long alertId);
    List<EqAlertRecord> selectEqAlertRecordListByDeviceId(Long deviceId);
    int insertEqAlertRecord(EqAlertRecord eqAlertRecord);
    int updateEqAlertRecord(EqAlertRecord eqAlertRecord);
    int deleteEqAlertRecordByAlertIds(Long[] alertIds);
    int deleteEqAlertRecordByAlertId(Long alertId);
    int deleteEqAlertRecordByDeviceId(Long deviceId);
    int deleteEqAlertRecordByDeviceIds(Long[] deviceIds);
}
