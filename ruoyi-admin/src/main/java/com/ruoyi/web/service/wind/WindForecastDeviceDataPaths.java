package com.ruoyi.web.service.wind;

import com.ruoyi.common.config.RuoYiConfig;

import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * 发电预测按设备隔离的默认 Excel 目录（与全局 yml 默认文件区分，避免多设备互相覆盖）。
 * 路径：{profile}/wind-device-data/{deviceId}/feature.xlsx | real.xlsx
 */
public final class WindForecastDeviceDataPaths {

    private WindForecastDeviceDataPaths() {
    }

    public static Path baseDir(long deviceId) {
        return Paths.get(RuoYiConfig.getProfile(), "wind-device-data", String.valueOf(deviceId));
    }

    public static Path featureFile(long deviceId) {
        return baseDir(deviceId).resolve("feature.xlsx");
    }

    public static Path realFile(long deviceId) {
        return baseDir(deviceId).resolve("real.xlsx");
    }

    /** @param kind {@code feature} 或 {@code real} */
    public static Path fileForKind(long deviceId, String kind) {
        if (kind == null) {
            return null;
        }
        if ("feature".equalsIgnoreCase(kind)) {
            return featureFile(deviceId);
        }
        if ("real".equalsIgnoreCase(kind)) {
            return realFile(deviceId);
        }
        return null;
    }
}
