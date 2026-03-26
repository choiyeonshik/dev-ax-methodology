package com.example.carcenter.vehicle.repository;

import com.example.carcenter.vehicle.dto.VehicleDto;
import com.example.carcenter.common.dto.PageRequest;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Optional;

/**
 * 차량 정보 매퍼 인터페이스
 */
@Mapper
public interface VehicleRepository {

    /**
     * 차량 등록
     * @param vehicleDto 차량 정보
     * @return 등록된 행 수
     */
    int insertVehicle(VehicleDto vehicleDto);

    /**
     * 차량 정보 조회 (ID로)
     * @param id 차량 ID
     * @return 차량 정보
     */
    Optional<VehicleDto> selectVehicleById(@Param("id") Long id);

    /**
     * 차량 정보 조회 (차량번호로)
     * @param licenseNumber 차량번호
     * @return 차량 정보
     */
    Optional<VehicleDto> selectVehicleByLicenseNumber(@Param("licenseNumber") String licenseNumber);

    /**
     * 사용자별 차량 목록 조회
     * @param userId 사용자 ID
     * @return 차량 목록
     */
    List<VehicleDto> selectVehiclesByUserId(@Param("userId") Long userId);

    /**
     * 사용자별 차량 목록 조회 (페이징)
     * @param userId 사용자 ID
     * @param pageRequest 페이징 정보
     * @return 차량 목록
     */
    List<VehicleDto> selectVehiclesByUserIdWithPaging(@Param("userId") Long userId, @Param("page") PageRequest pageRequest);

    /**
     * 사용자별 차량 개수 조회
     * @param userId 사용자 ID
     * @return 차량 개수
     */
    int countVehiclesByUserId(@Param("userId") Long userId);

    /**
     * 차량 정보 수정
     * @param vehicleDto 수정할 차량 정보
     * @return 수정된 행 수
     */
    int updateVehicle(VehicleDto vehicleDto);

    /**
     * 차량 주행거리 업데이트
     * @param id 차량 ID
     * @param mileage 주행거리
     * @return 수정된 행 수
     */
    int updateVehicleMileage(@Param("id") Long id, @Param("mileage") Integer mileage);

    /**
     * 차량 삭제 (소프트 삭제)
     * @param id 차량 ID
     * @return 삭제된 행 수
     */
    int deleteVehicle(@Param("id") Long id);

    /**
     * 차량 완전 삭제
     * @param id 차량 ID
     * @return 삭제된 행 수
     */
    int deleteVehiclePermanently(@Param("id") Long id);

    /**
     * 차량번호 중복 검사
     * @param licenseNumber 차량번호
     * @param excludeId 제외할 차량 ID (수정 시 사용)
     * @return 중복 여부
     */
    boolean existsByLicenseNumber(@Param("licenseNumber") String licenseNumber, @Param("excludeId") Long excludeId);

    /**
     * 제조사별 차량 목록 조회
     * @param manufacturer 제조사
     * @param pageRequest 페이징 정보
     * @return 차량 목록
     */
    List<VehicleDto> selectVehiclesByManufacturer(@Param("manufacturer") String manufacturer, @Param("page") PageRequest pageRequest);

    /**
     * 연식별 차량 목록 조회
     * @param startYear 시작 연식
     * @param endYear 종료 연식
     * @param pageRequest 페이징 정보
     * @return 차량 목록
     */
    List<VehicleDto> selectVehiclesByYearRange(@Param("startYear") Integer startYear, @Param("endYear") Integer endYear, @Param("page") PageRequest pageRequest);

    /**
     * 엔진 타입별 차량 목록 조회
     * @param engineType 엔진 타입
     * @param pageRequest 페이징 정보
     * @return 차량 목록
     */
    List<VehicleDto> selectVehiclesByEngineType(@Param("engineType") String engineType, @Param("page") PageRequest pageRequest);
}
