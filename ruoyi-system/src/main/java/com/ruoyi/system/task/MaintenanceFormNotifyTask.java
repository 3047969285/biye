package com.ruoyi.system.task;

import com.ruoyi.common.core.redis.RedisCache;
import com.ruoyi.system.domain.AiMaintenanceForm;
import com.ruoyi.system.mapper.AiMaintenanceFormMapper;
import com.ruoyi.system.service.ISysUserMessageService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * 定时扫描待处理运维表单并推送站内消息；与实时推送共用
 * {@link ISysUserMessageService#notifyMaintenanceFormPending}，由 Redis SET NX 去重（见 CacheConstants）。
 */
@Component("maintenanceFormNotifyTask")
public class MaintenanceFormNotifyTask {

    private static final Logger log = LoggerFactory.getLogger(MaintenanceFormNotifyTask.class);

    @Autowired
    private AiMaintenanceFormMapper aiMaintenanceFormMapper;

    @Autowired
    private ISysUserMessageService sysUserMessageService;

    @Autowired(required = false)
    private RedisCache redisCache;

    public void scanPendingFormsAndNotify() {
        if (redisCache == null) {
            log.warn("[运维表单推送] Redis 未配置：将仅依赖数据库去重发送（并行多实例时可能重复，建议配置 Redis）");
        }
        List<AiMaintenanceForm> forms = aiMaintenanceFormMapper.selectPendingFormsForScheduledNotify();
        if (forms == null || forms.isEmpty()) {
            log.debug("maintenanceForm schedule notify: no pending forms");
            return;
        }
        int sent = 0;
        int noop = 0;
        for (AiMaintenanceForm form : forms) {
            if (form.getFormId() == null) {
                continue;
            }
            try {
                if (sysUserMessageService.notifyMaintenanceFormPending(form)) {
                    sent++;
                } else {
                    noop++;
                }
            } catch (Exception e) {
                log.warn("maintenanceForm schedule notify failed formId={}: {}", form.getFormId(), e.getMessage());
            }
        }
        log.info("maintenanceForm schedule notify: scanned={}, sent={}, noopDedupOrSkip={}",
            forms.size(), sent, noop);
    }
}
