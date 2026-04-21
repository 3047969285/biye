package com.ruoyi.web.controller.meter;

import com.ruoyi.common.annotation.Anonymous;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.system.domain.MeterDl645Sample;
import com.ruoyi.web.meter.dl645.Dl645IngestService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * DL645 开放查询接口（前端展示数据库内容）
 */
@RestController
@RequestMapping("/api/open/meter/dl645")
public class MeterDl645OpenApiController extends BaseController {

    private final Dl645IngestService dl645IngestService;

    public MeterDl645OpenApiController(Dl645IngestService dl645IngestService) {
        this.dl645IngestService = dl645IngestService;
    }

    @Anonymous
    @GetMapping("/latest")
    public AjaxResult latest(MeterDl645Sample query) {
        startPage();
        List<MeterDl645Sample> rows = dl645IngestService.list(query);
        return AjaxResult.success(getDataTable(rows));
    }
}
