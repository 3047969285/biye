package com.ruoyi.department.domain.model;

import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.TreeEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

/**
 * 部门信息对象 department
 *
 * @author wangchangzhen
 * @date 2025-11-03
 */
public class Department extends TreeEntity {
    private static final long serialVersionUID = 1L;

    /** 部门ID */
    @Excel(name = "部门ID")
    private Long departmentId;

    /** 部门名称 */
    @Excel(name = "部门名称")
    private String departmentName;

    /** 部门负责人 */
    @Excel(name = "部门负责人")
    private String chairman;

    public void setDepartmentId(Long departmentId) {
        this.departmentId = departmentId;
    }

    public Long getDepartmentId() {
        return departmentId;
    }

    public void setDepartmentName(String departmentName) {
        this.departmentName = departmentName;
    }

    public String getDepartmentName() {
        return departmentName;
    }

    public void setChairman(String chairman) {
        this.chairman = chairman;
    }

    public String getChairman() {
        return chairman;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("departmentId", getDepartmentId())
            .append("departmentName", getDepartmentName())
            .append("parentId", getParentId())
            .append("chairman", getChairman())
            .toString();
    }
}
