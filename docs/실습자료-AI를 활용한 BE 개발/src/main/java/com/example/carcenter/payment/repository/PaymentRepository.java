package com.example.carcenter.payment.repository;

import com.example.carcenter.payment.dto.PaymentDto;
import com.example.carcenter.common.dto.PageRequest;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * 결제 정보 매퍼 인터페이스
 */
@Mapper
public interface PaymentRepository {

    /**
     * 결제 정보 생성
     * @param paymentDto 결제 정보
     * @return 등록된 행 수
     */
    int insertPayment(PaymentDto paymentDto);

    /**
     * 결제 정보 조회 (ID로)
     * @param id 결제 ID
     * @return 결제 정보
     */
    Optional<PaymentDto> selectPaymentById(@Param("id") Long id);

    /**
     * 결제 정보 조회 (결제번호로)
     * @param paymentNumber 결제번호
     * @return 결제 정보
     */
    Optional<PaymentDto> selectPaymentByPaymentNumber(@Param("paymentNumber") String paymentNumber);

    /**
     * 결제 정보 조회 (거래 ID로)
     * @param transactionId 거래 ID
     * @return 결제 정보
     */
    Optional<PaymentDto> selectPaymentByTransactionId(@Param("transactionId") String transactionId);

    /**
     * 견적별 결제 목록 조회
     * @param quoteId 견적 ID
     * @return 결제 목록
     */
    List<PaymentDto> selectPaymentsByQuoteId(@Param("quoteId") Long quoteId);

    /**
     * 상태별 결제 목록 조회
     * @param status 결제 상태
     * @param pageRequest 페이징 정보
     * @return 결제 목록
     */
    List<PaymentDto> selectPaymentsByStatus(@Param("status") String status, @Param("page") PageRequest pageRequest);

    /**
     * 결제 방법별 결제 목록 조회
     * @param paymentMethod 결제 방법
     * @param pageRequest 페이징 정보
     * @return 결제 목록
     */
    List<PaymentDto> selectPaymentsByMethod(@Param("paymentMethod") String paymentMethod, @Param("page") PageRequest pageRequest);

    /**
     * 날짜 범위별 결제 목록 조회
     * @param startDate 시작 날짜
     * @param endDate 종료 날짜
     * @param pageRequest 페이징 정보
     * @return 결제 목록
     */
    List<PaymentDto> selectPaymentsByDateRange(@Param("startDate") LocalDateTime startDate, 
                                              @Param("endDate") LocalDateTime endDate, 
                                              @Param("page") PageRequest pageRequest);

    /**
     * 금액 범위별 결제 목록 조회
     * @param minAmount 최소 금액
     * @param maxAmount 최대 금액
     * @param pageRequest 페이징 정보
     * @return 결제 목록
     */
    List<PaymentDto> selectPaymentsByAmountRange(@Param("minAmount") BigDecimal minAmount, 
                                                @Param("maxAmount") BigDecimal maxAmount, 
                                                @Param("page") PageRequest pageRequest);

    /**
     * 결제 정보 수정
     * @param paymentDto 수정할 결제 정보
     * @return 수정된 행 수
     */
    int updatePayment(PaymentDto paymentDto);

    /**
     * 결제 상태 변경
     * @param id 결제 ID
     * @param status 상태
     * @return 수정된 행 수
     */
    int updatePaymentStatus(@Param("id") Long id, @Param("status") String status);

    /**
     * 결제 완료 처리
     * @param id 결제 ID
     * @param paidAt 결제 완료 시간
     * @param transactionId 거래 ID
     * @return 수정된 행 수
     */
    int completePayment(@Param("id") Long id, @Param("paidAt") LocalDateTime paidAt, @Param("transactionId") String transactionId);

    /**
     * 결제 실패 처리
     * @param id 결제 ID
     * @param failureReason 실패 사유
     * @return 수정된 행 수
     */
    int failPayment(@Param("id") Long id, @Param("failureReason") String failureReason);

    /**
     * 환불 처리
     * @param id 결제 ID
     * @param refundAmount 환불 금액
     * @param refundReason 환불 사유
     * @param refundedAt 환불 시간
     * @return 수정된 행 수
     */
    int refundPayment(@Param("id") Long id, 
                     @Param("refundAmount") BigDecimal refundAmount, 
                     @Param("refundReason") String refundReason, 
                     @Param("refundedAt") LocalDateTime refundedAt);

    /**
     * 결제 삭제
     * @param id 결제 ID
     * @return 삭제된 행 수
     */
    int deletePayment(@Param("id") Long id);

    /**
     * 결제번호 중복 검사
     * @param paymentNumber 결제번호
     * @return 중복 여부
     */
    boolean existsByPaymentNumber(@Param("paymentNumber") String paymentNumber);

    /**
     * 거래 ID 중복 검사
     * @param transactionId 거래 ID
     * @return 중복 여부
     */
    boolean existsByTransactionId(@Param("transactionId") String transactionId);

    /**
     * 상태별 결제 개수 조회
     * @param status 결제 상태
     * @return 결제 개수
     */
    int countPaymentsByStatus(@Param("status") String status);

    /**
     * 결제 방법별 결제 개수 조회
     * @param paymentMethod 결제 방법
     * @return 결제 개수
     */
    int countPaymentsByMethod(@Param("paymentMethod") String paymentMethod);

    /**
     * 일별 결제 통계 조회
     * @param date 날짜
     * @return 결제 통계
     */
    PaymentDto selectDailyPaymentStats(@Param("date") LocalDateTime date);

    /**
     * 월별 결제 통계 조회
     * @param year 연도
     * @param month 월
     * @return 결제 통계
     */
    PaymentDto selectMonthlyPaymentStats(@Param("year") Integer year, @Param("month") Integer month);

    /**
     * 완료된 결제 목록 조회
     * @param pageRequest 페이징 정보
     * @return 결제 목록
     */
    List<PaymentDto> selectCompletedPayments(@Param("page") PageRequest pageRequest);

    /**
     * 실패한 결제 목록 조회
     * @param pageRequest 페이징 정보
     * @return 결제 목록
     */
    List<PaymentDto> selectFailedPayments(@Param("page") PageRequest pageRequest);

    /**
     * 환불된 결제 목록 조회
     * @param pageRequest 페이징 정보
     * @return 결제 목록
     */
    List<PaymentDto> selectRefundedPayments(@Param("page") PageRequest pageRequest);

    /**
     * 총 결제 금액 조회 (기간별)
     * @param startDate 시작 날짜
     * @param endDate 종료 날짜
     * @return 총 결제 금액
     */
    BigDecimal selectTotalPaymentAmount(@Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate);

    /**
     * 총 환불 금액 조회 (기간별)
     * @param startDate 시작 날짜
     * @param endDate 종료 날짜
     * @return 총 환불 금액
     */
    BigDecimal selectTotalRefundAmount(@Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate);
}
