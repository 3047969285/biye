package com.ruoyi.web.controller.equipment;
import java.util.List;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.system.domain.EqDeviceRule;
import com.ruoyi.system.service.IEqDeviceRuleService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;
@RestController
@RequestMapping("/equipment/deviceRule")
public class EqDeviceRuleController extends BaseController {
    @Autowired
    private IEqDeviceRuleService eqDeviceRuleService;
    @GetMapping("/list")
    public TableDataInfo list(EqDeviceRule eqDeviceRule) {
        startPage();
        List<EqDeviceRule> list = eqDeviceRuleService.selectEqDeviceRuleList(eqDeviceRule);
        return getDataTable(list);
    }
    @GetMapping("/listByDeviceId/{deviceId}")
    public AjaxResult listByDeviceId(@PathVariable("deviceId") Long deviceId) {
        List<EqDeviceRule> list = eqDeviceRuleService.selectEqDeviceRuleListByDeviceId(deviceId);
        return success(list);
    }
    @Log(title = "设备规则", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, EqDeviceRule eqDeviceRule) {
        List<EqDeviceRule> list = eqDeviceRuleService.selectEqDeviceRuleList(eqDeviceRule);
        ExcelUtil<EqDeviceRule> util = new ExcelUtil<EqDeviceRule>(EqDeviceRule.class);
        util.exportExcel(response, list, "设备规则数据");
    }
    @GetMapping(value = "/{ruleId}")
    public AjaxResult getInfo(@PathVariable("ruleId") Long ruleId) {
        return success(eqDeviceRuleService.selectEqDeviceRuleByRuleId(ruleId));
    }
    @Log(title = "设备规则", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody EqDeviceRule eqDeviceRule) {
        return toAjax(eqDeviceRuleService.insertEqDeviceRule(eqDeviceRule));
    }
    @Log(title = "设备规则", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody EqDeviceRule eqDeviceRule) {
        return toAjax(eqDeviceRuleService.updateEqDeviceRule(eqDeviceRule));
    }
    @Log(title = "设备规则", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ruleIds}")
    public AjaxResult remove(@PathVariable Long[] ruleIds) {
        return toAjax(eqDeviceRuleService.deleteEqDeviceRuleByRuleIds(ruleIds));
    }
}
