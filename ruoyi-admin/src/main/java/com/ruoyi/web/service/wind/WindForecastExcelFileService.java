package com.ruoyi.web.service.wind;

import java.nio.file.Path;

/**
 * 解析设备预测用的特征/真值 Excel 在服务器上的绝对路径（与按设备预测一致：绑定优先，缺省读 yml）。
 */
public interface WindForecastExcelFileService {

    /**
     * @param kind {@code feature} 或 {@code real}
     * @return 规范化后的绝对路径；未配置或 kind 非法时返回 {@code null}
     */
    Path resolveExcelPath(long deviceId, String kind);
}
