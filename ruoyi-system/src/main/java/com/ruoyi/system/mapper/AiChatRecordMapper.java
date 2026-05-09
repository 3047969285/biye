package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.AiChatRecord;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 智能问答对话记录 Mapper 接口
 * 
 * @author wangchangzhen
 * @date 2025-01-01
 */
@Mapper
public interface AiChatRecordMapper {
    /**
     * 查询对话记录列表
     * 
     * @param aiChatRecord 对话记录
     * @return 对话记录集合
     */
    List<AiChatRecord> selectAiChatRecordList(AiChatRecord aiChatRecord);

    /**
     * 根据记录ID查询对话记录
     * 
     * @param recordId 记录ID
     * @return 对话记录
     */
    AiChatRecord selectAiChatRecordByRecordId(@Param("recordId") Long recordId);

    /**
     * 新增对话记录
     * 
     * @param aiChatRecord 对话记录
     * @return 结果
     */
    int insertAiChatRecord(AiChatRecord aiChatRecord);

    /**
     * 更新AI回复消息
     * 
     * @param recordId 记录ID
     * @param aiMessage AI回复消息
     * @return 结果
     */
    int updateAiMessage(@Param("recordId") Long recordId, @Param("aiMessage") String aiMessage);

    /**
     * 删除对话记录
     * 
     * @param recordId 记录ID
     * @return 结果
     */
    int deleteAiChatRecordByRecordId(@Param("recordId") Long recordId);

    /**
     * 批量删除对话记录
     * 
     * @param recordIds 需要删除的记录ID
     * @return 结果
     */
    int deleteAiChatRecordByRecordIds(@Param("recordIds") Long[] recordIds);
}
