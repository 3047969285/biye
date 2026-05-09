package com.ruoyi.web.controller.equipment;

import java.util.List;

import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.system.domain.EqMaintenanceRecord;
import com.ruoyi.system.service.IEqMaintenanceRecordService;

/**
 * 维护记录：分页、按设备、导出、CRUD。
 *
 * @author wangchangzhen
 * @date 2026-01-07
 */
@RestController
@RequestMapping("/equipment/maintenanceRecord")
public class EqMaintenanceRecordController extends BaseController
{
    @Autowired
    private IEqMaintenanceRecordService eqMaintenanceRecordService;

    /** startPage 后分页查询。 */
    @GetMapping("/list")
    public TableDataInfo list(EqMaintenanceRecord eqMaintenanceRecord)
    {
        startPage();
        List<EqMaintenanceRecord> list = eqMaintenanceRecordService.selectEqMaintenanceRecordList(eqMaintenanceRecord);
        return getDataTable(list);
    }

    /** 按 deviceId 不分页列表。 */
    @GetMapping("/listByDeviceId/{deviceId}")
    public AjaxResult listByDeviceId(@PathVariable("deviceId") String deviceId)
    {
        List<EqMaintenanceRecord> list = eqMaintenanceRecordService.selectEqMaintenanceRecordListByDeviceId(deviceId);
        return success(list);
    }

    /** 条件全量导出 Excel。 */
    @Log(title = "维护记录", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, EqMaintenanceRecord eqMaintenanceRecord)
    {
        List<EqMaintenanceRecord> list = eqMaintenanceRecordService.selectEqMaintenanceRecordList(eqMaintenanceRecord);
        ExcelUtil<EqMaintenanceRecord> util = new ExcelUtil<EqMaintenanceRecord>(EqMaintenanceRecord.class);
        util.exportExcel(response, list, "维护记录数据");
    }

    /** 主键详情。 */
    @GetMapping(value = "/{recordId}")
    public AjaxResult getInfo(@PathVariable("recordId") Long recordId)
    {
        return success(eqMaintenanceRecordService.selectEqMaintenanceRecordByRecordId(recordId));
    }

    /** 新增。 */
    @Log(title = "维护记录", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody EqMaintenanceRecord eqMaintenanceRecord)
    {
        return toAjax(eqMaintenanceRecordService.insertEqMaintenanceRecord(eqMaintenanceRecord));
    }

    /** 更新。 */
    @Log(title = "维护记录", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody EqMaintenanceRecord eqMaintenanceRecord)
    {
        return toAjax(eqMaintenanceRecordService.updateEqMaintenanceRecord(eqMaintenanceRecord));
    }

    /** 批量删主键。 */
    @Log(title = "维护记录", businessType = BusinessType.DELETE)
    @DeleteMapping("/{recordIds}")
    public AjaxResult remove(@PathVariable Long[] recordIds)
    {
        return toAjax(eqMaintenanceRecordService.deleteEqMaintenanceRecordByRecordIds(recordIds));
    }
}
