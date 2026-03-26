-- =====================================================
-- 사용자 인증 및 사용자 관리 스키마
-- =====================================================

-- 사용자 기본 정보 테이블
CREATE TABLE carfix.user (
    user_id SERIAL PRIMARY KEY, -- 기본키
    user_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL, -- 이메일
    password VARCHAR(255) NOT NULL, -- 비밀번호
    name VARCHAR(100) NOT NULL, -- 사용자명
    phone VARCHAR(20), -- 전화번호
    role_code VARCHAR(50) NOT NULL DEFAULT 'CUSTOMER', -- 사용자 역할 코드 (코드그룹: USER_ROLE, 예시: CUSTOMER, MECHANIC, CENTER_OWNER, ADMIN)
    is_active_yn BOOLEAN DEFAULT true, -- 활성화 여부
    email_verified_yn BOOLEAN DEFAULT false, -- 이메일 인증 여부
    phone_verified_yn BOOLEAN DEFAULT false, -- 전화번호 인증 여부
    last_login_at TIMESTAMP, -- 마지막 로그인 일시
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 생성일시
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 수정일시
    created_by VARCHAR(50) NOT NULL, -- 생성자
    updated_by VARCHAR(50) NOT NULL, -- 수정자
    CONSTRAINT user_ux1 UNIQUE (email),
    CONSTRAINT user_ux2 UNIQUE (phone)
);

-- 사용자 프로필 정보 테이블
CREATE TABLE carfix.user_profile (
    user_profile_id SERIAL PRIMARY KEY, -- 기본키
    user_id INTEGER NOT NULL, -- 사용자 ID
    profile_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    birth_date DATE, -- 생년월일
    gender_code VARCHAR(50), -- 성별 코드 (코드그룹: GENDER, 예시: MALE, FEMALE, OTHER)
    address TEXT, -- 주소
    city VARCHAR(100), -- 도시
    state VARCHAR(100), -- 주/도
    postal_code VARCHAR(20), -- 우편번호
    emergency_contact VARCHAR(20), -- 비상연락처
    emergency_contact_name VARCHAR(100), -- 비상연락처 이름
    preferred_language_code VARCHAR(50) DEFAULT 'ko', -- 선호 언어 코드 (코드그룹: LANGUAGE, 예시: ko, en, ja, zh)
    timezone_code VARCHAR(50) DEFAULT 'Asia/Seoul', -- 시간대 코드 (코드그룹: TIMEZONE, 예시: Asia/Seoul, UTC, America/New_York)
    profile_image_url VARCHAR(500), -- 프로필 이미지 URL
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 생성일시
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 수정일시
    created_by VARCHAR(50) NOT NULL, -- 생성자
    updated_by VARCHAR(50) NOT NULL, -- 수정자
    CONSTRAINT user_profile_fk1 FOREIGN KEY (user_id) REFERENCES carfix.user(user_id) ON DELETE CASCADE
);

-- 소셜 로그인 연동 정보 테이블
CREATE TABLE carfix.social_login (
    social_login_id SERIAL PRIMARY KEY, -- 기본키
    user_id INTEGER NOT NULL, -- 사용자 ID
    provider_code VARCHAR(50) NOT NULL, -- 제공자 코드 (코드그룹: SOCIAL_PROVIDER, 예시: GOOGLE, NAVER, KAKAO)
    provider_user_id VARCHAR(255) NOT NULL, -- 제공자 사용자 ID
    provider_email VARCHAR(255), -- 제공자 이메일
    provider_name VARCHAR(100), -- 제공자 이름
    access_token TEXT, -- 액세스 토큰
    refresh_token TEXT, -- 리프레시 토큰
    token_expires_at TIMESTAMP, -- 토큰 만료 일시
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 생성일시
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 수정일시
    created_by VARCHAR(50) NOT NULL, -- 생성자
    updated_by VARCHAR(50) NOT NULL, -- 수정자
    CONSTRAINT social_login_fk1 FOREIGN KEY (user_id) REFERENCES carfix.user(user_id) ON DELETE CASCADE,
    CONSTRAINT social_login_ux1 UNIQUE (provider_code, provider_user_id)
);

-- 사용자 인증 토큰 테이블 (JWT 리프레시 토큰)
CREATE TABLE carfix.user_token (
    user_token_id SERIAL PRIMARY KEY, -- 기본키
    user_id INTEGER NOT NULL, -- 사용자 ID
    token_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    refresh_token VARCHAR(500) NOT NULL, -- 리프레시 토큰
    device_info TEXT, -- 디바이스 정보
    ip_address INET, -- IP 주소
    user_agent TEXT, -- 사용자 에이전트
    expires_at TIMESTAMP NOT NULL, -- 만료 일시
    is_revoked_yn BOOLEAN DEFAULT false, -- 폐기 여부
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 생성일시
    created_by VARCHAR(50) NOT NULL, -- 생성자
    CONSTRAINT user_token_fk1 FOREIGN KEY (user_id) REFERENCES carfix.user(user_id) ON DELETE CASCADE
);

-- SMS 인증 코드 테이블
CREATE TABLE carfix.sms_verification_code (
    sms_verification_code_id SERIAL PRIMARY KEY, -- 기본키
    phone VARCHAR(20) NOT NULL, -- 전화번호
    verification_code VARCHAR(6) NOT NULL, -- 인증 코드
    purpose_code VARCHAR(50) NOT NULL, -- 목적 코드 (코드그룹: SMS_PURPOSE, 예시: SIGNUP, LOGIN, PASSWORD_RESET, PHONE_UPDATE)
    is_used_yn BOOLEAN DEFAULT false, -- 사용 여부
    expires_at TIMESTAMP NOT NULL, -- 만료 일시
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 생성일시
    created_by VARCHAR(50) NOT NULL -- 생성자
);

-- 사용자 알림 설정 테이블
CREATE TABLE carfix.user_notification_setting (
    user_notification_setting_id SERIAL PRIMARY KEY, -- 기본키
    user_id INTEGER NOT NULL, -- 사용자 ID
    sms_enabled_yn BOOLEAN DEFAULT true, -- SMS 알림 활성화 여부
    email_enabled_yn BOOLEAN DEFAULT true, -- 이메일 알림 활성화 여부
    push_enabled_yn BOOLEAN DEFAULT true, -- 푸시 알림 활성화 여부
    in_app_enabled_yn BOOLEAN DEFAULT true, -- 앱 내 알림 활성화 여부
    night_mode_enabled_yn BOOLEAN DEFAULT false, -- 야간 모드 활성화 여부
    quiet_start_hour INTEGER DEFAULT 22 CHECK (quiet_start_hour >= 0 AND quiet_start_hour <= 23), -- 알림 금지 시작 시간
    quiet_end_hour INTEGER DEFAULT 8 CHECK (quiet_end_hour >= 0 AND quiet_end_hour <= 23), -- 알림 금지 종료 시간
    promotion_enabled_yn BOOLEAN DEFAULT true, -- 프로모션 알림 활성화 여부
    reservation_reminder_enabled_yn BOOLEAN DEFAULT true, -- 예약 알림 활성화 여부
    maintenance_reminder_enabled_yn BOOLEAN DEFAULT true, -- 정비 알림 활성화 여부
    review_reminder_enabled_yn BOOLEAN DEFAULT true, -- 리뷰 알림 활성화 여부
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 생성일시
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 수정일시
    created_by VARCHAR(50) NOT NULL, -- 생성자
    updated_by VARCHAR(50) NOT NULL, -- 수정자
    CONSTRAINT user_notification_setting_fk1 FOREIGN KEY (user_id) REFERENCES carfix.user(user_id) ON DELETE CASCADE
);

-- 사용자 약관 동의 이력 테이블
CREATE TABLE carfix.user_terms_agreement (
    user_terms_agreement_id SERIAL PRIMARY KEY, -- 기본키
    user_id INTEGER NOT NULL, -- 사용자 ID
    terms_type_code VARCHAR(50) NOT NULL, -- 약관 타입 코드 (코드그룹: TERMS_TYPE, 예시: SERVICE_TERMS, PRIVACY_POLICY, MARKETING_AGREEMENT)
    version VARCHAR(20) NOT NULL, -- 약관 버전
    agreed_at TIMESTAMP NOT NULL, -- 동의 일시
    ip_address INET, -- IP 주소
    user_agent TEXT, -- 사용자 에이전트
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 생성일시
    created_by VARCHAR(50) NOT NULL, -- 생성자
    CONSTRAINT user_terms_agreement_fk1 FOREIGN KEY (user_id) REFERENCES carfix.user(user_id) ON DELETE CASCADE
);

-- 테이블 코멘트
COMMENT ON TABLE carfix.user IS '사용자 기본 정보 테이블';
COMMENT ON TABLE carfix.user_profile IS '사용자 프로필 정보 테이블';
COMMENT ON TABLE carfix.social_login IS '소셜 로그인 연동 정보 테이블';
COMMENT ON TABLE carfix.user_token IS '사용자 인증 토큰 테이블';
COMMENT ON TABLE carfix.sms_verification_code IS 'SMS 인증 코드 테이블';
COMMENT ON TABLE carfix.user_notification_setting IS '사용자 알림 설정 테이블';
COMMENT ON TABLE carfix.user_terms_agreement IS '사용자 약관 동의 이력 테이블';

-- 컬럼 코멘트
COMMENT ON COLUMN carfix.user.user_id IS '사용자 ID';
COMMENT ON COLUMN carfix.user.user_uuid IS '사용자 UUID';
COMMENT ON COLUMN carfix.user.email IS '이메일';
COMMENT ON COLUMN carfix.user.password IS '비밀번호';
COMMENT ON COLUMN carfix.user.name IS '사용자명';
COMMENT ON COLUMN carfix.user.phone IS '전화번호';
COMMENT ON COLUMN carfix.user.role_code IS '사용자 역할 코드 (코드그룹: USER_ROLE, 예시: CUSTOMER, MECHANIC, CENTER_OWNER, ADMIN)';
COMMENT ON COLUMN carfix.user.is_active_yn IS '활성화 여부';
COMMENT ON COLUMN carfix.user.email_verified_yn IS '이메일 인증 여부';
COMMENT ON COLUMN carfix.user.phone_verified_yn IS '전화번호 인증 여부';
COMMENT ON COLUMN carfix.user.last_login_at IS '마지막 로그인 일시';
COMMENT ON COLUMN carfix.user.created_at IS '생성일시';
COMMENT ON COLUMN carfix.user.updated_at IS '수정일시';
COMMENT ON COLUMN carfix.user.created_by IS '생성자';
COMMENT ON COLUMN carfix.user.updated_by IS '수정자';

COMMENT ON COLUMN carfix.user_profile.user_profile_id IS '사용자 프로필 ID';
COMMENT ON COLUMN carfix.user_profile.user_id IS '사용자 ID';
COMMENT ON COLUMN carfix.user_profile.profile_uuid IS '프로필 UUID';
COMMENT ON COLUMN carfix.user_profile.birth_date IS '생년월일';
COMMENT ON COLUMN carfix.user_profile.gender_code IS '성별 코드 (코드그룹: GENDER, 예시: MALE, FEMALE, OTHER)';
COMMENT ON COLUMN carfix.user_profile.address IS '주소';
COMMENT ON COLUMN carfix.user_profile.city IS '도시';
COMMENT ON COLUMN carfix.user_profile.state IS '주/도';
COMMENT ON COLUMN carfix.user_profile.postal_code IS '우편번호';
COMMENT ON COLUMN carfix.user_profile.emergency_contact IS '비상연락처';
COMMENT ON COLUMN carfix.user_profile.emergency_contact_name IS '비상연락처 이름';
COMMENT ON COLUMN carfix.user_profile.preferred_language_code IS '선호 언어 코드 (코드그룹: LANGUAGE, 예시: ko, en, ja, zh)';
COMMENT ON COLUMN carfix.user_profile.timezone_code IS '시간대 코드 (코드그룹: TIMEZONE, 예시: Asia/Seoul, UTC, America/New_York)';
COMMENT ON COLUMN carfix.user_profile.profile_image_url IS '프로필 이미지 URL';
COMMENT ON COLUMN carfix.user_profile.created_at IS '생성일시';
COMMENT ON COLUMN carfix.user_profile.updated_at IS '수정일시';
COMMENT ON COLUMN carfix.user_profile.created_by IS '생성자';
COMMENT ON COLUMN carfix.user_profile.updated_by IS '수정자';

COMMENT ON COLUMN carfix.social_login.social_login_id IS '소셜 로그인 ID';
COMMENT ON COLUMN carfix.social_login.user_id IS '사용자 ID';
COMMENT ON COLUMN carfix.social_login.provider_code IS '제공자 코드 (코드그룹: SOCIAL_PROVIDER, 예시: GOOGLE, NAVER, KAKAO)';
COMMENT ON COLUMN carfix.social_login.provider_user_id IS '제공자 사용자 ID';
COMMENT ON COLUMN carfix.social_login.provider_email IS '제공자 이메일';
COMMENT ON COLUMN carfix.social_login.provider_name IS '제공자 이름';
COMMENT ON COLUMN carfix.social_login.access_token IS '액세스 토큰';
COMMENT ON COLUMN carfix.social_login.refresh_token IS '리프레시 토큰';
COMMENT ON COLUMN carfix.social_login.token_expires_at IS '토큰 만료 일시';
COMMENT ON COLUMN carfix.social_login.created_at IS '생성일시';
COMMENT ON COLUMN carfix.social_login.updated_at IS '수정일시';
COMMENT ON COLUMN carfix.social_login.created_by IS '생성자';
COMMENT ON COLUMN carfix.social_login.updated_by IS '수정자';

COMMENT ON COLUMN carfix.user_token.user_token_id IS '사용자 토큰 ID';
COMMENT ON COLUMN carfix.user_token.user_id IS '사용자 ID';
COMMENT ON COLUMN carfix.user_token.token_uuid IS '토큰 UUID';
COMMENT ON COLUMN carfix.user_token.refresh_token IS '리프레시 토큰';
COMMENT ON COLUMN carfix.user_token.device_info IS '디바이스 정보';
COMMENT ON COLUMN carfix.user_token.ip_address IS 'IP 주소';
COMMENT ON COLUMN carfix.user_token.user_agent IS '사용자 에이전트';
COMMENT ON COLUMN carfix.user_token.expires_at IS '만료 일시';
COMMENT ON COLUMN carfix.user_token.is_revoked_yn IS '폐기 여부';
COMMENT ON COLUMN carfix.user_token.created_at IS '생성일시';
COMMENT ON COLUMN carfix.user_token.created_by IS '생성자';

COMMENT ON COLUMN carfix.sms_verification_code.sms_verification_code_id IS 'SMS 인증 코드 ID';
COMMENT ON COLUMN carfix.sms_verification_code.phone IS '전화번호';
COMMENT ON COLUMN carfix.sms_verification_code.verification_code IS '인증 코드';
COMMENT ON COLUMN carfix.sms_verification_code.purpose_code IS '목적 코드 (코드그룹: SMS_PURPOSE, 예시: SIGNUP, LOGIN, PASSWORD_RESET, PHONE_UPDATE)';
COMMENT ON COLUMN carfix.sms_verification_code.is_used_yn IS '사용 여부';
COMMENT ON COLUMN carfix.sms_verification_code.expires_at IS '만료 일시';
COMMENT ON COLUMN carfix.sms_verification_code.created_at IS '생성일시';
COMMENT ON COLUMN carfix.sms_verification_code.created_by IS '생성자';

COMMENT ON COLUMN carfix.user_notification_setting.user_notification_setting_id IS '사용자 알림 설정 ID';
COMMENT ON COLUMN carfix.user_notification_setting.user_id IS '사용자 ID';
COMMENT ON COLUMN carfix.user_notification_setting.sms_enabled_yn IS 'SMS 알림 활성화 여부';
COMMENT ON COLUMN carfix.user_notification_setting.email_enabled_yn IS '이메일 알림 활성화 여부';
COMMENT ON COLUMN carfix.user_notification_setting.push_enabled_yn IS '푸시 알림 활성화 여부';
COMMENT ON COLUMN carfix.user_notification_setting.in_app_enabled_yn IS '앱 내 알림 활성화 여부';
COMMENT ON COLUMN carfix.user_notification_setting.night_mode_enabled_yn IS '야간 모드 활성화 여부';
COMMENT ON COLUMN carfix.user_notification_setting.quiet_start_hour IS '알림 금지 시작 시간';
COMMENT ON COLUMN carfix.user_notification_setting.quiet_end_hour IS '알림 금지 종료 시간';
COMMENT ON COLUMN carfix.user_notification_setting.promotion_enabled_yn IS '프로모션 알림 활성화 여부';
COMMENT ON COLUMN carfix.user_notification_setting.reservation_reminder_enabled_yn IS '예약 알림 활성화 여부';
COMMENT ON COLUMN carfix.user_notification_setting.maintenance_reminder_enabled_yn IS '정비 알림 활성화 여부';
COMMENT ON COLUMN carfix.user_notification_setting.review_reminder_enabled_yn IS '리뷰 알림 활성화 여부';
COMMENT ON COLUMN carfix.user_notification_setting.created_at IS '생성일시';
COMMENT ON COLUMN carfix.user_notification_setting.updated_at IS '수정일시';
COMMENT ON COLUMN carfix.user_notification_setting.created_by IS '생성자';
COMMENT ON COLUMN carfix.user_notification_setting.updated_by IS '수정자';

COMMENT ON COLUMN carfix.user_terms_agreement.user_terms_agreement_id IS '사용자 약관 동의 이력 ID';
COMMENT ON COLUMN carfix.user_terms_agreement.user_id IS '사용자 ID';
COMMENT ON COLUMN carfix.user_terms_agreement.terms_type_code IS '약관 타입 코드 (코드그룹: TERMS_TYPE, 예시: SERVICE_TERMS, PRIVACY_POLICY, MARKETING_AGREEMENT)';
COMMENT ON COLUMN carfix.user_terms_agreement.version IS '약관 버전';
COMMENT ON COLUMN carfix.user_terms_agreement.agreed_at IS '동의 일시';
COMMENT ON COLUMN carfix.user_terms_agreement.ip_address IS 'IP 주소';
COMMENT ON COLUMN carfix.user_terms_agreement.user_agent IS '사용자 에이전트';
COMMENT ON COLUMN carfix.user_terms_agreement.created_at IS '생성일시';
COMMENT ON COLUMN carfix.user_terms_agreement.created_by IS '생성자';

-- 인덱스 생성 (가이드 규칙 적용)
CREATE INDEX user_ix1 ON carfix.user (role_code);
CREATE INDEX user_ix2 ON carfix.user (is_active_yn);
CREATE INDEX user_ix3 ON carfix.user (created_at);
CREATE INDEX user_profile_ix1 ON carfix.user_profile (user_id);
CREATE INDEX user_profile_ix2 ON carfix.user_profile (gender_code);
CREATE INDEX social_login_ix1 ON carfix.social_login (user_id);
CREATE INDEX social_login_ix2 ON carfix.social_login (provider_code);
CREATE INDEX user_token_ix1 ON carfix.user_token (user_id);
CREATE INDEX user_token_ix2 ON carfix.user_token (refresh_token);
CREATE INDEX sms_verification_code_ix1 ON carfix.sms_verification_code (phone);
CREATE INDEX sms_verification_code_ix2 ON carfix.sms_verification_code (expires_at);
CREATE INDEX user_notification_setting_ix1 ON carfix.user_notification_setting (user_id);
CREATE INDEX user_terms_agreement_ix1 ON carfix.user_terms_agreement (user_id);
CREATE INDEX user_terms_agreement_ix2 ON carfix.user_terms_agreement (terms_type_code);

