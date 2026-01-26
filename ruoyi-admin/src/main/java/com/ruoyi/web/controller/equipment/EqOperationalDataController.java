package com.ruoyi.web.controller.equipment;
import java.util.List;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.system.domain.EqOperationalData;
import com.ruoyi.system.service.IEqOperationalDataService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;
@RestController
@RequestMapping("/equipment/operationalData")
public class EqOperationalDataController extends BaseController {
    @Autowired
    private IEqOperationalDataService eqOperationalDataService;
    @GetMapping("/list")
    public TableDataInfo list(EqOperationalData eqOperationalData) {
        startPage();
        List<EqOperationalData> list = eqOperationalDataService.selectEqOperationalDataList(eqOperationalData);
        return getDataTable(list);
    }
    @GetMapping("/listByDeviceId/{deviceId}")
    public AjaxResult listByDeviceId(@PathVariable("deviceId") Long deviceId) {
        List<EqOperationalData> list = eqOperationalDataService.selectEqOperationalDataListByDeviceId(deviceId);
        return success(list);
    }
    @Log(title = "操作数据", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, EqOperationalData eqOperationalData) {
        List<EqOperationalData> list = eqOperationalDataService.selectEqOperationalDataList(eqOperationalData);
        ExcelUtil<EqOperationalData> util = new ExcelUtil<EqOperationalData>(EqOperationalData.class);
        util.exportExcel(response, list, "操作数据数据");
    }
    @GetMapping(value = "/{operationalId}")
    public AjaxResult getInfo(@PathVariable("operationalId") Long operationalId) {
        return success(eqOperationalDataService.selectEqOperationalDataByOperationalId(operationalId));
    }
    @Log(title = "操作数据", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody EqOperationalData eqOperationalData) {
        return toAjax(eqOperationalDataService.insertEqOperationalData(eqOperationalData));
    }
    @Log(title = "操作数据", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody EqOperationalData eqOperationalData) {
        return toAjax(eqOperationalDataService.updateEqOperationalData(eqOperationalData));
    }
    @Log(title = "操作数据", businessType = BusinessType.DELETE)
    @DeleteMapping("/{operationalIds}")
    public AjaxResult remove(@PathVariable Long[] operationalIds) {
        return toAjax(eqOperationalDataService.deleteEqOperationalDataByOperationalIds(operationalIds));
    }
}
