package com.example.carcenter.user.controller;

import com.example.carcenter.common.response.ApiResponse;
import com.example.carcenter.user.dto.UserDto;
import com.example.carcenter.user.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import com.example.carcenter.common.dto.PageRequest;
import com.example.carcenter.common.dto.PageResponse;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.core.Authentication;

import jakarta.validation.Valid;

@Slf4j
@RestController
@RequestMapping("/users")
@RequiredArgsConstructor
@Tag(name = "User Management", description = "사용자 관리 API")
public class UserController {

    private final UserService userService;

    @Operation(summary = "사용자 생성", description = "새로운 사용자를 생성합니다.")
    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse<UserDto.Response> createUser(@Valid @RequestBody UserDto.CreateRequest request) {
        log.info("Creating user with username: {}", request.getUsername());
        UserDto.Response response = userService.createUser(request);
        return ApiResponse.success(response, HttpStatus.CREATED);
    }

    @Operation(summary = "사용자 조회", description = "ID로 사용자를 조회합니다.")
    @GetMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN') or #id == authentication.principal.id")
    public ApiResponse<UserDto.Response> getUser(
            @Parameter(description = "사용자 ID") @PathVariable Long id) {
        log.info("Getting user with id: {}", id);
        UserDto.Response response = userService.getUserById(id);
        return ApiResponse.success(response);
    }

    @Operation(summary = "사용자 목록 조회", description = "사용자 목록을 페이징으로 조회합니다.")
    @GetMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse<PageResponse<UserDto.Response>> getUsers(
            @Parameter(description = "페이지 번호") @RequestParam(defaultValue = "0") int page,
            @Parameter(description = "페이지 크기") @RequestParam(defaultValue = "20") int size,
            @Parameter(description = "정렬 필드") @RequestParam(required = false) String sort,
            @Parameter(description = "정렬 방향") @RequestParam(defaultValue = "ASC") String direction) {
        PageRequest pageRequest = PageRequest.builder()
                .page(page)
                .size(size)
                .sort(sort)
                .direction(direction)
                .build();
        log.info("Getting users with pageRequest: {}", pageRequest);
        PageResponse<UserDto.Response> response = userService.getUsers(pageRequest);
        return ApiResponse.success(response);
    }

    @Operation(summary = "사용자 수정", description = "사용자 정보를 수정합니다.")
    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN') or #id == authentication.principal.id")
    public ApiResponse<UserDto.Response> updateUser(
            @Parameter(description = "사용자 ID") @PathVariable Long id,
            @Valid @RequestBody UserDto.UpdateRequest request) {
        log.info("Updating user with id: {}", id);
        UserDto.Response response = userService.updateUser(id, request);
        return ApiResponse.success(response);
    }

    @Operation(summary = "사용자 삭제", description = "사용자를 삭제합니다. (논리삭제)")
    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse<Void> deleteUser(
            @Parameter(description = "사용자 ID") @PathVariable Long id) {
        log.info("Deleting user with id: {}", id);
        userService.deleteUser(id);
        return ApiResponse.success();
    }

    @Operation(summary = "사용자 상태 변경", description = "사용자의 활성화/비활성화 상태를 변경합니다.")
    @PatchMapping("/{id}/status")
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse<Void> updateUserStatus(
            @Parameter(description = "사용자 ID") @PathVariable Long id,
            @Parameter(description = "활성화 상태") @RequestParam boolean active) {
        log.info("Updating user status with id: {}, active: {}", id, active);
        userService.updateUserStatus(id, active);
        return ApiResponse.success();
    }



    @Operation(summary = "내 프로필 조회", description = "현재 로그인한 사용자의 프로필을 조회합니다.")
    @GetMapping("/profile")
    @PreAuthorize("isAuthenticated()")
    public ApiResponse<UserDto.Response> getMyProfile(Authentication authentication) {
        String username = authentication.getName();
        log.info("Getting profile for user: {}", username);
        UserDto.Response response = userService.getUserByUsername(username);
        return ApiResponse.success(response);
    }

    @Operation(summary = "내 프로필 수정", description = "현재 로그인한 사용자의 프로필을 수정합니다.")
    @PutMapping("/profile")
    @PreAuthorize("isAuthenticated()")
    public ApiResponse<UserDto.Response> updateMyProfile(
            Authentication authentication,
            @Valid @RequestBody UserDto.UpdateRequest request) {
        String username = authentication.getName();
        log.info("Updating profile for user: {}", username);
        
        // 현재 사용자 정보 조회하여 ID 가져오기
        UserDto.Response currentUser = userService.getUserByUsername(username);
        UserDto.Response response = userService.updateUser(currentUser.getId(), request);
        return ApiResponse.success(response);
    }
}
