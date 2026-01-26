package com.ruoyi.web.controller.equipment;

import java.util.List;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.system.domain.EqEconomicData;
import com.ruoyi.system.service.IEqEconomicDataService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

@RestController
@RequestMapping("/equipment/economicData")
public class EqEconomicDataController extends BaseController {
    @Autowired
    private IEqEconomicDataService eqEconomicDataService;

    @GetMapping("/list")
    public TableDataInfo list(EqEconomicData eqEconomicData) {
        startPage();
        List<EqEconomicData> list = eqEconomicDataService.selectEqEconomicDataList(eqEconomicData);
        return getDataTable(list);
    }

    @GetMapping("/listByDeviceId/{deviceId}")
    public AjaxResult listByDeviceId(@PathVariable("deviceId") Long deviceId) {
        List<EqEconomicData> list = eqEconomicDataService.selectEqEconomicDataListByDeviceId(deviceId);
        return success(list);
    }

    @Log(title = "经济数据", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, EqEconomicData eqEconomicData) {
        List<EqEconomicData> list = eqEconomicDataService.selectEqEconomicDataList(eqEconomicData);
        ExcelUtil<EqEconomicData> util = new ExcelUtil<EqEconomicData>(EqEconomicData.class);
        util.exportExcel(response, list, "经济数据数据");
    }

    @GetMapping(value = "/{economicId}")
    public AjaxResult getInfo(@PathVariable("economicId") Long economicId) {
        return success(eqEconomicDataService.selectEqEconomicDataByEconomicId(economicId));
    }

    @Log(title = "经济数据", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody EqEconomicData eqEconomicData) {
        return toAjax(eqEconomicDataService.insertEqEconomicData(eqEconomicData));
    }

    @Log(title = "经济数据", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody EqEconomicData eqEconomicData) {
        return toAjax(eqEconomicDataService.updateEqEconomicData(eqEconomicData));
    }

    @Log(title = "经济数据", businessType = BusinessType.DELETE)
    @DeleteMapping("/{economicIds}")
    public AjaxResult remove(@PathVariable Long[] economicIds) {
        return toAjax(eqEconomicDataService.deleteEqEconomicDataByEconomicIds(economicIds));
    }
}
