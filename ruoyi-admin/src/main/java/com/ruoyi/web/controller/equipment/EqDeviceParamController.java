package com.ruoyi.web.controller.equipment;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.system.domain.EqDeviceParam;
import com.ruoyi.system.service.IEqDeviceParamService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 设备参数 Controller
 *
 * @author ruoyi
 * @date 2026-01-07
 */
@RestController
@RequestMapping("/equipment/deviceParam")
public class EqDeviceParamController extends BaseController {

    @Autowired
    private IEqDeviceParamService eqDeviceParamService;

    /**
     * 查询设备参数列表
     */
    @PreAuthorize("@ss.hasPermi('equipment:param:list')")
    @GetMapping("/list")
    public TableDataInfo list(EqDeviceParam eqDeviceParam) {
        startPage();
        List<EqDeviceParam> list = eqDeviceParamService.selectEqDeviceParamList(eqDeviceParam);
        return getDataTable(list);
    }

    /**
     * 根据设备ID查询设备参数列表
     */
    @PreAuthorize("@ss.hasPermi('equipment:param:list')")
    @GetMapping("/listByDeviceId/{deviceId}")
    public AjaxResult listByDeviceId(@PathVariable("deviceId") Long deviceId) {
        List<EqDeviceParam> list = eqDeviceParamService.selectEqDeviceParamListByDeviceId(deviceId);
        return success(list);
    }

    /**
     * 导出设备参数列表
     */
    @PreAuthorize("@ss.hasPermi('equipment:param:export')")
    @Log(title = "设备参数", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, EqDeviceParam eqDeviceParam) {
        List<EqDeviceParam> list = eqDeviceParamService.selectEqDeviceParamList(eqDeviceParam);
        ExcelUtil<EqDeviceParam> util = new ExcelUtil<EqDeviceParam>(EqDeviceParam.class);
        util.exportExcel(response, list, "设备参数数据");
    }

    /**
     * 获取设备参数详细信息
     */
    @PreAuthorize("@ss.hasPermi('equipment:param:query')")
    @GetMapping(value = "/{paramId}")
    public AjaxResult getInfo(@PathVariable("paramId") Long paramId) {
        return success(eqDeviceParamService.selectEqDeviceParamByParamId(paramId));
    }

    /**
     * 新增设备参数
     */
    @PreAuthorize("@ss.hasPermi('equipment:param:add')")
    @Log(title = "设备参数", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody EqDeviceParam eqDeviceParam) {
        return toAjax(eqDeviceParamService.insertEqDeviceParam(eqDeviceParam));
    }

    /**
     * 修改设备参数
     */
    @PreAuthorize("@ss.hasPermi('equipment:param:edit')")
    @Log(title = "设备参数", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody EqDeviceParam eqDeviceParam) {
        return toAjax(eqDeviceParamService.updateEqDeviceParam(eqDeviceParam));
    }

    /**
     * 删除设备参数
     */
    @PreAuthorize("@ss.hasPermi('equipment:param:remove')")
    @Log(title = "设备参数", businessType = BusinessType.DELETE)
    @DeleteMapping("/{paramIds}")
    public AjaxResult remove(@PathVariable Long[] paramIds) {
        return toAjax(eqDeviceParamService.deleteEqDeviceParamByParamIds(paramIds));
    }
}
