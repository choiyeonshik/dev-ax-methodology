-- ========================================
-- V3__Insert_test_data.sql
-- 개발 및 테스트용 샘플 데이터 삽입
-- ========================================

-- 시스템 설정 데이터
INSERT INTO system_settings (setting_key, setting_value, description, data_type, is_public) VALUES
('app.name', 'Car Center DevLab', '애플리케이션 이름', 'STRING', true),
('app.version', '1.0.0', '애플리케이션 버전', 'STRING', true),
('maintenance.default_warranty_days', '30', '기본 보증 기간 (일)', 'INTEGER', false),
('notification.email_enabled', 'true', '이메일 알림 활성화', 'BOOLEAN', false),
('notification.sms_enabled', 'true', 'SMS 알림 활성화', 'BOOLEAN', false),
('payment.default_currency', 'KRW', '기본 통화', 'STRING', false),
('booking.max_advance_days', '30', '최대 예약 가능 일수', 'INTEGER', false),
('shop.default_rating', '0.0', '정비소 기본 평점', 'DECIMAL', false);

-- 테스트 사용자 데이터
INSERT INTO users (username, password, name, email, phone, role, status) VALUES
('admin', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewfBPdkzjvl1/3nm', '시스템 관리자', 'admin@carcenter.com', '010-0000-0000', 'SYSTEM_ADMIN', 'ACTIVE'),
('shop_admin1', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewfBPdkzjvl1/3nm', '정비소 관리자1', 'shop1@carcenter.com', '010-1111-1111', 'SHOP_ADMIN', 'ACTIVE'),
('shop_admin2', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewfBPdkzjvl1/3nm', '정비소 관리자2', 'shop2@carcenter.com', '010-2222-2222', 'SHOP_ADMIN', 'ACTIVE'),
('user1', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewfBPdkzjvl1/3nm', '김철수', 'user1@example.com', '010-1234-5678', 'USER', 'ACTIVE'),
('user2', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewfBPdkzjvl1/3nm', '이영희', 'user2@example.com', '010-2345-6789', 'USER', 'ACTIVE'),
('user3', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewfBPdkzjvl1/3nm', '박민수', 'user3@example.com', '010-3456-7890', 'USER', 'ACTIVE'),
('user4', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewfBPdkzjvl1/3nm', '최지은', 'user4@example.com', '010-4567-8901', 'USER', 'ACTIVE'),
('user5', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewfBPdkzjvl1/3nm', '정대호', 'user5@example.com', '010-5678-9012', 'USER', 'ACTIVE');

-- 테스트 차량 데이터
INSERT INTO vehicles (user_id, license_number, manufacturer, model, year, engine_type, mileage, color, vin) VALUES
(4, '12가3456', '현대', '소나타', 2020, 'GASOLINE', 45000, '흰색', 'KMHL14JA5LA123456'),
(4, '34나5678', '기아', 'K5', 2019, 'GASOLINE', 52000, '검은색', 'KNAG141ABKA234567'),
(5, '56다7890', '현대', '아반떼', 2021, 'GASOLINE', 28000, '은색', 'KMHD14LA6MA345678'),
(6, '78라9012', '기아', '스포티지', 2022, 'GASOLINE', 15000, '빨간색', 'KNDJ23AU5N7456789'),
(6, '90마3456', '현대', '투싼', 2020, 'DIESEL', 38000, '파란색', 'KMHJ81TA5LU567890'),
(7, '12바5678', '기아', '쏘렌토', 2021, 'DIESEL', 22000, '회색', 'KNDJC735XM7678901'),
(8, '34사7890', '현대', '그랜저', 2023, 'HYBRID', 8000, '검은색', 'KMHG35LA1PA789012'),
(8, '56아9012', '기아', 'EV6', 2022, 'ELECTRIC', 12000, '흰색', 'KNDCM3LD4N5890123');

-- 테스트 정비소 데이터
INSERT INTO shops (name, business_number, address, phone, email, latitude, longitude, operating_hours, description, rating, total_reviews, status) VALUES
('신속정비센터', '123-45-67890', '서울시 강남구 테헤란로 123', '02-1234-5678', 'info@sinsok.com', 37.5665, 126.9780, 
 '{"monday": {"open": "09:00", "close": "18:00"}, "tuesday": {"open": "09:00", "close": "18:00"}, "wednesday": {"open": "09:00", "close": "18:00"}, "thursday": {"open": "09:00", "close": "18:00"}, "friday": {"open": "09:00", "close": "18:00"}, "saturday": {"open": "09:00", "close": "15:00"}, "sunday": {"closed": true}}',
 '빠르고 정확한 자동차 정비 서비스를 제공합니다.', 4.5, 128, 'ACTIVE'),
('프리미엄카센터', '234-56-78901', '서울시 서초구 반포대로 456', '02-2345-6789', 'contact@premium.com', 37.5047, 127.0026,
 '{"monday": {"open": "08:30", "close": "19:00"}, "tuesday": {"open": "08:30", "close": "19:00"}, "wednesday": {"open": "08:30", "close": "19:00"}, "thursday": {"open": "08:30", "close": "19:00"}, "friday": {"open": "08:30", "close": "19:00"}, "saturday": {"open": "09:00", "close": "17:00"}, "sunday": {"open": "10:00", "close": "16:00"}}',
 '고급 수입차 전문 정비소입니다.', 4.8, 95, 'ACTIVE'),
('동네정비소', '345-67-89012', '서울시 마포구 홍대입구로 789', '02-3456-7890', 'hello@dongne.com', 37.5563, 126.9236,
 '{"monday": {"open": "09:00", "close": "18:00"}, "tuesday": {"open": "09:00", "close": "18:00"}, "wednesday": {"open": "09:00", "close": "18:00"}, "thursday": {"open": "09:00", "close": "18:00"}, "friday": {"open": "09:00", "close": "18:00"}, "saturday": {"open": "09:00", "close": "14:00"}, "sunday": {"closed": true}}',
 '친절하고 합리적인 가격의 정비소입니다.', 4.2, 67, 'ACTIVE'),
('24시간카센터', '456-78-90123', '서울시 용산구 이태원로 321', '02-4567-8901', 'support@24hour.com', 37.5344, 126.9947,
 '{"monday": {"open": "00:00", "close": "23:59"}, "tuesday": {"open": "00:00", "close": "23:59"}, "wednesday": {"open": "00:00", "close": "23:59"}, "thursday": {"open": "00:00", "close": "23:59"}, "friday": {"open": "00:00", "close": "23:59"}, "saturday": {"open": "00:00", "close": "23:59"}, "sunday": {"open": "00:00", "close": "23:59"}}',
 '24시간 응급 정비 서비스를 제공합니다.', 4.0, 203, 'ACTIVE'),
('에코카센터', '567-89-01234', '서울시 송파구 올림픽로 654', '02-5678-9012', 'info@eco.com', 37.5145, 127.1059,
 '{"monday": {"open": "09:00", "close": "18:00"}, "tuesday": {"open": "09:00", "close": "18:00"}, "wednesday": {"open": "09:00", "close": "18:00"}, "thursday": {"open": "09:00", "close": "18:00"}, "friday": {"open": "09:00", "close": "18:00"}, "saturday": {"open": "09:00", "close": "15:00"}, "sunday": {"closed": true}}',
 '친환경 차량 전문 정비소입니다.', 4.6, 84, 'ACTIVE');

-- 테스트 정비사 데이터
INSERT INTO technicians (shop_id, name, phone, email, specialties, experience_years, certification_number, status) VALUES
(1, '김정비', '010-1111-0001', 'kim@sinsok.com', '["엔진", "브레이크", "타이어"]', 8, 'TECH-001-2020', 'ACTIVE'),
(1, '이수리', '010-1111-0002', 'lee@sinsok.com', '["전기", "에어컨", "배터리"]', 5, 'TECH-002-2022', 'ACTIVE'),
(2, '박전문', '010-2222-0001', 'park@premium.com', '["수입차", "고급차", "진단"]', 12, 'TECH-003-2018', 'ACTIVE'),
(2, '최고급', '010-2222-0002', 'choi@premium.com', '["BMW", "벤츠", "아우디"]', 10, 'TECH-004-2019', 'ACTIVE'),
(3, '정친절', '010-3333-0001', 'jung@dongne.com', '["일반정비", "오일교환", "점검"]', 6, 'TECH-005-2021', 'ACTIVE'),
(4, '강응급', '010-4444-0001', 'kang@24hour.com', '["응급수리", "견인", "배터리"]', 7, 'TECH-006-2020', 'ACTIVE'),
(4, '윤야간', '010-4444-0002', 'yoon@24hour.com', '["야간정비", "응급처치", "타이어"]', 4, 'TECH-007-2023', 'ACTIVE'),
(5, '조친환', '010-5555-0001', 'cho@eco.com', '["하이브리드", "전기차", "친환경"]', 9, 'TECH-008-2019', 'ACTIVE');

-- 테스트 예약 데이터
INSERT INTO bookings (user_id, vehicle_id, shop_id, technician_id, appointment_datetime, service_types, description, estimated_duration, status, priority) VALUES
(4, 1, 1, 1, '2024-01-15 10:00:00', '["엔진오일교환", "필터교환"]', '정기점검 및 오일교환 요청', 60, 'COMPLETED', 'NORMAL'),
(4, 2, 2, 3, '2024-01-20 14:00:00', '["브레이크점검", "타이어교체"]', '브레이크에서 소음이 납니다', 90, 'COMPLETED', 'HIGH'),
(5, 3, 1, 2, '2024-01-25 09:30:00', '["에어컨점검", "배터리교체"]', '에어컨이 시원하지 않아요', 45, 'IN_PROGRESS', 'NORMAL'),
(6, 4, 3, 5, '2024-01-28 11:00:00', '["정기점검"]', '신차 첫 정기점검', 30, 'CONFIRMED', 'LOW'),
(6, 5, 4, 6, '2024-01-30 16:00:00', '["응급수리"]', '고속도로에서 갑자기 멈췄어요', 120, 'PENDING', 'URGENT'),
(7, 6, 2, 4, '2024-02-01 10:30:00', '["디젤엔진점검", "DPF청소"]', '디젤 엔진 점검 필요', 150, 'PENDING', 'NORMAL'),
(8, 7, 5, 8, '2024-02-03 13:00:00', '["하이브리드점검", "배터리진단"]', '하이브리드 시스템 점검', 90, 'PENDING', 'NORMAL'),
(8, 8, 5, 8, '2024-02-05 15:30:00', '["전기차충전포트점검", "배터리상태확인"]', '충전이 잘 안되는 것 같아요', 60, 'PENDING', 'HIGH');

-- 테스트 정비 작업 데이터
INSERT INTO maintenance (booking_id, technician_id, status, started_at, completed_at, diagnosis_notes, work_performed, parts_used, labor_hours, total_cost, warranty_period, quality_check_passed) VALUES
(1, 1, 'COMPLETED', '2024-01-15 10:00:00', '2024-01-15 11:00:00', '엔진오일 상태 양호, 필터 교체 필요', '엔진오일 교환, 오일필터 교체, 에어필터 교체', 
 '[{"name": "엔진오일", "quantity": 4, "unit": "L", "price": 8000}, {"name": "오일필터", "quantity": 1, "unit": "개", "price": 12000}, {"name": "에어필터", "quantity": 1, "unit": "개", "price": 15000}]', 
 1.0, 35000, 30, true),
(2, 3, 'COMPLETED', '2024-01-20 14:00:00', '2024-01-20 15:30:00', '브레이크 패드 마모 심함, 타이어 교체 필요', '브레이크 패드 교체, 타이어 4개 교체', 
 '[{"name": "브레이크패드", "quantity": 1, "unit": "세트", "price": 80000}, {"name": "타이어", "quantity": 4, "unit": "개", "price": 120000}]', 
 1.5, 200000, 60, true),
(3, 2, 'IN_PROGRESS', '2024-01-25 09:30:00', null, '에어컨 가스 부족, 배터리 전압 낮음', '에어컨 가스 충전 중, 배터리 교체 예정', 
 '[{"name": "에어컨가스", "quantity": 1, "unit": "통", "price": 25000}]', 
 0.5, 25000, 30, false);

-- 테스트 견적 데이터
INSERT INTO quotes (booking_id, maintenance_id, quote_number, items, subtotal, tax_amount, discount_amount, total_amount, status, valid_until, approved_at, approved_by) VALUES
(1, 1, 'Q2024010001', 
 '[{"description": "엔진오일 교환", "quantity": 1, "unitPrice": 8000, "totalPrice": 8000}, {"description": "오일필터 교체", "quantity": 1, "unitPrice": 12000, "totalPrice": 12000}, {"description": "에어필터 교체", "quantity": 1, "unitPrice": 15000, "totalPrice": 15000}]',
 35000, 3500, 0, 38500, 'APPROVED', '2024-01-20 23:59:59', '2024-01-15 09:30:00', 4),
(2, 2, 'Q2024010002',
 '[{"description": "브레이크 패드 교체", "quantity": 1, "unitPrice": 80000, "totalPrice": 80000}, {"description": "타이어 교체", "quantity": 4, "unitPrice": 30000, "totalPrice": 120000}]',
 200000, 20000, 10000, 210000, 'APPROVED', '2024-01-25 23:59:59', '2024-01-20 13:30:00', 4),
(3, 3, 'Q2024010003',
 '[{"description": "에어컨 가스 충전", "quantity": 1, "unitPrice": 25000, "totalPrice": 25000}, {"description": "배터리 교체", "quantity": 1, "unitPrice": 80000, "totalPrice": 80000}]',
 105000, 10500, 5000, 110500, 'PENDING', '2024-02-01 23:59:59', null, null);

-- 테스트 결제 데이터
INSERT INTO payments (quote_id, payment_number, amount, payment_method, payment_gateway, transaction_id, status, paid_at) VALUES
(1, 'PAY2024010001', 38500, 'CREDIT_CARD', '토스페이', 'TXN_20240115_001', 'COMPLETED', '2024-01-15 11:30:00'),
(2, 'PAY2024010002', 210000, 'BANK_TRANSFER', '카카오페이', 'TXN_20240120_002', 'COMPLETED', '2024-01-20 16:00:00');

-- 테스트 알림 데이터
INSERT INTO notifications (user_id, type, title, message, channel, status, sent_at, read_at, metadata) VALUES
(4, 'BOOKING_CONFIRMED', '예약이 확정되었습니다', '2024년 1월 15일 10:00 신속정비센터 예약이 확정되었습니다.', 'EMAIL', 'READ', '2024-01-14 18:00:00', '2024-01-14 18:30:00', '{"bookingId": 1, "shopName": "신속정비센터"}'),
(4, 'STATUS_UPDATED', '정비 작업이 완료되었습니다', '차량 정비가 완료되었습니다. 차량을 찾아가실 수 있습니다.', 'SMS', 'DELIVERED', '2024-01-15 11:00:00', null, '{"bookingId": 1, "status": "COMPLETED"}'),
(4, 'PAYMENT_COMPLETED', '결제가 완료되었습니다', '38,500원 결제가 정상적으로 완료되었습니다.', 'IN_APP', 'READ', '2024-01-15 11:30:00', '2024-01-15 12:00:00', '{"paymentId": 1, "amount": 38500}'),
(5, 'BOOKING_CONFIRMED', '예약이 확정되었습니다', '2024년 1월 25일 09:30 신속정비센터 예약이 확정되었습니다.', 'EMAIL', 'READ', '2024-01-24 17:00:00', '2024-01-24 17:15:00', '{"bookingId": 3, "shopName": "신속정비센터"}'),
(5, 'STATUS_UPDATED', '정비 작업이 시작되었습니다', '차량 정비 작업이 시작되었습니다.', 'PUSH', 'DELIVERED', '2024-01-25 09:30:00', null, '{"bookingId": 3, "status": "IN_PROGRESS"}');

-- 테스트 리뷰 데이터
INSERT INTO reviews (user_id, shop_id, booking_id, rating, title, content, photos, is_anonymous, status) VALUES
(4, 1, 1, 5, '정말 만족스러운 서비스!', '직원분들이 친절하고 작업도 꼼꼼하게 해주셨어요. 다음에도 이용하겠습니다.', '["review1_1.jpg", "review1_2.jpg"]', false, 'ACTIVE'),
(4, 2, 2, 4, '전문적인 정비소', '수입차 전문이라 그런지 정말 전문적으로 정비해주시네요. 가격은 조금 비싸지만 만족합니다.', '["review2_1.jpg"]', false, 'ACTIVE');

-- 감사 로그 샘플 데이터
INSERT INTO audit_logs (user_id, entity_type, entity_id, action, old_values, new_values, ip_address, user_agent) VALUES
(4, 'BOOKING', 1, 'CREATE', null, '{"status": "PENDING", "appointmentDateTime": "2024-01-15T10:00:00"}', '192.168.1.100', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'),
(4, 'BOOKING', 1, 'UPDATE', '{"status": "PENDING"}', '{"status": "CONFIRMED"}', '192.168.1.100', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'),
(1, 'MAINTENANCE', 1, 'UPDATE', '{"status": "RECEIVED"}', '{"status": "COMPLETED"}', '192.168.1.50', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'),
(4, 'PAYMENT', 1, 'CREATE', null, '{"amount": 38500, "status": "PENDING"}', '192.168.1.100', 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15');
