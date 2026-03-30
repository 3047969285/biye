package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.SysUserMessage;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface SysUserMessageMapper {

    int batchInsert(@Param("list") List<SysUserMessage> list);

    List<SysUserMessage> selectSysUserMessageList(SysUserMessage query);

    int countUnreadByUserId(@Param("userId") Long userId);

    int updateReadByMsgIdAndUserId(@Param("msgId") Long msgId, @Param("userId") Long userId);

    int updateAllReadByUserId(@Param("userId") Long userId);

    List<Long> selectNotifyUserIds();

    /** 删除指定类型的未读消息（用于待维护设备快照刷新） */
    int deleteUnreadByMsgType(@Param("msgType") String msgType);

    /** 是否已有该业务维度的消息（任意已读状态，用于同一表单/设备只推一次） */
    int countByUserMsgTypeBizId(@Param("userId") Long userId, @Param("msgType") String msgType, @Param("bizId") Long bizId);

    /** 删除 biz_id 不在集合中的消息（含已读），用于待维护设备列表收缩时去掉过期设备 */
    int deleteByMsgTypeAndBizIdNotIn(@Param("msgType") String msgType, @Param("bizIds") List<Long> bizIds);
}
