package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.TUserMapper;
import com.ruoyi.system.domain.TUser;
import com.ruoyi.system.service.ITUserService;

/**
 * 用户Service业务层处理
 * 
 * @author ruoyi
 * @date 2025-10-31
 */
@Service
public class TUserServiceImpl implements ITUserService 
{
    @Autowired
    private TUserMapper tUserMapper;

    /**
     * 查询用户
     * 
     * @param id 用户主键
     * @return 用户
     */
    @Override
    public TUser selectTUserById(String id)
    {
        return tUserMapper.selectTUserById(id);
    }

    /**
     * 查询用户列表
     * 
     * @param tUser 用户
     * @return 用户
     */
    @Override
    public List<TUser> selectTUserList(TUser tUser)
    {
        return tUserMapper.selectTUserList(tUser);
    }

    /**
     * 新增用户
     * 
     * @param tUser 用户
     * @return 结果
     */
    @Override
    public int insertTUser(TUser tUser)
    {
        return tUserMapper.insertTUser(tUser);
    }

    /**
     * 修改用户
     * 
     * @param tUser 用户
     * @return 结果
     */
    @Override
    public int updateTUser(TUser tUser)
    {
        return tUserMapper.updateTUser(tUser);
    }

    /**
     * 批量删除用户
     * 
     * @param ids 需要删除的用户主键
     * @return 结果
     */
    @Override
    public int deleteTUserByIds(String[] ids)
    {
        return tUserMapper.deleteTUserByIds(ids);
    }

    /**
     * 删除用户信息
     * 
     * @param id 用户主键
     * @return 结果
     */
    @Override
    public int deleteTUserById(String id)
    {
        return tUserMapper.deleteTUserById(id);
    }
}
