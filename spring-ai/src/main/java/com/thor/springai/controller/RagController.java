package com.thor.springai.controller;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.system.domain.AiMaintenanceForm;
import com.thor.springai.service.RagAppService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

@RestController
@RequestMapping("/springai/rag")
public class RagController extends BaseController {

    @Autowired
    private RagAppService ragAppService;

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

    @GetMapping("/ask")
    public AjaxResult askWithRag(@RequestParam(name = "question") String question,
                                  @RequestParam(name = "topK", defaultValue = "3") int topK) {
        return ragAppService.askWithRag(question, topK, getUserIdSafely(), getUsernameSafely());
    }

    @GetMapping(value = "/ask/stream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public SseEmitter askWithRagStream(@RequestParam(name = "question") String question,
                                       @RequestParam(name = "topK", defaultValue = "3") int topK) {
        return ragAppService.askWithRagStream(question, topK, getUserIdSafely(), getUsernameSafely());
    }

    @GetMapping("/generate-form")
    public AjaxResult generateMaintenanceForm(@RequestParam(name = "question") String question,
                                               @RequestParam(name = "topK", defaultValue = "3") int topK,
                                               @RequestParam(name = "saveToDb", defaultValue = "false") boolean saveToDb) {
        return ragAppService.generateMaintenanceForm(question, topK, saveToDb);
    }

    @DeleteMapping("/document/{documentId}")
    public AjaxResult deleteDocument(@PathVariable String documentId) {
        return ragAppService.deleteDocument(documentId);
    }

    @PostMapping("/clear")
    public AjaxResult clearKnowledgeBase() {
        return ragAppService.clearKnowledgeBase();
    }

    @GetMapping("/forms")
    public AjaxResult listForms(AiMaintenanceForm form) {
        startPage();
        return AjaxResult.success(getDataTable(ragAppService.selectForms(form)));
    }

    @GetMapping("/forms/{formId}")
    public AjaxResult getForm(@PathVariable Long formId) {
        return ragAppService.getForm(formId);
    }
}
