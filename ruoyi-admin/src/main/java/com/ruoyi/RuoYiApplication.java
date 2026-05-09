package com.ruoyi;

import org.mybatis.spring.annotation.MapperScan;
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
    scanBasePackages = {"com.ruoyi", "com.thor.springai"},
    excludeName = {
        "com.alibaba.cloud.ai.autoconfigure.dashscope.DashScopeAgentAutoConfiguration",
        "com.alibaba.cloud.ai.autoconfigure.dashscope.DashScopeEmbeddingAutoConfiguration"
    })
@MapperScan(basePackages = {"com.ruoyi.system.mapper", "com.ruoyi.quartz.mapper", "com.ruoyi.qcluser.mapper", "com.ruoyi.deparment.mapper"})
public class RuoYiApplication
{
    public static void main(String[] args)
    {
        // System.setProperty("spring.devtools.restart.enabled", "false");
        SpringApplication.run(RuoYiApplication.class, args);
        System.out.println("(♥◠‿◠)ﾉﾞ  智能电网运维系统启动成功   ლ(´ڡ`ლ)ﾞ  \n" +
                " .-------.       ____     __        \n" +
                " |  _ _   \\      \\   \\   /  /    \n" +
                " | ( ' )  |       \\  _. /  '       \n" +
                " |(_ o _) /        _( )_ .'         \n" +
                " | (_,_).' __  ___(_ o _)'          \n" +
                " |  |\\ \\  |  ||   |(_,_)'         \n" +
                " |  | \\ `'   /|   `-'  /           \n" +
                " |  |  \\    /  \\      /           \n" +
                " ''-'   `'-'    `-..-'              ");
    }
}