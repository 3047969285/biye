package com.qcl.good.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.ArrayList;
import com.ruoyi.common.utils.StringUtils;
import org.springframework.transaction.annotation.Transactional;
import com.qcl.good.domain.Good;
import com.qcl.good.mapper.GoodTypeMapper;
import com.qcl.good.domain.GoodType;
import com.qcl.good.service.IGoodTypeService;

/**
 * 分类管理Service业务层处理
 * 
 * @author 风格
 * @date 2025-11-03
 */
@Service
public class GoodTypeServiceImpl implements IGoodTypeService 
{
    @Autowired
    private GoodTypeMapper goodTypeMapper;

    /**
     * 查询分类管理
     * 
     * @param typeId 分类管理主键
     * @return 分类管理
     */
    @Override
    public GoodType selectGoodTypeByTypeId(Long typeId)
    {
        return goodTypeMapper.selectGoodTypeByTypeId(typeId);
    }

    /**
     * 查询分类管理列表
     * 
     * @param goodType 分类管理
     * @return 分类管理
     */
    @Override
    public List<GoodType> selectGoodTypeList(GoodType goodType)
    {
        return goodTypeMapper.selectGoodTypeList(goodType);
    }

    /**
     * 新增分类管理
     * 
     * @param goodType 分类管理
     * @return 结果
     */
    @Transactional
    @Override
    public int insertGoodType(GoodType goodType)
    {
        int rows = goodTypeMapper.insertGoodType(goodType);
        insertGood(goodType);
        return rows;
    }

    /**
     * 修改分类管理
     * 
     * @param goodType 分类管理
     * @return 结果
     */
    @Transactional
    @Override
    public int updateGoodType(GoodType goodType)
    {
        goodTypeMapper.deleteGoodByTypeId(goodType.getTypeId());
        insertGood(goodType);
        return goodTypeMapper.updateGoodType(goodType);
    }

    /**
     * 批量删除分类管理
     * 
     * @param typeIds 需要删除的分类管理主键
     * @return 结果
     */
    @Transactional
    @Override
    public int deleteGoodTypeByTypeIds(Long[] typeIds)
    {
        goodTypeMapper.deleteGoodByTypeIds(typeIds);
        return goodTypeMapper.deleteGoodTypeByTypeIds(typeIds);
    }

    /**
     * 删除分类管理信息
     * 
     * @param typeId 分类管理主键
     * @return 结果
     */
    @Transactional
    @Override
    public int deleteGoodTypeByTypeId(Long typeId)
    {
        goodTypeMapper.deleteGoodByTypeId(typeId);
        return goodTypeMapper.deleteGoodTypeByTypeId(typeId);
    }

    /**
     * 新增管理商品信息
     * 
     * @param goodType 分类管理对象
     */
    public void insertGood(GoodType goodType)
    {
        List<Good> goodList = goodType.getGoodList();
        Long typeId = goodType.getTypeId();
        if (StringUtils.isNotNull(goodList))
        {
            List<Good> list = new ArrayList<Good>();
            for (Good good : goodList)
            {
                good.setTypeId(typeId);
                list.add(good);
            }
            if (list.size() > 0)
            {
                goodTypeMapper.batchGood(list);
            }
        }
    }
}
