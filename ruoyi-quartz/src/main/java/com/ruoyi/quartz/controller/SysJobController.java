package com.ruoyi.quartz.controller;

import java.io.File;
import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.Objects;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ruoyi.common.annotation.Anonymous;
import com.ruoyi.quartz.dto.FileUploadRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.quartz.SchedulerException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.constant.Constants;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.exception.job.TaskException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.quartz.domain.SysJob;
import com.ruoyi.quartz.service.ISysJobService;
import com.ruoyi.quartz.util.CronUtils;
import com.ruoyi.quartz.util.ScheduleUtils;

/**
 * 调度任务信息操作处理
 * 
 * @author wangchangzhen
 */
@Anonymous
@RestController
@RequestMapping("/monitor/job")
public class SysJobController extends BaseController
{
    private static final String DEFAULT_DATE_TIME_PATTERN = "yyyy-MM-dd HH:mm:ss";

    @Autowired
    private ISysJobService jobService;

    /**
     * 查询定时任务列表
     */
    @PreAuthorize("@ss.hasPermi('monitor:job:list')")
    @GetMapping("/list")
    public TableDataInfo list(SysJob sysJob)
    {
        startPage();
        List<SysJob> list = jobService.selectJobList(sysJob);
        return getDataTable(list);
    }

    /**
     * 导出定时任务列表
     */
    @PreAuthorize("@ss.hasPermi('monitor:job:export')")
    @Log(title = "定时任务", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, SysJob sysJob)
    {
        List<SysJob> list = jobService.selectJobList(sysJob);
        ExcelUtil<SysJob> util = new ExcelUtil<SysJob>(SysJob.class);
        util.exportExcel(response, list, "定时任务");
    }

    /**
     * 获取定时任务详细信息
     */
    @PreAuthorize("@ss.hasPermi('monitor:job:query')")
    @GetMapping(value = "/{jobId}")
    public AjaxResult getInfo(@PathVariable("jobId") Long jobId)
    {
        return success(jobService.selectJobById(jobId));
    }

    /**
     * 新增定时任务
     */
    @PreAuthorize("@ss.hasPermi('monitor:job:add')")
    @Log(title = "定时任务", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody SysJob job) throws SchedulerException, TaskException
    {
        if (!CronUtils.isValid(job.getCronExpression()))
        {
            return error("新增任务'" + job.getJobName() + "'失败，Cron表达式不正确");
        }
        else if (StringUtils.containsIgnoreCase(job.getInvokeTarget(), Constants.LOOKUP_RMI))
        {
            return error("新增任务'" + job.getJobName() + "'失败，目标字符串不允许'rmi'调用");
        }
        else if (StringUtils.containsAnyIgnoreCase(job.getInvokeTarget(), new String[] { Constants.LOOKUP_LDAP, Constants.LOOKUP_LDAPS }))
        {
            return error("新增任务'" + job.getJobName() + "'失败，目标字符串不允许'ldap(s)'调用");
        }
        else if (StringUtils.containsAnyIgnoreCase(job.getInvokeTarget(), new String[] { Constants.HTTP, Constants.HTTPS }))
        {
            return error("新增任务'" + job.getJobName() + "'失败，目标字符串不允许'http(s)'调用");
        }
        else if (StringUtils.containsAnyIgnoreCase(job.getInvokeTarget(), Constants.JOB_ERROR_STR))
        {
            return error("新增任务'" + job.getJobName() + "'失败，目标字符串存在违规");
        }
        else if (!ScheduleUtils.whiteList(job.getInvokeTarget()))
        {
            return error("新增任务'" + job.getJobName() + "'失败，目标字符串不在白名单内");
        }
        job.setCreateBy(getUsername());
        return toAjax(jobService.insertJob(job));
    }

    /**
     * 修改定时任务
     */
    @PreAuthorize("@ss.hasPermi('monitor:job:edit')")
    @Log(title = "定时任务", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody SysJob job) throws SchedulerException, TaskException
    {
        if (!CronUtils.isValid(job.getCronExpression()))
        {
            return error("修改任务'" + job.getJobName() + "'失败，Cron表达式不正确");
        }
        else if (StringUtils.containsIgnoreCase(job.getInvokeTarget(), Constants.LOOKUP_RMI))
        {
            return error("修改任务'" + job.getJobName() + "'失败，目标字符串不允许'rmi'调用");
        }
        else if (StringUtils.containsAnyIgnoreCase(job.getInvokeTarget(), new String[] { Constants.LOOKUP_LDAP, Constants.LOOKUP_LDAPS }))
        {
            return error("修改任务'" + job.getJobName() + "'失败，目标字符串不允许'ldap(s)'调用");
        }
        else if (StringUtils.containsAnyIgnoreCase(job.getInvokeTarget(), new String[] { Constants.HTTP, Constants.HTTPS }))
        {
            return error("修改任务'" + job.getJobName() + "'失败，目标字符串不允许'http(s)'调用");
        }
        else if (StringUtils.containsAnyIgnoreCase(job.getInvokeTarget(), Constants.JOB_ERROR_STR))
        {
            return error("修改任务'" + job.getJobName() + "'失败，目标字符串存在违规");
        }
        else if (!ScheduleUtils.whiteList(job.getInvokeTarget()))
        {
            return error("修改任务'" + job.getJobName() + "'失败，目标字符串不在白名单内");
        }
        job.setUpdateBy(getUsername());
        return toAjax(jobService.updateJob(job));
    }

    /**
     * 定时任务状态修改
     */
    @PreAuthorize("@ss.hasPermi('monitor:job:changeStatus')")
    @Log(title = "定时任务", businessType = BusinessType.UPDATE)
    @PutMapping("/changeStatus")
    public AjaxResult changeStatus(@RequestBody SysJob job) throws SchedulerException
    {
        SysJob newJob = jobService.selectJobById(job.getJobId());
        newJob.setStatus(job.getStatus());
        return toAjax(jobService.changeStatus(newJob));
    }

    /**
     * 定时任务立即执行一次
     */
    @PreAuthorize("@ss.hasPermi('monitor:job:changeStatus')")
    @Log(title = "定时任务", businessType = BusinessType.UPDATE)
    @PutMapping("/run")
    public AjaxResult run(@RequestBody SysJob job) throws SchedulerException
    {
        boolean result = jobService.run(job);
        return result ? success() : error("任务不存在或已过期！");
    }

    /**
     * 删除定时任务
     */
    @PreAuthorize("@ss.hasPermi('monitor:job:remove')")
    @Log(title = "定时任务", businessType = BusinessType.DELETE)
    @DeleteMapping("/{jobIds}")
    public AjaxResult remove(@PathVariable Long[] jobIds) throws SchedulerException
    {
        jobService.deleteJobByIds(jobIds);
        return success();
    }

    @PostMapping("/upload")
    public AjaxResult uploadFiles(@RequestBody FileUploadRequest request) throws JsonProcessingException {
        if (request == null || request.getImgPath() == null || request.getImgPath().isEmpty()) {
            return error("请选择要上传的文件！");
        }

        // TODO: 替换 Thrift 调用为其他实现方式
        // 暂时返回成功，需要根据实际业务需求重新实现
        return AjaxResult.success("上传功能待实现");
    }

    /**
     * 按照中文模版格式返回字符串时间
     */
    @GetMapping("/time")
    public static String Time(String chineseTemplate, String timeToConvert) {
        String outputPattern = chineseTemplateToPattern(chineseTemplate);
        LocalDateTime dateTime = parseFlexibleToLocalDateTime(timeToConvert);
        return dateTime.format(DateTimeFormatter.ofPattern(outputPattern));
    }

    /** 中文占位 → DateTimeFormatter */
    private static String chineseTemplateToPattern(String chineseTemplate) {
        String pattern = Objects.toString(chineseTemplate, "").replace("\"", "").trim()
                .replace("年年年年", "yyyy")
                .replace("秒秒", "ss")
                .replace("分分", "mm")
                .replace("时时", "HH")
                .replace("日日", "dd")
                .replace("月月", "MM");
        if (StringUtils.isEmpty(pattern)) {
            return DEFAULT_DATE_TIME_PATTERN;
        }
        return pattern;
    }

    /**
     * 解析为 LocalDateTime；空为当前时间；按照格式转化（含时间戳、ISO、中英文日期时间、纯日期、纯时间）。
     */
    private static LocalDateTime parseFlexibleToLocalDateTime(String timeToConvert) {
        if (StringUtils.isEmpty(timeToConvert)) {
            return LocalDateTime.now();
        }
        String text = timeToConvert.replace("\"", "").trim();
        if (text.length() == 13 && text.chars().allMatch(Character::isDigit)) {
            return LocalDateTime.ofInstant(Instant.ofEpochMilli(Long.parseLong(text)), ZoneId.systemDefault());
        }
        if (text.length() == 10 && text.chars().allMatch(Character::isDigit)) {
            return LocalDateTime.ofInstant(Instant.ofEpochSecond(Long.parseLong(text)), ZoneId.systemDefault());
        }
        String[] dateTimePatterns = {
                "yyyy-MM-dd HH:mm:ss",
                "yyyy-MM-dd HH:mm:ss.SSS",
                "yyyy/MM/dd HH:mm:ss",
                "yyyy-MM-dd'T'HH:mm:ss",
                "yyyy-MM-dd'T'HH:mm:ss.SSS",
                "yyyy-MM-dd HH:mm",
                "yyyy年/MM月-dd日 HH:mm:ss",
                "yyyy年/MM月-dd日 HH:mm",
                "yyyy年/MM月-dd日 HH",
        };
        for (String p : dateTimePatterns) {
            try {
                return LocalDateTime.parse(text, DateTimeFormatter.ofPattern(p));
            } catch (DateTimeParseException ignored) {
            }
        }
        String[] datePatterns = {"yyyy-MM-dd", "yyyy/MM/dd", "yyyy年MM月dd日"};
        for (String p : datePatterns) {
            try {
                return LocalDate.parse(text, DateTimeFormatter.ofPattern(p)).atStartOfDay();
            } catch (DateTimeParseException ignored) {
            }
        }
        String[] timePatterns = {"HH:mm:ss", "HH:mm:ss.SSS", "HH:mm", "HH", "H:mm:ss"};
        for (String p : timePatterns) {
            try {
                return LocalDateTime.of(LocalDate.now(), LocalTime.parse(text, DateTimeFormatter.ofPattern(p)));
            } catch (DateTimeParseException ignored) {
            }
        }
        return LocalDateTime.now();
    }

















}
