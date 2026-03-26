package com.example.carcenter.booking.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;

import java.time.LocalDateTime;

/**
 * 예약 정보 DTO
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class BookingDto {
    
    private Long id;
    private Long userId;
    private Long vehicleId;
    private Long shopId;
    private Long technicianId;
    private LocalDateTime appointmentDateTime;
    private String serviceTypes; // JSON 문자열
    private String description;
    private Integer estimatedDuration;
    private String status;
    private String priority;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private LocalDateTime deletedAt;
    
    // 연관 정보 (조인 시 사용)
    private String userName;
    private String userEmail;
    private String userPhone;
    private String vehicleLicenseNumber;
    private String vehicleManufacturer;
    private String vehicleModel;
    private String shopName;
    private String shopAddress;
    private String shopPhone;
    private String technicianName;
    
    /**
     * 예약 생성 요청 DTO
     */
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class CreateRequest {
        private Long userId;
        private Long vehicleId;
        private Long shopId;
        private Long technicianId;
        private LocalDateTime appointmentDateTime;
        private String serviceTypes;
        private String description;
        private Integer estimatedDuration;
        private String priority;
    }
    
    /**
     * 예약 수정 요청 DTO
     */
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class UpdateRequest {
        private Long vehicleId;
        private Long shopId;
        private Long technicianId;
        private LocalDateTime appointmentDateTime;
        private String serviceTypes;
        private String description;
        private Integer estimatedDuration;
        private String status;
        private String priority;
    }
    
    /**
     * 예약 응답 DTO
     */
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class Response {
        private Long id;
        private Long userId;
        private Long vehicleId;
        private Long shopId;
        private Long technicianId;
        private LocalDateTime appointmentDateTime;
        private String serviceTypes;
        private String description;
        private Integer estimatedDuration;
        private String status;
        private String priority;
        private LocalDateTime createdAt;
        private LocalDateTime updatedAt;
        
        // 연관 정보
        private String userName;
        private String userEmail;
        private String userPhone;
        private String vehicleLicenseNumber;
        private String vehicleManufacturer;
        private String vehicleModel;
        private String shopName;
        private String shopAddress;
        private String shopPhone;
        private String technicianName;
    }
}
