package com.thor.springai.controller;

import com.alibaba.fastjson2.JSON;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.system.domain.AiMaintenanceForm;
import com.ruoyi.system.mapper.AiMaintenanceFormMapper;
import com.thor.springai.service.ChromaRagService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

/**
 * RAG（检索增强生成）控制器 - 基于 Chroma 向量数据库
 * 
 * @author ruoyi
 */
@RestController
@RequestMapping("/springai/rag")
public class RagController extends BaseController {

    private static final Logger logger = LoggerFactory.getLogger(RagController.class);
    
    @Autowired
    private ChromaRagService chromaRagService;

    @Autowired
    private AiMaintenanceFormMapper maintenanceFormMapper;

    /**
     * 添加文档到 Chroma 知识库
     * 
     * @param content 文档内容
     * @param title 文档标题
     * @param category 文档分类
     * @return 操作结果
     */
    @PostMapping("/document")
    public AjaxResult addDocument(@RequestParam(name = "content") String content, 
                                   @RequestParam(name = "title", required = false) String title,
                                   @RequestParam(name = "category", required = false) String category) {
        try {
            String documentId = UUID.randomUUID().toString();
            Map<String, String> metadata = new HashMap<>();
            if (title != null) metadata.put("title", title);
            if (category != null) metadata.put("category", category);
            metadata.put("timestamp", String.valueOf(System.currentTimeMillis()));
            
            chromaRagService.addDocument(documentId, content, metadata);
            return AjaxResult.success("文档添加成功", documentId);
        } catch (Exception e) {
            logger.error("添加文档失败: ", e);
            return AjaxResult.error("添加文档失败: " + e.getMessage());
        }
    }

    /**
     * 基于 RAG 生成运维操作表单（固定格式输出）
     * 
     * @param question 用户问题/故障描述
     * @param topK 检索文档数量（默认3）
     * @param saveToDb 是否保存到数据库（默认false）
     * @return 固定格式的运维表单
     */
    @GetMapping("/generate-form")
    public AjaxResult generateMaintenanceForm(@RequestParam(name = "question") String question,
                                               @RequestParam(name = "topK", defaultValue = "3") int topK,
                                               @RequestParam(name = "saveToDb", defaultValue = "false") boolean saveToDb) {
        try {
            // 使用 RAG 生成固定格式的运维表单
            ChromaRagService.MaintenanceFormResponse response = 
                chromaRagService.askWithFixedFormat(question, topK);
            
            // 如果需要保存到数据库
            if (saveToDb) {
                AiMaintenanceForm form = new AiMaintenanceForm();
                form.setDeviceName(response.getDeviceName());
                form.setFaultDescription(response.getFaultDescription());
                form.setMaintenanceType(response.getMaintenanceType());
                form.setPriorityLevel(response.getPriorityLevel());
                form.setEstimatedTime(response.getEstimatedTime());
                form.setRequiredTools(JSON.toJSONString(response.getRequiredTools()));
                form.setSafetyPrecautions(response.getSafetyPrecautions());
                form.setStepByStepGuide(JSON.toJSONString(response.getSteps()));
                form.setExpectedOutcome(response.getExpectedOutcome());
                form.setFormStatus("draft");
                form.setCreatedBy("AI");
                
                maintenanceFormMapper.insertAiMaintenanceForm(form);
                logger.info("运维表单已保存到数据库，ID: {}", form.getFormId());
                
                Map<String, Object> result = new HashMap<>();
                result.put("form", response);
                result.put("formId", form.getFormId());
                return AjaxResult.success("运维表单生成并保存成功", result);
            }
            
            return AjaxResult.success("运维表单生成成功", response);
        } catch (Exception e) {
            logger.error("生成运维表单失败: ", e);
            return AjaxResult.error("生成失败: " + e.getMessage());
        }
    }

    /**
     * 删除文档
     * 
     * @param documentId 文档ID
     * @return 操作结果
     */
    @DeleteMapping("/document/{documentId}")
    public AjaxResult deleteDocument(@PathVariable String documentId) {
        try {
            chromaRagService.deleteDocument(documentId);
            return AjaxResult.success("文档删除成功");
        } catch (Exception e) {
            logger.error("删除文档失败: ", e);
            return AjaxResult.error("删除失败: " + e.getMessage());
        }
    }

    /**
     * 获取运维表单列表
     * 
     * @param form 查询条件
     * @return 表单列表
     */
    @GetMapping("/forms")
    public AjaxResult listForms(AiMaintenanceForm form) {
        try {
            startPage();
            var list = maintenanceFormMapper.selectAiMaintenanceFormList(form);
            return AjaxResult.success(getDataTable(list));
        } catch (Exception e) {
            logger.error("查询运维表单失败: ", e);
            return AjaxResult.error("查询失败: " + e.getMessage());
        }
    }

    /**
     * 获取运维表单详情
     * 
     * @param formId 表单ID
     * @return 表单详情
     */
    @GetMapping("/forms/{formId}")
    public AjaxResult getForm(@PathVariable Long formId) {
        try {
            AiMaintenanceForm form = maintenanceFormMapper.selectAiMaintenanceFormById(formId);
            if (form == null) {
                return AjaxResult.error("表单不存在");
            }
            return AjaxResult.success(form);
        } catch (Exception e) {
            logger.error("查询运维表单失败: ", e);
            return AjaxResult.error("查询失败: " + e.getMessage());
        }
    }
}
