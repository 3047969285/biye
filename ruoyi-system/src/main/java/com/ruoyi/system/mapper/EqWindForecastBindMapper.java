package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.EqWindForecastBind;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface EqWindForecastBindMapper {

    EqWindForecastBind selectByDeviceId(@Param("deviceId") Long deviceId);

    int insertEqWindForecastBind(EqWindForecastBind row);

    int updateEqWindForecastBind(EqWindForecastBind row);
}
