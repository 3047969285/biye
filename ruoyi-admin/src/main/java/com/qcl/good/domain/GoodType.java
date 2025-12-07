package com.qcl.good.domain;

import java.util.List;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 分类管理对象 good_type
 * 
 * @author 风格
 * @date 2025-11-03
 */
public class GoodType extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 自增ID */
    private Long typeId;

    /** 类型名称 */
    @Excel(name = "类型名称")
    private String typeName;

    /** 管理商品信息 */
    private List<Good> goodList;

    public void setTypeId(Long typeId) 
    {
        this.typeId = typeId;
    }

    public Long getTypeId() 
    {
        return typeId;
    }

    public void setTypeName(String typeName) 
    {
        this.typeName = typeName;
    }

    public String getTypeName() 
    {
        return typeName;
    }

    public List<Good> getGoodList()
    {
        return goodList;
    }

    public void setGoodList(List<Good> goodList)
    {
        this.goodList = goodList;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("typeId", getTypeId())
            .append("typeName", getTypeName())
            .append("goodList", getGoodList())
            .toString();
    }
}
