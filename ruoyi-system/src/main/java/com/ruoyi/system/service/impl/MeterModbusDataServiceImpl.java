package com.ruoyi.system.service.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.system.domain.MeterPoint;
import com.ruoyi.system.domain.MeterSample;
import com.ruoyi.system.domain.vo.MeterPointSummaryVo;
import com.ruoyi.system.mapper.MeterPointMapper;
import com.ruoyi.system.mapper.MeterSampleMapper;
import com.ruoyi.system.service.IMeterModbusDataService;
import com.ruoyi.system.util.MeterRegisterCodec;

/**
 * 寄存器入库与汇总
 */
@Service
public class MeterModbusDataServiceImpl implements IMeterModbusDataService {

    private final MeterPointMapper meterPointMapper;
    private final MeterSampleMapper meterSampleMapper;

    public MeterModbusDataServiceImpl(MeterPointMapper meterPointMapper, MeterSampleMapper meterSampleMapper) {
        this.meterPointMapper = meterPointMapper;
        this.meterSampleMapper = meterSampleMapper;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int ingestRegisters(int slaveId, int registerType, int baseAddress, int[] registers, Date readTime, String source) {
        if (registers == null || registers.length == 0) {
            return 0;
        }
        List<MeterPoint> all = meterPointMapper.selectActivePoints();
        List<MeterSample> batch = new ArrayList<>();
        for (MeterPoint p : all) {
            if (p.getSlaveId() == null || p.getRegisterType() == null) {
                continue;
            }
            if (p.getSlaveId() != slaveId || p.getRegisterType() != registerType) {
                continue;
            }
            int rel = p.getAddrOffset() - baseAddress;
            if (rel < 0) {
                continue;
            }
            int span = MeterRegisterCodec.registerSpan(p.getDataType());
            if (rel + span > registers.length) {
                continue;
            }
            double[] decoded = MeterRegisterCodec.decodeToScaled(p, registers, rel);
            if (decoded == null) {
                continue;
            }
            MeterSample s = new MeterSample();
            s.setPointId(p.getPointId());
            s.setReadTime(readTime != null ? readTime : new Date());
            s.setValueRaw((long) decoded[0]);
            s.setValueScaled(decoded[1]);
            s.setSource(source);
            batch.add(s);
        }
        if (batch.isEmpty()) {
            return 0;
        }
        if (batch.size() == 1) {
            return meterSampleMapper.insertMeterSample(batch.get(0));
        }
        meterSampleMapper.insertMeterSampleBatch(batch);
        return batch.size();
    }

    @Override
    public List<MeterPointSummaryVo> querySummary(Date beginTime, Date endTime, String pointCode) {
        return meterSampleMapper.selectSummaryByTimeRange(beginTime, endTime, pointCode);
    }

    @Override
    public List<MeterPoint> listPublicPoints() {
        return meterPointMapper.selectActivePoints();
    }
}
