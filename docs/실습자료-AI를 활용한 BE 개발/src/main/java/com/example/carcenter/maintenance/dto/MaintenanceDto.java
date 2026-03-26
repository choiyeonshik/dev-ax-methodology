package com.example.carcenter.maintenance.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 정비 작업 DTO
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MaintenanceDto {
    
    private Long id;
    private Long bookingId;
    private Long technicianId;
    private String status;
    private LocalDateTime startedAt;
    private LocalDateTime completedAt;
    private String diagnosisNotes;
    private String workPerformed;
    private String partsUsed; // JSON 문자열
    private BigDecimal laborHours;
    private BigDecimal totalCost;
    private Integer warrantyPeriod;
    private Boolean qualityCheckPassed;
    private String customerSignature;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // 연관 정보 (조인 시 사용)
    private String technicianName;
    private String shopName;
    private String vehicleLicenseNumber;
    private String vehicleManufacturer;
    private String vehicleModel;
    private String userName;
    
    /**
     * 정비 작업 생성 요청 DTO
     */
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class CreateRequest {
        private Long bookingId;
        private Long technicianId;
        private String status;
        private LocalDateTime startedAt;
        private String diagnosisNotes;
        private String workPerformed;
        private String partsUsed;
        private BigDecimal laborHours;
        private BigDecimal totalCost;
        private Integer warrantyPeriod;
    }
    
    /**
     * 정비 작업 수정 요청 DTO
     */
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class UpdateRequest {
        private Long technicianId;
        private String status;
        private LocalDateTime startedAt;
        private LocalDateTime completedAt;
        private String diagnosisNotes;
        private String workPerformed;
        private String partsUsed;
        private BigDecimal laborHours;
        private BigDecimal totalCost;
        private Integer warrantyPeriod;
        private Boolean qualityCheckPassed;
        private String customerSignature;
    }
    
    /**
     * 정비 작업 응답 DTO
     */
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class Response {
        private Long id;
        private Long bookingId;
        private Long technicianId;
        private String status;
        private LocalDateTime startedAt;
        private LocalDateTime completedAt;
        private String diagnosisNotes;
        private String workPerformed;
        private String partsUsed;
        private BigDecimal laborHours;
        private BigDecimal totalCost;
        private Integer warrantyPeriod;
        private Boolean qualityCheckPassed;
        private String customerSignature;
        private LocalDateTime createdAt;
        private LocalDateTime updatedAt;
        
        // 연관 정보
        private String technicianName;
        private String shopName;
        private String vehicleLicenseNumber;
        private String vehicleManufacturer;
        private String vehicleModel;
        private String userName;
    }
}
