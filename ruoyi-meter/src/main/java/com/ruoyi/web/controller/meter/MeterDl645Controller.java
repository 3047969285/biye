package com.ruoyi.web.controller.meter;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.system.domain.MeterDl645Sample;
import com.ruoyi.web.controller.meter.dto.Dl645IngestPayload;
import com.ruoyi.web.meter.MeterIngestParseUtil;
import com.ruoyi.web.meter.dl645.Dl645IngestService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * DL/T645-2007 专用采集控制器
 */
@RestController
@RequestMapping("/meter/dl645")
public class MeterDl645Controller extends BaseController {

    private final Dl645IngestService dl645IngestService;

    public MeterDl645Controller(Dl645IngestService dl645IngestService) {
        this.dl645IngestService = dl645IngestService;
    }

    @PostMapping("/ingest")
    public AjaxResult ingest(@RequestBody Dl645IngestPayload body) {
        if (body == null || body.getFrameHex() == null || body.getFrameHex().isBlank()) {
            return error("frameHex 不能为空");
        }
        return dl645IngestService.ingestFrame(
            body.getFrameHex(),
            MeterIngestParseUtil.parseReadTime(body.getReadTime()),
            body.getSource()
        );
    }

    @GetMapping("/list")
    public AjaxResult list(MeterDl645Sample query) {
        startPage();
        List<MeterDl645Sample> rows = dl645IngestService.list(query);
        return success(getDataTable(rows));
    }
}
