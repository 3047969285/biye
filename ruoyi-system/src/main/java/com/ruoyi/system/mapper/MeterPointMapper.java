package com.ruoyi.system.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.system.domain.MeterPoint;

/**
 * 电表点表 Mapper
 */
public interface MeterPointMapper {

    MeterPoint selectMeterPointById(Long pointId);

    MeterPoint selectByPointCode(@Param("pointCode") String pointCode);

    List<MeterPoint> selectMeterPointList(MeterPoint query);

    List<MeterPoint> selectActivePoints();

    int insertMeterPoint(MeterPoint row);

    int updateMeterPoint(MeterPoint row);

    int deleteMeterPointById(Long pointId);

    int deleteMeterPointByIds(Long[] pointIds);

    int insertMeterPointBatch(List<MeterPoint> list);
}
