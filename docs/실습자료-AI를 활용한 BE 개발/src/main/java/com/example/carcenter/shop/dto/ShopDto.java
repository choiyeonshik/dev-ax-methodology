package com.example.carcenter.shop.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 정비소 정보 DTO
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ShopDto {
    
    private Long id;
    private String name;
    private String businessNumber;
    private String address;
    private String phone;
    private String email;
    private BigDecimal latitude;
    private BigDecimal longitude;
    private String operatingHours; // JSON 문자열
    private String description;
    private BigDecimal rating;
    private Integer totalReviews;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private LocalDateTime deletedAt;
    
    // 계산된 필드
    private Double distance; // 사용자 위치로부터의 거리 (km)
    
    /**
     * 정비소 등록 요청 DTO
     */
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class CreateRequest {
        private String name;
        private String businessNumber;
        private String address;
        private String phone;
        private String email;
        private BigDecimal latitude;
        private BigDecimal longitude;
        private String operatingHours;
        private String description;
    }
    
    /**
     * 정비소 수정 요청 DTO
     */
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class UpdateRequest {
        private String name;
        private String address;
        private String phone;
        private String email;
        private BigDecimal latitude;
        private BigDecimal longitude;
        private String operatingHours;
        private String description;
        private String status;
    }
    
    /**
     * 정비소 응답 DTO
     */
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class Response {
        private Long id;
        private String name;
        private String businessNumber;
        private String address;
        private String phone;
        private String email;
        private BigDecimal latitude;
        private BigDecimal longitude;
        private String operatingHours;
        private String description;
        private BigDecimal rating;
        private Integer totalReviews;
        private String status;
        private LocalDateTime createdAt;
        private LocalDateTime updatedAt;
        
        // 계산된 필드
        private Double distance;
    }
}