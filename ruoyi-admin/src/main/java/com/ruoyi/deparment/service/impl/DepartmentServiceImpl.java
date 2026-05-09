package com.ruoyi.deparment.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.deparment.mapper.DepartmentMapper;
import com.ruoyi.deparment.domain.Model.Department;
import com.ruoyi.deparment.service.IDepartmentService;

/**
 * 部门信息Service业务层处理
 * 
 * @author wangchangzhen
 * @date 2025-11-03
 */
@Service
public class DepartmentServiceImpl implements IDepartmentService 
{
    @Autowired
    private DepartmentMapper departmentMapper;

    /**
     * 查询部门信息
     * 
     * @param departmentId 部门信息主键
     * @return 部门信息
     */
    @Override
    public Department selectDepartmentByDepartmentId(Long departmentId)
    {
        return departmentMapper.selectDepartmentByDepartmentId(departmentId);
    }

    /**
     * 查询部门信息列表
     * 
     * @param department 部门信息
     * @return 部门信息
     */
    @Override
    public List<Department> selectDepartmentList(Department department)
    {
        return departmentMapper.selectDepartmentList(department);
    }

    /**
     * 新增部门信息
     * 
     * @param department 部门信息
     * @return 结果
     */
    @Override
    public int insertDepartment(Department department)
    {
        return departmentMapper.insertDepartment(department);
    }

    /**
     * 修改部门信息
     * 
     * @param department 部门信息
     * @return 结果
     */
    @Override
    public int updateDepartment(Department department)
    {
        return departmentMapper.updateDepartment(department);
    }

    /**
     * 批量删除部门信息
     * 
     * @param departmentIds 需要删除的部门信息主键
     * @return 结果
     */
    @Override
    public int deleteDepartmentByDepartmentIds(Long[] departmentIds)
    {
        return departmentMapper.deleteDepartmentByDepartmentIds(departmentIds);
    }

    /**
     * 删除部门信息信息
     * 
     * @param departmentId 部门信息主键
     * @return 结果
     */
    @Override
    public int deleteDepartmentByDepartmentId(Long departmentId)
    {
        return departmentMapper.deleteDepartmentByDepartmentId(departmentId);
    }
}
