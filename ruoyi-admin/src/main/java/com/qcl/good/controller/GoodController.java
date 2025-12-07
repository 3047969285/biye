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
import com.qcl.good.domain.Good;
import com.qcl.good.service.IGoodService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 管理商品Controller
 * 
 * @author 风格
 * @date 2025-11-03
 */
@RestController
@RequestMapping("/good/good")
public class GoodController extends BaseController
{
    @Autowired
    private IGoodService goodService;

    /**
     * 查询管理商品列表
     */
    @PreAuthorize("@ss.hasPermi('good:good:list')")
    @GetMapping("/list")
    public TableDataInfo list(Good good)
    {
        startPage();
        List<Good> list = goodService.selectGoodList(good);
        return getDataTable(list);
    }

    /**
     * 导出管理商品列表
     */
    @PreAuthorize("@ss.hasPermi('good:good:export')")
    @Log(title = "管理商品", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Good good)
    {
        List<Good> list = goodService.selectGoodList(good);
        ExcelUtil<Good> util = new ExcelUtil<Good>(Good.class);
        util.exportExcel(response, list, "管理商品数据");
    }

    /**
     * 获取管理商品详细信息
     */
    @PreAuthorize("@ss.hasPermi('good:good:query')")
    @GetMapping(value = "/{goodId}")
    public AjaxResult getInfo(@PathVariable("goodId") Long goodId)
    {
        return success(goodService.selectGoodByGoodId(goodId));
    }

    /**
     * 新增管理商品
     */
    @PreAuthorize("@ss.hasPermi('good:good:add')")
    @Log(title = "管理商品", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody Good good)
    {
        return toAjax(goodService.insertGood(good));
    }

    /**
     * 修改管理商品
     */
    @PreAuthorize("@ss.hasPermi('good:good:edit')")
    @Log(title = "管理商品", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody Good good)
    {
        return toAjax(goodService.updateGood(good));
    }

    /**
     * 删除管理商品
     */
    @PreAuthorize("@ss.hasPermi('good:good:remove')")
    @Log(title = "管理商品", businessType = BusinessType.DELETE)
	@DeleteMapping("/{goodIds}")
    public AjaxResult remove(@PathVariable Long[] goodIds)
    {
        return toAjax(goodService.deleteGoodByGoodIds(goodIds));
    }
}
