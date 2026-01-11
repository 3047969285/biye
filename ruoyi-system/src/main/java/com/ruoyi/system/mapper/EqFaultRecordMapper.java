package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.EqFaultRecord;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface EqFaultRecordMapper {
    List<EqFaultRecord> selectEqFaultRecordList(EqFaultRecord eqFaultRecord);
    EqFaultRecord selectEqFaultRecordByFaultId(@Param("faultId") Long faultId);
    List<EqFaultRecord> selectEqFaultRecordListByDeviceId(@Param("deviceId") Long deviceId);
    int insertEqFaultRecord(EqFaultRecord eqFaultRecord);
    int updateEqFaultRecord(EqFaultRecord eqFaultRecord);
    int deleteEqFaultRecordByFaultId(@Param("faultId") Long faultId);
    int deleteEqFaultRecordByFaultIds(@Param("faultIds") Long[] faultIds);
    int deleteEqFaultRecordByDeviceId(@Param("deviceId") Long deviceId);
    int deleteEqFaultRecordByDeviceIds(@Param("deviceIds") Long[] deviceIds);
}
