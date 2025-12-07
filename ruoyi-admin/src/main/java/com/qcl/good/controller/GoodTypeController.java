package com.qcl.good.controller;

import java.util.List;
import javax.servlet.http.HttpServletResponse;
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
import com.qcl.good.domain.GoodType;
import com.qcl.good.service.IGoodTypeService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 分类管理Controller
 * 
 * @author 风格
 * @date 2025-11-03
 */
@RestController
@RequestMapping("/good/type")
public class GoodTypeController extends BaseController
{
    @Autowired
    private IGoodTypeService goodTypeService;

    /**
     * 查询分类管理列表
     */
    @PreAuthorize("@ss.hasPermi('good:type:list')")
    @GetMapping("/list")
    public TableDataInfo list(GoodType goodType)
    {
        startPage();
        List<GoodType> list = goodTypeService.selectGoodTypeList(goodType);
        return getDataTable(list);
    }

    /**
     * 导出分类管理列表
     */
    @PreAuthorize("@ss.hasPermi('good:type:export')")
    @Log(title = "分类管理", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, GoodType goodType)
    {
        List<GoodType> list = goodTypeService.selectGoodTypeList(goodType);
        ExcelUtil<GoodType> util = new ExcelUtil<GoodType>(GoodType.class);
        util.exportExcel(response, list, "分类管理数据");
    }

    /**
     * 获取分类管理详细信息
     */
    @PreAuthorize("@ss.hasPermi('good:type:query')")
    @GetMapping(value = "/{typeId}")
    public AjaxResult getInfo(@PathVariable("typeId") Long typeId)
    {
        return success(goodTypeService.selectGoodTypeByTypeId(typeId));
    }

    /**
     * 新增分类管理
     */
    @PreAuthorize("@ss.hasPermi('good:type:add')")
    @Log(title = "分类管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody GoodType goodType)
    {
        return toAjax(goodTypeService.insertGoodType(goodType));
    }

    /**
     * 修改分类管理
     */
    @PreAuthorize("@ss.hasPermi('good:type:edit')")
    @Log(title = "分类管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody GoodType goodType)
    {
        return toAjax(goodTypeService.updateGoodType(goodType));
    }

    /**
     * 删除分类管理
     */
    @PreAuthorize("@ss.hasPermi('good:type:remove')")
    @Log(title = "分类管理", businessType = BusinessType.DELETE)
	@DeleteMapping("/{typeIds}")
    public AjaxResult remove(@PathVariable Long[] typeIds)
    {
        return toAjax(goodTypeService.deleteGoodTypeByTypeIds(typeIds));
    }
}
