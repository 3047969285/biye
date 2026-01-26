package com.ruoyi.web.controller.equipment;
import java.util.List;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.system.domain.EqMechanicalData;
import com.ruoyi.system.service.IEqMechanicalDataService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;
@RestController
@RequestMapping("/equipment/mechanicalData")
public class EqMechanicalDataController extends BaseController {
    @Autowired
    private IEqMechanicalDataService eqMechanicalDataService;
    @GetMapping("/list")
    public TableDataInfo list(EqMechanicalData eqMechanicalData) {
        startPage();
        List<EqMechanicalData> list = eqMechanicalDataService.selectEqMechanicalDataList(eqMechanicalData);
        return getDataTable(list);
    }
    @GetMapping("/listByDeviceId/{deviceId}")
    public AjaxResult listByDeviceId(@PathVariable("deviceId") Long deviceId) {
        List<EqMechanicalData> list = eqMechanicalDataService.selectEqMechanicalDataListByDeviceId(deviceId);
        return success(list);
    }
    @Log(title = "机械数据", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, EqMechanicalData eqMechanicalData) {
        List<EqMechanicalData> list = eqMechanicalDataService.selectEqMechanicalDataList(eqMechanicalData);
        ExcelUtil<EqMechanicalData> util = new ExcelUtil<EqMechanicalData>(EqMechanicalData.class);
        util.exportExcel(response, list, "机械数据数据");
    }
    @GetMapping(value = "/{mechanicalId}")
    public AjaxResult getInfo(@PathVariable("mechanicalId") Long mechanicalId) {
        return success(eqMechanicalDataService.selectEqMechanicalDataByMechanicalId(mechanicalId));
    }
    @Log(title = "机械数据", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody EqMechanicalData eqMechanicalData) {
        return toAjax(eqMechanicalDataService.insertEqMechanicalData(eqMechanicalData));
    }
    @Log(title = "机械数据", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody EqMechanicalData eqMechanicalData) {
        return toAjax(eqMechanicalDataService.updateEqMechanicalData(eqMechanicalData));
    }
    @Log(title = "机械数据", businessType = BusinessType.DELETE)
    @DeleteMapping("/{mechanicalIds}")
    public AjaxResult remove(@PathVariable Long[] mechanicalIds) {
        return toAjax(eqMechanicalDataService.deleteEqMechanicalDataByMechanicalIds(mechanicalIds));
    }
}
