package com.ruoyi.web.service.system.impl;

import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import com.ruoyi.common.config.RuoYiConfig;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.common.core.domain.model.LoginUser;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.ServletUtils;
import com.ruoyi.common.utils.file.FileUploadUtils;
import com.ruoyi.common.utils.file.FileUtils;
import com.ruoyi.common.utils.file.MimeTypeUtils;
import com.ruoyi.framework.web.service.TokenService;
import com.ruoyi.system.service.ISysUserService;
import com.ruoyi.web.service.system.SysProfileBridgeService;

@Service
public class SysProfileBridgeServiceImpl implements SysProfileBridgeService
{
    @Autowired
    private TokenService tokenService;

    @Autowired
    private ISysUserService userService;

    @Override
    public String updateProfile(SysUser user)
    {
        LoginUser loginUser = tokenService.getLoginUser(ServletUtils.getRequest());
        SysUser currentUser = loginUser.getUser();
        currentUser.setNickName(user.getNickName());
        currentUser.setEmail(user.getEmail());
        currentUser.setPhonenumber(user.getPhonenumber());
        currentUser.setSex(user.getSex());
        if (StringUtils.isNotEmpty(user.getPhonenumber()) && !userService.checkPhoneUnique(currentUser))
        {
            return "修改用户'" + loginUser.getUsername() + "'失败，手机号码已存在";
        }
        if (StringUtils.isNotEmpty(user.getEmail()) && !userService.checkEmailUnique(currentUser))
        {
            return "修改用户'" + loginUser.getUsername() + "'失败，邮箱账号已存在";
        }
        if (userService.updateUserProfile(currentUser) > 0)
        {
            tokenService.setLoginUser(loginUser);
            return null;
        }
        return "修改个人信息异常，请联系管理员";
    }

    @Override
    public String updatePwd(String oldPassword, String newPassword)
    {
        LoginUser loginUser = tokenService.getLoginUser(ServletUtils.getRequest());
        String password = loginUser.getPassword();
        if (!SecurityUtils.matchesPassword(oldPassword, password))
        {
            return "修改密码失败，旧密码错误";
        }
        if (SecurityUtils.matchesPassword(newPassword, password))
        {
            return "新密码不能与旧密码相同";
        }
        newPassword = SecurityUtils.encryptPassword(newPassword);
        if (userService.resetUserPwd(loginUser.getUserId(), newPassword) > 0)
        {
            loginUser.getUser().setPwdUpdateDate(DateUtils.getNowDate());
            loginUser.getUser().setPassword(newPassword);
            tokenService.setLoginUser(loginUser);
            return null;
        }
        return "修改密码异常，请联系管理员";
    }

    @Override
    public String updateAvatar(MultipartFile file, Map<String, Object> result) throws Exception
    {
        LoginUser loginUser = tokenService.getLoginUser(ServletUtils.getRequest());
        String avatar = FileUploadUtils.upload(RuoYiConfig.getAvatarPath(), file, MimeTypeUtils.IMAGE_EXTENSION, true);
        if (userService.updateUserAvatar(loginUser.getUserId(), avatar))
        {
            String oldAvatar = loginUser.getUser().getAvatar();
            if (StringUtils.isNotEmpty(oldAvatar))
            {
                FileUtils.deleteFile(RuoYiConfig.getProfile() + FileUtils.stripPrefix(oldAvatar));
            }
            result.put("imgUrl", avatar);
            loginUser.getUser().setAvatar(avatar);
            tokenService.setLoginUser(loginUser);
            return null;
        }
        return "上传图片异常，请联系管理员";
    }
}
