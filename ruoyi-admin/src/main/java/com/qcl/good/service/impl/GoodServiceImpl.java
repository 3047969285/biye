package com.qcl.good.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.qcl.good.mapper.GoodMapper;
import com.qcl.good.domain.Good;
import com.qcl.good.service.IGoodService;

/**
 * 管理商品Service业务层处理
 * 
 * @author 风格
 * @date 2025-11-03
 */
@Service
public class GoodServiceImpl implements IGoodService 
{
    @Autowired
    private GoodMapper goodMapper;

    /**
     * 查询管理商品
     * 
     * @param goodId 管理商品主键
     * @return 管理商品
     */
    @Override
    public Good selectGoodByGoodId(Long goodId)
    {
        return goodMapper.selectGoodByGoodId(goodId);
    }

    /**
     * 查询管理商品列表
     * 
     * @param good 管理商品
     * @return 管理商品
     */
    @Override
    public List<Good> selectGoodList(Good good)
    {
        return goodMapper.selectGoodList(good);
    }

    /**
     * 新增管理商品
     * 
     * @param good 管理商品
     * @return 结果
     */
    @Override
    public int insertGood(Good good)
    {
        return goodMapper.insertGood(good);
    }

    /**
     * 修改管理商品
     * 
     * @param good 管理商品
     * @return 结果
     */
    @Override
    public int updateGood(Good good)
    {
        return goodMapper.updateGood(good);
    }

    /**
     * 批量删除管理商品
     * 
     * @param goodIds 需要删除的管理商品主键
     * @return 结果
     */
    @Override
    public int deleteGoodByGoodIds(Long[] goodIds)
    {
        return goodMapper.deleteGoodByGoodIds(goodIds);
    }

    /**
     * 删除管理商品信息
     * 
     * @param goodId 管理商品主键
     * @return 结果
     */
    @Override
    public int deleteGoodByGoodId(Long goodId)
    {
        return goodMapper.deleteGoodByGoodId(goodId);
    }
}
