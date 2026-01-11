package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.EqEconomicData;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface EqEconomicDataMapper {
    List<EqEconomicData> selectEqEconomicDataList(EqEconomicData eqEconomicData);
    EqEconomicData selectEqEconomicDataByEconomicId(@Param("economicId") Long economicId);
    List<EqEconomicData> selectEqEconomicDataListByDeviceId(@Param("deviceId") Long deviceId);
    int insertEqEconomicData(EqEconomicData eqEconomicData);
    int updateEqEconomicData(EqEconomicData eqEconomicData);
    int deleteEqEconomicDataByEconomicId(@Param("economicId") Long economicId);
    int deleteEqEconomicDataByEconomicIds(@Param("economicIds") Long[] economicIds);
    int deleteEqEconomicDataByDeviceId(@Param("deviceId") Long deviceId);
    int deleteEqEconomicDataByDeviceIds(@Param("deviceIds") Long[] deviceIds);
}
