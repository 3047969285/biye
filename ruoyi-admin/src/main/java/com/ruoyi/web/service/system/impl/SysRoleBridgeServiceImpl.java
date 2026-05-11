package com.ruoyi.web.service.system.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.core.domain.entity.SysRole;
import com.ruoyi.common.core.domain.model.LoginUser;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.ServletUtils;
import com.ruoyi.framework.web.service.SysPermissionService;
import com.ruoyi.framework.web.service.TokenService;
import com.ruoyi.system.service.ISysRoleService;
import com.ruoyi.system.service.ISysUserService;
import com.ruoyi.web.service.system.SysRoleBridgeService;

@Service
public class SysRoleBridgeServiceImpl implements SysRoleBridgeService
{
    @Autowired
    private ISysRoleService roleService;

    @Autowired
    private TokenService tokenService;

    @Autowired
    private SysPermissionService permissionService;

    @Autowired
    private ISysUserService userService;

    @Override
    public String editRole(SysRole role)
    {
        if (roleService.updateRole(role) > 0)
        {
            LoginUser loginUser = tokenService.getLoginUser(ServletUtils.getRequest());
            if (StringUtils.isNotNull(loginUser.getUser()) && !loginUser.getUser().isAdmin())
            {
                loginUser.setUser(userService.selectUserByUserName(loginUser.getUser().getUserName()));
                loginUser.setPermissions(permissionService.getMenuPermission(loginUser.getUser()));
                tokenService.setLoginUser(loginUser);
            }
            return null;
        }
        return "修改角色'" + role.getRoleName() + "'失败，请联系管理员";
    }
}
