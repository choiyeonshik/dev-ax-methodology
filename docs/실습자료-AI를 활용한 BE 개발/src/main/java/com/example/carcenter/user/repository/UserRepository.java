package com.example.carcenter.user.repository;

import com.example.carcenter.user.dto.UserDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Optional;

@Mapper
public interface UserRepository {

    /**
     * 사용자 생성
     */
    int insertUser(UserDto.CreateRequest request);

    /**
     * 사용자 조회 (ID)
     */
    Optional<UserDto.Response> findById(@Param("id") Long id);

    /**
     * 사용자 조회 (사용자명)
     */
    Optional<UserDto.Response> findByUsername(@Param("username") String username);

    /**
     * 사용자 조회 (이메일)
     */
    Optional<UserDto.Response> findByEmail(@Param("email") String email);

    /**
     * 사용자 목록 조회
     */
    List<UserDto.Response> findAll(@Param("offset") int offset, @Param("limit") int limit);

    /**
     * 사용자 수정
     */
    int updateUser(@Param("id") Long id, @Param("request") UserDto.UpdateRequest request);

    /**
     * 사용자 삭제 (논리삭제)
     */
    int deleteUser(@Param("id") Long id);

    /**
     * 사용자 활성화/비활성화
     */
    int updateUserStatus(@Param("id") Long id, @Param("active") boolean active);

    /**
     * 사용자 총 개수
     */
    int countUsers();

    /**
     * 사용자명 중복 확인
     */
    boolean existsByUsername(@Param("username") String username);

    /**
     * 이메일 중복 확인
     */
    boolean existsByEmail(@Param("email") String email);

    /**
     * 인증용 사용자 조회 (사용자명, 패스워드 포함)
     */
    Optional<UserDto.AuthUser> findAuthUserByUsername(@Param("username") String username);
}
