package com.example.carcenter.common.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * 애플리케이션 설정 클래스
 */
@Configuration
public class HealthCheckConfig {

    /**
     * 애플리케이션 정보 빈 설정
     */
    @Bean
    public String applicationInfo() {
        return "Car Center Management System v1.0.0";
    }
}
