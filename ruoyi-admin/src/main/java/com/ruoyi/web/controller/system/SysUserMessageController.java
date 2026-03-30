package com.ruoyi.web.controller.system;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.system.domain.SysUserMessage;
import com.ruoyi.system.service.ISysUserMessageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/system/user-message")
public class SysUserMessageController extends BaseController {

    @Autowired
    private ISysUserMessageService sysUserMessageService;

    @PreAuthorize("isAuthenticated()")
    @GetMapping("/list")
    public TableDataInfo list(SysUserMessage query) {
        query.setUserId(SecurityUtils.getUserId());
        startPage();
        List<SysUserMessage> list = sysUserMessageService.selectMessageList(query);
        return getDataTable(list);
    }

    @PreAuthorize("isAuthenticated()")
    @GetMapping("/unreadCount")
    public AjaxResult unreadCount() {
        int n = sysUserMessageService.countUnread(SecurityUtils.getUserId());
        return success(n);
    }

    @PreAuthorize("isAuthenticated()")
    @PutMapping("/read/{msgId}")
    public AjaxResult markRead(@PathVariable Long msgId) {
        int rows = sysUserMessageService.markRead(msgId, SecurityUtils.getUserId());
        return rows > 0 ? success() : error("消息不存在或已读");
    }

    @PreAuthorize("isAuthenticated()")
    @PutMapping("/readAll")
    public AjaxResult markAllRead() {
        int rows = sysUserMessageService.markAllRead(SecurityUtils.getUserId());
        return success(rows);
    }
}
