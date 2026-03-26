package com.example.carcenter.booking.repository;

import com.example.carcenter.booking.dto.BookingDto;
import com.example.carcenter.common.dto.PageRequest;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * 예약 정보 매퍼 인터페이스
 */
@Mapper
public interface BookingRepository {

    /**
     * 예약 생성
     * @param bookingDto 예약 정보
     * @return 등록된 행 수
     */
    int insertBooking(BookingDto bookingDto);

    /**
     * 예약 정보 조회 (ID로)
     * @param id 예약 ID
     * @return 예약 정보
     */
    Optional<BookingDto> selectBookingById(@Param("id") Long id);

    /**
     * 사용자별 예약 목록 조회
     * @param userId 사용자 ID
     * @param pageRequest 페이징 정보
     * @return 예약 목록
     */
    List<BookingDto> selectBookingsByUserId(@Param("userId") Long userId, @Param("page") PageRequest pageRequest);

    /**
     * 정비소별 예약 목록 조회
     * @param shopId 정비소 ID
     * @param pageRequest 페이징 정보
     * @return 예약 목록
     */
    List<BookingDto> selectBookingsByShopId(@Param("shopId") Long shopId, @Param("page") PageRequest pageRequest);

    /**
     * 정비사별 예약 목록 조회
     * @param technicianId 정비사 ID
     * @param pageRequest 페이징 정보
     * @return 예약 목록
     */
    List<BookingDto> selectBookingsByTechnicianId(@Param("technicianId") Long technicianId, @Param("page") PageRequest pageRequest);

    /**
     * 상태별 예약 목록 조회
     * @param status 예약 상태
     * @param pageRequest 페이징 정보
     * @return 예약 목록
     */
    List<BookingDto> selectBookingsByStatus(@Param("status") String status, @Param("page") PageRequest pageRequest);

    /**
     * 날짜 범위별 예약 목록 조회
     * @param startDate 시작 날짜
     * @param endDate 종료 날짜
     * @param pageRequest 페이징 정보
     * @return 예약 목록
     */
    List<BookingDto> selectBookingsByDateRange(@Param("startDate") LocalDateTime startDate, 
                                              @Param("endDate") LocalDateTime endDate, 
                                              @Param("page") PageRequest pageRequest);

    /**
     * 정비소별 특정 날짜 예약 목록 조회
     * @param shopId 정비소 ID
     * @param appointmentDate 예약 날짜
     * @return 예약 목록
     */
    List<BookingDto> selectBookingsByShopAndDate(@Param("shopId") Long shopId, @Param("appointmentDate") LocalDateTime appointmentDate);

    /**
     * 예약 시간 중복 검사
     * @param shopId 정비소 ID
     * @param appointmentDateTime 예약 날짜/시간
     * @param excludeId 제외할 예약 ID (수정 시 사용)
     * @return 중복 여부
     */
    boolean existsByShopAndDateTime(@Param("shopId") Long shopId, 
                                   @Param("appointmentDateTime") LocalDateTime appointmentDateTime, 
                                   @Param("excludeId") Long excludeId);

    /**
     * 예약 정보 수정
     * @param bookingDto 수정할 예약 정보
     * @return 수정된 행 수
     */
    int updateBooking(BookingDto bookingDto);

    /**
     * 예약 상태 변경
     * @param id 예약 ID
     * @param status 상태
     * @return 수정된 행 수
     */
    int updateBookingStatus(@Param("id") Long id, @Param("status") String status);

    /**
     * 정비사 배정
     * @param id 예약 ID
     * @param technicianId 정비사 ID
     * @return 수정된 행 수
     */
    int assignTechnician(@Param("id") Long id, @Param("technicianId") Long technicianId);

    /**
     * 예약 삭제 (소프트 삭제)
     * @param id 예약 ID
     * @return 삭제된 행 수
     */
    int deleteBooking(@Param("id") Long id);

    /**
     * 예약 완전 삭제
     * @param id 예약 ID
     * @return 삭제된 행 수
     */
    int deleteBookingPermanently(@Param("id") Long id);

    /**
     * 사용자별 예약 개수 조회
     * @param userId 사용자 ID
     * @return 예약 개수
     */
    int countBookingsByUserId(@Param("userId") Long userId);

    /**
     * 정비소별 예약 개수 조회
     * @param shopId 정비소 ID
     * @return 예약 개수
     */
    int countBookingsByShopId(@Param("shopId") Long shopId);

    /**
     * 상태별 예약 개수 조회
     * @param status 예약 상태
     * @return 예약 개수
     */
    int countBookingsByStatus(@Param("status") String status);

    /**
     * 오늘 예약 목록 조회
     * @param shopId 정비소 ID (선택사항)
     * @return 예약 목록
     */
    List<BookingDto> selectTodayBookings(@Param("shopId") Long shopId);

    /**
     * 예정된 예약 목록 조회 (미래 예약)
     * @param userId 사용자 ID
     * @param pageRequest 페이징 정보
     * @return 예약 목록
     */
    List<BookingDto> selectUpcomingBookings(@Param("userId") Long userId, @Param("page") PageRequest pageRequest);

    /**
     * 완료된 예약 목록 조회 (과거 예약)
     * @param userId 사용자 ID
     * @param pageRequest 페이징 정보
     * @return 예약 목록
     */
    List<BookingDto> selectCompletedBookings(@Param("userId") Long userId, @Param("page") PageRequest pageRequest);
}
