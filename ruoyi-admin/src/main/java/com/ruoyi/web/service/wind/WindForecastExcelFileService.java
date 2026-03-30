package com.ruoyi.web.service.wind;

import java.nio.file.Path;

/**
 * 解析设备预测用的特征/真值 Excel 在服务器上的绝对路径。
 * 读取顺序：绑定路径 → 设备专属目录下已存在文件 → 仅当 deviceId 与 wind.forecast.bind-device-id 一致时回退 yml 全局默认。
 */
public interface WindForecastExcelFileService {

    /**
     * 用于下载、Python 预测：绑定优先；无绑定时若设备目录已有上传文件则用之；否则仅默认绑定设备可回退 yml。
     *
     * @param kind {@code feature} 或 {@code real}
     * @return 规范化后的绝对路径；未配置或 kind 非法时返回 {@code null}
     */
    Path resolveExcelPath(long deviceId, String kind);

    /**
     * 用于上传落盘：绑定中已配置路径则覆盖该路径；否则写入 {@code wind-device-data/{deviceId}/}，避免覆盖全局默认 Excel。
     */
    Path resolveUploadTargetPath(long deviceId, String kind);
}
