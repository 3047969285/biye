package com.ruoyi.web.controller.meter;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Anonymous;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.MeterPoint;
import com.ruoyi.system.domain.vo.MeterPointSummaryVo;
import com.ruoyi.system.service.IMeterModbusDataService;
import com.ruoyi.web.config.properties.MeterModbusProperties;

/**
 * Modbus 风格开放接口：汇总点表（匿名可访问，生产环境建议网关限流或关闭匿名）
 */
@Anonymous
@RestController
@RequestMapping("/api/open/meter")
public class MeterModbusOpenApiController extends BaseController {

    private final MeterModbusProperties props;
    private final IMeterModbusDataService meterModbusDataService;

    public MeterModbusOpenApiController(MeterModbusProperties props, IMeterModbusDataService meterModbusDataService) {
        this.props = props;
        this.meterModbusDataService = meterModbusDataService;
    }

    /**
     * 时间窗内各点 min/max/avg 及样本数（仅包含有采样数据的点）
     */
    @GetMapping("/summary")
    public AjaxResult summary(
        @RequestParam String beginTime,
        @RequestParam String endTime,
        @RequestParam(required = false) String pointCode) {
        if (StringUtils.isEmpty(beginTime) || StringUtils.isEmpty(endTime)) {
            return error("beginTime、endTime 必填");
        }
        Date begin = DateUtils.parseDate(beginTime);
        Date end = DateUtils.parseDate(endTime);
        if (begin == null || end == null) {
            return error("时间格式无效，支持 yyyy-MM-dd HH:mm:ss");
        }
        List<MeterPointSummaryVo> rows = meterModbusDataService.querySummary(begin, end, pointCode);
        Map<String, Object> out = new HashMap<>();
        out.put("beginTime", beginTime);
        out.put("endTime", endTime);
        out.put("rows", rows);
        if (props.isSummaryIncludePointTable()) {
            List<MeterPoint> points = meterModbusDataService.listPublicPoints();
            out.put("points", points);
        }
        return success(out);
    }

    /**
     * 当前启用点表（不含已删除/停用以外的过滤由 listPublicPoints 处理）
     */
    @GetMapping("/points")
    public AjaxResult points() {
        return success(meterModbusDataService.listPublicPoints());
    }
}

