package com.example.carcenter.auth.service;

import com.example.carcenter.common.security.JwtTokenProvider;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

/**
 * 인메모리 토큰 관리 서비스
 * Redis가 없는 환경에서 사용하는 대안 구현
 */
@Slf4j
@Service
public class InMemoryTokenService {

    private final JwtTokenProvider jwtTokenProvider;
    private final ConcurrentHashMap<String, TokenInfo> refreshTokenStore = new ConcurrentHashMap<>();
    private final ConcurrentHashMap<String, Long> blacklistedTokens = new ConcurrentHashMap<>();
    private final ScheduledExecutorService cleanupExecutor = Executors.newSingleThreadScheduledExecutor();

    public InMemoryTokenService(JwtTokenProvider jwtTokenProvider) {
        this.jwtTokenProvider = jwtTokenProvider;
        
        // 만료된 토큰들을 주기적으로 정리 (1시간마다)
        cleanupExecutor.scheduleAtFixedRate(this::cleanupExpiredTokens, 1, 1, TimeUnit.HOURS);
    }

    /**
     * Refresh Token 저장
     */
    public void saveRefreshToken(String username, String refreshToken) {
        long expiration = jwtTokenProvider.getExpirationDateFromToken(refreshToken).getTime();
        refreshTokenStore.put(username, new TokenInfo(refreshToken, expiration));
        log.debug("Refresh token saved for user: {}", username);
    }

    /**
     * Refresh Token 조회
     */
    public String getRefreshToken(String username) {
        TokenInfo tokenInfo = refreshTokenStore.get(username);
        if (tokenInfo != null && tokenInfo.getExpiresAt() > System.currentTimeMillis()) {
            return tokenInfo.getToken();
        }
        // 만료된 토큰은 제거
        if (tokenInfo != null) {
            refreshTokenStore.remove(username);
        }
        return null;
    }

    /**
     * Refresh Token 삭제 (로그아웃 시)
     */
    public void deleteRefreshToken(String username) {
        refreshTokenStore.remove(username);
        log.debug("Refresh token deleted for user: {}", username);
    }

    /**
     * Refresh Token 유효성 검증
     */
    public boolean isValidRefreshToken(String username, String refreshToken) {
        String storedToken = getRefreshToken(username);
        return storedToken != null && storedToken.equals(refreshToken) && 
               jwtTokenProvider.validateToken(refreshToken);
    }

    /**
     * 토큰 블랙리스트에 추가 (무효화)
     */
    public void addToBlacklist(String token) {
        try {
            long expiration = jwtTokenProvider.getExpirationDateFromToken(token).getTime();
            blacklistedTokens.put(token, expiration);
            log.debug("Token added to blacklist");
        } catch (Exception e) {
            log.error("Failed to add token to blacklist", e);
        }
    }

    /**
     * 토큰이 블랙리스트에 있는지 확인
     */
    public boolean isBlacklisted(String token) {
        Long expiration = blacklistedTokens.get(token);
        if (expiration != null) {
            if (expiration > System.currentTimeMillis()) {
                return true;
            } else {
                // 만료된 블랙리스트 엔트리 제거
                blacklistedTokens.remove(token);
            }
        }
        return false;
    }

    /**
     * 모든 사용자 토큰 무효화
     */
    public void invalidateAllTokensForUser(String username) {
        deleteRefreshToken(username);
        log.info("All tokens invalidated for user: {}", username);
    }

    /**
     * 만료된 토큰 정리
     */
    private void cleanupExpiredTokens() {
        long now = System.currentTimeMillis();
        
        // 만료된 refresh token 정리
        refreshTokenStore.entrySet().removeIf(entry -> entry.getValue().getExpiresAt() <= now);
        
        // 만료된 블랙리스트 토큰 정리
        blacklistedTokens.entrySet().removeIf(entry -> entry.getValue() <= now);
        
        log.debug("Expired tokens cleaned up");
    }

    /**
     * 토큰 정보 클래스
     */
    private static class TokenInfo {
        private final String token;
        private final long expiresAt;

        public TokenInfo(String token, long expiresAt) {
            this.token = token;
            this.expiresAt = expiresAt;
        }

        public String getToken() {
            return token;
        }

        public long getExpiresAt() {
            return expiresAt;
        }
    }
}
