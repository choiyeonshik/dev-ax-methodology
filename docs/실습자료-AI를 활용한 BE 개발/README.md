# Car Center Management System

자동차 정비소 관리 시스템을 위한 Spring Boot REST API 프로젝트입니다.

## 🛠 기술 스택

- **Java**: 17
- **Spring Boot**: 3.4.1
- **Gradle**: 8.11.1
- **Database**: PostgreSQL
- **ORM**: MyBatis
- **Security**: Spring Security + JWT
- **Documentation**: Swagger/OpenAPI 3
- **Build Tool**: Gradle

## 📁 프로젝트 구조

```
src/
├── main/
│   ├── java/com/example/carcenter/
│   │   ├── CarCenterApplication.java          # 메인 애플리케이션 클래스
│   │   ├── auth/                              # 인증 도메인
│   │   │   ├── controller/                    # 인증 컨트롤러
│   │   │   └── service/                       # 인증 서비스
│   │   ├── user/                              # 사용자 도메인
│   │   │   ├── controller/                    # 사용자 컨트롤러
│   │   │   ├── service/                       # 사용자 서비스
│   │   │   ├── repository/                    # 사용자 리포지토리
│   │   │   └── dto/                           # 사용자 DTO
│   │   └── common/                            # 공통 모듈
│   │       ├── config/                        # 설정 클래스
│   │       ├── security/                      # 보안 관련 클래스
│   │       ├── exception/                     # 예외 처리
│   │       └── response/                      # 공통 응답 클래스
│   └── resources/
│       ├── application.yml                    # 애플리케이션 설정
│       ├── mapper/                            # MyBatis 매퍼 XML
│       └── sql/                               # 데이터베이스 스키마
└── test/                                      # 테스트 코드
```

## 🚀 시작하기

### 1. 사전 요구사항

- Java 17 이상
- PostgreSQL 12 이상
- Gradle 8.11.1 이상

### 2. 데이터베이스 설정

PostgreSQL에 데이터베이스를 생성합니다:

```sql
CREATE DATABASE car_center_db;
CREATE USER car_center_user WITH PASSWORD 'password';
GRANT ALL PRIVILEGES ON DATABASE car_center_db TO car_center_user;
```

### 3. 환경 변수 설정

다음 환경 변수를 설정하거나 `application.yml`에서 직접 수정합니다:

```bash
export DB_USERNAME=car_center_user
export DB_PASSWORD=password
export JWT_SECRET=mySecretKey123456789012345678901234567890123456789012345678901234567890
```

### 4. 애플리케이션 실행

```bash
# 프로젝트 클론
git clone <repository-url>
cd car-center-devlab

# 의존성 설치 및 빌드
./gradlew build

# 애플리케이션 실행
./gradlew bootRun
```

### 5. API 문서 확인

애플리케이션 실행 후 다음 URL에서 API 문서를 확인할 수 있습니다:

- **Swagger UI**: http://localhost:8080/api/swagger-ui.html
- **API Docs**: http://localhost:8080/api/api-docs

## 🔐 인증 및 권한

### JWT 토큰 기반 인증

- **Access Token**: 24시간 유효
- **Refresh Token**: 7일 유효
- **토큰 형식**: `Bearer <token>`

### 기본 사용자 계정

```
관리자:
- Username: admin
- Password: admin123
- Role: ADMIN

일반 사용자:
- Username: user1
- Password: user123
- Role: USER
```

### API 엔드포인트

#### 인증 API
- `POST /api/auth/login` - 로그인
- `POST /api/auth/register` - 회원가입
- `POST /api/auth/refresh` - 토큰 갱신
- `POST /api/auth/logout` - 로그아웃

#### 사용자 관리 API
- `GET /api/users` - 사용자 목록 조회 (ADMIN)
- `GET /api/users/{id}` - 사용자 조회
- `POST /api/users` - 사용자 생성 (ADMIN)
- `PUT /api/users/{id}` - 사용자 수정
- `DELETE /api/users/{id}` - 사용자 삭제 (ADMIN)

## 🏗 아키텍처 패턴

### 도메인 주도 설계 (DDD)

각 도메인별로 패키지를 분리하여 관리합니다:

```
domain/
├── controller/     # REST 컨트롤러
├── service/        # 비즈니스 로직
├── repository/     # 데이터 접근 계층
├── dto/           # 데이터 전송 객체
└── exception/     # 도메인별 예외
```

### 계층형 아키텍처

1. **Controller Layer**: HTTP 요청/응답 처리
2. **Service Layer**: 비즈니스 로직 처리
3. **Repository Layer**: 데이터 접근 처리
4. **Database Layer**: 데이터 저장

## 📝 개발 가이드라인

### 1. 코딩 컨벤션

- **클래스명**: PascalCase (예: UserService)
- **메서드명**: camelCase (예: getUserById)
- **상수명**: UPPER_SNAKE_CASE (예: MAX_RETRY_COUNT)
- **패키지명**: lowercase (예: com.example.carcenter)

### 2. API 응답 형식

모든 API는 통일된 응답 형식을 사용합니다:

```json
{
  "success": true,
  "message": "성공",
  "data": { ... },
  "errorCode": null,
  "timestamp": "2024-01-15T10:30:00"
}
```

### 3. 예외 처리

- 비즈니스 예외: `BusinessException` 사용
- 에러 코드: `ErrorCode` enum 활용
- 글로벌 예외 처리: `GlobalExceptionHandler`

### 4. 로깅

```java
@Slf4j
public class UserService {
    public void createUser(UserDto.CreateRequest request) {
        log.info("Creating user with username: {}", request.getUsername());
        // 비즈니스 로직
        log.debug("User created successfully with id: {}", user.getId());
    }
}
```

### 5. 테스트 작성

```java
@SpringBootTest
@Transactional
class UserServiceTest {
    
    @Test
    void createUser_Success() {
        // Given
        UserDto.CreateRequest request = UserDto.CreateRequest.builder()
            .username("testuser")
            .password("password123")
            .email("test@example.com")
            .name("테스트 사용자")
            .build();
        
        // When
        UserDto.Response response = userService.createUser(request);
        
        // Then
        assertThat(response.getUsername()).isEqualTo("testuser");
    }
}
```

## 🔧 설정 관리

### Profile별 설정

- **local**: 로컬 개발 환경
- **dev**: 개발 서버 환경
- **prod**: 운영 서버 환경

### 데이터베이스 마이그레이션

스키마 변경 시 `src/main/resources/sql/` 디렉토리에 마이그레이션 스크립트를 추가합니다.

## 📊 모니터링

### Actuator 엔드포인트

- **Health Check**: `/actuator/health`
- **Metrics**: `/actuator/metrics`
- **Info**: `/actuator/info`

## 🚀 배포

### Docker를 사용한 배포

```dockerfile
FROM openjdk:17-jre-slim
COPY build/libs/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app.jar"]
```

### 빌드 및 배포 스크립트

```bash
#!/bin/bash
./gradlew clean build
docker build -t car-center-api .
docker run -p 8080:8080 car-center-api
```

## 🤝 기여하기

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 라이선스

이 프로젝트는 Apache License 2.0 하에 배포됩니다. 자세한 내용은 `LICENSE` 파일을 참조하세요.

## 📞 연락처

- **개발팀**: dev@carcenter.com
- **프로젝트 링크**: https://github.com/example/car-center-devlab
