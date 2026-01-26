package com.ruoyi.web.controller.equipment;
import java.util.List;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.system.domain.EqMaintenanceRecord;
import com.ruoyi.system.service.IEqMaintenanceRecordService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;
@RestController
@RequestMapping("/equipment/maintenanceRecord")
public class EqMaintenanceRecordController extends BaseController {
    @Autowired
    private IEqMaintenanceRecordService eqMaintenanceRecordService;
    @GetMapping("/list")
    public TableDataInfo list(EqMaintenanceRecord eqMaintenanceRecord) {
        startPage();
        List<EqMaintenanceRecord> list = eqMaintenanceRecordService.selectEqMaintenanceRecordList(eqMaintenanceRecord);
        return getDataTable(list);
    }
    @GetMapping("/listByDeviceId/{deviceId}")
    public AjaxResult listByDeviceId(@PathVariable("deviceId") Long deviceId) {
        List<EqMaintenanceRecord> list = eqMaintenanceRecordService.selectEqMaintenanceRecordListByDeviceId(deviceId);
        return success(list);
    }
    @Log(title = "维护记录", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, EqMaintenanceRecord eqMaintenanceRecord) {
        List<EqMaintenanceRecord> list = eqMaintenanceRecordService.selectEqMaintenanceRecordList(eqMaintenanceRecord);
        ExcelUtil<EqMaintenanceRecord> util = new ExcelUtil<EqMaintenanceRecord>(EqMaintenanceRecord.class);
        util.exportExcel(response, list, "维护记录数据");
    }
    @GetMapping(value = "/{recordId}")
    public AjaxResult getInfo(@PathVariable("recordId") Long recordId) {
        return success(eqMaintenanceRecordService.selectEqMaintenanceRecordByRecordId(recordId));
    }
    @Log(title = "维护记录", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody EqMaintenanceRecord eqMaintenanceRecord) {
        return toAjax(eqMaintenanceRecordService.insertEqMaintenanceRecord(eqMaintenanceRecord));
    }
    @Log(title = "维护记录", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody EqMaintenanceRecord eqMaintenanceRecord) {
        return toAjax(eqMaintenanceRecordService.updateEqMaintenanceRecord(eqMaintenanceRecord));
    }
    @Log(title = "维护记录", businessType = BusinessType.DELETE)
    @DeleteMapping("/{recordIds}")
    public AjaxResult remove(@PathVariable Long[] recordIds) {
        return toAjax(eqMaintenanceRecordService.deleteEqMaintenanceRecordByRecordIds(recordIds));
    }
}
