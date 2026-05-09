package com.ruoyi.qcluser.controller;

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
import com.ruoyi.qcluser.domain.QclUser;
import com.ruoyi.qcluser.service.IQclUserService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 用户Controller
 * 
 * @author wangchangzhen
 * @date 2025-11-03
 */
@RestController
@RequestMapping("/qcluser/qcluser")
public class QclUserController extends BaseController
{
    @Autowired
    private IQclUserService qclUserService;

    /**
     * 查询用户列表
     */
    @PreAuthorize("@ss.hasPermi('qcluser:qcluser:list')")
    @GetMapping("/list")
    public TableDataInfo list(QclUser qclUser)
    {
        startPage();
        List<QclUser> list = qclUserService.selectQclUserList(qclUser);
        return getDataTable(list);
    }

    /**
     * 导出用户列表
     */
    @PreAuthorize("@ss.hasPermi('qcluser:qcluser:export')")
    @Log(title = "用户", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, QclUser qclUser)
    {
        List<QclUser> list = qclUserService.selectQclUserList(qclUser);
        ExcelUtil<QclUser> util = new ExcelUtil<QclUser>(QclUser.class);
        util.exportExcel(response, list, "用户数据");
    }

    /**
     * 获取用户详细信息
     */
    @PreAuthorize("@ss.hasPermi('qcluser:qcluser:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(qclUserService.selectQclUserById(id));
    }

    /**
     * 新增用户
     */
    @PreAuthorize("@ss.hasPermi('qcluser:qcluser:add')")
    @Log(title = "用户", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody QclUser qclUser)
    {
        return toAjax(qclUserService.insertQclUser(qclUser));
    }

    /**
     * 修改用户
     */
    @PreAuthorize("@ss.hasPermi('qcluser:qcluser:edit')")
    @Log(title = "用户", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody QclUser qclUser)
    {
        return toAjax(qclUserService.updateQclUser(qclUser));
    }

    /**
     * 删除用户
     */
    @PreAuthorize("@ss.hasPermi('qcluser:qcluser:remove')")
    @Log(title = "用户", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(qclUserService.deleteQclUserByIds(ids));
    }
}
