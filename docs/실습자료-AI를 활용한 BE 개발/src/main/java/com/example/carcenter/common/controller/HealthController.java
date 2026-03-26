package com.example.carcenter.common.controller;

import com.example.carcenter.common.response.ApiResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

/**
 * 애플리케이션 상태 확인을 위한 컨트롤러
 */
@RestController
@RequestMapping("/health")
@Tag(name = "Health Check", description = "애플리케이션 상태 확인 API")
public class HealthController {

    @GetMapping
    @Operation(summary = "기본 헬스체크", description = "애플리케이션의 기본 상태를 확인합니다.")
    public ResponseEntity<ApiResponse<Map<String, Object>>> health() {
        Map<String, Object> healthData = new HashMap<>();
        healthData.put("status", "UP");
        healthData.put("timestamp", LocalDateTime.now());
        healthData.put("application", "Car Center API");
        healthData.put("version", "1.0.0");
        
        return ResponseEntity.ok(ApiResponse.success("애플리케이션이 정상적으로 동작 중입니다.", healthData));
    }

    @GetMapping("/ping")
    @Operation(summary = "핑 체크", description = "간단한 응답성 확인을 위한 핑 엔드포인트입니다.")
    public ResponseEntity<ApiResponse<String>> ping() {
        return ResponseEntity.ok(ApiResponse.success("서버가 응답 중입니다.", "pong"));
    }

    @GetMapping("/info")
    @Operation(summary = "애플리케이션 정보", description = "애플리케이션의 기본 정보를 반환합니다.")
    public ResponseEntity<ApiResponse<Map<String, Object>>> info() {
        Map<String, Object> info = new HashMap<>();
        
        // 시스템 정보
        Runtime runtime = Runtime.getRuntime();
        info.put("application", "Car Center Management System");
        info.put("version", "1.0.0");
        info.put("java_version", System.getProperty("java.version"));
        info.put("java_vendor", System.getProperty("java.vendor"));
        info.put("os_name", System.getProperty("os.name"));
        info.put("os_version", System.getProperty("os.version"));
        
        // 메모리 정보
        Map<String, Object> memory = new HashMap<>();
        memory.put("max", runtime.maxMemory() / 1024 / 1024 + " MB");
        memory.put("total", runtime.totalMemory() / 1024 / 1024 + " MB");
        memory.put("free", runtime.freeMemory() / 1024 / 1024 + " MB");
        memory.put("used", (runtime.totalMemory() - runtime.freeMemory()) / 1024 / 1024 + " MB");
        info.put("memory", memory);
        
        // 활성 프로파일
        String profiles = System.getProperty("spring.profiles.active");
        info.put("active_profiles", profiles != null ? profiles : "default");
        
        info.put("timestamp", LocalDateTime.now());
        
        return ResponseEntity.ok(ApiResponse.success("애플리케이션 정보를 성공적으로 조회했습니다.", info));
    }
}
