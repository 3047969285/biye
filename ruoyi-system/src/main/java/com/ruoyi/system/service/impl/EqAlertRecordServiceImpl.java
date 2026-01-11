package com.ruoyi.system.service.impl;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.EqAlertRecordMapper;
import com.ruoyi.system.domain.EqAlertRecord;
import com.ruoyi.system.service.IEqAlertRecordService;
@Service
public class EqAlertRecordServiceImpl implements IEqAlertRecordService {
    @Autowired
    private EqAlertRecordMapper eqAlertRecordMapper;
    @Override
    public List<EqAlertRecord> selectEqAlertRecordList(EqAlertRecord eqAlertRecord) {
        return eqAlertRecordMapper.selectEqAlertRecordList(eqAlertRecord);
    }
    @Override
    public EqAlertRecord selectEqAlertRecordByAlertId(Long alertId) {
        return eqAlertRecordMapper.selectEqAlertRecordByAlertId(alertId);
    }
    @Override
    public List<EqAlertRecord> selectEqAlertRecordListByDeviceId(Long deviceId) {
        return eqAlertRecordMapper.selectEqAlertRecordListByDeviceId(deviceId);
    }
    @Override
    public int insertEqAlertRecord(EqAlertRecord eqAlertRecord) {
        return eqAlertRecordMapper.insertEqAlertRecord(eqAlertRecord);
    }
    @Override
    public int updateEqAlertRecord(EqAlertRecord eqAlertRecord) {
        return eqAlertRecordMapper.updateEqAlertRecord(eqAlertRecord);
    }
    @Override
    public int deleteEqAlertRecordByAlertIds(Long[] alertIds) {
        return eqAlertRecordMapper.deleteEqAlertRecordByAlertIds(alertIds);
    }
    @Override
    public int deleteEqAlertRecordByAlertId(Long alertId) {
        return eqAlertRecordMapper.deleteEqAlertRecordByAlertId(alertId);
    }
    @Override
    public int deleteEqAlertRecordByDeviceId(Long deviceId) {
        return eqAlertRecordMapper.deleteEqAlertRecordByDeviceId(deviceId);
    }
    @Override
    public int deleteEqAlertRecordByDeviceIds(Long[] deviceIds) {
        return eqAlertRecordMapper.deleteEqAlertRecordByDeviceIds(deviceIds);
    }
}
