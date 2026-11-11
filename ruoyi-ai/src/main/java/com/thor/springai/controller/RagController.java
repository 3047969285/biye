package com.thor.springai.controller;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.system.domain.AiMaintenanceForm;
import com.thor.springai.service.RagAppService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

/**
 * RAG 知识库问答控制器
 *
 * @author wangchangzhen
 */
@RestController
@RequestMapping("/springai/rag")
public class RagController extends BaseController {

    @Autowired
    private RagAppService ragAppService;

    /**
     * 新增知识库文档
     *
     * @param content 文档内容
     * @param title 文档标题
     * @param category 文档分类
     * @return 处理结果
     */
    @PostMapping("/document")
    public AjaxResult addDocument(@RequestParam(name = "content") String content,
                                   @RequestParam(name = "title", required = false) String title,
                                   @RequestParam(name = "category", required = false) String category) {
        return ragAppService.addDocument(content, title, category);
    }

    private Long getUserIdSafely() {
        try {
            return getUserId();
        } catch (Exception e) {
            logger.warn("无法获取用户ID: {}", e.getMessage());
            return null;
        }
    }

    private String getUsernameSafely() {
        try {
            return getUsername();
        } catch (Exception e) {
            logger.warn("无法获取用户名: {}", e.getMessage());
            return "匿名用户";
        }
    }

    /**
     * RAG 问答
     *
     * @param question 问题
     * @param topK 召回条数
     * @return 回答结果
     */
    @GetMapping("/ask")
    public AjaxResult askWithRag(@RequestParam(name = "question") String question,
                                  @RequestParam(name = "topK", defaultValue = "3") int topK,
                                  @RequestParam(name = "conversationId", required = false) String conversationId) {
        return ragAppService.askWithRag(question, topK, getUserIdSafely(), getUsernameSafely(), conversationId);
    }

    /**
     * RAG 问答（流式）
     *
     * @param question 问题
     * @param topK 召回条数
     * @return SSE 推送器
     */
    @GetMapping(value = "/ask/stream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public SseEmitter askWithRagStream(@RequestParam(name = "question") String question,
                                       @RequestParam(name = "topK", defaultValue = "3") int topK,
                                       @RequestParam(name = "conversationId", required = false) String conversationId) {
        return ragAppService.askWithRagStream(question, topK, getUserIdSafely(), getUsernameSafely(), conversationId);
    }

    /**
     * 生成运维表单
     *
     * @param question 问题
     * @param topK 召回条数
     * @param saveToDb 是否保存
     * @return 生成结果
     */
    @GetMapping("/generate-form")
    public AjaxResult generateMaintenanceForm(@RequestParam(name = "question") String question,
                                               @RequestParam(name = "topK", defaultValue = "3") int topK,
                                               @RequestParam(name = "saveToDb", defaultValue = "false") boolean saveToDb) {
        return ragAppService.generateMaintenanceForm(question, topK, saveToDb);
    }

    /**
     * 删除知识库文档
     *
     * @param documentId 文档ID
     * @return 删除结果
     */
    @DeleteMapping("/document/{documentId}")
    public AjaxResult deleteDocument(@PathVariable String documentId) {
        return ragAppService.deleteDocument(documentId);
    }

    /**
     * 清空知识库
     *
     * @return 清空结果
     */
    @PostMapping("/clear")
    public AjaxResult clearKnowledgeBase() {
        return ragAppService.clearKnowledgeBase();
    }

    /**
     * RAG 运行状态自检
     *
     * @return 运行状态
     */
    @GetMapping("/status")
    public AjaxResult getRagStatus() {
        return ragAppService.getRagRuntimeStatus();
    }

    /**
     * 查询运维表单列表
     *
     * @param form 查询条件
     * @return 表单列表
     */
    @GetMapping("/forms")
    public AjaxResult listForms(AiMaintenanceForm form) {
        startPage();
        return AjaxResult.success(getDataTable(ragAppService.selectForms(form)));
    }

    /**
     * 查询运维表单详情
     *
     * @param formId 表单ID
     * @return 表单详情
     */
    @GetMapping("/forms/{formId}")
    public AjaxResult getForm(@PathVariable Long formId) {
        return ragAppService.getForm(formId);
    }
}
