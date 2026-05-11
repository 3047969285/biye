package com.ruoyi.web.service.system;

import org.springframework.web.multipart.MultipartFile;
import com.ruoyi.common.core.domain.entity.SysUser;

/**
 * 个人信息桥接服务 — 封装需要 ruoyi-framework 依赖的业务逻辑。
 *
 * @author wangchangzhen
 */
public interface SysProfileBridgeService
{
    /** 修改个人信息并刷新缓存，返回 null 表示成功，否则返回错误消息。 */
    String updateProfile(SysUser user);

    /** 修改密码并刷新缓存，返回 null 表示成功，否则返回错误消息。 */
    String updatePwd(String oldPassword, String newPassword);

    /** 上传头像并刷新缓存，返回 null 表示成功，否则返回错误消息。成功时 result 中包含 imgUrl。 */
    String updateAvatar(MultipartFile file, java.util.Map<String, Object> result) throws Exception;
}
