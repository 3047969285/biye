package com.ruoyi.web.meter.dl645;

import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.MeterDl645Sample;
import com.ruoyi.system.domain.MeterPoint;
import com.ruoyi.system.domain.MeterSample;
import com.ruoyi.system.mapper.MeterDl645SampleMapper;
import com.ruoyi.system.mapper.MeterPointMapper;
import com.ruoyi.system.mapper.MeterSampleMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class Dl645IngestService {

    private final Dl645DiConfigService diConfigService;
    private final MeterPointMapper meterPointMapper;
    private final MeterSampleMapper meterSampleMapper;
    private final MeterDl645SampleMapper meterDl645SampleMapper;

    public Dl645IngestService(Dl645DiConfigService diConfigService, MeterPointMapper meterPointMapper,
        MeterSampleMapper meterSampleMapper, MeterDl645SampleMapper meterDl645SampleMapper) {
        this.diConfigService = diConfigService;
        this.meterPointMapper = meterPointMapper;
        this.meterSampleMapper = meterSampleMapper;
        this.meterDl645SampleMapper = meterDl645SampleMapper;
    }

    @Transactional(rollbackFor = Exception.class)
    public AjaxResult ingestFrame(String frameHex, Date readTime, String source) {
        Dl645FrameParser.Dl645ParsedValue parsed = Dl645FrameParser.parse(frameHex);
        Dl645DiItem diItem = diConfigService.getByDi(parsed.diCode());
        if (diItem == null) {
            return AjaxResult.error("DI 未配置映射: " + parsed.diCode());
        }
        MeterPoint point = meterPointMapper.selectByPointCode(diItem.getPointCode());
        if (point == null) {
            return AjaxResult.error("点位不存在 pointCode=" + diItem.getPointCode());
        }
        int decimals = diItem.getDecimals() == null ? 2 : diItem.getDecimals();
        double scale = diItem.getScale() == null ? 1D : diItem.getScale();
        double value = Dl645FrameParser.bcdLittleEndianToDouble(parsed.valueBytes(), decimals) * scale;
        Date t = readTime == null ? new Date() : readTime;

        MeterSample sample = new MeterSample();
        sample.setPointId(point.getPointId());
        sample.setReadTime(t);
        sample.setValueRaw((long) Math.round(value * 10000));
        sample.setValueScaled(value);
        sample.setSource(StringUtils.isEmpty(source) ? "DL645" : source);
        meterSampleMapper.insertMeterSample(sample);

        MeterDl645Sample detail = new MeterDl645Sample();
        detail.setMeterAddress(parsed.meterAddress());
        detail.setDiCode(parsed.diCode());
        detail.setPointCode(diItem.getPointCode());
        detail.setPointName(StringUtils.isEmpty(diItem.getPointName()) ? point.getPointName() : diItem.getPointName());
        detail.setValue(value);
        detail.setUnit(StringUtils.isEmpty(diItem.getUnit()) ? point.getUnit() : diItem.getUnit());
        detail.setReadTime(t);
        detail.setSource(sample.getSource());
        detail.setRawFrameHex(frameHex);
        detail.setCreateBy("dl645");
        detail.setCreateTime(DateUtils.getNowDate());
        meterDl645SampleMapper.insertMeterDl645Sample(detail);

        Map<String, Object> result = new HashMap<>();
        result.put("meterAddress", parsed.meterAddress());
        result.put("diCode", parsed.diCode());
        result.put("pointCode", diItem.getPointCode());
        result.put("value", value);
        result.put("unit", StringUtils.isEmpty(diItem.getUnit()) ? point.getUnit() : diItem.getUnit());
        result.put("readTime", t);
        return AjaxResult.success("DL645 采集成功", result);
    }

    public List<MeterDl645Sample> list(MeterDl645Sample query) {
        return meterDl645SampleMapper.selectMeterDl645SampleList(query);
    }
}
