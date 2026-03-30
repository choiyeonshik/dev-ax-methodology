-- =====================================================
-- 예약 시스템 스키마
-- =====================================================

-- 예약 기본 정보 테이블
CREATE TABLE reservations (
    id BIGSERIAL PRIMARY KEY,
    reservation_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    vehicle_id BIGINT NOT NULL REFERENCES vehicles(id) ON DELETE CASCADE,
    service_center_id BIGINT NOT NULL REFERENCES service_centers(id) ON DELETE CASCADE,
    service_type_id BIGINT NOT NULL REFERENCES service_types(id) ON DELETE CASCADE,
    mechanic_id BIGINT REFERENCES mechanics(id),
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'CONFIRMED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED', 'NO_SHOW')),
    priority VARCHAR(20) DEFAULT 'NORMAL' CHECK (priority IN ('LOW', 'NORMAL', 'HIGH', 'URGENT')),
    scheduled_date TIMESTAMP NOT NULL,
    estimated_duration INTEGER, -- 예상 소요시간(분)
    actual_start_time TIMESTAMP,
    actual_end_time TIMESTAMP,
    customer_notes TEXT,
    mechanic_notes TEXT,
    internal_notes TEXT, -- 정비소 내부 메모
    is_urgent BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 예약 상태 변경 이력 테이블
CREATE TABLE reservation_status_history (
    id BIGSERIAL PRIMARY KEY,
    reservation_id BIGINT NOT NULL REFERENCES reservations(id) ON DELETE CASCADE,
    history_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    from_status VARCHAR(20),
    to_status VARCHAR(20) NOT NULL,
    changed_by BIGINT REFERENCES users(id),
    reason TEXT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 예약 변경/취소 이력 테이블
CREATE TABLE reservation_changes (
    id BIGSERIAL PRIMARY KEY,
    reservation_id BIGINT NOT NULL REFERENCES reservations(id) ON DELETE CASCADE,
    change_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    change_type VARCHAR(20) NOT NULL CHECK (change_type IN ('RESCHEDULE', 'CANCEL', 'MODIFY_SERVICE', 'CHANGE_MECHANIC')),
    old_value TEXT,
    new_value TEXT,
    changed_by BIGINT REFERENCES users(id),
    reason TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 예약 대기열 테이블
CREATE TABLE reservation_waitlist (
    id BIGSERIAL PRIMARY KEY,
    waitlist_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    vehicle_id BIGINT NOT NULL REFERENCES vehicles(id) ON DELETE CASCADE,
    service_center_id BIGINT NOT NULL REFERENCES service_centers(id) ON DELETE CASCADE,
    service_type_id BIGINT NOT NULL REFERENCES service_types(id) ON DELETE CASCADE,
    preferred_date_start DATE NOT NULL,
    preferred_date_end DATE NOT NULL,
    preferred_time_start TIME,
    preferred_time_end TIME,
    customer_notes TEXT,
    is_notified BOOLEAN DEFAULT false,
    notified_at TIMESTAMP,
    status VARCHAR(20) DEFAULT 'WAITING' CHECK (status IN ('WAITING', 'NOTIFIED', 'CONVERTED', 'CANCELLED')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 예약 알림 테이블
CREATE TABLE reservation_notifications (
    id BIGSERIAL PRIMARY KEY,
    reservation_id BIGINT NOT NULL REFERENCES reservations(id) ON DELETE CASCADE,
    notification_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    notification_type VARCHAR(50) NOT NULL CHECK (notification_type IN ('CONFIRMATION', 'REMINDER_24H', 'REMINDER_2H', 'STARTED', 'COMPLETED', 'CANCELLED')),
    channel VARCHAR(20) NOT NULL CHECK (channel IN ('SMS', 'EMAIL', 'PUSH', 'IN_APP')),
    recipient_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(255),
    message TEXT NOT NULL,
    is_sent BOOLEAN DEFAULT false,
    sent_at TIMESTAMP,
    is_read BOOLEAN DEFAULT false,
    read_at TIMESTAMP,
    error_message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 예약 첨부 파일 테이블
CREATE TABLE reservation_attachments (
    id BIGSERIAL PRIMARY KEY,
    reservation_id BIGINT NOT NULL REFERENCES reservations(id) ON DELETE CASCADE,
    attachment_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    file_name VARCHAR(255) NOT NULL,
    file_url VARCHAR(500) NOT NULL,
    file_type VARCHAR(50) CHECK (file_type IN ('IMAGE', 'DOCUMENT', 'VIDEO', 'AUDIO')),
    file_size INTEGER, -- 바이트 단위
    description TEXT,
    uploaded_by BIGINT REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 예약 평가 테이블 (정비 완료 후)
CREATE TABLE reservation_evaluations (
    id BIGSERIAL PRIMARY KEY,
    reservation_id BIGINT NOT NULL REFERENCES reservations(id) ON DELETE CASCADE,
    evaluation_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    overall_satisfaction INTEGER CHECK (overall_satisfaction >= 1 AND overall_satisfaction <= 5),
    service_quality INTEGER CHECK (service_quality >= 1 AND service_quality <= 5),
    communication INTEGER CHECK (communication >= 1 AND communication <= 5),
    timeliness INTEGER CHECK (timeliness >= 1 AND timeliness <= 5),
    price_satisfaction INTEGER CHECK (price_satisfaction >= 1 AND price_satisfaction <= 5),
    comments TEXT,
    is_anonymous BOOLEAN DEFAULT false,
    evaluated_by BIGINT REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(reservation_id)
);

-- 예약 통계 뷰
CREATE VIEW reservation_statistics AS
SELECT 
    sc.id as service_center_id,
    sc.name as service_center_name,
    COUNT(r.id) as total_reservations,
    COUNT(CASE WHEN r.status = 'COMPLETED' THEN 1 END) as completed_reservations,
    COUNT(CASE WHEN r.status = 'CANCELLED' THEN 1 END) as cancelled_reservations,
    COUNT(CASE WHEN r.status = 'NO_SHOW' THEN 1 END) as no_show_reservations,
    AVG(CASE WHEN r.status = 'COMPLETED' THEN EXTRACT(EPOCH FROM (r.actual_end_time - r.actual_start_time))/3600 END) as avg_completion_hours,
    AVG(CASE WHEN r.status = 'COMPLETED' THEN re.overall_satisfaction END) as avg_satisfaction,
    COUNT(CASE WHEN r.is_urgent = true THEN 1 END) as urgent_reservations
FROM service_centers sc
LEFT JOIN reservations r ON sc.id = r.service_center_id
LEFT JOIN reservation_evaluations re ON r.id = re.reservation_id
GROUP BY sc.id, sc.name;

-- 인덱스 생성
CREATE INDEX idx_reservations_user_id ON reservations(user_id);
CREATE INDEX idx_reservations_vehicle_id ON reservations(vehicle_id);
CREATE INDEX idx_reservations_service_center_id ON reservations(service_center_id);
CREATE INDEX idx_reservations_service_type_id ON reservations(service_type_id);
CREATE INDEX idx_reservations_mechanic_id ON reservations(mechanic_id);
CREATE INDEX idx_reservations_status ON reservations(status);
CREATE INDEX idx_reservations_scheduled_date ON reservations(scheduled_date);
CREATE INDEX idx_reservations_is_urgent ON reservations(is_urgent);
CREATE INDEX idx_reservations_created_at ON reservations(created_at);
CREATE INDEX idx_reservation_status_history_reservation_id ON reservation_status_history(reservation_id);
CREATE INDEX idx_reservation_status_history_to_status ON reservation_status_history(to_status);
CREATE INDEX idx_reservation_status_history_created_at ON reservation_status_history(created_at);
CREATE INDEX idx_reservation_changes_reservation_id ON reservation_changes(reservation_id);
CREATE INDEX idx_reservation_changes_change_type ON reservation_changes(change_type);
CREATE INDEX idx_reservation_waitlist_user_id ON reservation_waitlist(user_id);
CREATE INDEX idx_reservation_waitlist_service_center_id ON reservation_waitlist(service_center_id);
CREATE INDEX idx_reservation_waitlist_status ON reservation_waitlist(status);
CREATE INDEX idx_reservation_waitlist_preferred_date_start ON reservation_waitlist(preferred_date_start);
CREATE INDEX idx_reservation_notifications_reservation_id ON reservation_notifications(reservation_id);
CREATE INDEX idx_reservation_notifications_recipient_id ON reservation_notifications(recipient_id);
CREATE INDEX idx_reservation_notifications_notification_type ON reservation_notifications(notification_type);
CREATE INDEX idx_reservation_notifications_is_sent ON reservation_notifications(is_sent);
CREATE INDEX idx_reservation_attachments_reservation_id ON reservation_attachments(reservation_id);
CREATE INDEX idx_reservation_attachments_file_type ON reservation_attachments(file_type);
CREATE INDEX idx_reservation_evaluations_reservation_id ON reservation_evaluations(reservation_id);
CREATE INDEX idx_reservation_evaluations_overall_satisfaction ON reservation_evaluations(overall_satisfaction);

-- 복합 인덱스
CREATE INDEX idx_reservations_center_date ON reservations(service_center_id, scheduled_date);
CREATE INDEX idx_reservations_user_date ON reservations(user_id, scheduled_date);
CREATE INDEX idx_reservations_status_date ON reservations(status, scheduled_date);

-- 트리거 생성
CREATE TRIGGER update_reservations_updated_at BEFORE UPDATE ON reservations FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_reservation_waitlist_updated_at BEFORE UPDATE ON reservation_waitlist FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_reservation_evaluations_updated_at BEFORE UPDATE ON reservation_evaluations FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 예약 상태 변경 시 자동으로 이력 기록하는 트리거 함수
CREATE OR REPLACE FUNCTION log_reservation_status_change()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.status IS DISTINCT FROM NEW.status THEN
        INSERT INTO reservation_status_history (
            reservation_id, 
            from_status, 
            to_status, 
            changed_by, 
            created_at
        ) VALUES (
            NEW.id, 
            OLD.status, 
            NEW.status, 
            NEW.user_id, -- 실제로는 현재 로그인한 사용자 ID를 사용해야 함
            CURRENT_TIMESTAMP
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 예약 상태 변경 트리거
CREATE TRIGGER trigger_reservation_status_change
    AFTER UPDATE ON reservations
    FOR EACH ROW
    EXECUTE FUNCTION log_reservation_status_change();
