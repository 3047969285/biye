package com.ruoyi.system.service.impl;

import com.ruoyi.common.constant.CacheConstants;
import com.ruoyi.common.core.redis.RedisCache;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.AiMaintenanceForm;
import com.ruoyi.system.domain.SysUserMessage;
import com.ruoyi.system.domain.vo.MaintenanceDevicePendingVo;
import com.ruoyi.system.mapper.SysUserMessageMapper;
import com.ruoyi.system.service.ISysUserMessageService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

@Service
public class SysUserMessageServiceImpl implements ISysUserMessageService {

    private static final Logger log = LoggerFactory.getLogger(SysUserMessageServiceImpl.class);

    public static final String MSG_TYPE_MAINTENANCE_FORM = "maintenance_form";

    /** 与待维护设备列表同步，biz_id 存 device_id */
    public static final String MSG_TYPE_MAINTENANCE_DEVICE_PENDING = "maintenance_device_pending";

    private final SysUserMessageMapper sysUserMessageMapper;

    @Autowired(required = false)
    private RedisCache redisCache;

    public SysUserMessageServiceImpl(SysUserMessageMapper sysUserMessageMapper) {
        this.sysUserMessageMapper = sysUserMessageMapper;
    }

    @Override
    public boolean notifyMaintenanceFormPending(AiMaintenanceForm form) {
        if (form == null || form.getFormId() == null) {
            return false;
        }
        String status = form.getFormStatus();
        if (status != null && !"draft".equalsIgnoreCase(status) && !"pending".equalsIgnoreCase(status)) {
            return false;
        }
        List<Long> userIds = sysUserMessageMapper.selectNotifyUserIds();
        if (CollectionUtils.isEmpty(userIds)) {
            return false;
        }
        Long formBizId = form.getFormId();
        List<Long> toNotify = new ArrayList<>();
        for (Long uid : userIds) {
            if (uid == null) {
                continue;
            }
            if (sysUserMessageMapper.countByUserMsgTypeBizId(uid, MSG_TYPE_MAINTENANCE_FORM, String.valueOf(formBizId)) > 0) {
                continue;
            }
            toNotify.add(uid);
        }
        if (toNotify.isEmpty()) {
            return false;
        }
        String deviceName = form.getDeviceName() != null ? form.getDeviceName() : "未知设备";
        String priority = form.getPriorityLevel() != null ? form.getPriorityLevel() : "—";
        String title = "运维表单待处理";
        String content = String.format("设备「%s」已生成运维表单（#%s），优先级：%s，请及时处理。",
            deviceName, formBizId, priority);
        Date now = new Date();
        List<SysUserMessage> batch = new ArrayList<>(toNotify.size());
        for (Long uid : toNotify) {
            SysUserMessage m = new SysUserMessage();
            m.setUserId(uid);
            m.setMsgType(MSG_TYPE_MAINTENANCE_FORM);
            m.setTitle(title);
            m.setContent(content);
            m.setBizId(String.valueOf(formBizId));
            m.setReadFlag("0");
            m.setCreateTime(now);
            batch.add(m);
        }
        String dedupKey = CacheConstants.MAINTENANCE_FORM_SCHEDULE_NOTIFY_KEY + formBizId;
        if (redisCache != null) {
            boolean locked = redisCache.setCacheObjectIfAbsent(dedupKey, "1",
                CacheConstants.MAINTENANCE_FORM_NOTIFY_TTL_SECONDS, TimeUnit.SECONDS);
            if (!locked) {
                return false;
            }
        }
        try {
            sysUserMessageMapper.batchInsert(batch);
            return true;
        } catch (Exception e) {
            log.warn("推送运维表单消息失败: {}", e.getMessage());
            if (redisCache != null) {
                redisCache.deleteObject(dedupKey);
            }
            return false;
        }
    }

    @Override
    public void syncMaintenanceDevicePendingMessages(List<MaintenanceDevicePendingVo> devices) {
        if (CollectionUtils.isEmpty(devices)) {
            sysUserMessageMapper.deleteUnreadByMsgType(MSG_TYPE_MAINTENANCE_DEVICE_PENDING);
            return;
        }
        List<String> bizIds = devices.stream()
            .map(MaintenanceDevicePendingVo::getDeviceId)
            .filter(StringUtils::isNotEmpty)
            .map(String::trim)
            .filter(s -> !s.isEmpty())
            .distinct()
            .collect(Collectors.toList());
        if (!bizIds.isEmpty()) {
            sysUserMessageMapper.deleteByMsgTypeAndBizIdNotIn(MSG_TYPE_MAINTENANCE_DEVICE_PENDING, bizIds);
        }
        List<Long> userIds = sysUserMessageMapper.selectNotifyUserIds();
        if (CollectionUtils.isEmpty(userIds)) {
            return;
        }
        Date now = new Date();
        String title = "设备待维护";
        List<SysUserMessage> batch = new ArrayList<>();
        for (Long uid : userIds) {
            if (uid == null) {
                continue;
            }
            for (MaintenanceDevicePendingVo d : devices) {
                String deviceBizId = d.getDeviceId() != null ? d.getDeviceId().trim() : "";
                if (deviceBizId.isEmpty()) {
                    continue;
                }
                if (sysUserMessageMapper.countByUserMsgTypeBizId(uid, MSG_TYPE_MAINTENANCE_DEVICE_PENDING, deviceBizId) > 0) {
                    continue;
                }
                SysUserMessage m = new SysUserMessage();
                m.setUserId(uid);
                m.setMsgType(MSG_TYPE_MAINTENANCE_DEVICE_PENDING);
                m.setTitle(title);
                m.setContent(String.format("设备「%s」当前需维护（优先级：%s），请到运维表单页处理。", d.getDeviceName(), d.getPriority()));
                m.setBizId(deviceBizId);
                m.setReadFlag("0");
                m.setCreateTime(now);
                batch.add(m);
            }
        }
        if (batch.isEmpty()) {
            return;
        }
        try {
            sysUserMessageMapper.batchInsert(batch);
        } catch (Exception e) {
            log.warn("同步待维护设备站内消息失败: {}", e.getMessage());
        }
    }

    @Override
    public List<SysUserMessage> selectMessageList(SysUserMessage query) {
        return sysUserMessageMapper.selectSysUserMessageList(query);
    }

    @Override
    public int countUnread(Long userId) {
        if (userId == null) {
            return 0;
        }
        return sysUserMessageMapper.countUnreadByUserId(userId);
    }

    @Override
    public int markRead(Long msgId, Long userId) {
        if (msgId == null || userId == null) {
            return 0;
        }
        return sysUserMessageMapper.updateReadByMsgIdAndUserId(msgId, userId);
    }

    @Override
    public int markAllRead(Long userId) {
        if (userId == null) {
            return 0;
        }
        return sysUserMessageMapper.updateAllReadByUserId(userId);
    }

    @Override
    public int deleteMessage(Long msgId, Long userId) {
        if (msgId == null || userId == null) {
            return 0;
        }
        return sysUserMessageMapper.deleteByMsgIdAndUserId(msgId, userId);
    }
}
