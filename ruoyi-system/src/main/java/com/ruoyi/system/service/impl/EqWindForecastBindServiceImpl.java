package com.ruoyi.system.service.impl;

import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.EqWindForecastBind;
import com.ruoyi.system.mapper.EqWindForecastBindMapper;
import com.ruoyi.system.service.IEqWindForecastBindService;
import org.springframework.stereotype.Service;

@Service
public class EqWindForecastBindServiceImpl implements IEqWindForecastBindService {

    private final EqWindForecastBindMapper bindMapper;

    public EqWindForecastBindServiceImpl(EqWindForecastBindMapper bindMapper) {
        this.bindMapper = bindMapper;
    }

    @Override
    public EqWindForecastBind selectByDeviceId(Long deviceId) {
        if (deviceId == null || deviceId <= 0) {
            return null;
        }
        return bindMapper.selectByDeviceId(deviceId);
    }

    @Override
    public void mergeSave(EqWindForecastBind patch) {
        if (patch == null || patch.getDeviceId() == null || patch.getDeviceId() <= 0) {
            return;
        }
        EqWindForecastBind existing = bindMapper.selectByDeviceId(patch.getDeviceId());
        String model = existing != null ? existing.getModelPath() : null;
        String feat = existing != null ? existing.getFeatureExcelPath() : null;
        String real = existing != null ? existing.getRealExcelPath() : null;
        String inline = existing != null ? existing.getInlineDataJson() : null;
        if (StringUtils.isNotEmpty(patch.getModelPath())) {
            model = patch.getModelPath();
        }
        if (StringUtils.isNotEmpty(patch.getFeatureExcelPath())) {
            feat = patch.getFeatureExcelPath();
        }
        if (StringUtils.isNotEmpty(patch.getRealExcelPath())) {
            real = patch.getRealExcelPath();
        }
        if (patch.getInlineDataJson() != null) {
            inline = patch.getInlineDataJson();
        }
        EqWindForecastBind out = new EqWindForecastBind();
        out.setDeviceId(patch.getDeviceId());
        out.setModelPath(model);
        out.setFeatureExcelPath(feat);
        out.setRealExcelPath(real);
        out.setInlineDataJson(inline);
        if (existing == null) {
            bindMapper.insertEqWindForecastBind(out);
        } else {
            bindMapper.updateEqWindForecastBind(out);
        }
    }
}
