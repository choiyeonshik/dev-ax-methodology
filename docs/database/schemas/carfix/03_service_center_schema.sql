-- =====================================================
-- 정비소 관리 스키마
-- =====================================================

-- 정비소 기본 정보 테이블
CREATE TABLE service_centers (
    id BIGSERIAL PRIMARY KEY,
    center_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    owner_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    business_number VARCHAR(20) UNIQUE NOT NULL, -- 사업자등록번호
    description TEXT,
    address TEXT NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(255),
    website VARCHAR(500),
    rating NUMERIC(3,2) DEFAULT 0.0,
    total_reviews INTEGER DEFAULT 0,
    total_reservations INTEGER DEFAULT 0,
    is_verified BOOLEAN DEFAULT false,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 정비소 운영시간 테이블
CREATE TABLE service_center_operating_hours (
    id BIGSERIAL PRIMARY KEY,
    center_id BIGINT NOT NULL REFERENCES service_centers(id) ON DELETE CASCADE,
    day_of_week INTEGER NOT NULL CHECK (day_of_week >= 1 AND day_of_week <= 7), -- 1=월요일, 7=일요일
    open_time TIME,
    close_time TIME,
    is_closed BOOLEAN DEFAULT false,
    break_start_time TIME,
    break_end_time TIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(center_id, day_of_week)
);

-- 정비소 휴무일 테이블
CREATE TABLE service_center_holidays (
    id BIGSERIAL PRIMARY KEY,
    center_id BIGINT NOT NULL REFERENCES service_centers(id) ON DELETE CASCADE,
    holiday_date DATE NOT NULL,
    holiday_name VARCHAR(100),
    is_recurring BOOLEAN DEFAULT false, -- 매년 반복되는 휴무일
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(center_id, holiday_date)
);

-- 정비소 사진 테이블
CREATE TABLE service_center_images (
    id BIGSERIAL PRIMARY KEY,
    center_id BIGINT NOT NULL REFERENCES service_centers(id) ON DELETE CASCADE,
    image_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    image_url VARCHAR(500) NOT NULL,
    image_type VARCHAR(20) CHECK (image_type IN ('EXTERIOR', 'INTERIOR', 'WORKSHOP', 'EQUIPMENT', 'CERTIFICATE', 'LOGO')),
    description TEXT,
    is_primary BOOLEAN DEFAULT false,
    display_order INTEGER DEFAULT 0,
    file_size INTEGER,
    file_format VARCHAR(10),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 정비소 인증 및 자격 정보 테이블
CREATE TABLE service_center_certifications (
    id BIGSERIAL PRIMARY KEY,
    center_id BIGINT NOT NULL REFERENCES service_centers(id) ON DELETE CASCADE,
    certification_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    certification_type VARCHAR(50) CHECK (certification_type IN ('ISO', 'KSA', 'BRAND_CERTIFIED', 'SAFETY', 'ENVIRONMENTAL', 'OTHER')),
    certification_name VARCHAR(100) NOT NULL,
    issuing_organization VARCHAR(100),
    issue_date DATE,
    expiry_date DATE,
    certificate_number VARCHAR(100),
    certificate_url VARCHAR(500),
    is_verified BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 정비소 보유 장비 테이블
CREATE TABLE service_center_equipment (
    id BIGSERIAL PRIMARY KEY,
    center_id BIGINT NOT NULL REFERENCES service_centers(id) ON DELETE CASCADE,
    equipment_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    equipment_name VARCHAR(100) NOT NULL,
    equipment_type VARCHAR(50) CHECK (equipment_type IN ('DIAGNOSTIC', 'LIFT', 'TOOL', 'MACHINE', 'TESTING', 'OTHER')),
    brand VARCHAR(100),
    model VARCHAR(100),
    description TEXT,
    is_available BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 정비사 정보 테이블
CREATE TABLE mechanics (
    id BIGSERIAL PRIMARY KEY,
    mechanic_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    center_id BIGINT NOT NULL REFERENCES service_centers(id) ON DELETE CASCADE,
    user_id BIGINT REFERENCES users(id), -- 정비사가 시스템 사용자인 경우
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(255),
    license_number VARCHAR(50), -- 정비사 자격증 번호
    experience_years INTEGER,
    specialties TEXT, -- 전문 분야 (JSON 형태로 저장 가능)
    is_available BOOLEAN DEFAULT true,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 정비사 스케줄 테이블
CREATE TABLE mechanic_schedules (
    id BIGSERIAL PRIMARY KEY,
    mechanic_id BIGINT NOT NULL REFERENCES mechanics(id) ON DELETE CASCADE,
    schedule_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    work_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    is_available BOOLEAN DEFAULT true,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 정비소 서비스 타입 테이블
CREATE TABLE service_types (
    id BIGSERIAL PRIMARY KEY,
    service_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    category VARCHAR(50) NOT NULL CHECK (category IN ('ENGINE', 'BRAKE', 'TIRE', 'ELECTRICAL', 'AC_HEATING', 'TRANSMISSION', 'SUSPENSION', 'EXHAUST', 'INSPECTION', 'OTHER')),
    estimated_duration INTEGER, -- 예상 소요시간(분)
    base_price DECIMAL(10,2), -- 기본 가격
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 정비소별 서비스 제공 정보 테이블
CREATE TABLE service_center_services (
    id BIGSERIAL PRIMARY KEY,
    center_id BIGINT NOT NULL REFERENCES service_centers(id) ON DELETE CASCADE,
    service_type_id BIGINT NOT NULL REFERENCES service_types(id) ON DELETE CASCADE,
    price DECIMAL(10,2) NOT NULL,
    estimated_duration INTEGER, -- 정비소별 예상 소요시간
    is_available BOOLEAN DEFAULT true,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(center_id, service_type_id)
);

-- 정비소 평점 통계 테이블
CREATE TABLE service_center_ratings (
    id BIGSERIAL PRIMARY KEY,
    center_id BIGINT NOT NULL REFERENCES service_centers(id) ON DELETE CASCADE,
    rating_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    overall_rating NUMERIC(3,2) DEFAULT 0.0,
    service_quality_rating NUMERIC(3,2) DEFAULT 0.0,
    price_rating NUMERIC(3,2) DEFAULT 0.0,
    communication_rating NUMERIC(3,2) DEFAULT 0.0,
    cleanliness_rating NUMERIC(3,2) DEFAULT 0.0,
    total_reviews INTEGER DEFAULT 0,
    five_star_count INTEGER DEFAULT 0,
    four_star_count INTEGER DEFAULT 0,
    three_star_count INTEGER DEFAULT 0,
    two_star_count INTEGER DEFAULT 0,
    one_star_count INTEGER DEFAULT 0,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(center_id)
);

-- 정비소 운영 상태 이력 테이블
CREATE TABLE service_center_status_history (
    id BIGSERIAL PRIMARY KEY,
    center_id BIGINT NOT NULL REFERENCES service_centers(id) ON DELETE CASCADE,
    status_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    status VARCHAR(20) NOT NULL CHECK (status IN ('OPEN', 'CLOSED', 'BUSY', 'MAINTENANCE', 'HOLIDAY')),
    reason TEXT,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP,
    created_by BIGINT REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 인덱스 생성
CREATE INDEX idx_service_centers_owner_id ON service_centers(owner_id);
CREATE INDEX idx_service_centers_business_number ON service_centers(business_number);
CREATE INDEX idx_service_centers_city_state ON service_centers(city, state);
CREATE INDEX idx_service_centers_latitude_longitude ON service_centers(latitude, longitude);
CREATE INDEX idx_service_centers_rating ON service_centers(rating);
CREATE INDEX idx_service_centers_is_verified ON service_centers(is_verified);
CREATE INDEX idx_service_centers_is_active ON service_centers(is_active);
CREATE INDEX idx_service_center_operating_hours_center_id ON service_center_operating_hours(center_id);
CREATE INDEX idx_service_center_operating_hours_day_of_week ON service_center_operating_hours(day_of_week);
CREATE INDEX idx_service_center_holidays_center_id ON service_center_holidays(center_id);
CREATE INDEX idx_service_center_holidays_holiday_date ON service_center_holidays(holiday_date);
CREATE INDEX idx_service_center_images_center_id ON service_center_images(center_id);
CREATE INDEX idx_service_center_images_image_type ON service_center_images(image_type);
CREATE INDEX idx_service_center_certifications_center_id ON service_center_certifications(center_id);
CREATE INDEX idx_service_center_certifications_type ON service_center_certifications(certification_type);
CREATE INDEX idx_service_center_equipment_center_id ON service_center_equipment(center_id);
CREATE INDEX idx_service_center_equipment_type ON service_center_equipment(equipment_type);
CREATE INDEX idx_mechanics_center_id ON mechanics(center_id);
CREATE INDEX idx_mechanics_user_id ON mechanics(user_id);
CREATE INDEX idx_mechanics_is_available ON mechanics(is_available);
CREATE INDEX idx_mechanic_schedules_mechanic_id ON mechanic_schedules(mechanic_id);
CREATE INDEX idx_mechanic_schedules_work_date ON mechanic_schedules(work_date);
CREATE INDEX idx_service_types_category ON service_types(category);
CREATE INDEX idx_service_types_is_active ON service_types(is_active);
CREATE INDEX idx_service_center_services_center_id ON service_center_services(center_id);
CREATE INDEX idx_service_center_services_service_type_id ON service_center_services(service_type_id);
CREATE INDEX idx_service_center_ratings_center_id ON service_center_ratings(center_id);
CREATE INDEX idx_service_center_status_history_center_id ON service_center_status_history(center_id);
CREATE INDEX idx_service_center_status_history_status ON service_center_status_history(status);
CREATE INDEX idx_service_center_status_history_start_time ON service_center_status_history(start_time);

-- 뷰 생성: 정비소 상세 정보 조합 뷰
CREATE VIEW service_center_summary AS
SELECT 
    sc.id,
    sc.center_uuid,
    sc.owner_id,
    sc.name,
    sc.business_number,
    sc.description,
    sc.address,
    sc.city,
    sc.state,
    sc.postal_code,
    sc.latitude,
    sc.longitude,
    sc.phone,
    sc.email,
    sc.website,
    sc.rating,
    sc.total_reviews,
    sc.total_reservations,
    sc.is_verified,
    sc.is_active,
    scr.overall_rating as calculated_rating,
    scr.service_quality_rating,
    scr.price_rating,
    scr.communication_rating,
    scr.cleanliness_rating,
    COUNT(DISTINCT m.id) as mechanic_count,
    COUNT(DISTINCT sct.id) as service_type_count,
    sc.created_at,
    sc.updated_at
FROM service_centers sc
LEFT JOIN service_center_ratings scr ON sc.id = scr.center_id
LEFT JOIN mechanics m ON sc.id = m.center_id AND m.is_active = true
LEFT JOIN service_center_services sct ON sc.id = sct.center_id AND sct.is_available = true
GROUP BY sc.id, scr.overall_rating, scr.service_quality_rating, scr.price_rating, scr.communication_rating, scr.cleanliness_rating;

-- 트리거 생성
CREATE TRIGGER update_service_centers_updated_at BEFORE UPDATE ON service_centers FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_service_center_operating_hours_updated_at BEFORE UPDATE ON service_center_operating_hours FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_service_center_certifications_updated_at BEFORE UPDATE ON service_center_certifications FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_service_center_equipment_updated_at BEFORE UPDATE ON service_center_equipment FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_mechanics_updated_at BEFORE UPDATE ON mechanics FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_mechanic_schedules_updated_at BEFORE UPDATE ON mechanic_schedules FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_service_types_updated_at BEFORE UPDATE ON service_types FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_service_center_services_updated_at BEFORE UPDATE ON service_center_services FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_service_center_ratings_updated_at BEFORE UPDATE ON service_center_ratings FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
