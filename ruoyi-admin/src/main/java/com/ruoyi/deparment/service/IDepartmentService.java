package com.ruoyi.deparment.service;

import java.util.List;
import com.ruoyi.deparment.domain.Model.Department;

/**
 * 部门信息Service接口
 * 
 * @author wangchangzhen
 * @date 2025-11-03
 */
public interface IDepartmentService 
{
    /**
     * 查询部门信息
     * 
     * @param departmentId 部门信息主键
     * @return 部门信息
     */
    public Department selectDepartmentByDepartmentId(Long departmentId);

    /**
     * 查询部门信息列表
     * 
     * @param department 部门信息
     * @return 部门信息集合
     */
    public List<Department> selectDepartmentList(Department department);

    /**
     * 新增部门信息
     * 
     * @param department 部门信息
     * @return 结果
     */
    public int insertDepartment(Department department);

    /**
     * 修改部门信息
     * 
     * @param department 部门信息
     * @return 结果
     */
    public int updateDepartment(Department department);

    /**
     * 批量删除部门信息
     * 
     * @param departmentIds 需要删除的部门信息主键集合
     * @return 结果
     */
    public int deleteDepartmentByDepartmentIds(Long[] departmentIds);

    /**
     * 删除部门信息信息
     * 
     * @param departmentId 部门信息主键
     * @return 结果
     */
    public int deleteDepartmentByDepartmentId(Long departmentId);
}
