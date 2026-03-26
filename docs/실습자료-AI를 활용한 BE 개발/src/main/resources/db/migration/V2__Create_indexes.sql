-- ========================================
-- V2__Create_indexes.sql
-- 인덱스 및 성능 최적화 스크립트
-- ========================================

-- ========================================
-- 사용자 테이블 인덱스
-- ========================================
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_phone ON users(phone);
CREATE INDEX idx_users_status ON users(status);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_created_at ON users(created_at);

-- ========================================
-- 차량 테이블 인덱스
-- ========================================
CREATE INDEX idx_vehicles_user_id ON vehicles(user_id);
CREATE INDEX idx_vehicles_license_number ON vehicles(license_number);
CREATE INDEX idx_vehicles_manufacturer_model ON vehicles(manufacturer, model);
CREATE INDEX idx_vehicles_year ON vehicles(year);
CREATE INDEX idx_vehicles_engine_type ON vehicles(engine_type);

-- ========================================
-- 정비소 테이블 인덱스
-- ========================================
CREATE INDEX idx_shops_business_number ON shops(business_number);
CREATE INDEX idx_shops_location ON shops(latitude, longitude);
CREATE INDEX idx_shops_status ON shops(status);
CREATE INDEX idx_shops_rating ON shops(rating DESC);
CREATE INDEX idx_shops_name ON shops(name);

-- ========================================
-- 예약 테이블 인덱스
-- ========================================
CREATE INDEX idx_bookings_user_id ON bookings(user_id);
CREATE INDEX idx_bookings_vehicle_id ON bookings(vehicle_id);
CREATE INDEX idx_bookings_shop_id ON bookings(shop_id);
CREATE INDEX idx_bookings_technician_id ON bookings(technician_id);
CREATE INDEX idx_bookings_appointment ON bookings(appointment_datetime);
CREATE INDEX idx_bookings_status ON bookings(status);
CREATE INDEX idx_bookings_priority ON bookings(priority);
CREATE INDEX idx_bookings_date_status ON bookings(appointment_datetime, status);
CREATE INDEX idx_bookings_shop_date ON bookings(shop_id, appointment_datetime);
CREATE INDEX idx_bookings_user_status ON bookings(user_id, status);

-- ========================================
-- 정비 작업 테이블 인덱스
-- ========================================
CREATE INDEX idx_maintenance_booking_id ON maintenance(booking_id);
CREATE INDEX idx_maintenance_technician_id ON maintenance(technician_id);
CREATE INDEX idx_maintenance_status ON maintenance(status);
CREATE INDEX idx_maintenance_started_at ON maintenance(started_at);
CREATE INDEX idx_maintenance_completed_at ON maintenance(completed_at);
CREATE INDEX idx_maintenance_status_dates ON maintenance(status, started_at, completed_at);

-- ========================================
-- 결제 테이블 인덱스
-- ========================================
CREATE INDEX idx_payments_quote_id ON payments(quote_id);
CREATE INDEX idx_payments_payment_number ON payments(payment_number);
CREATE INDEX idx_payments_status ON payments(status);
CREATE INDEX idx_payments_method ON payments(payment_method);
CREATE INDEX idx_payments_transaction_id ON payments(transaction_id);
CREATE INDEX idx_payments_paid_at ON payments(paid_at);
CREATE INDEX idx_payments_status_date ON payments(status, paid_at);

-- ========================================
-- 알림 테이블 인덱스
-- ========================================
CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_type ON notifications(type);
CREATE INDEX idx_notifications_channel ON notifications(channel);
CREATE INDEX idx_notifications_status ON notifications(status);
CREATE INDEX idx_notifications_sent_at ON notifications(sent_at);
CREATE INDEX idx_notifications_user_status ON notifications(user_id, status);

-- ========================================
-- 복합 인덱스 (성능 최적화용)
-- ========================================

-- 예약 검색 최적화
CREATE INDEX idx_bookings_search ON bookings(shop_id, appointment_datetime, status);

-- 정비소 검색 최적화 (위치 기반)
CREATE INDEX idx_shops_location_rating ON shops(latitude, longitude, rating, status);

-- 사용자별 예약 이력 조회 최적화
CREATE INDEX idx_bookings_user_history ON bookings(user_id, created_at DESC, status);

-- 정비사별 작업 이력 최적화
CREATE INDEX idx_maintenance_technician_history ON maintenance(technician_id, started_at DESC, status);

-- 결제 상태별 조회 최적화
CREATE INDEX idx_payments_status_amount ON payments(status, paid_at, amount);

-- 알림 발송 최적화
CREATE INDEX idx_notifications_pending ON notifications(status, channel, created_at);