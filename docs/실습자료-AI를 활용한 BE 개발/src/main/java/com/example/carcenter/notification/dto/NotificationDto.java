package com.example.carcenter.notification.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;

import java.time.LocalDateTime;

/**
 * 알림 정보 DTO
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class NotificationDto {
    
    private Long id;
    private Long userId;
    private String type;
    private String title;
    private String message;
    private String channel;
    private String status;
    private LocalDateTime sentAt;
    private LocalDateTime readAt;
    private String metadata; // JSON 문자열
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // 연관 정보 (조인 시 사용)
    private String userName;
    private String userEmail;
    
    /**
     * 알림 생성 요청 DTO
     */
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class CreateRequest {
        private Long userId;
        private String type;
        private String title;
        private String message;
        private String channel;
        private String metadata;
    }
    
    /**
     * 알림 수정 요청 DTO
     */
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class UpdateRequest {
        private String type;
        private String title;
        private String message;
        private String channel;
        private String status;
        private LocalDateTime sentAt;
        private LocalDateTime readAt;
        private String metadata;
    }
    
    /**
     * 알림 응답 DTO
     */
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class Response {
        private Long id;
        private Long userId;
        private String type;
        private String title;
        private String message;
        private String channel;
        private String status;
        private LocalDateTime sentAt;
        private LocalDateTime readAt;
        private String metadata;
        private LocalDateTime createdAt;
        private LocalDateTime updatedAt;
        
        // 연관 정보
        private String userName;
        private String userEmail;
    }
}
