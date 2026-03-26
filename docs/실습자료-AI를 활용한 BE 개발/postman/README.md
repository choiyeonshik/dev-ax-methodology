# Car Center API Postman Collection

자동차 센터 관리 시스템 API를 테스트하기 위한 Postman 컬렉션입니다.

## 🚀 빠른 시작

### 1. 애플리케이션 실행
```bash
cd D:\dev-work\car-center-devlab
./gradlew bootRun
```

### 2. Postman에서 컬렉션 import
1. Postman 실행
2. `Import` 버튼 클릭
3. `car-center-api-collection.json` 파일 선택
4. `car-center-environment.json` 환경 파일도 import

### 3. 환경 설정
- Postman 우상단에서 `Car Center Development` 환경 선택
- 기본 URL이 `http://localhost:8080/api`로 설정되어 있는지 확인

## 📋 테스트 시나리오

### 기본 흐름
1. **Health Check** → 애플리케이션 상태 확인
2. **Authentication** → 로그인하여 JWT 토큰 획득
3. **User Management** → 인증된 상태에서 사용자 관리 API 테스트

### 📁 컬렉션 구조

#### 1. Health Check
- ✅ **기본 헬스체크**: `GET /health`
- ✅ **핑 체크**: `GET /health/ping`
- ✅ **애플리케이션 정보**: `GET /health/info`
- ✅ **Actuator 헬스체크**: `GET /actuator/health`

#### 2. Authentication
- 🔐 **로그인 (관리자)**: `POST /auth/login`
  - 자동으로 JWT 토큰을 환경변수에 저장
- 🔐 **로그인 (일반 사용자)**: `POST /auth/login`
- 🔄 **토큰 갱신**: `POST /auth/refresh`
- 🚪 **로그아웃**: `POST /auth/logout`

#### 3. User Management
- 👤 **사용자 생성**: `POST /users`
- 📋 **사용자 목록 조회**: `GET /users`
- 🔍 **사용자 검색**: `GET /users?keyword=admin`
- 📖 **사용자 상세 조회**: `GET /users/{id}`
- ✏️ **사용자 정보 수정**: `PUT /users/{id}`
- 🗑️ **사용자 삭제**: `DELETE /users/{id}`

#### 4. Database & System
- 💾 **H2 콘솔 접근**: `GET /h2-console`
- 📚 **Swagger UI**: `GET /swagger-ui/index.html`
- 📄 **API 문서**: `GET /v3/api-docs`

## 🔑 인증 방식

### JWT 토큰 자동 관리
컬렉션은 JWT 토큰을 자동으로 관리합니다:

1. **로그인 요청 시**: 응답에서 `accessToken`을 자동 추출하여 환경변수 `jwtToken`에 저장
2. **인증 필요한 요청**: `Authorization: Bearer {{jwtToken}}` 헤더 자동 추가

### 기본 계정 정보
```json
// 관리자 계정
{
  "username": "admin",
  "password": "admin123"
}

// 일반 사용자 계정
{
  "username": "user01", 
  "password": "user123"
}
```

## 🧪 테스트 스크립트

컬렉션에는 자동 테스트 스크립트가 포함되어 있습니다:

### 공통 테스트
- ✅ 응답 시간 1초 이하 확인
- ✅ Content-Type JSON 확인

### API별 특화 테스트
- **로그인**: JWT 토큰 자동 저장 및 응답 구조 검증
- **사용자 관리**: 성공 응답 및 데이터 구조 검증
- **상태 확인**: 헬스체크 응답 검증

## 🔧 환경 변수

| 변수명 | 기본값 | 설명 |
|--------|--------|------|
| `baseUrl` | `http://localhost:8080/api` | API 기본 URL |
| `adminUsername` | `admin` | 관리자 계정명 |
| `adminPassword` | `admin123` | 관리자 비밀번호 |
| `userUsername` | `user01` | 일반 사용자 계정명 |
| `userPassword` | `user123` | 일반 사용자 비밀번호 |
| `jwtToken` | (자동 설정) | JWT 토큰 |

## 🚨 문제 해결

### 1. 연결 실패 시
```bash
# 애플리케이션이 실행 중인지 확인
curl http://localhost:8080/api/health/ping
```

### 2. 인증 오류 시
- 먼저 로그인 요청을 실행하여 JWT 토큰 획득
- 환경변수 `jwtToken`에 토큰이 저장되었는지 확인

### 3. 404 오류 시
- URL 경로가 올바른지 확인 (`/api` prefix 포함)
- 애플리케이션이 최신 버전으로 실행되고 있는지 확인

## 🔍 로그 확인

애플리케이션 콘솔에서 다음과 같은 로그를 확인할 수 있습니다:

```log
Security filter chain: [] empty (bypassed by security='none')  # 헬스체크
Security filter chain: [JwtAuthenticationFilter, ...] # 인증 필요한 API
```

## 📚 추가 도구

### H2 데이터베이스 콘솔
- **URL**: http://localhost:8080/api/h2-console
- **JDBC URL**: `jdbc:h2:file:./data/car_center_db`
- **Username**: `sa`
- **Password**: (빈 값)

### Swagger UI
- **URL**: http://localhost:8080/api/swagger-ui/index.html
- 브라우저에서 직접 API 테스트 가능
- API 문서 자동 생성

## 🏁 완료!

모든 설정이 완료되었습니다. Health Check부터 시작하여 순차적으로 API를 테스트해보세요! 🎉
