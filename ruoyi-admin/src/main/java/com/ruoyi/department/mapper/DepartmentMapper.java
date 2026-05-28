package com.ruoyi.department.mapper;

import com.ruoyi.department.domain.model.Department;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

/**
 * 部门信息Mapper接口
 *
 * @author wangchangzhen
 * @date 2025-11-03
 */
@Mapper
public interface DepartmentMapper {
    /**
     * 查询部门信息
     *
     * @param departmentId 部门信息主键
     * @return 部门信息
     */
    Department selectDepartmentByDepartmentId(Long departmentId);

    /**
     * 查询部门信息列表
     *
     * @param department 部门信息
     * @return 部门信息集合
     */
    List<Department> selectDepartmentList(Department department);

    /**
     * 新增部门信息
     *
     * @param department 部门信息
     * @return 结果
     */
    int insertDepartment(Department department);

    /**
     * 修改部门信息
     *
     * @param department 部门信息
     * @return 结果
     */
    int updateDepartment(Department department);

    /**
     * 删除部门信息
     *
     * @param departmentId 部门信息主键
     * @return 结果
     */
    int deleteDepartmentByDepartmentId(Long departmentId);

    /**
     * 批量删除部门信息
     *
     * @param departmentIds 需要删除的数据主键集合
     * @return 结果
     */
    int deleteDepartmentByDepartmentIds(Long[] departmentIds);
}
