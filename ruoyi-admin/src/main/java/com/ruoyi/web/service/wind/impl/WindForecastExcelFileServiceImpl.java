package com.ruoyi.web.service.wind.impl;

import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.EqWindForecastBind;
import com.ruoyi.system.service.IEqWindForecastBindService;
import com.ruoyi.web.config.properties.WindForecastProperties;
import com.ruoyi.web.service.wind.WindForecastExcelFileService;
import com.ruoyi.web.service.wind.WindForecastPathResolver;
import org.springframework.stereotype.Service;

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
        EqWindForecastBind bind = bindService.selectByDeviceId(deviceId);
        String raw;
        if ("feature".equalsIgnoreCase(kind)) {
            raw = firstNonBlank(bind != null ? bind.getFeatureExcelPath() : null, props.getFeatureExcel());
        } else if ("real".equalsIgnoreCase(kind)) {
            raw = firstNonBlank(bind != null ? bind.getRealExcelPath() : null, props.getRealExcel());
        } else {
            return null;
        }
        String abs = WindForecastPathResolver.toAbsolutePath(raw);
        if (StringUtils.isEmpty(abs)) {
            return null;
        }
        return Paths.get(abs).normalize();
    }

    private static String firstNonBlank(String... values) {
        if (values == null) {
            return null;
        }
        for (String v : values) {
            if (StringUtils.isNotEmpty(v)) {
                return v.trim();
            }
        }
        return null;
    }
}
