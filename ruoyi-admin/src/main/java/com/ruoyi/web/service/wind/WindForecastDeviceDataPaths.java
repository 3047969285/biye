package com.ruoyi.web.service.wind;

import com.ruoyi.common.config.RuoYiConfig;

import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * 发电预测按设备隔离的数据目录（与全局 yml 默认区分，避免多设备互相覆盖）。
 * 路径：{profile}/wind-device-data/{deviceId}/feature.xlsx | real.xlsx | gru_FD.h5
 */
public final class WindForecastDeviceDataPaths {

    private WindForecastDeviceDataPaths() {
    }

    public static Path baseDir(String deviceId) {
        return Paths.get(RuoYiConfig.getProfile(), "wind-device-data", deviceId);
    }

    public static Path featureFile(String deviceId) {
        return baseDir(deviceId).resolve("feature.xlsx");
    }

    public static Path realFile(String deviceId) {
        return baseDir(deviceId).resolve("real.xlsx");
    }

    /** 设备专属 GRU 模型（与 Python train.py 默认文件名一致） */
    public static Path modelFile(String deviceId) {
        return baseDir(deviceId).resolve("gru_FD.h5");
    }

    /** @param kind {@code feature} 或 {@code real} */
    public static Path fileForKind(String deviceId, String kind) {
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
