package com.ruoyi.qcluser.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.qcluser.mapper.QclUserMapper;
import com.ruoyi.qcluser.domain.QclUser;
import com.ruoyi.qcluser.service.IQclUserService;

/**
 * 用户Service业务层处理
 * 
 * @author ruoyi
 * @date 2025-11-03
 */
@Service
public class QclUserServiceImpl implements IQclUserService 
{
    @Autowired
    private QclUserMapper qclUserMapper;

    /**
     * 查询用户
     * 
     * @param id 用户主键
     * @return 用户
     */
    @Override
    public QclUser selectQclUserById(Long id)
    {
        return qclUserMapper.selectQclUserById(id);
    }

    /**
     * 查询用户列表
     * 
     * @param qclUser 用户
     * @return 用户
     */
    @Override
    public List<QclUser> selectQclUserList(QclUser qclUser)
    {
        return qclUserMapper.selectQclUserList(qclUser);
    }

    /**
     * 新增用户
     * 
     * @param qclUser 用户
     * @return 结果
     */
    @Override
    public int insertQclUser(QclUser qclUser)
    {
        return qclUserMapper.insertQclUser(qclUser);
    }

    /**
     * 修改用户
     * 
     * @param qclUser 用户
     * @return 结果
     */
    @Override
    public int updateQclUser(QclUser qclUser)
    {
        return qclUserMapper.updateQclUser(qclUser);
    }

    /**
     * 批量删除用户
     * 
     * @param ids 需要删除的用户主键
     * @return 结果
     */
    @Override
    public int deleteQclUserByIds(Long[] ids)
    {
        return qclUserMapper.deleteQclUserByIds(ids);
    }

    /**
     * 删除用户信息
     * 
     * @param id 用户主键
     * @return 结果
     */
    @Override
    public int deleteQclUserById(Long id)
    {
        return qclUserMapper.deleteQclUserById(id);
    }
}
