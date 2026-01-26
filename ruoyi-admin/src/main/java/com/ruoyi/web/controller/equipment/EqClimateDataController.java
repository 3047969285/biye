package com.ruoyi.web.controller.equipment;
import java.util.List;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.system.domain.EqClimateData;
import com.ruoyi.system.service.IEqClimateDataService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;
@RestController
@RequestMapping("/equipment/climateData")
public class EqClimateDataController extends BaseController {
    @Autowired
    private IEqClimateDataService eqClimateDataService;
    @GetMapping("/list")
    public TableDataInfo list(EqClimateData eqClimateData) {
        startPage();
        List<EqClimateData> list = eqClimateDataService.selectEqClimateDataList(eqClimateData);
        return getDataTable(list);
    }
    @GetMapping("/listByDeviceId/{deviceId}")
    public AjaxResult listByDeviceId(@PathVariable("deviceId") Long deviceId) {
        List<EqClimateData> list = eqClimateDataService.selectEqClimateDataListByDeviceId(deviceId);
        return success(list);
    }
    @Log(title = "气候数据", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, EqClimateData eqClimateData) {
        List<EqClimateData> list = eqClimateDataService.selectEqClimateDataList(eqClimateData);
        ExcelUtil<EqClimateData> util = new ExcelUtil<EqClimateData>(EqClimateData.class);
        util.exportExcel(response, list, "气候数据数据");
    }
    @GetMapping(value = "/{climateId}")
    public AjaxResult getInfo(@PathVariable("climateId") Long climateId) {
        return success(eqClimateDataService.selectEqClimateDataByClimateId(climateId));
    }
    @Log(title = "气候数据", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody EqClimateData eqClimateData) {
        return toAjax(eqClimateDataService.insertEqClimateData(eqClimateData));
    }
    @Log(title = "气候数据", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody EqClimateData eqClimateData) {
        return toAjax(eqClimateDataService.updateEqClimateData(eqClimateData));
    }
    @Log(title = "气候数据", businessType = BusinessType.DELETE)
    @DeleteMapping("/{climateIds}")
    public AjaxResult remove(@PathVariable Long[] climateIds) {
        return toAjax(eqClimateDataService.deleteEqClimateDataByClimateIds(climateIds));
    }
}
