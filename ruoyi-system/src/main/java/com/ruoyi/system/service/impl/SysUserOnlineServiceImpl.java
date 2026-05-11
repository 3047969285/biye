package com.ruoyi.system.service.impl;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.constant.CacheConstants;
import com.ruoyi.common.core.domain.model.LoginUser;
import com.ruoyi.common.core.redis.RedisCache;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.SysUserOnline;
import com.ruoyi.system.service.ISysUserOnlineService;

@Service
public class SysUserOnlineServiceImpl implements ISysUserOnlineService {

    @Autowired
    private RedisCache redisCache;

    @Override
    public List<SysUserOnline> selectUserOnlineList(String ipaddr, String userName) {
        Collection<String> keys = redisCache.keys(CacheConstants.LOGIN_TOKEN_KEY + "*");
        List<SysUserOnline> userOnlineList = new ArrayList<>();
        for (String key : keys) {
            LoginUser user = resolveLoginUser(redisCache.getCacheObject(key));
            if (user == null || user.getUser() == null) {
                continue;
            }
            if (StringUtils.isNotEmpty(ipaddr) && StringUtils.isNotEmpty(userName)) {
                userOnlineList.add(selectOnlineByInfo(ipaddr, userName, user));
            } else if (StringUtils.isNotEmpty(ipaddr)) {
                userOnlineList.add(selectOnlineByIpaddr(ipaddr, user));
            } else if (StringUtils.isNotEmpty(userName)) {
                userOnlineList.add(selectOnlineByUserName(userName, user));
            } else {
                userOnlineList.add(loginUserToUserOnline(user));
            }
        }
        Collections.reverse(userOnlineList);
        userOnlineList.removeAll(Collections.singleton(null));
        return userOnlineList;
    }

    @Override
    public SysUserOnline selectOnlineByIpaddr(String ipaddr, LoginUser user) {
        if (StringUtils.equals(ipaddr, user.getIpaddr())) {
            return loginUserToUserOnline(user);
        }
        return null;
    }

    @Override
    public SysUserOnline selectOnlineByUserName(String userName, LoginUser user) {
        if (StringUtils.equals(userName, user.getUsername())) {
            return loginUserToUserOnline(user);
        }
        return null;
    }

    @Override
    public SysUserOnline selectOnlineByInfo(String ipaddr, String userName, LoginUser user) {
        if (StringUtils.equals(ipaddr, user.getIpaddr()) && StringUtils.equals(userName, user.getUsername())) {
            return loginUserToUserOnline(user);
        }
        return null;
    }

    @Override
    public SysUserOnline loginUserToUserOnline(LoginUser user) {
        if (StringUtils.isNull(user) || StringUtils.isNull(user.getUser())) {
            return null;
        }
        SysUserOnline sysUserOnline = new SysUserOnline();
        sysUserOnline.setTokenId(user.getToken());
        sysUserOnline.setUserName(user.getUsername());
        sysUserOnline.setIpaddr(user.getIpaddr());
        sysUserOnline.setLoginLocation(user.getLoginLocation());
        sysUserOnline.setBrowser(user.getBrowser());
        sysUserOnline.setOs(user.getOs());
        sysUserOnline.setLoginTime(user.getLoginTime());
        if (StringUtils.isNotNull(user.getUser().getDept())) {
            sysUserOnline.setDeptName(user.getUser().getDept().getDeptName());
        }
        return sysUserOnline;
    }

    /** 处理 Redis 返回的可能类型：LoginUser / JSONObject / 其他 */
    private LoginUser resolveLoginUser(Object obj) {
        if (obj == null) {
            return null;
        }
        if (obj instanceof LoginUser loginUser) {
            return loginUser;
        }
        if (obj instanceof com.alibaba.fastjson2.JSONObject jsonObject) {
            return jsonObject.toJavaObject(LoginUser.class);
        }
        try {
            return com.alibaba.fastjson2.JSON.parseObject(
                com.alibaba.fastjson2.JSON.toJSONString(obj), LoginUser.class);
        } catch (Exception e) {
            return null;
        }
    }
}
