package com.example.carcenter.notification.repository;

import com.example.carcenter.notification.dto.NotificationDto;
import com.example.carcenter.common.dto.PageRequest;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * 알림 정보 매퍼 인터페이스
 */
@Mapper
public interface NotificationRepository {

    /**
     * 알림 생성
     * @param notificationDto 알림 정보
     * @return 등록된 행 수
     */
    int insertNotification(NotificationDto notificationDto);

    /**
     * 알림 정보 조회 (ID로)
     * @param id 알림 ID
     * @return 알림 정보
     */
    Optional<NotificationDto> selectNotificationById(@Param("id") Long id);

    /**
     * 사용자별 알림 목록 조회
     * @param userId 사용자 ID
     * @param pageRequest 페이징 정보
     * @return 알림 목록
     */
    List<NotificationDto> selectNotificationsByUserId(@Param("userId") Long userId, @Param("page") PageRequest pageRequest);

    /**
     * 사용자별 읽지 않은 알림 목록 조회
     * @param userId 사용자 ID
     * @param pageRequest 페이징 정보
     * @return 알림 목록
     */
    List<NotificationDto> selectUnreadNotificationsByUserId(@Param("userId") Long userId, @Param("page") PageRequest pageRequest);

    /**
     * 알림 유형별 알림 목록 조회
     * @param type 알림 유형
     * @param pageRequest 페이징 정보
     * @return 알림 목록
     */
    List<NotificationDto> selectNotificationsByType(@Param("type") String type, @Param("page") PageRequest pageRequest);

    /**
     * 알림 채널별 알림 목록 조회
     * @param channel 알림 채널
     * @param pageRequest 페이징 정보
     * @return 알림 목록
     */
    List<NotificationDto> selectNotificationsByChannel(@Param("channel") String channel, @Param("page") PageRequest pageRequest);

    /**
     * 상태별 알림 목록 조회
     * @param status 알림 상태
     * @param pageRequest 페이징 정보
     * @return 알림 목록
     */
    List<NotificationDto> selectNotificationsByStatus(@Param("status") String status, @Param("page") PageRequest pageRequest);

    /**
     * 발송 대기 중인 알림 목록 조회
     * @param channel 알림 채널 (선택사항)
     * @param limit 최대 개수
     * @return 알림 목록
     */
    List<NotificationDto> selectPendingNotifications(@Param("channel") String channel, @Param("limit") Integer limit);

    /**
     * 날짜 범위별 알림 목록 조회
     * @param startDate 시작 날짜
     * @param endDate 종료 날짜
     * @param pageRequest 페이징 정보
     * @return 알림 목록
     */
    List<NotificationDto> selectNotificationsByDateRange(@Param("startDate") LocalDateTime startDate, 
                                                        @Param("endDate") LocalDateTime endDate, 
                                                        @Param("page") PageRequest pageRequest);

    /**
     * 알림 정보 수정
     * @param notificationDto 수정할 알림 정보
     * @return 수정된 행 수
     */
    int updateNotification(NotificationDto notificationDto);

    /**
     * 알림 상태 변경
     * @param id 알림 ID
     * @param status 상태
     * @return 수정된 행 수
     */
    int updateNotificationStatus(@Param("id") Long id, @Param("status") String status);

    /**
     * 알림 발송 완료 처리
     * @param id 알림 ID
     * @param sentAt 발송 시간
     * @return 수정된 행 수
     */
    int markNotificationAsSent(@Param("id") Long id, @Param("sentAt") LocalDateTime sentAt);

    /**
     * 알림 읽음 처리
     * @param id 알림 ID
     * @param readAt 읽은 시간
     * @return 수정된 행 수
     */
    int markNotificationAsRead(@Param("id") Long id, @Param("readAt") LocalDateTime readAt);

    /**
     * 사용자별 모든 알림 읽음 처리
     * @param userId 사용자 ID
     * @param readAt 읽은 시간
     * @return 수정된 행 수
     */
    int markAllNotificationsAsRead(@Param("userId") Long userId, @Param("readAt") LocalDateTime readAt);

    /**
     * 알림 발송 실패 처리
     * @param id 알림 ID
     * @return 수정된 행 수
     */
    int markNotificationAsFailed(@Param("id") Long id);

    /**
     * 알림 삭제
     * @param id 알림 ID
     * @return 삭제된 행 수
     */
    int deleteNotification(@Param("id") Long id);

    /**
     * 사용자별 알림 일괄 삭제
     * @param userId 사용자 ID
     * @param olderThan 이 날짜보다 오래된 알림 삭제
     * @return 삭제된 행 수
     */
    int deleteNotificationsByUser(@Param("userId") Long userId, @Param("olderThan") LocalDateTime olderThan);

    /**
     * 오래된 알림 일괄 삭제
     * @param olderThan 이 날짜보다 오래된 알림 삭제
     * @return 삭제된 행 수
     */
    int deleteOldNotifications(@Param("olderThan") LocalDateTime olderThan);

    /**
     * 사용자별 알림 개수 조회
     * @param userId 사용자 ID
     * @return 알림 개수
     */
    int countNotificationsByUserId(@Param("userId") Long userId);

    /**
     * 사용자별 읽지 않은 알림 개수 조회
     * @param userId 사용자 ID
     * @return 읽지 않은 알림 개수
     */
    int countUnreadNotificationsByUserId(@Param("userId") Long userId);

    /**
     * 상태별 알림 개수 조회
     * @param status 알림 상태
     * @return 알림 개수
     */
    int countNotificationsByStatus(@Param("status") String status);

    /**
     * 알림 유형별 알림 개수 조회
     * @param type 알림 유형
     * @return 알림 개수
     */
    int countNotificationsByType(@Param("type") String type);

    /**
     * 알림 채널별 알림 개수 조회
     * @param channel 알림 채널
     * @return 알림 개수
     */
    int countNotificationsByChannel(@Param("channel") String channel);

    /**
     * 일별 알림 통계 조회
     * @param date 날짜
     * @return 알림 통계
     */
    NotificationDto selectDailyNotificationStats(@Param("date") LocalDateTime date);

    /**
     * 월별 알림 통계 조회
     * @param year 연도
     * @param month 월
     * @return 알림 통계
     */
    NotificationDto selectMonthlyNotificationStats(@Param("year") Integer year, @Param("month") Integer month);

    /**
     * 재시도 대상 알림 목록 조회 (발송 실패한 알림)
     * @param maxRetryCount 최대 재시도 횟수
     * @param limit 최대 개수
     * @return 알림 목록
     */
    List<NotificationDto> selectRetryableNotifications(@Param("maxRetryCount") Integer maxRetryCount, @Param("limit") Integer limit);
}
