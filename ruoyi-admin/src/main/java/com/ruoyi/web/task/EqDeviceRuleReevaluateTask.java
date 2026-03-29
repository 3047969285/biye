package com.ruoyi.web.task;

import com.ruoyi.system.domain.EqDevice;
import com.ruoyi.system.mapper.EqDeviceMapper;
import com.ruoyi.system.service.IEqDeviceRuleEvaluationService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * 定时按设备对「最新一条运行状态」重算规则：补告警、抬升运行状态、打需维护标记。
 * <p>
 * 与采集入库触发的 {@link IEqDeviceRuleEvaluationService#evaluateAfterStatusChange} 形成闭环，
 * 适用于规则变更后补偿、漏报修复等生产场景，亦可作为毕设「规则引擎 + 调度」亮点说明。
 */
@Component
@ConditionalOnProperty(prefix = "ruoyi.equipment", name = "rule-reevaluate-enabled", havingValue = "true", matchIfMissing = true)
public class EqDeviceRuleReevaluateTask {

    private static final Logger log = LoggerFactory.getLogger(EqDeviceRuleReevaluateTask.class);

    private final EqDeviceMapper eqDeviceMapper;
    private final IEqDeviceRuleEvaluationService ruleEvaluationService;

    public EqDeviceRuleReevaluateTask(EqDeviceMapper eqDeviceMapper,
                                      IEqDeviceRuleEvaluationService ruleEvaluationService) {
        this.eqDeviceMapper = eqDeviceMapper;
        this.ruleEvaluationService = ruleEvaluationService;
    }

    @Scheduled(
        initialDelayString = "${ruoyi.equipment.rule-reevaluate-initial-ms:120000}",
        fixedDelayString = "${ruoyi.equipment.rule-reevaluate-interval-ms:900000}"
    )
    public void reevaluateLatestStatusPerDevice() {
        List<EqDevice> devices = eqDeviceMapper.selectEqDeviceList(new EqDevice());
        if (devices == null || devices.isEmpty()) {
            return;
        }
        int failures = 0;
        for (EqDevice device : devices) {
            if (device.getDeviceId() == null) {
                continue;
            }
            try {
                ruleEvaluationService.evaluateLatestStatusForDevice(device.getDeviceId());
            } catch (Exception e) {
                failures++;
                log.warn("定时规则重算失败 deviceId={} {}", device.getDeviceId(), e.getMessage());
            }
        }
        if (failures > 0) {
            log.warn("定时规则重算结束 设备数={} 失败数={}", devices.size(), failures);
        } else {
            log.debug("定时规则重算结束 设备数={}", devices.size());
        }
    }
}
