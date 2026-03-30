package com.ruoyi.system.service;

import java.util.Date;
import java.util.List;
import com.ruoyi.system.domain.MeterPoint;
import com.ruoyi.system.domain.vo.MeterPointSummaryVo;

/**
 * 电表数据：寄存器入库与汇总查询
 */
public interface IMeterModbusDataService {

    /**
     * 按基址与寄存器数组写入采样（根据点表匹配 slave、寄存器类型、偏移）
     */
    int ingestRegisters(int slaveId, int registerType, int baseAddress, int[] registers, Date readTime, String source);

    List<MeterPointSummaryVo> querySummary(Date beginTime, Date endTime, String pointCode);

    List<MeterPoint> listPublicPoints();
}
