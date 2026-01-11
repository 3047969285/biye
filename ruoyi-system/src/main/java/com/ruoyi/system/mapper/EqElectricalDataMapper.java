package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.EqElectricalData;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface EqElectricalDataMapper {
    List<EqElectricalData> selectEqElectricalDataList(EqElectricalData eqElectricalData);
    EqElectricalData selectEqElectricalDataByElectricalId(@Param("electricalId") Long electricalId);
    List<EqElectricalData> selectEqElectricalDataListByDeviceId(@Param("deviceId") Long deviceId);
    int insertEqElectricalData(EqElectricalData eqElectricalData);
    int updateEqElectricalData(EqElectricalData eqElectricalData);
    int deleteEqElectricalDataByElectricalId(@Param("electricalId") Long electricalId);
    int deleteEqElectricalDataByElectricalIds(@Param("electricalIds") Long[] electricalIds);
    int deleteEqElectricalDataByDeviceId(@Param("deviceId") Long deviceId);
    int deleteEqElectricalDataByDeviceIds(@Param("deviceIds") Long[] deviceIds);
}
