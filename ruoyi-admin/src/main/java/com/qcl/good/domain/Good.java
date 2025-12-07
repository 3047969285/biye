package com.qcl.good.domain;

import java.math.BigDecimal;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 管理商品对象 good
 * 
 * @author 风格
 * @date 2025-11-03
 */
public class Good extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 自增ID */
    @Excel(name = "自增ID")
    private Long goodId;

    /** 商品名称 */
    @Excel(name = "商品名称")
    private String goodName;

    /** 价格 */
    @Excel(name = "价格")
    private BigDecimal price;

    /** 图片链接 */
    @Excel(name = "图片链接")
    private String imageUrl;

    /** 类型ID */
    @Excel(name = "类型ID")
    private Long typeId;

    public void setGoodId(Long goodId) 
    {
        this.goodId = goodId;
    }

    public Long getGoodId() 
    {
        return goodId;
    }

    public void setGoodName(String goodName) 
    {
        this.goodName = goodName;
    }

    public String getGoodName() 
    {
        return goodName;
    }

    public void setPrice(BigDecimal price) 
    {
        this.price = price;
    }

    public BigDecimal getPrice() 
    {
        return price;
    }

    public void setImageUrl(String imageUrl) 
    {
        this.imageUrl = imageUrl;
    }

    public String getImageUrl() 
    {
        return imageUrl;
    }

    public void setTypeId(Long typeId) 
    {
        this.typeId = typeId;
    }

    public Long getTypeId() 
    {
        return typeId;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("goodId", getGoodId())
            .append("goodName", getGoodName())
            .append("price", getPrice())
            .append("imageUrl", getImageUrl())
            .append("typeId", getTypeId())
            .toString();
    }
}
