package com.ruoyi.system.service;

import com.ruoyi.system.domain.AiMaintenanceForm;
import com.ruoyi.system.domain.SysUserMessage;
import com.ruoyi.system.domain.vo.MaintenanceDevicePendingVo;

import java.util.List;

public interface ISysUserMessageService {

    /**
     * @return true 已写入站内消息并刷新 Redis 去重；false 未发送（无用户、状态不符或写库失败）
     */
    boolean notifyMaintenanceFormPending(AiMaintenanceForm form);

    /**
     * 按当前「待维护设备」列表同步未读消息：先删除本类型未读，再每台设备一条（与待维护列表条数一致）。
     */
    void syncMaintenanceDevicePendingMessages(List<MaintenanceDevicePendingVo> devices);

    List<SysUserMessage> selectMessageList(SysUserMessage query);

    int countUnread(Long userId);

    int markRead(Long msgId, Long userId);

    int markAllRead(Long userId);
}
