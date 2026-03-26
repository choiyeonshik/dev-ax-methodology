package com.example.carcenter.common.exception;

import lombok.AllArgsConstructor;
import lombok.Getter;
import org.springframework.http.HttpStatus;

@Getter
@AllArgsConstructor
public enum ErrorCode {

    // Common
    INTERNAL_SERVER_ERROR(HttpStatus.INTERNAL_SERVER_ERROR, "C001", "내부 서버 오류가 발생했습니다."),
    INVALID_INPUT_VALUE(HttpStatus.BAD_REQUEST, "C002", "잘못된 입력값입니다."),
    METHOD_NOT_ALLOWED(HttpStatus.METHOD_NOT_ALLOWED, "C003", "허용되지 않은 HTTP 메서드입니다."),
    ENTITY_NOT_FOUND(HttpStatus.NOT_FOUND, "C004", "엔티티를 찾을 수 없습니다."),
    INVALID_TYPE_VALUE(HttpStatus.BAD_REQUEST, "C005", "잘못된 타입 값입니다."),
    HANDLE_ACCESS_DENIED(HttpStatus.FORBIDDEN, "C006", "접근이 거부되었습니다."),

    // Authentication & Authorization
    AUTHENTICATION_FAILED(HttpStatus.UNAUTHORIZED, "A001", "인증에 실패했습니다."),
    AUTHORIZATION_FAILED(HttpStatus.FORBIDDEN, "A002", "권한이 없습니다."),
    TOKEN_EXPIRED(HttpStatus.UNAUTHORIZED, "A003", "토큰이 만료되었습니다."),
    INVALID_TOKEN(HttpStatus.UNAUTHORIZED, "A004", "유효하지 않은 토큰입니다."),
    TOKEN_NOT_FOUND(HttpStatus.UNAUTHORIZED, "A005", "토큰을 찾을 수 없습니다."),

    // User
    USER_NOT_FOUND(HttpStatus.NOT_FOUND, "U001", "사용자를 찾을 수 없습니다."),
    DUPLICATE_USERNAME(HttpStatus.CONFLICT, "U002", "이미 존재하는 사용자명입니다."),
    DUPLICATE_EMAIL(HttpStatus.CONFLICT, "U003", "이미 존재하는 이메일입니다."),
    USER_CREATE_FAILED(HttpStatus.INTERNAL_SERVER_ERROR, "U004", "사용자 생성에 실패했습니다."),
    USER_UPDATE_FAILED(HttpStatus.INTERNAL_SERVER_ERROR, "U005", "사용자 수정에 실패했습니다."),
    USER_DELETE_FAILED(HttpStatus.INTERNAL_SERVER_ERROR, "U006", "사용자 삭제에 실패했습니다."),
    INVALID_PASSWORD(HttpStatus.BAD_REQUEST, "U007", "잘못된 비밀번호입니다."),

    // Car
    CAR_NOT_FOUND(HttpStatus.NOT_FOUND, "R001", "차량을 찾을 수 없습니다."),
    CAR_CREATE_FAILED(HttpStatus.INTERNAL_SERVER_ERROR, "R002", "차량 등록에 실패했습니다."),
    CAR_UPDATE_FAILED(HttpStatus.INTERNAL_SERVER_ERROR, "R003", "차량 수정에 실패했습니다."),
    CAR_DELETE_FAILED(HttpStatus.INTERNAL_SERVER_ERROR, "R004", "차량 삭제에 실패했습니다."),

    // Service
    SERVICE_NOT_FOUND(HttpStatus.NOT_FOUND, "S001", "서비스를 찾을 수 없습니다."),
    SERVICE_CREATE_FAILED(HttpStatus.INTERNAL_SERVER_ERROR, "S002", "서비스 생성에 실패했습니다."),
    SERVICE_UPDATE_FAILED(HttpStatus.INTERNAL_SERVER_ERROR, "S003", "서비스 수정에 실패했습니다."),
    SERVICE_DELETE_FAILED(HttpStatus.INTERNAL_SERVER_ERROR, "S004", "서비스 삭제에 실패했습니다.");

    private final HttpStatus httpStatus;
    private final String code;
    private final String message;
}
