package com.example.protocoltrans;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.scheduling.annotation.EnableScheduling;

/**
 * 协议转换统一平台启动类
 * @author wangchangzhen
 */
@SpringBootApplication()
@ComponentScan(basePackages = {"com.example.dl645", "com.example.modbus", "com.example.protocoltrans"})
@EnableScheduling
public class ProtocolTransApplication {
    public static void main(String[] args) {
        SpringApplication.run(ProtocolTransApplication.class, args);
    }
}
