package com.ruoyi;

import org.mybatis.spring.annotation.MapperScan;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

/**
 * 启动程序
 * 
 * @author wangchangzhen
 */
@EnableScheduling
@SpringBootApplication(
    scanBasePackages = {
        "com.ruoyi",
        "com.thor.springai",
        "com.example.dl645",
        "com.example.modbus",
        "com.example.protocoltrans.config",
        "com.example.protocoltrans.service",
        "com.example.protocoltrans.task"
    },
    excludeName = {
        "com.alibaba.cloud.ai.autoconfigure.dashscope.DashScopeAgentAutoConfiguration"
    })
@MapperScan(basePackages = {"com.ruoyi.system.mapper", "com.ruoyi.quartz.mapper", "com.ruoyi.qcluser.mapper", "com.ruoyi.department.mapper"})
public class RuoYiApplication
{
    private static final Logger LOG = LoggerFactory.getLogger(RuoYiApplication.class);

    public static void main(String[] args)
    {
        SpringApplication.run(RuoYiApplication.class, args);
        LOG.info("智能电网运维系统启动成功");
    }
}