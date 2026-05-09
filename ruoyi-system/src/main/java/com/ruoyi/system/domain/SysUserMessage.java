package com.ruoyi.system.domain;

import com.ruoyi.common.core.domain.BaseEntity;

public class SysUserMessage extends BaseEntity {

    private static final long serialVersionUID = 1L;

    private Long msgId;
    private Long userId;
    private String msgType;
    private String title;
    private String content;
    /** 业务主键：运维表单为 formId 字符串，待维护设备同步为 deviceId（UUID） */
    private String bizId;
    private String readFlag;

    public Long getMsgId() {
        return msgId;
    }

    public void setMsgId(Long msgId) {
        this.msgId = msgId;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getMsgType() {
        return msgType;
    }

    public void setMsgType(String msgType) {
        this.msgType = msgType;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getBizId() {
        return bizId;
    }

    public void setBizId(String bizId) {
        this.bizId = bizId;
    }

    public String getReadFlag() {
        return readFlag;
    }

    public void setReadFlag(String readFlag) {
        this.readFlag = readFlag;
    }
}
