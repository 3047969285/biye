package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.MeterDl645Sample;
import org.apache.ibatis.annotations.Param;

import java.util.Date;
import java.util.List;

/**
 * DL/T645-2007 采样 Mapper
 */
public interface MeterDl645SampleMapper {

    int insertMeterDl645Sample(MeterDl645Sample row);

    List<MeterDl645Sample> selectMeterDl645SampleList(MeterDl645Sample query);

    List<MeterDl645Sample> selectLatestByRange(@Param("beginTime") Date beginTime, @Param("endTime") Date endTime);
}
