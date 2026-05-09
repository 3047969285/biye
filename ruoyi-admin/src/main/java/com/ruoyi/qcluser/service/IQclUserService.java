package com.ruoyi.qcluser.service;

import java.util.List;
import com.ruoyi.qcluser.domain.QclUser;

/**
 * 用户Service接口
 * 
 * @author wangchangzhen
 * @date 2025-11-03
 */
public interface IQclUserService 
{
    /**
     * 查询用户
     * 
     * @param id 用户主键
     * @return 用户
     */
    public QclUser selectQclUserById(Long id);

    /**
     * 查询用户列表
     * 
     * @param qclUser 用户
     * @return 用户集合
     */
    public List<QclUser> selectQclUserList(QclUser qclUser);

    /**
     * 新增用户
     * 
     * @param qclUser 用户
     * @return 结果
     */
    public int insertQclUser(QclUser qclUser);

    /**
     * 修改用户
     * 
     * @param qclUser 用户
     * @return 结果
     */
    public int updateQclUser(QclUser qclUser);

    /**
     * 批量删除用户
     * 
     * @param ids 需要删除的用户主键集合
     * @return 结果
     */
    public int deleteQclUserByIds(Long[] ids);

    /**
     * 删除用户信息
     * 
     * @param id 用户主键
     * @return 结果
     */
    public int deleteQclUserById(Long id);
}
