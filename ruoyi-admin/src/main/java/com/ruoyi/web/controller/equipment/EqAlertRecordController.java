package com.ruoyi.web.controller.equipment;

import java.util.List;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.access.prepost.PreAuthorize;
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
import com.ruoyi.system.domain.EqAlertRecord;
import com.ruoyi.system.service.IEqAlertRecordService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 告警记录Controller
 * 
 * @author ruoyi
 * @date 2026-01-07
 */
@RestController
@RequestMapping("/equipment/alertRecord")
public class EqAlertRecordController extends BaseController
{
    @Autowired
    private IEqAlertRecordService eqAlertRecordService;

    /**
     * 查询告警记录列表
     */
    @GetMapping("/list")
    public TableDataInfo list(EqAlertRecord eqAlertRecord)
    {
        startPage();
        List<EqAlertRecord> list = eqAlertRecordService.selectEqAlertRecordList(eqAlertRecord);
        return getDataTable(list);
    }

    /**
     * 根据设备ID查询告警记录列表
     */
    @GetMapping("/listByDeviceId/{deviceId}")
    public AjaxResult listByDeviceId(@PathVariable("deviceId") Long deviceId)
    {
        List<EqAlertRecord> list = eqAlertRecordService.selectEqAlertRecordListByDeviceId(deviceId);
        return success(list);
    }

    /**
     * 导出告警记录列表
     */
    @Log(title = "告警记录", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, EqAlertRecord eqAlertRecord)
    {
        List<EqAlertRecord> list = eqAlertRecordService.selectEqAlertRecordList(eqAlertRecord);
        ExcelUtil<EqAlertRecord> util = new ExcelUtil<EqAlertRecord>(EqAlertRecord.class);
        util.exportExcel(response, list, "告警记录数据");
    }

    /**
     * 获取告警记录详细信息
     */
    @GetMapping(value = "/{alertId}")
    public AjaxResult getInfo(@PathVariable("alertId") Long alertId)
    {
        return success(eqAlertRecordService.selectEqAlertRecordByAlertId(alertId));
    }

    /**
     * 新增告警记录
     */
    @Log(title = "告警记录", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody EqAlertRecord eqAlertRecord)
    {
        return toAjax(eqAlertRecordService.insertEqAlertRecord(eqAlertRecord));
    }

    /**
     * 修改告警记录
     */
    @Log(title = "告警记录", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody EqAlertRecord eqAlertRecord)
    {
        return toAjax(eqAlertRecordService.updateEqAlertRecord(eqAlertRecord));
    }

    /**
     * 删除告警记录
     */
    @Log(title = "告警记录", businessType = BusinessType.DELETE)
	@DeleteMapping("/{alertIds}")
    public AjaxResult remove(@PathVariable Long[] alertIds)
    {
        return toAjax(eqAlertRecordService.deleteEqAlertRecordByAlertIds(alertIds));
    }
}
