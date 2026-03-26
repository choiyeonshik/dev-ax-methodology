package com.example.carcenter.vehicle.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;

import java.time.LocalDateTime;

/**
 * 차량 정보 DTO
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class VehicleDto {
    
    private Long id;
    private Long userId;
    private String licenseNumber;
    private String manufacturer;
    private String model;
    private Integer modelYear;
    private String engineType;
    private Integer mileage;
    private String color;
    private String vin;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private LocalDateTime deletedAt;
    
    // 연관 정보 (조인 시 사용)
    private String userName;
    private String userEmail;
    
    /**
     * 차량 등록 요청 DTO
     */
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class CreateRequest {
        private Long userId;
        private String licenseNumber;
        private String manufacturer;
        private String model;
        private Integer modelYear;
        private String engineType;
        private Integer mileage;
        private String color;
        private String vin;
    }
    
    /**
     * 차량 수정 요청 DTO
     */
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class UpdateRequest {
        private String licenseNumber;
        private String manufacturer;
        private String model;
        private Integer modelYear;
        private String engineType;
        private Integer mileage;
        private String color;
        private String vin;
    }
    
    /**
     * 차량 응답 DTO
     */
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class Response {
        private Long id;
        private Long userId;
        private String licenseNumber;
        private String manufacturer;
        private String model;
        private Integer modelYear;
        private String engineType;
        private Integer mileage;
        private String color;
        private String vin;
        private LocalDateTime createdAt;
        private LocalDateTime updatedAt;
        
        // 연관 정보
        private String userName;
        private String userEmail;
    }
}
