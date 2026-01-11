package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.EqClimateData;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface EqClimateDataMapper {
    List<EqClimateData> selectEqClimateDataList(EqClimateData eqClimateData);
    EqClimateData selectEqClimateDataByClimateId(@Param("climateId") Long climateId);
    List<EqClimateData> selectEqClimateDataListByDeviceId(@Param("deviceId") Long deviceId);
    int insertEqClimateData(EqClimateData eqClimateData);
    int updateEqClimateData(EqClimateData eqClimateData);
    int deleteEqClimateDataByClimateId(@Param("climateId") Long climateId);
    int deleteEqClimateDataByClimateIds(@Param("climateIds") Long[] climateIds);
    int deleteEqClimateDataByDeviceId(@Param("deviceId") Long deviceId);
    int deleteEqClimateDataByDeviceIds(@Param("deviceIds") Long[] deviceIds);
}
