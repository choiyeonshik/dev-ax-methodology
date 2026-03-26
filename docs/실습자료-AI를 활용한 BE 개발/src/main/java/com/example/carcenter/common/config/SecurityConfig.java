package com.example.carcenter.common.config;

import com.example.carcenter.common.security.JwtAuthenticationEntryPoint;
import com.example.carcenter.common.security.JwtAuthenticationFilter;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.Arrays;

@Configuration
@EnableWebSecurity(debug = true)
@EnableMethodSecurity(prePostEnabled = true)
@RequiredArgsConstructor
public class SecurityConfig {

    private final JwtAuthenticationEntryPoint jwtAuthenticationEntryPoint;

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder(12); // 보안 강도 12 설정
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration config) throws Exception {
        return config.getAuthenticationManager();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http, JwtAuthenticationFilter jwtAuthenticationFilter) throws Exception {
        http
            .csrf(AbstractHttpConfigurer::disable)
            .cors(cors -> cors.configurationSource(corsConfigurationSource()))
            .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .exceptionHandling(exception -> exception.authenticationEntryPoint(jwtAuthenticationEntryPoint))
            .authorizeHttpRequests(auth -> auth
                // Health check endpoints (가장 먼저 확인)
                .requestMatchers("/health/**").permitAll()
                .requestMatchers("/actuator/**").permitAll()
                // Authentication endpoints
                .requestMatchers("/auth/**").permitAll()
                // Public endpoints
                .requestMatchers("/public/**").permitAll()
                // Documentation endpoints - Swagger UI 관련 모든 경로 허용
                .requestMatchers("/swagger-ui/**", "/swagger-ui.html", "/v3/api-docs/**", "/swagger-resources/**", "/webjars/**").permitAll()
                // H2 Console (개발용)
                .requestMatchers("/h2-console/**").permitAll()
                
                // Role-based access control
                // System Admin - 시스템 전체 관리
                .requestMatchers("/admin/**").hasRole("SYSTEM_ADMIN")
                .requestMatchers("/api/admin/**").hasRole("SYSTEM_ADMIN")
                
                // Shop Admin - 정비소 관리
                .requestMatchers("/api/shop/admin/**").hasAnyRole("SHOP_ADMIN", "SYSTEM_ADMIN")
                .requestMatchers("/api/maintenance/admin/**").hasAnyRole("SHOP_ADMIN", "SYSTEM_ADMIN")
                
                // User access - 일반 사용자 및 상위 권한
                .requestMatchers("/api/user/**").hasAnyRole("USER", "SHOP_ADMIN", "SYSTEM_ADMIN")
                .requestMatchers("/api/vehicle/**").hasAnyRole("USER", "SHOP_ADMIN", "SYSTEM_ADMIN")
                .requestMatchers("/api/booking/**").hasAnyRole("USER", "SHOP_ADMIN", "SYSTEM_ADMIN")
                .requestMatchers("/api/payment/**").hasAnyRole("USER", "SHOP_ADMIN", "SYSTEM_ADMIN")
                
                // Public shop and maintenance information (read-only)
                .requestMatchers("/api/shop/search/**").hasAnyRole("USER", "SHOP_ADMIN", "SYSTEM_ADMIN")
                .requestMatchers("/api/shop/info/**").hasAnyRole("USER", "SHOP_ADMIN", "SYSTEM_ADMIN")
                
                // All other requests need authentication
                .anyRequest().authenticated()
            )
            .headers(headers -> headers.frameOptions(frameOptions -> frameOptions.disable())) // H2 Console iframe 허용
            .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    @Bean
    public WebSecurityCustomizer webSecurityCustomizer() {
        return (web) -> web.ignoring()
            .requestMatchers("/health/**")  // context-path 때문에 /api는 자동으로 붙음
            .requestMatchers("/actuator/**")
            .requestMatchers("/swagger-ui/**", "/swagger-ui.html", "/swagger-resources/**", "/webjars/**")
            .requestMatchers("/v3/api-docs/**")
            .requestMatchers("/h2-console/**");
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        configuration.setAllowedOriginPatterns(Arrays.asList("*"));
        configuration.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS"));
        configuration.setAllowedHeaders(Arrays.asList("*"));
        configuration.setAllowCredentials(true);
        configuration.setMaxAge(3600L);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }
}
