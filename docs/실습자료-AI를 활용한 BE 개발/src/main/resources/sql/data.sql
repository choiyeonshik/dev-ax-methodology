-- ========================================
-- 개발 환경용 기본 데이터
-- 실제 테스트 데이터는 Flyway 마이그레이션에서 관리됩니다.
-- ========================================

-- 기본 시스템 설정
INSERT INTO system_settings (setting_key, setting_value, description, data_type, is_public) 
SELECT 'app.name', 'Car Center DevLab', '애플리케이션 이름', 'STRING', true
WHERE NOT EXISTS (SELECT 1 FROM system_settings WHERE setting_key = 'app.name');

INSERT INTO system_settings (setting_key, setting_value, description, data_type, is_public) 
SELECT 'app.version', '1.0.0-DEV', '애플리케이션 버전', 'STRING', true
WHERE NOT EXISTS (SELECT 1 FROM system_settings WHERE setting_key = 'app.version');

INSERT INTO system_settings (setting_key, setting_value, description, data_type, is_public) 
SELECT 'maintenance.default_warranty_days', '30', '기본 보증 기간 (일)', 'INTEGER', false
WHERE NOT EXISTS (SELECT 1 FROM system_settings WHERE setting_key = 'maintenance.default_warranty_days');

-- 기본 관리자 계정 (비밀번호: admin123)
INSERT INTO users (username, password, name, email, phone, role, status) 
SELECT 'admin', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewfBPdkzjvl1/3nm', '시스템 관리자', 'admin@carcenter.com', '010-0000-0000', 'SYSTEM_ADMIN', 'ACTIVE'
WHERE NOT EXISTS (SELECT 1 FROM users WHERE username = 'admin');

-- 개발용 테스트 사용자 (비밀번호: user123)
INSERT INTO users (username, password, name, email, phone, role, status) 
SELECT 'testuser', '$2a$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi.', '테스트 사용자', 'test@example.com', '010-1234-5678', 'USER', 'ACTIVE'
WHERE NOT EXISTS (SELECT 1 FROM users WHERE username = 'testuser');

-- 개발용 테스트 정비소
INSERT INTO shops (name, business_number, address, phone, email, latitude, longitude, operating_hours, description, rating, total_reviews, status) 
SELECT '개발테스트센터', '999-99-99999', '서울시 테스트구 개발로 123', '02-9999-9999', 'dev@test.com', 37.5665, 126.9780, 
       '{"monday": {"open": "09:00", "close": "18:00"}, "tuesday": {"open": "09:00", "close": "18:00"}, "wednesday": {"open": "09:00", "close": "18:00"}, "thursday": {"open": "09:00", "close": "18:00"}, "friday": {"open": "09:00", "close": "18:00"}, "saturday": {"open": "09:00", "close": "15:00"}, "sunday": {"closed": true}}',
       '개발 및 테스트용 정비소입니다.', 5.0, 1, 'ACTIVE'
WHERE NOT EXISTS (SELECT 1 FROM shops WHERE business_number = '999-99-99999');

-- 개발용 테스트 차량
INSERT INTO vehicles (user_id, license_number, manufacturer, model, model_year, engine_type, mileage, color, vin) 
SELECT 2, '00A0000', 'TestCorp', 'DevCar', 2024, 'GASOLINE', 0, 'White', 'TEST0000000000000'
WHERE NOT EXISTS (SELECT 1 FROM vehicles WHERE license_number = '00A0000');