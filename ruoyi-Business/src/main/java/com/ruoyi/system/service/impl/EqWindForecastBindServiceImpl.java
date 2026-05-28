package com.ruoyi.system.service.impl;

import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.EqWindForecastBind;
import com.ruoyi.system.mapper.EqWindForecastBindMapper;
import com.ruoyi.system.service.IEqWindForecastBindService;
import org.springframework.stereotype.Service;

/**
 * 风电预测绑定Service业务层处理
 *
 * @author wangchangzhen
 * @date 2026-01-07
 */
@Service
public class EqWindForecastBindServiceImpl implements IEqWindForecastBindService {

    private final EqWindForecastBindMapper bindMapper;

    public EqWindForecastBindServiceImpl(EqWindForecastBindMapper bindMapper) {
        this.bindMapper = bindMapper;
    }

    /**
     * 根据设备ID查询风电预测绑定配置
     *
     * @param deviceId 设备ID
     * @return 绑定配置，不存在或参数为空时返回null
     */
    @Override
    public EqWindForecastBind selectByDeviceId(String deviceId) {
        if (StringUtils.isEmpty(deviceId)) {
            return null;
        }
        return bindMapper.selectByDeviceId(deviceId);
    }

    /**
     * 合并保存风电预测绑定（按设备ID upsert）
     *
     * @param patch 待合并的绑定数据
     */
    @Override
    public void mergeSave(EqWindForecastBind patch) {
        if (patch == null || StringUtils.isEmpty(patch.getDeviceId())) {
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
