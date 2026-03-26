-- ========================================
-- 인덱스 및 성능 최적화 스크립트
-- 버전: 1.0.0
-- 호환성: H2, PostgreSQL
-- ========================================

-- ========================================
-- 사용자 테이블 인덱스
-- ========================================
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_phone ON users(phone);
CREATE INDEX IF NOT EXISTS idx_users_status ON users(status);
CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);
CREATE INDEX IF NOT EXISTS idx_users_created_at ON users(created_at);
CREATE INDEX IF NOT EXISTS idx_users_active ON users(status, deleted_at) WHERE deleted_at IS NULL;

-- ========================================
-- 차량 테이블 인덱스
-- ========================================
CREATE INDEX IF NOT EXISTS idx_vehicles_user_id ON vehicles(user_id);
CREATE INDEX IF NOT EXISTS idx_vehicles_license_number ON vehicles(license_number);
CREATE INDEX IF NOT EXISTS idx_vehicles_manufacturer_model ON vehicles(manufacturer, model);
CREATE INDEX IF NOT EXISTS idx_vehicles_year ON vehicles(year);
CREATE INDEX IF NOT EXISTS idx_vehicles_engine_type ON vehicles(engine_type);
CREATE INDEX IF NOT EXISTS idx_vehicles_active ON vehicles(user_id, deleted_at) WHERE deleted_at IS NULL;

-- ========================================
-- 정비소 테이블 인덱스
-- ========================================
CREATE INDEX IF NOT EXISTS idx_shops_business_number ON shops(business_number);
CREATE INDEX IF NOT EXISTS idx_shops_location ON shops(latitude, longitude);
CREATE INDEX IF NOT EXISTS idx_shops_status ON shops(status);
CREATE INDEX IF NOT EXISTS idx_shops_rating ON shops(rating DESC);
CREATE INDEX IF NOT EXISTS idx_shops_name ON shops(name);
CREATE INDEX IF NOT EXISTS idx_shops_active ON shops(status, deleted_at) WHERE deleted_at IS NULL;

-- ========================================
-- 정비사 테이블 인덱스
-- ========================================
CREATE INDEX IF NOT EXISTS idx_technicians_shop_id ON technicians(shop_id);
CREATE INDEX IF NOT EXISTS idx_technicians_status ON technicians(status);
CREATE INDEX IF NOT EXISTS idx_technicians_certification ON technicians(certification_number);
CREATE INDEX IF NOT EXISTS idx_technicians_active ON technicians(shop_id, status, deleted_at) WHERE deleted_at IS NULL;

-- ========================================
-- 예약 테이블 인덱스
-- ========================================
CREATE INDEX IF NOT EXISTS idx_bookings_user_id ON bookings(user_id);
CREATE INDEX IF NOT EXISTS idx_bookings_vehicle_id ON bookings(vehicle_id);
CREATE INDEX IF NOT EXISTS idx_bookings_shop_id ON bookings(shop_id);
CREATE INDEX IF NOT EXISTS idx_bookings_technician_id ON bookings(technician_id);
CREATE INDEX IF NOT EXISTS idx_bookings_appointment ON bookings(appointment_datetime);
CREATE INDEX IF NOT EXISTS idx_bookings_status ON bookings(status);
CREATE INDEX IF NOT EXISTS idx_bookings_priority ON bookings(priority);
CREATE INDEX IF NOT EXISTS idx_bookings_date_status ON bookings(appointment_datetime, status);
CREATE INDEX IF NOT EXISTS idx_bookings_shop_date ON bookings(shop_id, appointment_datetime);
CREATE INDEX IF NOT EXISTS idx_bookings_user_status ON bookings(user_id, status);
CREATE INDEX IF NOT EXISTS idx_bookings_active ON bookings(status, deleted_at) WHERE deleted_at IS NULL;

-- ========================================
-- 정비 작업 테이블 인덱스
-- ========================================
CREATE INDEX IF NOT EXISTS idx_maintenance_booking_id ON maintenance(booking_id);
CREATE INDEX IF NOT EXISTS idx_maintenance_technician_id ON maintenance(technician_id);
CREATE INDEX IF NOT EXISTS idx_maintenance_status ON maintenance(status);
CREATE INDEX IF NOT EXISTS idx_maintenance_started_at ON maintenance(started_at);
CREATE INDEX IF NOT EXISTS idx_maintenance_completed_at ON maintenance(completed_at);
CREATE INDEX IF NOT EXISTS idx_maintenance_status_dates ON maintenance(status, started_at, completed_at);

-- ========================================
-- 견적 테이블 인덱스
-- ========================================
CREATE INDEX IF NOT EXISTS idx_quotes_booking_id ON quotes(booking_id);
CREATE INDEX IF NOT EXISTS idx_quotes_maintenance_id ON quotes(maintenance_id);
CREATE INDEX IF NOT EXISTS idx_quotes_quote_number ON quotes(quote_number);
CREATE INDEX IF NOT EXISTS idx_quotes_status ON quotes(status);
CREATE INDEX IF NOT EXISTS idx_quotes_valid_until ON quotes(valid_until);
CREATE INDEX IF NOT EXISTS idx_quotes_approved_by ON quotes(approved_by);
CREATE INDEX IF NOT EXISTS idx_quotes_status_valid ON quotes(status, valid_until);

-- ========================================
-- 결제 테이블 인덱스
-- ========================================
CREATE INDEX IF NOT EXISTS idx_payments_quote_id ON payments(quote_id);
CREATE INDEX IF NOT EXISTS idx_payments_payment_number ON payments(payment_number);
CREATE INDEX IF NOT EXISTS idx_payments_status ON payments(status);
CREATE INDEX IF NOT EXISTS idx_payments_method ON payments(payment_method);
CREATE INDEX IF NOT EXISTS idx_payments_transaction_id ON payments(transaction_id);
CREATE INDEX IF NOT EXISTS idx_payments_paid_at ON payments(paid_at);
CREATE INDEX IF NOT EXISTS idx_payments_status_date ON payments(status, paid_at);

-- ========================================
-- 알림 테이블 인덱스
-- ========================================
CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_type ON notifications(type);
CREATE INDEX IF NOT EXISTS idx_notifications_channel ON notifications(channel);
CREATE INDEX IF NOT EXISTS idx_notifications_status ON notifications(status);
CREATE INDEX IF NOT EXISTS idx_notifications_sent_at ON notifications(sent_at);
CREATE INDEX IF NOT EXISTS idx_notifications_user_status ON notifications(user_id, status);
CREATE INDEX IF NOT EXISTS idx_notifications_user_unread ON notifications(user_id, status) WHERE status IN ('SENT', 'DELIVERED');

-- ========================================
-- 리뷰 테이블 인덱스
-- ========================================
CREATE INDEX IF NOT EXISTS idx_reviews_user_id ON reviews(user_id);
CREATE INDEX IF NOT EXISTS idx_reviews_shop_id ON reviews(shop_id);
CREATE INDEX IF NOT EXISTS idx_reviews_booking_id ON reviews(booking_id);
CREATE INDEX IF NOT EXISTS idx_reviews_rating ON reviews(rating);
CREATE INDEX IF NOT EXISTS idx_reviews_status ON reviews(status);
CREATE INDEX IF NOT EXISTS idx_reviews_shop_rating ON reviews(shop_id, rating, status);
CREATE INDEX IF NOT EXISTS idx_reviews_created_at ON reviews(created_at);

-- ========================================
-- 시스템 설정 테이블 인덱스
-- ========================================
CREATE INDEX IF NOT EXISTS idx_system_settings_key ON system_settings(setting_key);
CREATE INDEX IF NOT EXISTS idx_system_settings_public ON system_settings(is_public);

-- ========================================
-- 감사 로그 테이블 인덱스
-- ========================================
CREATE INDEX IF NOT EXISTS idx_audit_logs_user_id ON audit_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_entity ON audit_logs(entity_type, entity_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_action ON audit_logs(action);
CREATE INDEX IF NOT EXISTS idx_audit_logs_created_at ON audit_logs(created_at);
CREATE INDEX IF NOT EXISTS idx_audit_logs_user_action ON audit_logs(user_id, action, created_at);

-- ========================================
-- 복합 인덱스 (성능 최적화용)
-- ========================================

-- 예약 검색 최적화
CREATE INDEX IF NOT EXISTS idx_bookings_search ON bookings(shop_id, appointment_datetime, status) WHERE deleted_at IS NULL;

-- 정비소 검색 최적화 (위치 기반)
CREATE INDEX IF NOT EXISTS idx_shops_location_rating ON shops(latitude, longitude, rating, status) WHERE deleted_at IS NULL;

-- 사용자별 예약 이력 조회 최적화
CREATE INDEX IF NOT EXISTS idx_bookings_user_history ON bookings(user_id, created_at DESC, status) WHERE deleted_at IS NULL;

-- 정비사별 작업 이력 최적화
CREATE INDEX IF NOT EXISTS idx_maintenance_technician_history ON maintenance(technician_id, started_at DESC, status);

-- 결제 상태별 조회 최적화
CREATE INDEX IF NOT EXISTS idx_payments_status_amount ON payments(status, paid_at, amount);

-- 알림 발송 최적화
CREATE INDEX IF NOT EXISTS idx_notifications_pending ON notifications(status, channel, created_at) WHERE status = 'PENDING';

-- ========================================
-- 전문 검색을 위한 인덱스 (PostgreSQL 전용)
-- ========================================

-- 정비소 이름 전문 검색 (PostgreSQL에서만 동작)
-- CREATE INDEX IF NOT EXISTS idx_shops_name_fulltext ON shops USING gin(to_tsvector('korean', name)) WHERE status = 'ACTIVE';

-- 리뷰 내용 전문 검색 (PostgreSQL에서만 동작)
-- CREATE INDEX IF NOT EXISTS idx_reviews_content_fulltext ON reviews USING gin(to_tsvector('korean', coalesce(title, '') || ' ' || coalesce(content, ''))) WHERE status = 'ACTIVE';
