package com.ruoyi.system.service.impl;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.EqFaultRecordMapper;
import com.ruoyi.system.domain.EqFaultRecord;
import com.ruoyi.system.service.IEqFaultRecordService;
@Service
public class EqFaultRecordServiceImpl implements IEqFaultRecordService {
    @Autowired
    private EqFaultRecordMapper eqFaultRecordMapper;
    @Override
    public List<EqFaultRecord> selectEqFaultRecordList(EqFaultRecord eqFaultRecord) {
        return eqFaultRecordMapper.selectEqFaultRecordList(eqFaultRecord);
    }
    @Override
    public EqFaultRecord selectEqFaultRecordByFaultId(Long faultId) {
        return eqFaultRecordMapper.selectEqFaultRecordByFaultId(faultId);
    }
    @Override
    public List<EqFaultRecord> selectEqFaultRecordListByDeviceId(Long deviceId) {
        return eqFaultRecordMapper.selectEqFaultRecordListByDeviceId(deviceId);
    }
    @Override
    public int insertEqFaultRecord(EqFaultRecord eqFaultRecord) {
        return eqFaultRecordMapper.insertEqFaultRecord(eqFaultRecord);
    }
    @Override
    public int updateEqFaultRecord(EqFaultRecord eqFaultRecord) {
        return eqFaultRecordMapper.updateEqFaultRecord(eqFaultRecord);
    }
    @Override
    public int deleteEqFaultRecordByFaultIds(Long[] faultIds) {
        return eqFaultRecordMapper.deleteEqFaultRecordByFaultIds(faultIds);
    }
    @Override
    public int deleteEqFaultRecordByFaultId(Long faultId) {
        return eqFaultRecordMapper.deleteEqFaultRecordByFaultId(faultId);
    }
    @Override
    public int deleteEqFaultRecordByDeviceId(Long deviceId) {
        return eqFaultRecordMapper.deleteEqFaultRecordByDeviceId(deviceId);
    }
    @Override
    public int deleteEqFaultRecordByDeviceIds(Long[] deviceIds) {
        return eqFaultRecordMapper.deleteEqFaultRecordByDeviceIds(deviceIds);
    }
}
