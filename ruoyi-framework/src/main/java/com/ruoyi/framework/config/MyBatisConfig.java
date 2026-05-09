package com.ruoyi.framework.config;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.context.annotation.Configuration;

/**
 * Mybatis配置类
 * 
 * 注意：Spring Boot 3.x 的 MyBatis Spring Boot Starter 已支持通配符包扫描
 * 
 * @author wangchangzhen
 */
@Configuration
public class MyBatisConfig
{
    // 使用 Spring Boot MyBatis 自动配置
    // Mapper 扫描通过 @MapperScan 注解配置
}
