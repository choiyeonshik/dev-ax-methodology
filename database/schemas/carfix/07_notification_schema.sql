-- =====================================================
-- 알림 시스템 스키마
-- =====================================================

-- 알림 기본 정보 테이블
CREATE TABLE notifications (
    id BIGSERIAL PRIMARY KEY,
    notification_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    type VARCHAR(50) NOT NULL CHECK (type IN (
        'RESERVATION_CONFIRMED', 'RESERVATION_REMINDER', 'RESERVATION_CANCELLED', 'RESERVATION_STARTED', 'RESERVATION_COMPLETED',
        'QUOTE_RECEIVED', 'QUOTE_APPROVED', 'QUOTE_REJECTED', 'QUOTE_EXPIRED',
        'PAYMENT_COMPLETED', 'PAYMENT_FAILED', 'PAYMENT_REFUNDED',
        'REVIEW_REQUESTED', 'REVIEW_RECEIVED', 'REVIEW_REPLY',
        'MAINTENANCE_REMINDER', 'INSURANCE_EXPIRY', 'REGISTRATION_EXPIRY',
        'SYSTEM_ANNOUNCEMENT', 'PROMOTION', 'SECURITY_ALERT'
    )),
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    priority VARCHAR(20) DEFAULT 'NORMAL' CHECK (priority IN ('LOW', 'NORMAL', 'HIGH', 'URGENT')),
    related_entity_type VARCHAR(50), -- 연관 엔티티 타입 (예: 'RESERVATION', 'QUOTE', 'PAYMENT')
    related_entity_id BIGINT, -- 연관 엔티티 ID
    action_url VARCHAR(500), -- 알림 클릭 시 이동할 URL
    action_text VARCHAR(100), -- 액션 버튼 텍스트
    is_read BOOLEAN DEFAULT false,
    read_at TIMESTAMP,
    is_sent BOOLEAN DEFAULT false,
    sent_at TIMESTAMP,
    scheduled_at TIMESTAMP, -- 예약 발송 시간
    expires_at TIMESTAMP, -- 알림 만료 시간
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 알림 템플릿 테이블
CREATE TABLE notification_templates (
    id BIGSERIAL PRIMARY KEY,
    template_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    template_code VARCHAR(100) UNIQUE NOT NULL, -- 템플릿 코드 (예: 'RESERVATION_CONFIRMATION')
    name VARCHAR(100) NOT NULL,
    description TEXT,
    type VARCHAR(50) NOT NULL CHECK (type IN ('SMS', 'EMAIL', 'PUSH', 'IN_APP')),
    title_template TEXT, -- 제목 템플릿 (변수 포함 가능)
    message_template TEXT NOT NULL, -- 메시지 템플릿 (변수 포함 가능)
    variables JSONB, -- 템플릿에서 사용할 변수 정의
    is_active BOOLEAN DEFAULT true,
    created_by BIGINT REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 알림 발송 이력 테이블
CREATE TABLE notification_delivery_logs (
    id BIGSERIAL PRIMARY KEY,
    notification_id BIGINT NOT NULL REFERENCES notifications(id) ON DELETE CASCADE,
    log_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    channel VARCHAR(20) NOT NULL CHECK (channel IN ('SMS', 'EMAIL', 'PUSH', 'IN_APP')),
    recipient VARCHAR(255) NOT NULL, -- 수신자 정보 (전화번호, 이메일, 디바이스 토큰 등)
    status VARCHAR(20) NOT NULL CHECK (status IN ('PENDING', 'SENT', 'DELIVERED', 'FAILED', 'BOUNCED')),
    sent_at TIMESTAMP,
    delivered_at TIMESTAMP,
    error_message TEXT,
    retry_count INTEGER DEFAULT 0,
    max_retries INTEGER DEFAULT 3,
    next_retry_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 알림 그룹 테이블 (대량 발송용)
CREATE TABLE notification_groups (
    id BIGSERIAL PRIMARY KEY,
    group_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    template_id BIGINT REFERENCES notification_templates(id),
    target_criteria JSONB, -- 대상 선정 기준 (예: 특정 지역, 특정 서비스 이용자 등)
    scheduled_at TIMESTAMP,
    status VARCHAR(20) DEFAULT 'DRAFT' CHECK (status IN ('DRAFT', 'SCHEDULED', 'SENDING', 'COMPLETED', 'CANCELLED')),
    total_recipients INTEGER DEFAULT 0,
    sent_count INTEGER DEFAULT 0,
    failed_count INTEGER DEFAULT 0,
    created_by BIGINT REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 알림 그룹 수신자 테이블
CREATE TABLE notification_group_recipients (
    id BIGSERIAL PRIMARY KEY,
    group_id BIGINT NOT NULL REFERENCES notification_groups(id) ON DELETE CASCADE,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    notification_id BIGINT REFERENCES notifications(id) ON DELETE SET NULL,
    status VARCHAR(20) DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'SENT', 'FAILED', 'SKIPPED')),
    sent_at TIMESTAMP,
    error_message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(group_id, user_id)
);

-- 푸시 알림 디바이스 토큰 테이블
CREATE TABLE push_notification_tokens (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    device_token VARCHAR(500) NOT NULL,
    device_type VARCHAR(20) CHECK (device_type IN ('IOS', 'ANDROID', 'WEB')),
    app_version VARCHAR(20),
    os_version VARCHAR(20),
    device_model VARCHAR(100),
    is_active BOOLEAN DEFAULT true,
    last_used_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, device_token)
);

-- 알림 설정 테이블 (사용자별 세부 설정)
CREATE TABLE notification_preferences (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    preference_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    notification_type VARCHAR(50) NOT NULL,
    sms_enabled BOOLEAN DEFAULT true,
    email_enabled BOOLEAN DEFAULT true,
    push_enabled BOOLEAN DEFAULT true,
    in_app_enabled BOOLEAN DEFAULT true,
    quiet_hours_start TIME DEFAULT '22:00:00',
    quiet_hours_end TIME DEFAULT '08:00:00',
    timezone VARCHAR(50) DEFAULT 'Asia/Seoul',
    language VARCHAR(10) DEFAULT 'ko',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, notification_type)
);

-- 알림 통계 테이블
CREATE TABLE notification_statistics (
    id BIGSERIAL PRIMARY KEY,
    stats_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    date DATE NOT NULL,
    notification_type VARCHAR(50) NOT NULL,
    channel VARCHAR(20) NOT NULL,
    total_sent INTEGER DEFAULT 0,
    total_delivered INTEGER DEFAULT 0,
    total_failed INTEGER DEFAULT 0,
    total_bounced INTEGER DEFAULT 0,
    delivery_rate NUMERIC(5,2) DEFAULT 0.00, -- 배달률 (%)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(date, notification_type, channel)
);

-- 인덱스 생성
CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_type ON notifications(type);
CREATE INDEX idx_notifications_is_read ON notifications(is_read);
CREATE INDEX idx_notifications_is_sent ON notifications(is_sent);
CREATE INDEX idx_notifications_scheduled_at ON notifications(scheduled_at);
CREATE INDEX idx_notifications_expires_at ON notifications(expires_at);
CREATE INDEX idx_notifications_created_at ON notifications(created_at);
CREATE INDEX idx_notification_templates_template_code ON notification_templates(template_code);
CREATE INDEX idx_notification_templates_type ON notification_templates(type);
CREATE INDEX idx_notification_templates_is_active ON notification_templates(is_active);
CREATE INDEX idx_notification_delivery_logs_notification_id ON notification_delivery_logs(notification_id);
CREATE INDEX idx_notification_delivery_logs_channel ON notification_delivery_logs(channel);
CREATE INDEX idx_notification_delivery_logs_status ON notification_delivery_logs(status);
CREATE INDEX idx_notification_delivery_logs_sent_at ON notification_delivery_logs(sent_at);
CREATE INDEX idx_notification_groups_template_id ON notification_groups(template_id);
CREATE INDEX idx_notification_groups_status ON notification_groups(status);
CREATE INDEX idx_notification_groups_scheduled_at ON notification_groups(scheduled_at);
CREATE INDEX idx_notification_group_recipients_group_id ON notification_group_recipients(group_id);
CREATE INDEX idx_notification_group_recipients_user_id ON notification_group_recipients(user_id);
CREATE INDEX idx_notification_group_recipients_status ON notification_group_recipients(status);
CREATE INDEX idx_push_notification_tokens_user_id ON push_notification_tokens(user_id);
CREATE INDEX idx_push_notification_tokens_device_token ON push_notification_tokens(device_token);
CREATE INDEX idx_push_notification_tokens_device_type ON push_notification_tokens(device_type);
CREATE INDEX idx_push_notification_tokens_is_active ON push_notification_tokens(is_active);
CREATE INDEX idx_notification_preferences_user_id ON notification_preferences(user_id);
CREATE INDEX idx_notification_preferences_notification_type ON notification_preferences(notification_type);
CREATE INDEX idx_notification_statistics_date ON notification_statistics(date);
CREATE INDEX idx_notification_statistics_type_channel ON notification_statistics(notification_type, channel);

-- 복합 인덱스
CREATE INDEX idx_notifications_user_read ON notifications(user_id, is_read);
CREATE INDEX idx_notifications_user_sent ON notifications(user_id, is_sent);
CREATE INDEX idx_notifications_type_created ON notifications(type, created_at);
CREATE INDEX idx_notification_delivery_logs_notification_status ON notification_delivery_logs(notification_id, status);

-- 뷰 생성: 알림 요약 정보
CREATE VIEW notification_summary AS
SELECT 
    n.id,
    n.notification_uuid,
    n.user_id,
    n.type,
    n.title,
    n.message,
    n.priority,
    n.related_entity_type,
    n.related_entity_id,
    n.action_url,
    n.is_read,
    n.read_at,
    n.is_sent,
    n.sent_at,
    n.scheduled_at,
    n.expires_at,
    n.created_at,
    n.updated_at,
    u.name as user_name,
    u.email as user_email,
    u.phone as user_phone,
    COUNT(ndl.id) as delivery_attempts,
    COUNT(CASE WHEN ndl.status = 'DELIVERED' THEN 1 END) as successful_deliveries,
    COUNT(CASE WHEN ndl.status = 'FAILED' THEN 1 END) as failed_deliveries
FROM notifications n
JOIN users u ON n.user_id = u.id
LEFT JOIN notification_delivery_logs ndl ON n.id = ndl.notification_id
GROUP BY n.id, u.name, u.email, u.phone;

-- 뷰 생성: 알림 통계 요약
CREATE VIEW notification_stats_summary AS
SELECT 
    ns.date,
    ns.notification_type,
    ns.channel,
    ns.total_sent,
    ns.total_delivered,
    ns.total_failed,
    ns.total_bounced,
    ns.delivery_rate,
    CASE 
        WHEN ns.total_sent > 0 THEN 
            ROUND((ns.total_delivered::NUMERIC / ns.total_sent::NUMERIC) * 100, 2)
        ELSE 0 
    END as calculated_delivery_rate,
    CASE 
        WHEN ns.total_sent > 0 THEN 
            ROUND((ns.total_failed::NUMERIC / ns.total_sent::NUMERIC) * 100, 2)
        ELSE 0 
    END as failure_rate
FROM notification_statistics ns
ORDER BY ns.date DESC, ns.notification_type, ns.channel;

-- 트리거 생성
CREATE TRIGGER update_notifications_updated_at BEFORE UPDATE ON notifications FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_notification_templates_updated_at BEFORE UPDATE ON notification_templates FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_notification_groups_updated_at BEFORE UPDATE ON notification_groups FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_push_notification_tokens_updated_at BEFORE UPDATE ON push_notification_tokens FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_notification_preferences_updated_at BEFORE UPDATE ON notification_preferences FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_notification_statistics_updated_at BEFORE UPDATE ON notification_statistics FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 알림 읽음 처리 시 자동으로 read_at 업데이트하는 트리거 함수
CREATE OR REPLACE FUNCTION update_notification_read_at()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.is_read = true AND OLD.is_read = false THEN
        NEW.read_at = CURRENT_TIMESTAMP;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 알림 읽음 처리 트리거
CREATE TRIGGER trigger_update_notification_read_at
    BEFORE UPDATE ON notifications
    FOR EACH ROW
    EXECUTE FUNCTION update_notification_read_at();

-- 알림 발송 완료 시 자동으로 sent_at 업데이트하는 트리거 함수
CREATE OR REPLACE FUNCTION update_notification_sent_at()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.is_sent = true AND OLD.is_sent = false THEN
        NEW.sent_at = CURRENT_TIMESTAMP;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 알림 발송 완료 트리거
CREATE TRIGGER trigger_update_notification_sent_at
    BEFORE UPDATE ON notifications
    FOR EACH ROW
    EXECUTE FUNCTION update_notification_sent_at();
