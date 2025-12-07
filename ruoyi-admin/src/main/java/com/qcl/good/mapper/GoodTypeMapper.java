package com.qcl.good.mapper;

import java.util.List;
import com.qcl.good.domain.GoodType;
import com.qcl.good.domain.Good;

/**
 * 分类管理Mapper接口
 * 
 * @author 风格
 * @date 2025-11-03
 */
public interface GoodTypeMapper 
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
     * 删除分类管理
     * 
     * @param typeId 分类管理主键
     * @return 结果
     */
    public int deleteGoodTypeByTypeId(Long typeId);

    /**
     * 批量删除分类管理
     * 
     * @param typeIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteGoodTypeByTypeIds(Long[] typeIds);

    /**
     * 批量删除管理商品
     * 
     * @param typeIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteGoodByTypeIds(Long[] typeIds);
    
    /**
     * 批量新增管理商品
     * 
     * @param goodList 管理商品列表
     * @return 结果
     */
    public int batchGood(List<Good> goodList);
    

    /**
     * 通过分类管理主键删除管理商品信息
     * 
     * @param typeId 分类管理ID
     * @return 结果
     */
    public int deleteGoodByTypeId(Long typeId);
}
