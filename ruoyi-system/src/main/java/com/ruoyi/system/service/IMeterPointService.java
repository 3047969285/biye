package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.MeterPoint;

/**
 * 电表点表
 */
public interface IMeterPointService {

    MeterPoint selectById(Long pointId);

    List<MeterPoint> selectList(MeterPoint query);

    int insert(MeterPoint row);

    int update(MeterPoint row);

    int deleteByIds(Long[] pointIds);

    String importPoints(List<MeterPoint> list, boolean updateSupport, String operName);
}
