-- =====================================================
-- 차량 관리 스키마
-- =====================================================

-- 차량 제조사 마스터 테이블
CREATE TABLE vehicle_brands (
    id BIGSERIAL PRIMARY KEY,
    brand_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL UNIQUE,
    name_en VARCHAR(100),
    country VARCHAR(50),
    logo_url VARCHAR(500),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 차량 모델 마스터 테이블
CREATE TABLE vehicle_models (
    id BIGSERIAL PRIMARY KEY,
    model_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    brand_id BIGINT NOT NULL REFERENCES vehicle_brands(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    name_en VARCHAR(100),
    category VARCHAR(50) CHECK (category IN ('SEDAN', 'SUV', 'HATCHBACK', 'WAGON', 'COUPE', 'CONVERTIBLE', 'PICKUP', 'VAN', 'TRUCK')),
    body_type VARCHAR(50),
    fuel_type VARCHAR(20) CHECK (fuel_type IN ('GASOLINE', 'DIESEL', 'HYBRID', 'ELECTRIC', 'LPG', 'HYDROGEN')),
    engine_type VARCHAR(100),
    transmission_type VARCHAR(20) CHECK (transmission_type IN ('MANUAL', 'AUTOMATIC', 'CVT', 'DCT')),
    start_year INTEGER,
    end_year INTEGER,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(brand_id, name, start_year)
);

-- 차량 세부 모델 정보 테이블
CREATE TABLE vehicle_model_details (
    id BIGSERIAL PRIMARY KEY,
    model_id BIGINT NOT NULL REFERENCES vehicle_models(id) ON DELETE CASCADE,
    detail_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    trim_name VARCHAR(100),
    engine_displacement DECIMAL(3,1), -- 리터 단위
    power_hp INTEGER,
    power_kw INTEGER,
    torque_nm INTEGER,
    fuel_efficiency_city DECIMAL(4,1), -- km/L
    fuel_efficiency_highway DECIMAL(4,1),
    fuel_efficiency_combined DECIMAL(4,1),
    battery_capacity DECIMAL(4,1), -- kWh (전기차용)
    seating_capacity INTEGER,
    cargo_volume DECIMAL(5,2), -- 리터
    weight INTEGER, -- kg
    length INTEGER, -- mm
    width INTEGER, -- mm
    height INTEGER, -- mm
    wheelbase INTEGER, -- mm
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 사용자 차량 정보 테이블
CREATE TABLE vehicles (
    id BIGSERIAL PRIMARY KEY,
    vehicle_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    brand_id BIGINT REFERENCES vehicle_brands(id),
    model_id BIGINT REFERENCES vehicle_models(id),
    model_detail_id BIGINT REFERENCES vehicle_model_details(id),
    license_plate VARCHAR(20) UNIQUE NOT NULL,
    vin VARCHAR(17), -- Vehicle Identification Number
    nickname VARCHAR(100), -- 사용자가 지정한 차량 별명
    year INTEGER NOT NULL,
    color VARCHAR(50),
    mileage INTEGER DEFAULT 0, -- 주행거리 (km)
    fuel_level DECIMAL(3,1) CHECK (fuel_level >= 0 AND fuel_level <= 100), -- 연료량 (%)
    last_service_date DATE,
    next_service_date DATE,
    insurance_expiry_date DATE,
    registration_expiry_date DATE,
    is_primary BOOLEAN DEFAULT false, -- 사용자의 주차량 여부
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 차량 사진 테이블
CREATE TABLE vehicle_images (
    id BIGSERIAL PRIMARY KEY,
    vehicle_id BIGINT NOT NULL REFERENCES vehicles(id) ON DELETE CASCADE,
    image_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    image_url VARCHAR(500) NOT NULL,
    image_type VARCHAR(20) CHECK (image_type IN ('EXTERIOR', 'INTERIOR', 'ENGINE', 'DAMAGE', 'DOCUMENT')),
    description TEXT,
    is_primary BOOLEAN DEFAULT false,
    file_size INTEGER, -- 바이트 단위
    file_format VARCHAR(10),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 차량 정비 이력 테이블
CREATE TABLE vehicle_maintenance_history (
    id BIGSERIAL PRIMARY KEY,
    vehicle_id BIGINT NOT NULL REFERENCES vehicles(id) ON DELETE CASCADE,
    history_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    service_center_id BIGINT, -- 정비소 ID (나중에 service_centers 테이블 참조)
    service_date DATE NOT NULL,
    mileage_at_service INTEGER NOT NULL,
    service_type VARCHAR(100),
    description TEXT,
    parts_replaced TEXT, -- JSON 형태로 저장 가능
    labor_cost DECIMAL(10,2),
    parts_cost DECIMAL(10,2),
    total_cost DECIMAL(10,2),
    next_service_mileage INTEGER,
    next_service_date DATE,
    mechanic_notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 차량 소모품 교체 이력 테이블
CREATE TABLE vehicle_consumable_history (
    id BIGSERIAL PRIMARY KEY,
    vehicle_id BIGINT NOT NULL REFERENCES vehicles(id) ON DELETE CASCADE,
    consumable_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    consumable_type VARCHAR(50) CHECK (consumable_type IN ('ENGINE_OIL', 'OIL_FILTER', 'AIR_FILTER', 'FUEL_FILTER', 'BRAKE_PAD', 'BRAKE_FLUID', 'COOLANT', 'TRANSMISSION_FLUID', 'BATTERY', 'TIRE', 'WIPER')),
    replaced_date DATE NOT NULL,
    mileage_at_replacement INTEGER NOT NULL,
    brand VARCHAR(100),
    model VARCHAR(100),
    next_replacement_mileage INTEGER,
    next_replacement_date DATE,
    cost DECIMAL(10,2),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 차량 정기점검 스케줄 테이블
CREATE TABLE vehicle_maintenance_schedules (
    id BIGSERIAL PRIMARY KEY,
    vehicle_id BIGINT NOT NULL REFERENCES vehicles(id) ON DELETE CASCADE,
    schedule_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    schedule_type VARCHAR(50) CHECK (schedule_type IN ('MILEAGE_BASED', 'TIME_BASED', 'HYBRID')),
    service_name VARCHAR(100) NOT NULL,
    interval_mileage INTEGER, -- km 단위
    interval_months INTEGER, -- 월 단위
    last_service_date DATE,
    last_service_mileage INTEGER,
    next_service_date DATE,
    next_service_mileage INTEGER,
    is_active BOOLEAN DEFAULT true,
    reminder_enabled BOOLEAN DEFAULT true,
    reminder_days_before INTEGER DEFAULT 7,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 차량 문제점/증상 기록 테이블
CREATE TABLE vehicle_issues (
    id BIGSERIAL PRIMARY KEY,
    vehicle_id BIGINT NOT NULL REFERENCES vehicles(id) ON DELETE CASCADE,
    issue_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    issue_type VARCHAR(50) CHECK (issue_type IN ('ENGINE', 'TRANSMISSION', 'BRAKE', 'SUSPENSION', 'ELECTRICAL', 'AC_HEATING', 'EXTERIOR', 'INTERIOR', 'OTHER')),
    severity VARCHAR(20) CHECK (severity IN ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL')),
    description TEXT NOT NULL,
    symptoms TEXT,
    detected_date DATE NOT NULL,
    resolved_date DATE,
    estimated_repair_cost DECIMAL(10,2),
    actual_repair_cost DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'OPEN' CHECK (status IN ('OPEN', 'IN_PROGRESS', 'RESOLVED', 'IGNORED')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 인덱스 생성
CREATE INDEX idx_vehicle_brands_name ON vehicle_brands(name);
CREATE INDEX idx_vehicle_brands_is_active ON vehicle_brands(is_active);
CREATE INDEX idx_vehicle_models_brand_id ON vehicle_models(brand_id);
CREATE INDEX idx_vehicle_models_category ON vehicle_models(category);
CREATE INDEX idx_vehicle_models_fuel_type ON vehicle_models(fuel_type);
CREATE INDEX idx_vehicle_models_is_active ON vehicle_models(is_active);
CREATE INDEX idx_vehicle_model_details_model_id ON vehicle_model_details(model_id);
CREATE INDEX idx_vehicles_user_id ON vehicles(user_id);
CREATE INDEX idx_vehicles_license_plate ON vehicles(license_plate);
CREATE INDEX idx_vehicles_vin ON vehicles(vin);
CREATE INDEX idx_vehicles_brand_id ON vehicles(brand_id);
CREATE INDEX idx_vehicles_model_id ON vehicles(model_id);
CREATE INDEX idx_vehicles_is_primary ON vehicles(is_primary);
CREATE INDEX idx_vehicles_is_active ON vehicles(is_active);
CREATE INDEX idx_vehicle_images_vehicle_id ON vehicle_images(vehicle_id);
CREATE INDEX idx_vehicle_images_image_type ON vehicle_images(image_type);
CREATE INDEX idx_vehicle_maintenance_history_vehicle_id ON vehicle_maintenance_history(vehicle_id);
CREATE INDEX idx_vehicle_maintenance_history_service_date ON vehicle_maintenance_history(service_date);
CREATE INDEX idx_vehicle_consumable_history_vehicle_id ON vehicle_consumable_history(vehicle_id);
CREATE INDEX idx_vehicle_consumable_history_consumable_type ON vehicle_consumable_history(consumable_type);
CREATE INDEX idx_vehicle_maintenance_schedules_vehicle_id ON vehicle_maintenance_schedules(vehicle_id);
CREATE INDEX idx_vehicle_maintenance_schedules_next_service_date ON vehicle_maintenance_schedules(next_service_date);
CREATE INDEX idx_vehicle_issues_vehicle_id ON vehicle_issues(vehicle_id);
CREATE INDEX idx_vehicle_issues_status ON vehicle_issues(status);
CREATE INDEX idx_vehicle_issues_severity ON vehicle_issues(severity);

-- 뷰 생성: 차량 상세 정보 조합 뷰
CREATE VIEW vehicle_summary AS
SELECT 
    v.id,
    v.vehicle_uuid,
    v.user_id,
    vb.name as brand_name,
    vm.name as model_name,
    vmd.trim_name,
    v.license_plate,
    v.vin,
    v.nickname,
    v.year,
    v.color,
    v.mileage,
    v.fuel_level,
    v.last_service_date,
    v.next_service_date,
    v.insurance_expiry_date,
    v.registration_expiry_date,
    v.is_primary,
    v.is_active,
    v.created_at,
    v.updated_at
FROM vehicles v
LEFT JOIN vehicle_brands vb ON v.brand_id = vb.id
LEFT JOIN vehicle_models vm ON v.model_id = vm.id
LEFT JOIN vehicle_model_details vmd ON v.model_detail_id = vmd.id;

-- 트리거 생성
CREATE TRIGGER update_vehicle_brands_updated_at BEFORE UPDATE ON vehicle_brands FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_vehicle_models_updated_at BEFORE UPDATE ON vehicle_models FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_vehicle_model_details_updated_at BEFORE UPDATE ON vehicle_model_details FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_vehicles_updated_at BEFORE UPDATE ON vehicles FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_vehicle_maintenance_history_updated_at BEFORE UPDATE ON vehicle_maintenance_history FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_vehicle_maintenance_schedules_updated_at BEFORE UPDATE ON vehicle_maintenance_schedules FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_vehicle_issues_updated_at BEFORE UPDATE ON vehicle_issues FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
