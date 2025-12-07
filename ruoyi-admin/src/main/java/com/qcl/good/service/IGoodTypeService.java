package com.qcl.good.service;

import java.util.List;
import com.qcl.good.domain.GoodType;

/**
 * 分类管理Service接口
 * 
 * @author 风格
 * @date 2025-11-03
 */
public interface IGoodTypeService 
{
    /**
     * 查询分类管理
     * 
     * @param typeId 分类管理主键
     * @return 分类管理
     */
    public GoodType selectGoodTypeByTypeId(Long typeId);

    /**
     * 查询分类管理列表
     * 
     * @param goodType 分类管理
     * @return 分类管理集合
     */
    public List<GoodType> selectGoodTypeList(GoodType goodType);

    /**
     * 新增分类管理
     * 
     * @param goodType 分类管理
     * @return 结果
     */
    public int insertGoodType(GoodType goodType);

    /**
     * 修改分类管理
     * 
     * @param goodType 分类管理
     * @return 结果
     */
    public int updateGoodType(GoodType goodType);

    /**
     * 批量删除分类管理
     * 
     * @param typeIds 需要删除的分类管理主键集合
     * @return 结果
     */
    public int deleteGoodTypeByTypeIds(Long[] typeIds);

    /**
     * 删除分类管理信息
     * 
     * @param typeId 分类管理主键
     * @return 结果
     */
    public int deleteGoodTypeByTypeId(Long typeId);
}
