package com.example.carcenter.common.util;

import lombok.experimental.UtilityClass;

import java.util.regex.Pattern;

/**
 * 비밀번호 정책 검증 유틸리티 클래스
 */
@UtilityClass
public class PasswordValidator {

    // 최소 8자, 최대 100자
    private static final int MIN_LENGTH = 8;
    private static final int MAX_LENGTH = 100;
    
    // 대문자 포함 패턴
    private static final Pattern UPPERCASE_PATTERN = Pattern.compile(".*[A-Z].*");
    
    // 소문자 포함 패턴
    private static final Pattern LOWERCASE_PATTERN = Pattern.compile(".*[a-z].*");
    
    // 숫자 포함 패턴
    private static final Pattern DIGIT_PATTERN = Pattern.compile(".*[0-9].*");
    
    // 특수문자 포함 패턴
    private static final Pattern SPECIAL_CHAR_PATTERN = Pattern.compile(".*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?].*");

    /**
     * 비밀번호 정책 검증
     * 
     * @param password 검증할 비밀번호
     * @return 검증 결과
     */
    public static PasswordValidationResult validate(String password) {
        if (password == null) {
            return PasswordValidationResult.of(false, "비밀번호는 필수입니다.");
        }

        // 길이 검증
        if (password.length() < MIN_LENGTH) {
            return PasswordValidationResult.of(false, 
                String.format("비밀번호는 최소 %d자 이상이어야 합니다.", MIN_LENGTH));
        }
        
        if (password.length() > MAX_LENGTH) {
            return PasswordValidationResult.of(false, 
                String.format("비밀번호는 최대 %d자 이하여야 합니다.", MAX_LENGTH));
        }

        // 대문자 포함 검증
        if (!UPPERCASE_PATTERN.matcher(password).matches()) {
            return PasswordValidationResult.of(false, "비밀번호에 대문자가 포함되어야 합니다.");
        }

        // 소문자 포함 검증
        if (!LOWERCASE_PATTERN.matcher(password).matches()) {
            return PasswordValidationResult.of(false, "비밀번호에 소문자가 포함되어야 합니다.");
        }

        // 숫자 포함 검증
        if (!DIGIT_PATTERN.matcher(password).matches()) {
            return PasswordValidationResult.of(false, "비밀번호에 숫자가 포함되어야 합니다.");
        }

        // 특수문자 포함 검증
        if (!SPECIAL_CHAR_PATTERN.matcher(password).matches()) {
            return PasswordValidationResult.of(false, "비밀번호에 특수문자가 포함되어야 합니다.");
        }

        return PasswordValidationResult.of(true, "유효한 비밀번호입니다.");
    }

    /**
     * 비밀번호 강도 계산
     * 
     * @param password 비밀번호
     * @return 강도 점수 (1~5)
     */
    public static int calculateStrength(String password) {
        if (password == null || password.isEmpty()) {
            return 0;
        }

        int strength = 0;

        // 길이 점수
        if (password.length() >= 8) strength++;
        if (password.length() >= 12) strength++;

        // 문자 종류 점수
        if (UPPERCASE_PATTERN.matcher(password).matches()) strength++;
        if (LOWERCASE_PATTERN.matcher(password).matches()) strength++;
        if (DIGIT_PATTERN.matcher(password).matches()) strength++;
        if (SPECIAL_CHAR_PATTERN.matcher(password).matches()) strength++;

        return Math.min(strength, 5);
    }

    /**
     * 비밀번호 검증 결과 클래스
     */
    public static class PasswordValidationResult {
        private final boolean valid;
        private final String message;

        private PasswordValidationResult(boolean valid, String message) {
            this.valid = valid;
            this.message = message;
        }

        public static PasswordValidationResult of(boolean valid, String message) {
            return new PasswordValidationResult(valid, message);
        }

        public boolean isValid() {
            return valid;
        }

        public String getMessage() {
            return message;
        }
    }
}
