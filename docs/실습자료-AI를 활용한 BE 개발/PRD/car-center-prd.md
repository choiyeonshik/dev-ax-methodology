# 자동차 정비 예약 시스템 PRD (Product Requirements Document)

## 문서 정보
- **문서명**: 자동차 정비 예약 시스템 PRD
- **버전**: 1.0.0
- **작성일**: 2024-01-01
- **작성자**: 개발팀
- **승인자**: 프로젝트 매니저

---

## 1. 프로젝트 개요

### 1.1 프로젝트 목적
고객이 온라인으로 자동차 정비를 예약하고, 정비 진행상황을 실시간으로 확인할 수 있는 웹 플랫폼을 개발하여 정비소와 고객 간의 효율적인 소통과 서비스 품질 향상을 목표로 합니다.

### 1.2 프로젝트 범위
- **포함 범위**: 웹 기반 예약 시스템, 정비 진행 관리, 결제 시스템, 알림 서비스
- **제외 범위**: 모바일 앱, 오프라인 POS 시스템, 외부 ERP 연동

### 1.3 주요 이해관계자
- **주 사용자**: 차량 소유자 (일반 고객)
- **부 사용자**: 정비소 직원, 관리자
- **시스템 관리자**: IT 운영팀

---

## 2. 기술 스택 및 아키텍처

### 2.1 백엔드 기술 스택
- **언어**: Java 17
- **프레임워크**: Spring Boot 3.4.1
- **빌드 도구**: Gradle 8.14.3
- **데이터베이스**: 
  - 로컬 개발: H2 Database
  - 운영 환경: PostgreSQL
- **ORM**: MyBatis
- **보안**: Spring Security + JWT
- **API 문서**: Swagger/OpenAPI 3

### 2.2 프론트엔드 기술 스택
- **기본**: HTML5, CSS3, JavaScript (ES6+)
- **UI 프레임워크**: Bootstrap 5 또는 Tailwind CSS
- **템플릿 엔진**: Thymeleaf (초기 버전)
- **향후 확장**: React.js 또는 Vue.js

### 2.3 인프라 및 배포
- **웹서버**: Embedded Tomcat
- **클라우드**: AWS 또는 NCP
- **CI/CD**: GitHub Actions
- **모니터링**: Spring Boot Actuator + Micrometer

### 2.4 패키지 구조 [[memory:4205676]]
```
com.example.carcenter
├── common/
│   ├── config/         # 전역 설정 (Security, Swagger 등)
│   ├── dto/           # 공통 DTO
│   ├── exception/     # 전역 예외 처리
│   ├── response/      # 공통 응답 객체
│   └── security/      # 보안 관련 공통 클래스
├── auth/              # 인증/인가
├── user/              # 사용자 관리
├── vehicle/           # 차량 관리
├── shop/              # 정비소 관리
├── booking/           # 예약 관리
├── maintenance/       # 정비 관리
├── payment/           # 결제 관리
├── notification/      # 알림 관리
└── review/            # 리뷰 관리
```

---

## 3. 핵심 기능 명세

### 3.1 사용자 관리 모듈

#### 3.1.1 회원가입 및 인증
- **기능**: 이메일/비밀번호 기반 회원가입
- **API 엔드포인트**: 
  - `POST /api/auth/register` - 회원가입
  - `POST /api/auth/login` - 로그인
  - `POST /api/auth/refresh` - 토큰 갱신
  - `POST /api/auth/logout` - 로그아웃

#### 3.1.2 사용자 프로필 관리
- **기능**: 개인정보 수정, 차량 정보 등록/관리
- **API 엔드포인트**:
  - `GET /api/users/profile` - 프로필 조회
  - `PUT /api/users/profile` - 프로필 수정
  - `GET /api/users/vehicles` - 차량 목록 조회
  - `POST /api/users/vehicles` - 차량 등록

### 3.2 차량 정보 관리 모듈

#### 3.2.1 차량 등록 및 관리
- **데이터 구조**:
```java
public class VehicleDto {
    @Schema(description = "차량 번호", example = "12가3456")
    private String licenseNumber;
    
    @Schema(description = "제조사", example = "현대")
    private String manufacturer;
    
    @Schema(description = "모델명", example = "소나타")
    private String model;
    
    @Schema(description = "연식", example = "2020")
    private Integer year;
    
    @Schema(description = "엔진 타입", example = "GASOLINE")
    private EngineType engineType;
    
    @Schema(description = "현재 주행거리", example = "50000")
    private Integer mileage;
}
```

#### 3.2.2 차량 이력 관리
- **기능**: 정비 이력 자동 저장, 부품 교체 이력 추적
- **API 엔드포인트**:
  - `GET /api/vehicles/{vehicleId}/history` - 정비 이력 조회
  - `POST /api/vehicles/{vehicleId}/maintenance` - 정비 기록 추가

### 3.3 정비소 관리 모듈

#### 3.3.1 정비소 정보 관리
- **데이터 구조**:
```java
public class ShopDto {
    @Schema(description = "정비소명", example = "신속정비센터")
    private String name;
    
    @Schema(description = "사업자번호", example = "123-45-67890")
    private String businessNumber;
    
    @Schema(description = "주소", example = "서울시 강남구 테헤란로 123")
    private String address;
    
    @Schema(description = "운영시간")
    private OperatingHours operatingHours;
    
    @Schema(description = "정비 가능 항목")
    private List<MaintenanceType> availableServices;
}
```

#### 3.3.2 정비사 관리
- **기능**: 정비사 정보 등록, 전문 분야 설정, 스케줄 관리
- **API 엔드포인트**:
  - `GET /api/shops/{shopId}/technicians` - 정비사 목록
  - `POST /api/shops/{shopId}/technicians` - 정비사 등록

### 3.4 예약 시스템 모듈

#### 3.4.1 정비소 검색 및 선택
- **기능**: 위치 기반 검색, 거리순/평점순 정렬
- **API 엔드포인트**:
  - `GET /api/shops/search` - 정비소 검색
  - `GET /api/shops/{shopId}` - 정비소 상세 정보
  - `GET /api/shops/{shopId}/reviews` - 리뷰 조회

#### 3.4.2 예약 관리
- **데이터 구조**:
```java
public class BookingDto {
    @Schema(description = "예약 ID")
    private Long id;
    
    @Schema(description = "차량 ID")
    private Long vehicleId;
    
    @Schema(description = "정비소 ID")
    private Long shopId;
    
    @Schema(description = "예약 날짜/시간")
    private LocalDateTime appointmentDateTime;
    
    @Schema(description = "정비 항목")
    private List<MaintenanceType> serviceTypes;
    
    @Schema(description = "증상 설명")
    private String description;
    
    @Schema(description = "예약 상태")
    private BookingStatus status;
}
```

### 3.5 정비 프로세스 관리 모듈

#### 3.5.1 정비 진행 단계
1. **접수 완료** (RECEIVED): 차량 입고 및 사전 점검
2. **진단 중** (DIAGNOSING): 정확한 문제 파악 및 견적 작성
3. **견적 대기** (QUOTE_PENDING): 고객 견적 승인 대기
4. **정비 진행** (IN_PROGRESS): 실제 정비 작업 수행
5. **품질 검사** (QUALITY_CHECK): 정비 완료 후 최종 점검
6. **완료** (COMPLETED): 차량 인도 준비 완료

#### 3.5.2 실시간 진행상황 추적
- **API 엔드포인트**:
  - `GET /api/maintenance/{maintenanceId}/status` - 진행상황 조회
  - `PUT /api/maintenance/{maintenanceId}/status` - 상태 업데이트
  - `POST /api/maintenance/{maintenanceId}/comments` - 코멘트 추가

### 3.6 견적 및 가격 관리 모듈

#### 3.6.1 견적 시스템
- **데이터 구조**:
```java
public class QuoteDto {
    @Schema(description = "견적 ID")
    private Long id;
    
    @Schema(description = "예약 ID")
    private Long bookingId;
    
    @Schema(description = "견적 항목")
    private List<QuoteItem> items;
    
    @Schema(description = "총 금액")
    private BigDecimal totalAmount;
    
    @Schema(description = "견적 상태")
    private QuoteStatus status;
    
    @Schema(description = "유효기간")
    private LocalDateTime validUntil;
}
```

### 3.7 결제 시스템 모듈

#### 3.7.1 결제 방법
- 신용카드/체크카드
- 계좌이체
- 휴대폰 결제
- 간편결제 (카카오페이, 네이버페이)

#### 3.7.2 결제 프로세스
- **API 엔드포인트**:
  - `POST /api/payments/prepare` - 결제 준비
  - `POST /api/payments/execute` - 결제 실행
  - `GET /api/payments/{paymentId}` - 결제 상태 조회
  - `POST /api/payments/{paymentId}/refund` - 환불 처리

### 3.8 알림 시스템 모듈

#### 3.8.1 알림 유형
- **실시간 알림**: 예약 확인, 정비 진행상황 변경
- **정기 알림**: 정기점검 시기, 소모품 교체 주기
- **이벤트 알림**: 할인 쿠폰, 프로모션

#### 3.8.2 알림 채널
- 이메일 (Email)
- SMS (문자메시지)
- 웹 푸시 알림

---

## 4. 데이터베이스 설계 [[memory:2410824]]

### 4.1 주요 테이블 구조

#### 4.1.1 사용자 테이블 (users)
```sql
CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(20),
    role VARCHAR(20) DEFAULT 'USER',
    status VARCHAR(20) DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL
);
```

#### 4.1.2 차량 테이블 (vehicles)
```sql
CREATE TABLE vehicles (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    license_number VARCHAR(20) NOT NULL UNIQUE,
    manufacturer VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    year INTEGER NOT NULL,
    engine_type VARCHAR(20) NOT NULL,
    mileage INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
```

#### 4.1.3 정비소 테이블 (shops)
```sql
CREATE TABLE shops (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    business_number VARCHAR(20) NOT NULL UNIQUE,
    address VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    operating_hours JSON,
    description TEXT,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL
);
```

#### 4.1.4 예약 테이블 (bookings)
```sql
CREATE TABLE bookings (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    vehicle_id BIGINT NOT NULL,
    shop_id BIGINT NOT NULL,
    appointment_datetime TIMESTAMP NOT NULL,
    service_types JSON NOT NULL,
    description TEXT,
    status VARCHAR(20) DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(id),
    FOREIGN KEY (shop_id) REFERENCES shops(id)
);
```

### 4.2 인덱스 설계
```sql
-- 사용자 테이블 인덱스
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_phone ON users(phone);
CREATE INDEX idx_users_status ON users(status);

-- 차량 테이블 인덱스
CREATE INDEX idx_vehicles_user_id ON vehicles(user_id);
CREATE INDEX idx_vehicles_license_number ON vehicles(license_number);

-- 정비소 테이블 인덱스
CREATE INDEX idx_shops_location ON shops(latitude, longitude);
CREATE INDEX idx_shops_status ON shops(status);

-- 예약 테이블 인덱스
CREATE INDEX idx_bookings_user_id ON bookings(user_id);
CREATE INDEX idx_bookings_shop_id ON bookings(shop_id);
CREATE INDEX idx_bookings_appointment ON bookings(appointment_datetime);
CREATE INDEX idx_bookings_status ON bookings(status);
```

---

## 5. API 설계 원칙

### 5.1 RESTful API 가이드라인
- **기본 URL**: `https://api.carcenter.com/api/v1`
- **인증 방식**: JWT Bearer Token
- **응답 형식**: JSON
- **HTTP 상태 코드**: 표준 HTTP 상태 코드 사용

### 5.2 공통 응답 형식
```json
{
  "success": true,
  "data": {
    // 실제 데이터
  },
  "errorCode": null,
  "errorMessage": null,
  "timestamp": "2024-01-01T10:00:00Z"
}
```

### 5.3 에러 응답 형식
```json
{
  "success": false,
  "data": null,
  "errorCode": "USER_NOT_FOUND",
  "errorMessage": "사용자를 찾을 수 없습니다",
  "timestamp": "2024-01-01T10:00:00Z"
}
```

### 5.4 페이징 응답 형식
```json
{
  "success": true,
  "data": {
    "content": [...],
    "totalElements": 100,
    "totalPages": 10,
    "size": 10,
    "number": 0,
    "first": true,
    "last": false
  }
}
```

---

## 6. 보안 요구사항

### 6.1 인증 및 인가
- **JWT 토큰**: 24시간 만료 (Access Token), 7일 만료 (Refresh Token)
- **비밀번호 암호화**: BCrypt (강도 12)
- **역할 기반 접근 제어**: USER, SHOP_ADMIN, SYSTEM_ADMIN

### 6.2 데이터 보안
- **개인정보 암호화**: AES-256 암호화
- **SQL 인젝션 방어**: MyBatis PreparedStatement 사용
- **XSS 방어**: Spring Security의 XSS 필터 적용
- **CSRF 방어**: CSRF 토큰 적용

### 6.3 통신 보안
- **HTTPS 강제**: 모든 API 통신 SSL/TLS 암호화
- **CORS 설정**: 허용된 도메인만 접근 가능
- **API 요청 제한**: Rate Limiting 적용

---

## 7. 성능 요구사항

### 7.1 응답 시간
- **API 응답 시간**: 평균 500ms 이내, 최대 2초
- **데이터베이스 쿼리**: 평균 100ms 이내
- **페이지 로딩**: 초기 로딩 3초 이내

### 7.2 동시성
- **동시 접속자**: 최소 100명
- **API 처리량**: 1000 TPS (Transactions Per Second)
- **데이터베이스 커넥션**: 최대 20개 커넥션 풀

### 7.3 가용성
- **시스템 가용성**: 99.5% 이상
- **장애 복구 시간**: 4시간 이내 (RTO)
- **데이터 손실 허용**: 1시간 이내 (RPO)

---

## 8. 테스트 전략

### 8.1 테스트 유형
- **단위 테스트**: JUnit 5 + Mockito (커버리지 80% 이상)
- **통합 테스트**: Spring Boot Test (@SpringBootTest)
- **API 테스트**: MockMvc + TestRestTemplate
- **보안 테스트**: Spring Security Test

### 8.2 테스트 환경
- **테스트 DB**: H2 In-Memory Database
- **Mock 외부 서비스**: WireMock 사용
- **CI/CD**: GitHub Actions에서 자동 테스트 실행

---

## 9. 모니터링 및 로깅

### 9.1 애플리케이션 모니터링
- **헬스 체크**: Spring Boot Actuator
- **메트릭 수집**: Micrometer + Prometheus
- **APM**: New Relic 또는 DataDog

### 9.2 로깅 전략
- **로그 레벨**: ERROR, WARN, INFO, DEBUG
- **로그 형식**: JSON 구조화 로깅
- **로그 저장**: ELK Stack (Elasticsearch, Logstash, Kibana)

---

## 10. 배포 및 운영

### 10.1 배포 전략
- **Blue-Green 배포**: 무중단 배포
- **롤백 계획**: 자동 롤백 지원
- **환경 분리**: dev, staging, production

### 10.2 운영 환경
- **클라우드**: AWS 또는 NCP
- **컨테이너**: Docker + Kubernetes
- **로드 밸런서**: AWS ALB 또는 NCP Load Balancer

---

## 11. 마일스톤 및 일정

### 11.1 개발 단계
1. **Phase 1** (4주): 기본 인증, 사용자 관리, 차량 관리
2. **Phase 2** (4주): 정비소 관리, 예약 시스템
3. **Phase 3** (4주): 정비 프로세스, 견적 시스템
4. **Phase 4** (4주): 결제 시스템, 알림 서비스
5. **Phase 5** (2주): 테스트, 배포, 운영 준비

### 11.2 주요 마일스톤
- **MVP 완성**: 8주차 (Phase 2 완료)
- **Beta 테스트**: 12주차 (Phase 3 완료)
- **정식 출시**: 16주차 (Phase 4 완료)

---

## 12. 위험 요소 및 대응 방안

### 12.1 기술적 위험
- **외부 결제 API 장애**: 복수 결제 게이트웨이 연동
- **데이터베이스 성능 이슈**: 쿼리 최적화, 인덱스 튜닝
- **보안 취약점**: 정기적인 보안 감사, 펜테스트

### 12.2 비즈니스 위험
- **정비소 참여 부족**: 인센티브 제공, 마케팅 강화
- **고객 사용성 이슈**: 사용자 테스트, UI/UX 개선
- **법적 규제 변경**: 법무팀 검토, 컴플라이언스 준수

---

## 13. 향후 확장 계획

### 13.1 기능 확장
- **모바일 앱**: React Native 또는 Flutter
- **AI 기반 서비스**: 고장 진단, 정비 추천
- **IoT 연동**: 차량 센서 데이터 연동
- **B2B 서비스**: 기업용 차량 관리 서비스

### 13.2 기술 확장
- **마이크로서비스**: 서비스별 분리
- **클라우드 네이티브**: Kubernetes, Service Mesh
- **데이터 분석**: BigData, Machine Learning

---

## 부록

### A. 용어 정의
- **정비소**: 자동차 수리 및 정비를 수행하는 업체
- **정비사**: 자동차 정비 자격을 보유한 기술자
- **예약**: 정비 서비스를 사전에 신청하는 행위
- **견적**: 정비 비용에 대한 사전 산정서

### B. 참조 문서
- [요구사항 정의서](../REQ/car_center_requirements.md)
- [Java Spring Boot 구조 규칙](.cursor/rules/001-java-spring-boot-structure.mdc)
- [MyBatis SQL 가이드라인](.cursor/rules/002-mybatis-sql-guidelines.mdc)
- [Spring Security JWT 가이드라인](.cursor/rules/003-spring-security-jwt.mdc)

### C. 변경 이력
| 버전 | 일자 | 변경 내용 | 작성자 |
|------|------|-----------|--------|
| 1.0.0 | 2024-01-01 | 초기 작성 | 개발팀 |

---

**문서 승인**
- 개발팀장: _______________
- 프로젝트 매니저: _______________
- 비즈니스 오너: _______________
