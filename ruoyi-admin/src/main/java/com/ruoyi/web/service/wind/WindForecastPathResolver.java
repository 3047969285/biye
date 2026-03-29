package com.ruoyi.web.service.wind;

import com.ruoyi.common.config.RuoYiConfig;
import com.ruoyi.common.constant.Constants;
import com.ruoyi.common.utils.StringUtils;

/**
 * 将通用上传返回的 /profile/... 转为服务器绝对路径，供 Python 读取。
 */
public final class WindForecastPathResolver {

    private WindForecastPathResolver() {
    }

    public static String toAbsolutePath(String pathOrUrl) {
        if (StringUtils.isEmpty(pathOrUrl)) {
            return null;
        }
        String p = pathOrUrl.trim();
        if (p.startsWith(Constants.RESOURCE_PREFIX + "/") || p.equals(Constants.RESOURCE_PREFIX)) {
            String suffix = p.length() > Constants.RESOURCE_PREFIX.length()
                ? p.substring(Constants.RESOURCE_PREFIX.length())
                : "";
            if (suffix.startsWith("/")) {
                return RuoYiConfig.getProfile() + suffix;
            }
            return RuoYiConfig.getProfile() + "/" + suffix;
        }
        return p;
    }
}
