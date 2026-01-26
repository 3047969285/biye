package com.ruoyi.web.controller.equipment;
import java.util.List;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.system.domain.EqTechnologyData;
import com.ruoyi.system.service.IEqTechnologyDataService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;
@RestController
@RequestMapping("/equipment/technologyData")
public class EqTechnologyDataController extends BaseController {
    @Autowired
    private IEqTechnologyDataService eqTechnologyDataService;
    @GetMapping("/list")
    public TableDataInfo list(EqTechnologyData eqTechnologyData) {
        startPage();
        List<EqTechnologyData> list = eqTechnologyDataService.selectEqTechnologyDataList(eqTechnologyData);
        return getDataTable(list);
    }
    @GetMapping("/listByDeviceId/{deviceId}")
    public AjaxResult listByDeviceId(@PathVariable("deviceId") Long deviceId) {
        List<EqTechnologyData> list = eqTechnologyDataService.selectEqTechnologyDataListByDeviceId(deviceId);
        return success(list);
    }
    @Log(title = "技术数据", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, EqTechnologyData eqTechnologyData) {
        List<EqTechnologyData> list = eqTechnologyDataService.selectEqTechnologyDataList(eqTechnologyData);
        ExcelUtil<EqTechnologyData> util = new ExcelUtil<EqTechnologyData>(EqTechnologyData.class);
        util.exportExcel(response, list, "技术数据数据");
    }
    @GetMapping(value = "/{techId}")
    public AjaxResult getInfo(@PathVariable("techId") Long techId) {
        return success(eqTechnologyDataService.selectEqTechnologyDataByTechId(techId));
    }
    @Log(title = "技术数据", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody EqTechnologyData eqTechnologyData) {
        return toAjax(eqTechnologyDataService.insertEqTechnologyData(eqTechnologyData));
    }
    @Log(title = "技术数据", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody EqTechnologyData eqTechnologyData) {
        return toAjax(eqTechnologyDataService.updateEqTechnologyData(eqTechnologyData));
    }
    @Log(title = "技术数据", businessType = BusinessType.DELETE)
    @DeleteMapping("/{techIds}")
    public AjaxResult remove(@PathVariable Long[] techIds) {
        return toAjax(eqTechnologyDataService.deleteEqTechnologyDataByTechIds(techIds));
    }
}
