package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.EqTechnologyData;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface EqTechnologyDataMapper {
    List<EqTechnologyData> selectEqTechnologyDataList(EqTechnologyData eqTechnologyData);
    EqTechnologyData selectEqTechnologyDataByTechId(@Param("techId") Long techId);
    List<EqTechnologyData> selectEqTechnologyDataListByDeviceId(@Param("deviceId") Long deviceId);
    int insertEqTechnologyData(EqTechnologyData eqTechnologyData);
    int updateEqTechnologyData(EqTechnologyData eqTechnologyData);
    int deleteEqTechnologyDataByTechId(@Param("techId") Long techId);
    int deleteEqTechnologyDataByTechIds(@Param("techIds") Long[] techIds);
    int deleteEqTechnologyDataByDeviceId(@Param("deviceId") Long deviceId);
    int deleteEqTechnologyDataByDeviceIds(@Param("deviceIds") Long[] deviceIds);
}
