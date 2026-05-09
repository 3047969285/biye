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
import com.ruoyi.system.domain.EqDeviceRule;
import com.ruoyi.system.service.IEqDeviceRuleService;

/**
 * 设备规则：分页、按设备、导出、CRUD。
 *
 * @author wangchangzhen
 * @date 2026-01-07
 */
@RestController
@RequestMapping("/equipment/deviceRule")
public class EqDeviceRuleController extends BaseController
{
    @Autowired
    private IEqDeviceRuleService eqDeviceRuleService;

    /** startPage 后分页查询。 */
    @GetMapping("/list")
    public TableDataInfo list(EqDeviceRule eqDeviceRule)
    {
        startPage();
        List<EqDeviceRule> list = eqDeviceRuleService.selectEqDeviceRuleList(eqDeviceRule);
        return getDataTable(list);
    }

    /** 按 deviceId 不分页列表。 */
    @GetMapping("/listByDeviceId/{deviceId}")
    public AjaxResult listByDeviceId(@PathVariable("deviceId") String deviceId)
    {
        List<EqDeviceRule> list = eqDeviceRuleService.selectEqDeviceRuleListByDeviceId(deviceId);
        return success(list);
    }

    /** 条件全量导出 Excel。 */
    @Log(title = "设备规则", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, EqDeviceRule eqDeviceRule)
    {
        List<EqDeviceRule> list = eqDeviceRuleService.selectEqDeviceRuleList(eqDeviceRule);
        ExcelUtil<EqDeviceRule> util = new ExcelUtil<EqDeviceRule>(EqDeviceRule.class);
        util.exportExcel(response, list, "设备规则数据");
    }

    /** 主键详情。 */
    @GetMapping(value = "/{ruleId}")
    public AjaxResult getInfo(@PathVariable("ruleId") Long ruleId)
    {
        return success(eqDeviceRuleService.selectEqDeviceRuleByRuleId(ruleId));
    }

    /** 新增。 */
    @Log(title = "设备规则", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody EqDeviceRule eqDeviceRule)
    {
        return toAjax(eqDeviceRuleService.insertEqDeviceRule(eqDeviceRule));
    }

    /** 更新。 */
    @Log(title = "设备规则", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody EqDeviceRule eqDeviceRule)
    {
        return toAjax(eqDeviceRuleService.updateEqDeviceRule(eqDeviceRule));
    }

    /** 批量删主键。 */
    @Log(title = "设备规则", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ruleIds}")
    public AjaxResult remove(@PathVariable Long[] ruleIds)
    {
        return toAjax(eqDeviceRuleService.deleteEqDeviceRuleByRuleIds(ruleIds));
    }
}
