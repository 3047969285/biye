package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.EqMechanicalData;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface EqMechanicalDataMapper {
    List<EqMechanicalData> selectEqMechanicalDataList(EqMechanicalData eqMechanicalData);
    EqMechanicalData selectEqMechanicalDataByMechanicalId(@Param("mechanicalId") Long mechanicalId);
    List<EqMechanicalData> selectEqMechanicalDataListByDeviceId(@Param("deviceId") Long deviceId);
    int insertEqMechanicalData(EqMechanicalData eqMechanicalData);
    int updateEqMechanicalData(EqMechanicalData eqMechanicalData);
    int deleteEqMechanicalDataByMechanicalId(@Param("mechanicalId") Long mechanicalId);
    int deleteEqMechanicalDataByMechanicalIds(@Param("mechanicalIds") Long[] mechanicalIds);
    int deleteEqMechanicalDataByDeviceId(@Param("deviceId") Long deviceId);
    int deleteEqMechanicalDataByDeviceIds(@Param("deviceIds") Long[] deviceIds);
}
