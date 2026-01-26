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
import com.ruoyi.system.domain.EqEnvironmentData;
import com.ruoyi.system.service.IEqEnvironmentDataService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 环境数据Controller
 * 
 * @author ruoyi
 * @date 2026-01-08
 */
@RestController
@RequestMapping("/equipment/environmentData")
public class EqEnvironmentDataController extends BaseController
{
    @Autowired
    private IEqEnvironmentDataService eqEnvironmentDataService;

    /**
     * 查询环境数据列表
     */
    @GetMapping("/list")
    public TableDataInfo list(EqEnvironmentData eqEnvironmentData)
    {
        startPage();
        List<EqEnvironmentData> list = eqEnvironmentDataService.selectEqEnvironmentDataList(eqEnvironmentData);
        return getDataTable(list);
    }

    /**
     * 根据设备ID查询环境数据列表
     */
    @GetMapping("/listByDeviceId/{deviceId}")
    public AjaxResult listByDeviceId(@PathVariable("deviceId") Long deviceId)
    {
        List<EqEnvironmentData> list = eqEnvironmentDataService.selectEqEnvironmentDataListByDeviceId(deviceId);
        return success(list);
    }

    /**
     * 导出环境数据列表
     */
    @Log(title = "环境数据", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, EqEnvironmentData eqEnvironmentData)
    {
        List<EqEnvironmentData> list = eqEnvironmentDataService.selectEqEnvironmentDataList(eqEnvironmentData);
        ExcelUtil<EqEnvironmentData> util = new ExcelUtil<EqEnvironmentData>(EqEnvironmentData.class);
        util.exportExcel(response, list, "环境数据数据");
    }

    /**
     * 获取环境数据详细信息
     */
    @GetMapping(value = "/{envId}")
    public AjaxResult getInfo(@PathVariable("envId") Long envId)
    {
        return success(eqEnvironmentDataService.selectEqEnvironmentDataByEnvId(envId));
    }

    /**
     * 新增环境数据
     */
    @Log(title = "环境数据", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody EqEnvironmentData eqEnvironmentData)
    {
        return toAjax(eqEnvironmentDataService.insertEqEnvironmentData(eqEnvironmentData));
    }

    /**
     * 修改环境数据
     */
    @Log(title = "环境数据", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody EqEnvironmentData eqEnvironmentData)
    {
        return toAjax(eqEnvironmentDataService.updateEqEnvironmentData(eqEnvironmentData));
    }

    /**
     * 删除环境数据
     */
    @Log(title = "环境数据", businessType = BusinessType.DELETE)
	@DeleteMapping("/{envIds}")
    public AjaxResult remove(@PathVariable Long[] envIds)
    {
        return toAjax(eqEnvironmentDataService.deleteEqEnvironmentDataByEnvIds(envIds));
    }
}
