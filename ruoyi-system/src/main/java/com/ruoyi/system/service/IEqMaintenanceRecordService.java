package com.ruoyi.system.service;
import java.util.List;
import com.ruoyi.system.domain.EqMaintenanceRecord;
public interface IEqMaintenanceRecordService {
    List<EqMaintenanceRecord> selectEqMaintenanceRecordList(EqMaintenanceRecord eqMaintenanceRecord);
    EqMaintenanceRecord selectEqMaintenanceRecordByRecordId(Long recordId);
    List<EqMaintenanceRecord> selectEqMaintenanceRecordListByDeviceId(Long deviceId);
    int insertEqMaintenanceRecord(EqMaintenanceRecord eqMaintenanceRecord);
    int updateEqMaintenanceRecord(EqMaintenanceRecord eqMaintenanceRecord);
    int deleteEqMaintenanceRecordByRecordIds(Long[] recordIds);
    int deleteEqMaintenanceRecordByRecordId(Long recordId);
    int deleteEqMaintenanceRecordByDeviceId(Long deviceId);
    int deleteEqMaintenanceRecordByDeviceIds(Long[] deviceIds);
}
