package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.AiMaintenanceForm;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * AI运维操作表单Mapper接口
 * 
 * @author wangchangzhen
 */
@Mapper
public interface AiMaintenanceFormMapper {
    
    /**
     * 查询AI运维操作表单
     * 
     * @param formId 表单ID
     * @return AI运维操作表单
     */
    AiMaintenanceForm selectAiMaintenanceFormById(Long formId);

    /**
     * 查询AI运维操作表单列表
     * 
     * @param aiMaintenanceForm AI运维操作表单
     * @return AI运维操作表单集合
     */
    List<AiMaintenanceForm> selectAiMaintenanceFormList(AiMaintenanceForm aiMaintenanceForm);

    /**
     * 新增AI运维操作表单
     * 
     * @param aiMaintenanceForm AI运维操作表单
     * @return 结果
     */
    int insertAiMaintenanceForm(AiMaintenanceForm aiMaintenanceForm);

    /**
     * 修改AI运维操作表单
     * 
     * @param aiMaintenanceForm AI运维操作表单
     * @return 结果
     */
    int updateAiMaintenanceForm(AiMaintenanceForm aiMaintenanceForm);

    /**
     * 删除AI运维操作表单
     * 
     * @param formId 表单ID
     * @return 结果
     */
    int deleteAiMaintenanceFormById(Long formId);

    /**
     * 批量删除AI运维操作表单
     * 
     * @param formIds 需要删除的数据ID
     * @return 结果
     */
    int deleteAiMaintenanceFormByIds(@Param("formIds") Long[] formIds);

    /**
     * 待处理状态表单，供定时任务扫描推送消息（draft/pending）
     */
    List<AiMaintenanceForm> selectPendingFormsForScheduledNotify();
}
