package com.ruoyi.quartz.task;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Service;

import com.ruoyi.common.core.domain.AjaxResult;

/**
 * Quartz「检查报警」调用目标 maintenanceFormService.notifyDevicesRequiringMaintenance 的实际入口。
 * <p>
 * spring-ai 中的 {@code MaintenanceFormService} 注册为 {@code springAiMaintenanceFormService}，
 * 由本类在白名单包 {@code com.ruoyi.quartz.task} 内提供 {@code maintenanceFormService} 名称并委托调用，
 * 避免 spring-ai 未加载或 Bean 名不一致时出现 {@code NoSuchBeanDefinitionException}。
 */
@Service("maintenanceFormService")
public class MaintenanceFormScheduleFacade {

    private static final Logger log = LoggerFactory.getLogger(MaintenanceFormScheduleFacade.class);

    private static final String DELEGATE_BEAN = "springAiMaintenanceFormService";

    @Autowired
    private ApplicationContext applicationContext;

    /**
     * 供 sys_job 调用：委托 spring-ai 运维表单服务聚合设备告警并推送站内消息。
     *
     * @return 业务结果（定时任务框架忽略返回值）
     */
    public AjaxResult notifyDevicesRequiringMaintenance() {
        log.info("[Quartz-检查报警] 开始执行 maintenanceFormService.notifyDevicesRequiringMaintenance");
        if (!applicationContext.containsBean(DELEGATE_BEAN)) {
            log.warn("[Quartz-检查报警] 未注册 Bean [{}]，跳过（请确认 spring-ai 已加载且扫描 com.thor.springai）", DELEGATE_BEAN);
            return AjaxResult.error("运维检查服务未加载：缺少 " + DELEGATE_BEAN);
        }
        try {
            Object delegate = applicationContext.getBean(DELEGATE_BEAN);
            Object out = delegate.getClass().getMethod("notifyDevicesRequiringMaintenance").invoke(delegate);
            if (out instanceof AjaxResult r) {
                log.info("[Quartz-检查报警] 执行结束 success={} msg={}", r.isSuccess(), r.get(AjaxResult.MSG_TAG));
                return r;
            }
            log.info("[Quartz-检查报警] 执行结束（无 AjaxResult 返回值）");
            return AjaxResult.success();
        } catch (Exception e) {
            log.error("[Quartz-检查报警] 委托执行失败", e);
            return AjaxResult.error("检查报警执行失败：" + e.getMessage());
        }
    }
}
