package com.example.carcenter.user.service;

import com.example.carcenter.common.exception.BusinessException;
import com.example.carcenter.common.exception.ErrorCode;
import com.example.carcenter.common.util.PasswordValidator;
import com.example.carcenter.user.dto.UserDto;
import com.example.carcenter.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import com.example.carcenter.common.dto.PageRequest;
import com.example.carcenter.common.dto.PageResponse;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    /**
     * 사용자 생성
     */
    @Transactional
    public UserDto.Response createUser(UserDto.CreateRequest request) {
        log.info("Creating user with username: {}", request.getUsername());
        
        // 중복 확인
        if (userRepository.existsByUsername(request.getUsername())) {
            log.warn("Username already exists: {}", request.getUsername());
            throw new BusinessException(ErrorCode.DUPLICATE_USERNAME);
        }
        if (userRepository.existsByEmail(request.getEmail())) {
            log.warn("Email already exists: {}", request.getEmail());
            throw new BusinessException(ErrorCode.DUPLICATE_EMAIL);
        }

        // 비밀번호 정책 검증
        PasswordValidator.PasswordValidationResult validationResult = 
            PasswordValidator.validate(request.getPassword());
        if (!validationResult.isValid()) {
            log.warn("Password validation failed for user {}: {}", 
                request.getUsername(), validationResult.getMessage());
            throw new BusinessException(ErrorCode.INVALID_PASSWORD, validationResult.getMessage());
        }

        // 비밀번호 암호화
        String encodedPassword = passwordEncoder.encode(request.getPassword());
        request.setPassword(encodedPassword);

        // 사용자 생성
        int result = userRepository.insertUser(request);
        if (result == 0) {
            log.error("Failed to create user: {}", request.getUsername());
            throw new BusinessException(ErrorCode.USER_CREATE_FAILED);
        }

        log.info("User created successfully: {} with ID: {}", request.getUsername(), request.getId());
        
        // 생성된 사용자 조회 (ID로 조회하여 더 효율적)
        if (request.getId() != null) {
            return userRepository.findById(request.getId())
                    .orElseThrow(() -> new BusinessException(ErrorCode.USER_NOT_FOUND));
        } else {
            // ID가 없는 경우 username으로 조회 (fallback)
            return userRepository.findByUsername(request.getUsername())
                    .orElseThrow(() -> new BusinessException(ErrorCode.USER_NOT_FOUND));
        }
    }

    /**
     * 사용자 조회 (ID)
     */
    public UserDto.Response getUserById(Long id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new BusinessException(ErrorCode.USER_NOT_FOUND));
    }

    /**
     * 사용자 조회 (사용자명)
     */
    public UserDto.Response getUserByUsername(String username) {
        return userRepository.findByUsername(username)
                .orElseThrow(() -> new BusinessException(ErrorCode.USER_NOT_FOUND));
    }

    /**
     * 사용자 목록 조회 (페이징)
     */
    public PageResponse<UserDto.Response> getUsers(PageRequest pageRequest) {
        int offset = pageRequest.getOffset();
        int limit = pageRequest.getLimit();
        
        List<UserDto.Response> users = userRepository.findAll(offset, limit);
        int total = userRepository.countUsers();
        
        return PageResponse.of(users, pageRequest, total);
    }

    /**
     * 사용자 수정
     */
    @Transactional
    public UserDto.Response updateUser(Long id, UserDto.UpdateRequest request) {
        // 사용자 존재 확인
        UserDto.Response existingUser = getUserById(id);

        // 이메일 중복 확인 (본인 제외)
        if (request.getEmail() != null && !request.getEmail().equals(existingUser.getEmail())) {
            if (userRepository.existsByEmail(request.getEmail())) {
                throw new BusinessException(ErrorCode.DUPLICATE_EMAIL);
            }
        }

        // 사용자 수정
        int result = userRepository.updateUser(id, request);
        if (result == 0) {
            throw new BusinessException(ErrorCode.USER_UPDATE_FAILED);
        }

        // 수정된 사용자 조회
        return getUserById(id);
    }

    /**
     * 사용자 삭제 (논리삭제)
     */
    @Transactional
    public void deleteUser(Long id) {
        // 사용자 존재 확인
        getUserById(id);

        int result = userRepository.deleteUser(id);
        if (result == 0) {
            throw new BusinessException(ErrorCode.USER_DELETE_FAILED);
        }
    }

    /**
     * 사용자 활성화/비활성화
     */
    @Transactional
    public void updateUserStatus(Long id, boolean active) {
        // 사용자 존재 확인
        getUserById(id);

        int result = userRepository.updateUserStatus(id, active);
        if (result == 0) {
            throw new BusinessException(ErrorCode.USER_UPDATE_FAILED);
        }
    }

    /**
     * 사용자명 중복 확인
     */
    public boolean isUsernameExists(String username) {
        return userRepository.existsByUsername(username);
    }

    /**
     * 이메일 중복 확인
     */
    public boolean isEmailExists(String email) {
        return userRepository.existsByEmail(email);
    }
}
