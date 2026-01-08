package com.ruoyi.web.controller.equipment;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.system.domain.EqMaintenanceRecord;
import com.ruoyi.system.service.IEqMaintenanceRecordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 维护记录 Controller
 *
 * @author ruoyi
 * @date 2026-01-07
 */
@RestController
@RequestMapping("/equipment/maintenanceRecord")
public class EqMaintenanceRecordController extends BaseController {

    @Autowired
    private IEqMaintenanceRecordService eqMaintenanceRecordService;

    /**
     * 查询维护记录列表
     */
    @PreAuthorize("@ss.hasPermi('equipment:maintenance:list')")
    @GetMapping("/list")
    public TableDataInfo list(EqMaintenanceRecord eqMaintenanceRecord) {
        startPage();
        List<EqMaintenanceRecord> list = eqMaintenanceRecordService.selectEqMaintenanceRecordList(eqMaintenanceRecord);
        return getDataTable(list);
    }

    /**
     * 根据设备ID查询维护记录列表
     */
    @PreAuthorize("@ss.hasPermi('equipment:maintenance:list')")
    @GetMapping("/listByDeviceId/{deviceId}")
    public AjaxResult listByDeviceId(@PathVariable("deviceId") Long deviceId) {
        List<EqMaintenanceRecord> list = eqMaintenanceRecordService.selectEqMaintenanceRecordListByDeviceId(deviceId);
        return success(list);
    }

    /**
     * 导出维护记录列表
     */
    @PreAuthorize("@ss.hasPermi('equipment:maintenance:export')")
    @Log(title = "维护记录", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, EqMaintenanceRecord eqMaintenanceRecord) {
        List<EqMaintenanceRecord> list = eqMaintenanceRecordService.selectEqMaintenanceRecordList(eqMaintenanceRecord);
        ExcelUtil<EqMaintenanceRecord> util = new ExcelUtil<EqMaintenanceRecord>(EqMaintenanceRecord.class);
        util.exportExcel(response, list, "维护记录数据");
    }

    /**
     * 获取维护记录详细信息
     */
    @PreAuthorize("@ss.hasPermi('equipment:maintenance:query')")
    @GetMapping(value = "/{recordId}")
    public AjaxResult getInfo(@PathVariable("recordId") Long recordId) {
        return success(eqMaintenanceRecordService.selectEqMaintenanceRecordByRecordId(recordId));
    }

    /**
     * 新增维护记录
     */
    @PreAuthorize("@ss.hasPermi('equipment:maintenance:add')")
    @Log(title = "维护记录", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody EqMaintenanceRecord eqMaintenanceRecord) {
        return toAjax(eqMaintenanceRecordService.insertEqMaintenanceRecord(eqMaintenanceRecord));
    }

    /**
     * 修改维护记录
     */
    @PreAuthorize("@ss.hasPermi('equipment:maintenance:edit')")
    @Log(title = "维护记录", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody EqMaintenanceRecord eqMaintenanceRecord) {
        return toAjax(eqMaintenanceRecordService.updateEqMaintenanceRecord(eqMaintenanceRecord));
    }

    /**
     * 删除维护记录
     */
    @PreAuthorize("@ss.hasPermi('equipment:maintenance:remove')")
    @Log(title = "维护记录", businessType = BusinessType.DELETE)
    @DeleteMapping("/{recordIds}")
    public AjaxResult remove(@PathVariable Long[] recordIds) {
        return toAjax(eqMaintenanceRecordService.deleteEqMaintenanceRecordByRecordIds(recordIds));
    }
}
