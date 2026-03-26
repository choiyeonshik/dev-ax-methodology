package com.example.carcenter.shop.repository;

import com.example.carcenter.shop.dto.ShopDto;
import com.example.carcenter.common.dto.PageRequest;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

/**
 * 정비소 정보 매퍼 인터페이스
 */
@Mapper
public interface ShopRepository {

    /**
     * 정비소 등록
     * @param shopDto 정비소 정보
     * @return 등록된 행 수
     */
    int insertShop(ShopDto shopDto);

    /**
     * 정비소 정보 조회 (ID로)
     * @param id 정비소 ID
     * @return 정비소 정보
     */
    Optional<ShopDto> selectShopById(@Param("id") Long id);

    /**
     * 정비소 정보 조회 (사업자번호로)
     * @param businessNumber 사업자번호
     * @return 정비소 정보
     */
    Optional<ShopDto> selectShopByBusinessNumber(@Param("businessNumber") String businessNumber);

    /**
     * 모든 정비소 목록 조회
     * @param pageRequest 페이징 정보
     * @return 정비소 목록
     */
    List<ShopDto> selectAllShops(@Param("page") PageRequest pageRequest);

    /**
     * 활성 정비소 목록 조회
     * @param pageRequest 페이징 정보
     * @return 정비소 목록
     */
    List<ShopDto> selectActiveShops(@Param("page") PageRequest pageRequest);

    /**
     * 정비소 이름으로 검색
     * @param name 정비소 이름 (부분 검색)
     * @param pageRequest 페이징 정보
     * @return 정비소 목록
     */
    List<ShopDto> selectShopsByName(@Param("name") String name, @Param("page") PageRequest pageRequest);

    /**
     * 위치 기반 정비소 검색
     * @param latitude 위도
     * @param longitude 경도
     * @param radiusKm 검색 반경 (km)
     * @param pageRequest 페이징 정보
     * @return 정비소 목록
     */
    List<ShopDto> selectShopsByLocation(@Param("latitude") BigDecimal latitude, 
                                       @Param("longitude") BigDecimal longitude, 
                                       @Param("radiusKm") Double radiusKm, 
                                       @Param("page") PageRequest pageRequest);

    /**
     * 평점 기준 정비소 검색
     * @param minRating 최소 평점
     * @param pageRequest 페이징 정보
     * @return 정비소 목록
     */
    List<ShopDto> selectShopsByRating(@Param("minRating") BigDecimal minRating, @Param("page") PageRequest pageRequest);

    /**
     * 정비소 정보 수정
     * @param shopDto 수정할 정비소 정보
     * @return 수정된 행 수
     */
    int updateShop(ShopDto shopDto);

    /**
     * 정비소 평점 업데이트
     * @param id 정비소 ID
     * @param rating 평점
     * @param totalReviews 총 리뷰 수
     * @return 수정된 행 수
     */
    int updateShopRating(@Param("id") Long id, @Param("rating") BigDecimal rating, @Param("totalReviews") Integer totalReviews);

    /**
     * 정비소 상태 변경
     * @param id 정비소 ID
     * @param status 상태
     * @return 수정된 행 수
     */
    int updateShopStatus(@Param("id") Long id, @Param("status") String status);

    /**
     * 정비소 삭제 (소프트 삭제)
     * @param id 정비소 ID
     * @return 삭제된 행 수
     */
    int deleteShop(@Param("id") Long id);

    /**
     * 정비소 완전 삭제
     * @param id 정비소 ID
     * @return 삭제된 행 수
     */
    int deleteShopPermanently(@Param("id") Long id);

    /**
     * 사업자번호 중복 검사
     * @param businessNumber 사업자번호
     * @param excludeId 제외할 정비소 ID (수정 시 사용)
     * @return 중복 여부
     */
    boolean existsByBusinessNumber(@Param("businessNumber") String businessNumber, @Param("excludeId") Long excludeId);

    /**
     * 정비소 총 개수 조회
     * @return 정비소 개수
     */
    int countAllShops();

    /**
     * 활성 정비소 개수 조회
     * @return 활성 정비소 개수
     */
    int countActiveShops();

    /**
     * 위치 기반 정비소 개수 조회
     * @param latitude 위도
     * @param longitude 경도
     * @param radiusKm 검색 반경 (km)
     * @return 정비소 개수
     */
    int countShopsByLocation(@Param("latitude") BigDecimal latitude, 
                            @Param("longitude") BigDecimal longitude, 
                            @Param("radiusKm") Double radiusKm);
}
