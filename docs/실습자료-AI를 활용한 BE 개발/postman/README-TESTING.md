# Car Center API - 사용자 등록 및 인증 테스트

## 📋 개요

이 Postman Collection은 Car Center 애플리케이션의 사용자 등록, 로그인, 인증 기능을 완전히 테스트할 수 있도록 구성되었습니다.

## 🚀 시작하기

### 1. 필수 조건
- Car Center 애플리케이션이 `http://localhost:8080`에서 실행 중이어야 합니다
- Postman 또는 Postman Desktop App이 설치되어 있어야 합니다

### 2. Collection 가져오기
1. Postman 열기
2. **Import** 버튼 클릭
3. `car-center-auth-complete-collection.json` 파일 선택
4. `car-center-test-environment.json` 환경 파일도 함께 가져오기

### 3. Environment 설정
1. Postman 우측 상단의 Environment 드롭다운에서 **Car Center - Test Environment** 선택
2. 필요시 baseUrl 값을 확인/수정 (`http://localhost:8080`)

## 🧪 테스트 시나리오

### 1단계: 사전 검증 (Pre-validation)
- **애플리케이션 상태 확인**: 서버가 정상적으로 실행되고 있는지 확인
- **비밀번호 정책 검증**: 사용할 비밀번호가 정책에 맞는지 확인

### 2단계: 중복 확인 (Duplication Check)
- **사용자명 중복 확인**: 사용할 사용자명이 이미 존재하는지 확인
- **이메일 중복 확인**: 사용할 이메일이 이미 존재하는지 확인

### 3단계: 회원가입 (Registration)
- **사용자 등록**: 새로운 사용자 계정 생성
- **중복 사용자명으로 등록 시도**: 실패 케이스 테스트
- **약한 비밀번호로 등록 시도**: 비밀번호 정책 검증 테스트

### 4단계: 로그인 (Authentication)
- **사용자 로그인**: 등록한 계정으로 로그인 및 JWT 토큰 발급
- **잘못된 비밀번호로 로그인 시도**: 실패 케이스 테스트
- **존재하지 않는 사용자로 로그인 시도**: 실패 케이스 테스트

### 5단계: 인증된 API 테스트 (Authenticated APIs)
- **내 프로필 조회**: JWT 토큰을 사용한 인증된 API 호출
- **내 프로필 수정**: 프로필 정보 업데이트
- **인증 없이 프로필 조회 시도**: 보안 검증 테스트

### 6단계: 토큰 관리 (Token Management)
- **토큰 갱신**: Refresh Token을 사용한 Access Token 갱신
- **로그아웃**: 토큰 무효화 및 세션 종료
- **로그아웃 후 프로필 조회 시도**: 블랙리스트된 토큰 검증

## 🔍 자동 테스트 검증

각 요청에는 자동 테스트 스크립트가 포함되어 있어 다음을 자동으로 검증합니다:

### ✅ 성공 케이스 검증
- HTTP 상태 코드 확인
- 응답 데이터 구조 검증
- 토큰 발급 및 저장 확인
- 사용자 정보 일치성 확인

### ❌ 실패 케이스 검증
- 적절한 에러 상태 코드 반환
- 에러 메시지 내용 확인
- 보안 정책 동작 확인

## 🎯 자동 실행 방법

### Collection Runner 사용
1. Collection 우클릭 → **Run collection** 선택
2. Environment를 **Car Center - Test Environment**로 설정
3. **Run Car Center - 사용자 등록 및 인증 테스트** 클릭
4. 모든 테스트가 자동으로 순차 실행됩니다

### Newman (CLI) 사용
```bash
# Newman 설치 (처음 한 번만)
npm install -g newman

# Collection 실행
newman run car-center-auth-complete-collection.json \
  --environment car-center-test-environment.json \
  --reporters cli,json,html \
  --reporter-html-export test-results.html
```

## 📊 테스트 결과 확인

### Postman GUI에서
- **Test Results** 탭에서 각 테스트의 통과/실패 상태 확인
- **Console** 탭에서 상세 로그 확인

### Newman CLI에서
- 터미널에서 실시간 결과 확인
- `test-results.html` 파일로 상세 리포트 생성

## 🔧 커스터마이징

### 테스트 데이터 변경
Collection Variables에서 다음 값들을 수정할 수 있습니다:
- `testUsername`: 테스트용 사용자명
- `testEmail`: 테스트용 이메일
- `testPassword`: 테스트용 비밀번호

### 환경별 설정
Environment 파일을 복사하여 다른 환경(개발/스테이징/운영)용으로 수정할 수 있습니다:
- `baseUrl`: 대상 서버 URL
- 기타 환경별 설정값들

## 🚨 주의사항

1. **API 경로**: 모든 API는 `/api` context-path를 포함해야 합니다 (`http://localhost:8080/api/...`)
2. **테스트 데이터**: 세션 동안 일관된 사용자명/이메일이 생성되어 회원가입과 로그인의 일치를 보장합니다
3. **토큰 관리**: 로그인 시 발급된 토큰이 자동으로 저장되고 후속 요청에 사용됩니다
4. **순서 실행**: 테스트는 순서대로 실행되어야 합니다 (의존성이 있음)
5. **서버 상태**: 테스트 실행 전 반드시 애플리케이션이 실행 중인지 확인하세요

## 🔧 최근 수정사항 (해결된 이슈들)

### ✅ MyBatis 키 생성 오류 해결
- `UserDto.CreateRequest`에 `id` 필드 추가
- 자동 생성된 키가 올바르게 설정되도록 수정

### ✅ 컬럼 매핑 오류 해결  
- `phone` 컬럼과 `phoneNumber` 프로퍼티 매핑 수정
- MyBatis AutoMapping 경고 해결

### ✅ 로그인 테스트 일관성 확보
- 랜덤 변수 대신 타임스탬프 기반 고정 변수 사용
- 회원가입과 로그인에서 동일한 사용자명 사용 보장

## 📝 API 엔드포인트 목록

### 인증 관련 (`/auth`)
- `POST /auth/register` - 회원가입
- `POST /auth/login` - 로그인
- `POST /auth/refresh` - 토큰 갱신
- `POST /auth/logout` - 로그아웃
- `GET /auth/check-username` - 사용자명 중복 확인
- `GET /auth/check-email` - 이메일 중복 확인
- `POST /auth/validate-password` - 비밀번호 정책 검증

### 사용자 관련 (`/users`)
- `GET /users/profile` - 내 프로필 조회
- `PUT /users/profile` - 내 프로필 수정

### 기타
- `GET /health` - 헬스체크

## 🎉 성공적인 테스트 완료 시

모든 테스트가 통과하면 다음이 검증된 것입니다:

✅ 회원가입 기능이 정상 동작  
✅ 로그인/로그아웃 기능이 정상 동작  
✅ JWT 토큰 기반 인증이 정상 동작  
✅ 비밀번호 정책이 올바르게 적용  
✅ 중복 검증이 정상 동작  
✅ 프로필 관리 기능이 정상 동작  
✅ 보안 정책이 올바르게 적용  

이제 Car Center 애플리케이션의 인증 시스템이 완전히 동작한다는 것이 검증되었습니다! 🎊
