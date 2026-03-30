package com.ruoyi.system.mapper;

import java.util.Date;
import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.system.domain.MeterSample;
import com.ruoyi.system.domain.vo.MeterPointSummaryVo;

/**
 * 电表采样 Mapper
 */
public interface MeterSampleMapper {

    int insertMeterSample(MeterSample row);

    int insertMeterSampleBatch(List<MeterSample> list);

    List<MeterPointSummaryVo> selectSummaryByTimeRange(
        @Param("beginTime") Date beginTime,
        @Param("endTime") Date endTime,
        @Param("pointCode") String pointCode);
}
