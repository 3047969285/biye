package com.ruoyi.web.service.wind.impl;

import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.EqWindForecastBind;
import com.ruoyi.system.service.IEqWindForecastBindService;
import com.ruoyi.web.config.properties.WindForecastProperties;
import com.ruoyi.web.service.wind.WindForecastExcelFileService;
import com.ruoyi.web.service.wind.WindForecastDeviceDataPaths;
import com.ruoyi.web.service.wind.WindForecastPathResolver;
import org.springframework.stereotype.Service;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@Service
public class WindForecastExcelFileServiceImpl implements WindForecastExcelFileService {

    private final WindForecastProperties props;
    private final IEqWindForecastBindService bindService;

    public WindForecastExcelFileServiceImpl(WindForecastProperties props, IEqWindForecastBindService bindService) {
        this.props = props;
        this.bindService = bindService;
    }

    @Override
    public Path resolveExcelPath(long deviceId, String kind) {
        if (deviceId <= 0) {
            return null;
        }
        Path bound = resolveBoundPath(deviceId, kind);
        if (bound != null) {
            return bound;
        }
        Path perDevice = WindForecastDeviceDataPaths.fileForKind(deviceId, kind);
        if (perDevice != null && Files.isRegularFile(perDevice)) {
            return perDevice.toAbsolutePath().normalize();
        }
        if (!props.isGlobalYamlFallbackDevice(deviceId)) {
            return null;
        }
        String global = "feature".equalsIgnoreCase(kind) ? props.getFeatureExcel() : props.getRealExcel();
        String abs = WindForecastPathResolver.toAbsolutePath(global);
        if (StringUtils.isEmpty(abs)) {
            return null;
        }
        return Paths.get(abs).normalize();
    }

    @Override
    public Path resolveUploadTargetPath(long deviceId, String kind) {
        if (deviceId <= 0) {
            return null;
        }
        Path bound = resolveBoundPath(deviceId, kind);
        if (bound != null) {
            return bound;
        }
        Path perDevice = WindForecastDeviceDataPaths.fileForKind(deviceId, kind);
        if (perDevice == null) {
            return null;
        }
        try {
            Path parent = perDevice.getParent();
            if (parent != null) {
                Files.createDirectories(parent);
            }
        } catch (Exception ignored) {
            // transferTo 仍可能失败并返回错误
        }
        return perDevice.toAbsolutePath().normalize();
    }

    /** 仅当绑定表里配置了该 kind 的路径时返回，否则 null（由调用方决定用设备目录或全局） */
    private Path resolveBoundPath(long deviceId, String kind) {
        EqWindForecastBind bind = bindService.selectByDeviceId(deviceId);
        String raw = null;
        if ("feature".equalsIgnoreCase(kind)) {
            raw = bind != null ? bind.getFeatureExcelPath() : null;
        } else if ("real".equalsIgnoreCase(kind)) {
            raw = bind != null ? bind.getRealExcelPath() : null;
        } else {
            return null;
        }
        if (StringUtils.isEmpty(raw)) {
            return null;
        }
        String abs = WindForecastPathResolver.toAbsolutePath(raw.trim());
        if (StringUtils.isEmpty(abs)) {
            return null;
        }
        return Paths.get(abs).normalize();
    }
}
