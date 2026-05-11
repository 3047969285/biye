package com.ruoyi.web.service.system;

import com.ruoyi.common.core.domain.entity.SysRole;

/**
 * 角色管理桥接服务 — 封装需要 ruoyi-framework 依赖的业务逻辑。
 *
 * @author wangchangzhen
 */
public interface SysRoleBridgeService
{
    /** 更新角色并刷新登录用户权限缓存。 */
    String editRole(SysRole role);
}
