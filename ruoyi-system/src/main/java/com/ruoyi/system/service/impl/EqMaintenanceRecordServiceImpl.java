package com.ruoyi.system.service.impl;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.EqMaintenanceRecordMapper;
import com.ruoyi.system.domain.EqMaintenanceRecord;
import com.ruoyi.system.service.IEqMaintenanceRecordService;
@Service
public class EqMaintenanceRecordServiceImpl implements IEqMaintenanceRecordService {
    @Autowired
    private EqMaintenanceRecordMapper eqMaintenanceRecordMapper;
    @Override
    public List<EqMaintenanceRecord> selectEqMaintenanceRecordList(EqMaintenanceRecord eqMaintenanceRecord) {
        return eqMaintenanceRecordMapper.selectEqMaintenanceRecordList(eqMaintenanceRecord);
    }
    @Override
    public EqMaintenanceRecord selectEqMaintenanceRecordByRecordId(Long recordId) {
        return eqMaintenanceRecordMapper.selectEqMaintenanceRecordByRecordId(recordId);
    }
    @Override
    public List<EqMaintenanceRecord> selectEqMaintenanceRecordListByDeviceId(Long deviceId) {
        return eqMaintenanceRecordMapper.selectEqMaintenanceRecordListByDeviceId(deviceId);
    }
    @Override
    public int insertEqMaintenanceRecord(EqMaintenanceRecord eqMaintenanceRecord) {
        return eqMaintenanceRecordMapper.insertEqMaintenanceRecord(eqMaintenanceRecord);
    }
    @Override
    public int updateEqMaintenanceRecord(EqMaintenanceRecord eqMaintenanceRecord) {
        return eqMaintenanceRecordMapper.updateEqMaintenanceRecord(eqMaintenanceRecord);
    }
    @Override
    public int deleteEqMaintenanceRecordByRecordIds(Long[] recordIds) {
        return eqMaintenanceRecordMapper.deleteEqMaintenanceRecordByRecordIds(recordIds);
    }
    @Override
    public int deleteEqMaintenanceRecordByRecordId(Long recordId) {
        return eqMaintenanceRecordMapper.deleteEqMaintenanceRecordByRecordId(recordId);
    }
    @Override
    public int deleteEqMaintenanceRecordByDeviceId(Long deviceId) {
        return eqMaintenanceRecordMapper.deleteEqMaintenanceRecordByDeviceId(deviceId);
    }
    @Override
    public int deleteEqMaintenanceRecordByDeviceIds(Long[] deviceIds) {
        return eqMaintenanceRecordMapper.deleteEqMaintenanceRecordByDeviceIds(deviceIds);
    }
}
