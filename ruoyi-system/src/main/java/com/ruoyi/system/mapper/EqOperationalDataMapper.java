package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.EqOperationalData;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface EqOperationalDataMapper {
    List<EqOperationalData> selectEqOperationalDataList(EqOperationalData eqOperationalData);
    EqOperationalData selectEqOperationalDataByOperationalId(@Param("operationalId") Long operationalId);
    List<EqOperationalData> selectEqOperationalDataListByDeviceId(@Param("deviceId") Long deviceId);
    int insertEqOperationalData(EqOperationalData eqOperationalData);
    int updateEqOperationalData(EqOperationalData eqOperationalData);
    int deleteEqOperationalDataByOperationalId(@Param("operationalId") Long operationalId);
    int deleteEqOperationalDataByOperationalIds(@Param("operationalIds") Long[] operationalIds);
    int deleteEqOperationalDataByDeviceId(@Param("deviceId") Long deviceId);
    int deleteEqOperationalDataByDeviceIds(@Param("deviceIds") Long[] deviceIds);
}
