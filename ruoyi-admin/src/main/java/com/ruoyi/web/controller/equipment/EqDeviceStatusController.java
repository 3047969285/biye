package com.ruoyi.web.controller.equipment;

import java.util.List;

import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
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
import com.ruoyi.system.domain.EqDeviceStatus;
import com.ruoyi.system.service.IEqDeviceStatusService;

/**
 * 设备运行状态：分页、导出、CRUD；支持按设备触发规则重算。
 *
 * @author wangchangzhen
 * @date 2026-01-07
 */
@RestController
@RequestMapping("/equipment/deviceStatus")
public class EqDeviceStatusController extends BaseController
{
    @Autowired
    private IEqDeviceStatusService eqDeviceStatusService;

    /** startPage 后分页查询。 */
    @GetMapping("/list")
    public TableDataInfo list(EqDeviceStatus eqDeviceStatus)
    {
        startPage();
        List<EqDeviceStatus> list = eqDeviceStatusService.selectEqDeviceStatusList(eqDeviceStatus);
        return getDataTable(list);
    }

    /** 条件全量导出 Excel。 */
    @Log(title = "设备运行状态", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, EqDeviceStatus eqDeviceStatus)
    {
        List<EqDeviceStatus> list = eqDeviceStatusService.selectEqDeviceStatusList(eqDeviceStatus);
        ExcelUtil<EqDeviceStatus> util = new ExcelUtil<EqDeviceStatus>(EqDeviceStatus.class);
        util.exportExcel(response, list, "设备运行状态数据");
    }

    /** 主键详情。 */
    @GetMapping(value = "/{statusId}")
    public AjaxResult getInfo(@PathVariable("statusId") Long statusId)
    {
        return success(eqDeviceStatusService.selectEqDeviceStatusByStatusId(statusId));
    }

    /** 新增；成功后业务层会按快照跑规则。 */
    @Log(title = "设备运行状态", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody EqDeviceStatus eqDeviceStatus)
    {
        return toAjax(eqDeviceStatusService.insertEqDeviceStatus(eqDeviceStatus));
    }

    /** 更新；成功后业务层会按快照跑规则。 */
    @Log(title = "设备运行状态", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody EqDeviceStatus eqDeviceStatus)
    {
        return toAjax(eqDeviceStatusService.updateEqDeviceStatus(eqDeviceStatus));
    }

    /** 批量删主键。 */
    @Log(title = "设备运行状态", businessType = BusinessType.DELETE)
    @DeleteMapping("/{statusIds}")
    public AjaxResult remove(@PathVariable Long[] statusIds)
    {
        return toAjax(eqDeviceStatusService.deleteEqDeviceStatusByStatusIds(statusIds));
    }

    /**
     * 对该设备取最新一条状态，再执行规则匹配（告警写入、运行状态抬升、维护标记等都在业务层完成）。
     */
    @PreAuthorize("@ss.hasPermi('equipment:deviceStatus:edit')")
    @Log(title = "设备运行状态", businessType = BusinessType.UPDATE)
    @PostMapping("/reevaluateRules/{deviceId}")
    public AjaxResult reevaluateRules(@PathVariable("deviceId") String deviceId)
    {
        eqDeviceStatusService.reevaluateRulesByDeviceId(deviceId);
        return success("已触发规则重算");
    }
}
