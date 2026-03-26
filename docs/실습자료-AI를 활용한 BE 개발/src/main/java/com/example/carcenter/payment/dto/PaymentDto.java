package com.example.carcenter.payment.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 결제 정보 DTO
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PaymentDto {
    
    private Long id;
    private Long quoteId;
    private String paymentNumber;
    private BigDecimal amount;
    private String paymentMethod;
    private String paymentGateway;
    private String transactionId;
    private String status;
    private LocalDateTime paidAt;
    private LocalDateTime refundedAt;
    private BigDecimal refundAmount;
    private String refundReason;
    private String failureReason;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // 연관 정보 (조인 시 사용)
    private String userName;
    private String userEmail;
    private String shopName;
    private String vehicleLicenseNumber;
    
    /**
     * 결제 생성 요청 DTO
     */
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class CreateRequest {
        private Long quoteId;
        private String paymentNumber;
        private BigDecimal amount;
        private String paymentMethod;
        private String paymentGateway;
    }
    
    /**
     * 결제 수정 요청 DTO
     */
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class UpdateRequest {
        private BigDecimal amount;
        private String paymentMethod;
        private String paymentGateway;
        private String transactionId;
        private String status;
        private LocalDateTime paidAt;
        private LocalDateTime refundedAt;
        private BigDecimal refundAmount;
        private String refundReason;
        private String failureReason;
    }
    
    /**
     * 결제 응답 DTO
     */
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class Response {
        private Long id;
        private Long quoteId;
        private String paymentNumber;
        private BigDecimal amount;
        private String paymentMethod;
        private String paymentGateway;
        private String transactionId;
        private String status;
        private LocalDateTime paidAt;
        private LocalDateTime refundedAt;
        private BigDecimal refundAmount;
        private String refundReason;
        private String failureReason;
        private LocalDateTime createdAt;
        private LocalDateTime updatedAt;
        
        // 연관 정보
        private String userName;
        private String userEmail;
        private String shopName;
        private String vehicleLicenseNumber;
    }
}
