package com.example.carcenter.auth.controller;

import com.example.carcenter.auth.service.AuthService;
import com.example.carcenter.common.response.ApiResponse;
import com.example.carcenter.user.dto.UserDto;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import com.example.carcenter.common.util.PasswordValidator;
import com.example.carcenter.user.service.UserService;

@Slf4j
@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
@Tag(name = "Authentication", description = "인증 관리 API")
public class AuthController {

    private final AuthService authService;
    private final UserService userService;

    @Operation(summary = "로그인", description = "사용자 로그인을 처리합니다.")
    @PostMapping("/login")
    public ApiResponse<UserDto.LoginResponse> login(@Valid @RequestBody UserDto.LoginRequest request) {
        log.info("Login attempt for username: {}", request.getUsername());
        UserDto.LoginResponse response = authService.login(request);
        return ApiResponse.success(response);
    }

    @Operation(summary = "회원가입", description = "새로운 사용자를 등록합니다.")
    @PostMapping("/register")
    public ApiResponse<UserDto.Response> register(@Valid @RequestBody UserDto.CreateRequest request) {
        log.info("Registration attempt for username: {}", request.getUsername());
        UserDto.Response response = authService.register(request);
        return ApiResponse.success(response, HttpStatus.CREATED);
    }

    @Operation(summary = "토큰 갱신", description = "Refresh Token을 사용하여 Access Token을 갱신합니다.")
    @PostMapping("/refresh")
    public ApiResponse<UserDto.LoginResponse> refresh(@RequestParam String refreshToken) {
        log.info("Token refresh attempt");
        UserDto.LoginResponse response = authService.refresh(refreshToken);
        return ApiResponse.success(response);
    }

    @Operation(summary = "로그아웃", description = "사용자 로그아웃을 처리합니다.")
    @PostMapping("/logout")
    public ApiResponse<Void> logout(HttpServletRequest request, @RequestParam String refreshToken) {
        log.info("Logout attempt");
        
        // Authorization 헤더에서 Access Token 추출
        String accessToken = null;
        String bearerToken = request.getHeader("Authorization");
        if (bearerToken != null && bearerToken.startsWith("Bearer ")) {
            accessToken = bearerToken.substring(7);
        }
        
        authService.logout(accessToken, refreshToken);
        return ApiResponse.success();
    }

    @Operation(summary = "사용자명 중복 확인", description = "사용자명 중복 여부를 확인합니다.")
    @GetMapping("/check-username")
    public ApiResponse<CheckUsernameResponse> checkUsername(@RequestParam String username) {
        log.info("Username check for: {}", username);
        boolean exists = userService.isUsernameExists(username);
        return ApiResponse.success(new CheckUsernameResponse(username, !exists, 
            exists ? "이미 사용 중인 사용자명입니다." : "사용 가능한 사용자명입니다."));
    }

    @Operation(summary = "이메일 중복 확인", description = "이메일 중복 여부를 확인합니다.")
    @GetMapping("/check-email")
    public ApiResponse<CheckEmailResponse> checkEmail(@RequestParam String email) {
        log.info("Email check for: {}", email);
        boolean exists = userService.isEmailExists(email);
        return ApiResponse.success(new CheckEmailResponse(email, !exists, 
            exists ? "이미 사용 중인 이메일입니다." : "사용 가능한 이메일입니다."));
    }

    @Operation(summary = "비밀번호 정책 검증", description = "비밀번호가 정책에 맞는지 검증합니다.")
    @PostMapping("/validate-password")
    public ApiResponse<PasswordValidationResponse> validatePassword(@RequestBody PasswordValidationRequest request) {
        log.info("Password validation request");
        PasswordValidator.PasswordValidationResult result = PasswordValidator.validate(request.password());
        int strength = PasswordValidator.calculateStrength(request.password());
        
        return ApiResponse.success(new PasswordValidationResponse(
            result.isValid(), 
            result.getMessage(), 
            strength,
            getStrengthText(strength)
        ));
    }

    private String getStrengthText(int strength) {
        return switch (strength) {
            case 0, 1 -> "매우 약함";
            case 2 -> "약함";
            case 3 -> "보통";
            case 4 -> "강함";
            case 5 -> "매우 강함";
            default -> "알 수 없음";
        };
    }

    // DTO 클래스들
    public record CheckUsernameResponse(String username, boolean available, String message) {}
    public record CheckEmailResponse(String email, boolean available, String message) {}
    public record PasswordValidationRequest(String password) {}
    public record PasswordValidationResponse(boolean valid, String message, int strength, String strengthText) {}
}
