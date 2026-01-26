package com.ruoyi.web.controller.equipment;
import java.util.List;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.system.domain.EqDeviceStat;
import com.ruoyi.system.service.IEqDeviceStatService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;
@RestController
@RequestMapping("/equipment/deviceStat")
public class EqDeviceStatController extends BaseController {
    @Autowired
    private IEqDeviceStatService eqDeviceStatService;
    @GetMapping("/list")
    public TableDataInfo list(EqDeviceStat eqDeviceStat) {
        startPage();
        List<EqDeviceStat> list = eqDeviceStatService.selectEqDeviceStatList(eqDeviceStat);
        return getDataTable(list);
    }
    @GetMapping("/listByDeviceId/{deviceId}")
    public AjaxResult listByDeviceId(@PathVariable("deviceId") Long deviceId) {
        List<EqDeviceStat> list = eqDeviceStatService.selectEqDeviceStatListByDeviceId(deviceId);
        return success(list);
    }
    @Log(title = "设备统计", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, EqDeviceStat eqDeviceStat) {
        List<EqDeviceStat> list = eqDeviceStatService.selectEqDeviceStatList(eqDeviceStat);
        ExcelUtil<EqDeviceStat> util = new ExcelUtil<EqDeviceStat>(EqDeviceStat.class);
        util.exportExcel(response, list, "设备统计数据");
    }
    @GetMapping(value = "/{statId}")
    public AjaxResult getInfo(@PathVariable("statId") Long statId) {
        return success(eqDeviceStatService.selectEqDeviceStatByStatId(statId));
    }
    @Log(title = "设备统计", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody EqDeviceStat eqDeviceStat) {
        return toAjax(eqDeviceStatService.insertEqDeviceStat(eqDeviceStat));
    }
    @Log(title = "设备统计", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody EqDeviceStat eqDeviceStat) {
        return toAjax(eqDeviceStatService.updateEqDeviceStat(eqDeviceStat));
    }
    @Log(title = "设备统计", businessType = BusinessType.DELETE)
    @DeleteMapping("/{statIds}")
    public AjaxResult remove(@PathVariable Long[] statIds) {
        return toAjax(eqDeviceStatService.deleteEqDeviceStatByStatIds(statIds));
    }
}
