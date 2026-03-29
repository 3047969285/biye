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
import com.ruoyi.system.domain.EqDeviceStatus;
import com.ruoyi.system.service.IEqDeviceStatusService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 设备运行状态Controller
 * 
 * @author ruoyi
 * @date 2025-01-07
 */
@RestController
@RequestMapping("/equipment/deviceStatus")
public class EqDeviceStatusController extends BaseController
{
    @Autowired
    private IEqDeviceStatusService eqDeviceStatusService;

    /**
     * 查询设备运行状态列表
     */
    @GetMapping("/list")
    public TableDataInfo list(EqDeviceStatus eqDeviceStatus)
    {
        startPage();
        List<EqDeviceStatus> list = eqDeviceStatusService.selectEqDeviceStatusList(eqDeviceStatus);
        return getDataTable(list);
    }

    /**
     * 导出设备运行状态列表
     */
    @Log(title = "设备运行状态", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, EqDeviceStatus eqDeviceStatus)
    {
        List<EqDeviceStatus> list = eqDeviceStatusService.selectEqDeviceStatusList(eqDeviceStatus);
        ExcelUtil<EqDeviceStatus> util = new ExcelUtil<EqDeviceStatus>(EqDeviceStatus.class);
        util.exportExcel(response, list, "设备运行状态数据");
    }

    /**
     * 获取设备运行状态详细信息
     */
    @GetMapping(value = "/{statusId}")
    public AjaxResult getInfo(@PathVariable("statusId") Long statusId)
    {
        return success(eqDeviceStatusService.selectEqDeviceStatusByStatusId(statusId));
    }

    /**
     * 新增设备运行状态
     */
    @Log(title = "设备运行状态", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody EqDeviceStatus eqDeviceStatus)
    {
        return toAjax(eqDeviceStatusService.insertEqDeviceStatus(eqDeviceStatus));
    }

    /**
     * 修改设备运行状态
     */
    @Log(title = "设备运行状态", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody EqDeviceStatus eqDeviceStatus)
    {
        return toAjax(eqDeviceStatusService.updateEqDeviceStatus(eqDeviceStatus));
    }

    /**
     * 删除设备运行状态
     */
    @Log(title = "设备运行状态", businessType = BusinessType.DELETE)
	@DeleteMapping("/{statusIds}")
    public AjaxResult remove(@PathVariable Long[] statusIds)
    {
        return toAjax(eqDeviceStatusService.deleteEqDeviceStatusByStatusIds(statusIds));
    }

    /**
     * 按设备重算规则（最新一条状态）：生成告警、抬升运行状态、标记需维护
     */
    @PreAuthorize("@ss.hasPermi('equipment:deviceStatus:edit')")
    @Log(title = "设备运行状态", businessType = BusinessType.UPDATE)
    @PostMapping("/reevaluateRules/{deviceId}")
    public AjaxResult reevaluateRules(@PathVariable("deviceId") Long deviceId)
    {
        eqDeviceStatusService.reevaluateRulesByDeviceId(deviceId);
        return success("已触发规则重算");
    }
}
