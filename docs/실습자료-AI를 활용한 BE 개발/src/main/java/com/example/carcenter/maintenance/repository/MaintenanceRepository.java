package com.example.carcenter.maintenance.repository;

import com.example.carcenter.maintenance.dto.MaintenanceDto;
import com.example.carcenter.common.dto.PageRequest;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * 정비 작업 매퍼 인터페이스
 */
@Mapper
public interface MaintenanceRepository {

    /**
     * 정비 작업 생성
     * @param maintenanceDto 정비 작업 정보
     * @return 등록된 행 수
     */
    int insertMaintenance(MaintenanceDto maintenanceDto);

    /**
     * 정비 작업 조회 (ID로)
     * @param id 정비 작업 ID
     * @return 정비 작업 정보
     */
    Optional<MaintenanceDto> selectMaintenanceById(@Param("id") Long id);

    /**
     * 예약별 정비 작업 조회
     * @param bookingId 예약 ID
     * @return 정비 작업 정보
     */
    Optional<MaintenanceDto> selectMaintenanceByBookingId(@Param("bookingId") Long bookingId);

    /**
     * 정비사별 정비 작업 목록 조회
     * @param technicianId 정비사 ID
     * @param pageRequest 페이징 정보
     * @return 정비 작업 목록
     */
    List<MaintenanceDto> selectMaintenancesByTechnicianId(@Param("technicianId") Long technicianId, @Param("page") PageRequest pageRequest);

    /**
     * 상태별 정비 작업 목록 조회
     * @param status 정비 상태
     * @param pageRequest 페이징 정보
     * @return 정비 작업 목록
     */
    List<MaintenanceDto> selectMaintenancesByStatus(@Param("status") String status, @Param("page") PageRequest pageRequest);

    /**
     * 날짜 범위별 정비 작업 목록 조회
     * @param startDate 시작 날짜
     * @param endDate 종료 날짜
     * @param pageRequest 페이징 정보
     * @return 정비 작업 목록
     */
    List<MaintenanceDto> selectMaintenancesByDateRange(@Param("startDate") LocalDateTime startDate, 
                                                      @Param("endDate") LocalDateTime endDate, 
                                                      @Param("page") PageRequest pageRequest);

    /**
     * 차량별 정비 이력 조회
     * @param vehicleId 차량 ID
     * @param pageRequest 페이징 정보
     * @return 정비 작업 목록
     */
    List<MaintenanceDto> selectMaintenanceHistoryByVehicleId(@Param("vehicleId") Long vehicleId, @Param("page") PageRequest pageRequest);

    /**
     * 사용자별 정비 이력 조회
     * @param userId 사용자 ID
     * @param pageRequest 페이징 정보
     * @return 정비 작업 목록
     */
    List<MaintenanceDto> selectMaintenanceHistoryByUserId(@Param("userId") Long userId, @Param("page") PageRequest pageRequest);

    /**
     * 정비 작업 정보 수정
     * @param maintenanceDto 수정할 정비 작업 정보
     * @return 수정된 행 수
     */
    int updateMaintenance(MaintenanceDto maintenanceDto);

    /**
     * 정비 상태 변경
     * @param id 정비 작업 ID
     * @param status 상태
     * @return 수정된 행 수
     */
    int updateMaintenanceStatus(@Param("id") Long id, @Param("status") String status);

    /**
     * 정비 시작 시간 설정
     * @param id 정비 작업 ID
     * @param startedAt 시작 시간
     * @return 수정된 행 수
     */
    int updateMaintenanceStartTime(@Param("id") Long id, @Param("startedAt") LocalDateTime startedAt);

    /**
     * 정비 완료 시간 설정
     * @param id 정비 작업 ID
     * @param completedAt 완료 시간
     * @return 수정된 행 수
     */
    int updateMaintenanceCompletionTime(@Param("id") Long id, @Param("completedAt") LocalDateTime completedAt);

    /**
     * 진단 노트 업데이트
     * @param id 정비 작업 ID
     * @param diagnosisNotes 진단 노트
     * @return 수정된 행 수
     */
    int updateDiagnosisNotes(@Param("id") Long id, @Param("diagnosisNotes") String diagnosisNotes);

    /**
     * 작업 내용 업데이트
     * @param id 정비 작업 ID
     * @param workPerformed 작업 내용
     * @return 수정된 행 수
     */
    int updateWorkPerformed(@Param("id") Long id, @Param("workPerformed") String workPerformed);

    /**
     * 품질 검사 결과 업데이트
     * @param id 정비 작업 ID
     * @param qualityCheckPassed 품질 검사 통과 여부
     * @return 수정된 행 수
     */
    int updateQualityCheckResult(@Param("id") Long id, @Param("qualityCheckPassed") Boolean qualityCheckPassed);

    /**
     * 정비사 배정
     * @param id 정비 작업 ID
     * @param technicianId 정비사 ID
     * @return 수정된 행 수
     */
    int assignTechnician(@Param("id") Long id, @Param("technicianId") Long technicianId);

    /**
     * 정비 작업 삭제
     * @param id 정비 작업 ID
     * @return 삭제된 행 수
     */
    int deleteMaintenance(@Param("id") Long id);

    /**
     * 정비사별 작업 개수 조회
     * @param technicianId 정비사 ID
     * @return 작업 개수
     */
    int countMaintenancesByTechnicianId(@Param("technicianId") Long technicianId);

    /**
     * 상태별 작업 개수 조회
     * @param status 정비 상태
     * @return 작업 개수
     */
    int countMaintenancesByStatus(@Param("status") String status);

    /**
     * 진행 중인 정비 작업 목록 조회
     * @param technicianId 정비사 ID (선택사항)
     * @return 정비 작업 목록
     */
    List<MaintenanceDto> selectInProgressMaintenances(@Param("technicianId") Long technicianId);

    /**
     * 완료된 정비 작업 목록 조회
     * @param startDate 시작 날짜
     * @param endDate 종료 날짜
     * @param pageRequest 페이징 정보
     * @return 정비 작업 목록
     */
    List<MaintenanceDto> selectCompletedMaintenances(@Param("startDate") LocalDateTime startDate, 
                                                    @Param("endDate") LocalDateTime endDate, 
                                                    @Param("page") PageRequest pageRequest);

    /**
     * 정비 통계 조회 (월별)
     * @param year 연도
     * @param month 월
     * @return 통계 정보
     */
    List<MaintenanceDto> selectMaintenanceStatsByMonth(@Param("year") Integer year, @Param("month") Integer month);
}
