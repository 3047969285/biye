package com.ruoyi.department.controller;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.department.domain.model.Department;
import com.ruoyi.department.service.IDepartmentService;
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

import java.util.List;

/**
 * 部门信息Controller
 *
 * @author wangchangzhen
 * @date 2025-11-03
 */
@RestController
@RequestMapping("/department/department")
public class DepartmentController extends BaseController {
    @Autowired
    private IDepartmentService departmentService;

    /**
     * 查询部门信息列表
     */
    @PreAuthorize("@ss.hasPermi('department:department:list')")
    @GetMapping("/list")
    public AjaxResult list(Department department) {
        List<Department> list = departmentService.selectDepartmentList(department);
        return success(list);
    }

    /**
     * 导出部门信息列表
     */
    @PreAuthorize("@ss.hasPermi('department:department:export')")
    @Log(title = "部门信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Department department) {
        List<Department> list = departmentService.selectDepartmentList(department);
        ExcelUtil<Department> util = new ExcelUtil<>(Department.class);
        util.exportExcel(response, list, "部门信息数据");
    }

    /**
     * 获取部门信息详细信息
     */
    @PreAuthorize("@ss.hasPermi('department:department:query')")
    @GetMapping(value = "/{departmentId}")
    public AjaxResult getInfo(@PathVariable("departmentId") Long departmentId) {
        return success(departmentService.selectDepartmentByDepartmentId(departmentId));
    }

    /**
     * 新增部门信息
     */
    @PreAuthorize("@ss.hasPermi('department:department:add')")
    @Log(title = "部门信息", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody Department department) {
        return toAjax(departmentService.insertDepartment(department));
    }

    /**
     * 修改部门信息
     */
    @PreAuthorize("@ss.hasPermi('department:department:edit')")
    @Log(title = "部门信息", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody Department department) {
        return toAjax(departmentService.updateDepartment(department));
    }

    /**
     * 删除部门信息
     */
    @PreAuthorize("@ss.hasPermi('department:department:remove')")
    @Log(title = "部门信息", businessType = BusinessType.DELETE)
    @DeleteMapping("/{departmentIds}")
    public AjaxResult remove(@PathVariable Long[] departmentIds) {
        return toAjax(departmentService.deleteDepartmentByDepartmentIds(departmentIds));
    }
}
