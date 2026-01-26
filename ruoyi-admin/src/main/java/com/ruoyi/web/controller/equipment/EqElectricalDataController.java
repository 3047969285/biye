package com.ruoyi.web.controller.equipment;
import java.util.List;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.system.domain.EqElectricalData;
import com.ruoyi.system.service.IEqElectricalDataService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;
@RestController
@RequestMapping("/equipment/electricalData")
public class EqElectricalDataController extends BaseController {
    @Autowired
    private IEqElectricalDataService eqElectricalDataService;
    @GetMapping("/list")
    public TableDataInfo list(EqElectricalData eqElectricalData) {
        startPage();
        List<EqElectricalData> list = eqElectricalDataService.selectEqElectricalDataList(eqElectricalData);
        return getDataTable(list);
    }
    @GetMapping("/listByDeviceId/{deviceId}")
    public AjaxResult listByDeviceId(@PathVariable("deviceId") Long deviceId) {
        List<EqElectricalData> list = eqElectricalDataService.selectEqElectricalDataListByDeviceId(deviceId);
        return success(list);
    }
    @Log(title = "电气数据", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, EqElectricalData eqElectricalData) {
        List<EqElectricalData> list = eqElectricalDataService.selectEqElectricalDataList(eqElectricalData);
        ExcelUtil<EqElectricalData> util = new ExcelUtil<EqElectricalData>(EqElectricalData.class);
        util.exportExcel(response, list, "电气数据数据");
    }
    @GetMapping(value = "/{electricalId}")
    public AjaxResult getInfo(@PathVariable("electricalId") Long electricalId) {
        return success(eqElectricalDataService.selectEqElectricalDataByElectricalId(electricalId));
    }
    @Log(title = "电气数据", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody EqElectricalData eqElectricalData) {
        return toAjax(eqElectricalDataService.insertEqElectricalData(eqElectricalData));
    }
    @Log(title = "电气数据", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody EqElectricalData eqElectricalData) {
        return toAjax(eqElectricalDataService.updateEqElectricalData(eqElectricalData));
    }
    @Log(title = "电气数据", businessType = BusinessType.DELETE)
    @DeleteMapping("/{electricalIds}")
    public AjaxResult remove(@PathVariable Long[] electricalIds) {
        return toAjax(eqElectricalDataService.deleteEqElectricalDataByElectricalIds(electricalIds));
    }
}
