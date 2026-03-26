package com.example.carcenter.auth.service;

import com.example.carcenter.common.exception.BusinessException;
import com.example.carcenter.common.exception.ErrorCode;
import com.example.carcenter.common.security.JwtTokenProvider;
import com.example.carcenter.user.dto.UserDto;
import com.example.carcenter.user.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AuthService {

    private final AuthenticationManager authenticationManager;
    private final JwtTokenProvider tokenProvider;
    private final UserService userService;
    
    // InMemoryTokenService 자동 주입
    @Autowired
    private InMemoryTokenService tokenService;

    /**
     * 로그인
     */
    @Transactional
    public UserDto.LoginResponse login(UserDto.LoginRequest request) {
        try {
            // 인증 처리
            Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                    request.getUsername(),
                    request.getPassword()
                )
            );

            // 토큰 생성
            String accessToken = tokenProvider.generateAccessToken(authentication);
            String refreshToken = tokenProvider.generateRefreshToken(request.getUsername());

            // Refresh Token 저장
            saveRefreshToken(request.getUsername(), refreshToken);

            // 사용자 정보 조회
            UserDto.Response user = userService.getUserByUsername(request.getUsername());

            return UserDto.LoginResponse.builder()
                    .accessToken(accessToken)
                    .refreshToken(refreshToken)
                    .tokenType("Bearer")
                    .expiresIn(86400L) // 24시간
                    .user(user)
                    .build();

        } catch (AuthenticationException e) {
            log.error("Authentication failed for username: {}", request.getUsername());
            throw new BusinessException(ErrorCode.AUTHENTICATION_FAILED);
        }
    }

    /**
     * 회원가입
     */
    @Transactional
    public UserDto.Response register(UserDto.CreateRequest request) {
        return userService.createUser(request);
    }

    /**
     * 토큰 갱신
     */
    @Transactional
    public UserDto.LoginResponse refresh(String refreshToken) {
        // 토큰 유효성 검증
        if (!tokenProvider.validateToken(refreshToken)) {
            throw new BusinessException(ErrorCode.INVALID_TOKEN);
        }

        // 사용자명 추출
        String username = tokenProvider.getUsernameFromToken(refreshToken);
        
        // 저장된 Refresh Token과 비교 검증
        if (!isValidRefreshToken(username, refreshToken)) {
            throw new BusinessException(ErrorCode.INVALID_TOKEN);
        }
        
        // 사용자 정보 조회
        UserDto.Response user = userService.getUserByUsername(username);

        // 새로운 토큰 생성 (사용자 정보로 Authentication 생성)
        Authentication authentication = new UsernamePasswordAuthenticationToken(
            user.getUsername(), null, 
            java.util.Collections.singletonList(new org.springframework.security.core.authority.SimpleGrantedAuthority("ROLE_" + user.getRole())));
        String newAccessToken = tokenProvider.generateAccessToken(authentication);
        String newRefreshToken = tokenProvider.generateRefreshToken(username);

        // 새로운 Refresh Token 저장
        saveRefreshToken(username, newRefreshToken);

        return UserDto.LoginResponse.builder()
                .accessToken(newAccessToken)
                .refreshToken(newRefreshToken)
                .tokenType("Bearer")
                .expiresIn(86400L) // 24시간
                .user(user)
                .build();
    }

    /**
     * 로그아웃
     */
    @Transactional
    public void logout(String accessToken, String refreshToken) {
        try {
            // Access Token에서 사용자명 추출
            String username = tokenProvider.getUsernameFromToken(accessToken);
            
            // Refresh Token 삭제
            deleteRefreshToken(username);
            
            // Access Token 블랙리스트에 추가
            addToBlacklist(accessToken);
            
            log.info("User {} logged out successfully", username);
        } catch (Exception e) {
            log.error("Error during logout", e);
            // 로그아웃은 실패해도 클라이언트에서 토큰을 삭제하므로 예외를 던지지 않음
        }
    }

    /**
     * Refresh Token 저장
     */
    private void saveRefreshToken(String username, String refreshToken) {
        tokenService.saveRefreshToken(username, refreshToken);
    }

    /**
     * Refresh Token 유효성 검증
     */
    private boolean isValidRefreshToken(String username, String refreshToken) {
        return tokenService.isValidRefreshToken(username, refreshToken);
    }

    /**
     * Refresh Token 삭제
     */
    private void deleteRefreshToken(String username) {
        tokenService.deleteRefreshToken(username);
    }

    /**
     * 토큰 블랙리스트에 추가
     */
    private void addToBlacklist(String token) {
        tokenService.addToBlacklist(token);
    }

    /**
     * 토큰 블랙리스트 확인
     */
    public boolean isBlacklisted(String token) {
        return tokenService.isBlacklisted(token);
    }
}
