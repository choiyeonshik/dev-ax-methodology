package com.example.carcenter.config;

import com.example.carcenter.user.repository.UserRepository;
import com.example.carcenter.user.dto.UserDto;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Primary;

import java.util.List;
import java.util.Optional;

@TestConfiguration
public class TestConfig {

    @Bean
    @Primary
    public UserRepository mockUserRepository() {
        return new UserRepository() {
            @Override
            public int insertUser(UserDto.CreateRequest request) {
                return 1;
            }

            @Override
            public Optional<UserDto.Response> findById(Long id) {
                return Optional.of(UserDto.Response.builder()
                        .id(id)
                        .username("testuser")
                        .email("test@example.com")
                        .name("테스트 사용자")
                        .role("USER")
                        .active(true)
                        .build());
            }

            @Override
            public Optional<UserDto.Response> findByUsername(String username) {
                return Optional.of(UserDto.Response.builder()
                        .id(1L)
                        .username(username)
                        .email("test@example.com")
                        .name("테스트 사용자")
                        .role("USER")
                        .active(true)
                        .build());
            }

            @Override
            public Optional<UserDto.Response> findByEmail(String email) {
                return Optional.empty();
            }

            @Override
            public List<UserDto.Response> findAll(int offset, int limit) {
                return List.of();
            }

            @Override
            public int updateUser(Long id, UserDto.UpdateRequest request) {
                return 1;
            }

            @Override
            public int deleteUser(Long id) {
                return 1;
            }

            @Override
            public int updateUserStatus(Long id, boolean active) {
                return 1;
            }

            @Override
            public int countUsers() {
                return 0;
            }

            @Override
            public boolean existsByUsername(String username) {
                return false;
            }

            @Override
            public boolean existsByEmail(String email) {
                return false;
            }

            @Override
            public Optional<UserDto.AuthUser> findAuthUserByUsername(String username) {
                return Optional.of(UserDto.AuthUser.builder()
                        .id(1L)
                        .username(username)
                        .password("$2a$12$encoded_password_here") // BCrypt encoded dummy password
                        .email("test@example.com")
                        .name("테스트 사용자")
                        .role("USER")
                        .active(true)
                        .build());
            }
        };
    }
}

