-- =====================================================
-- 시스템 관리 및 관리자 기능 스키마
-- =====================================================

-- 시스템 설정 테이블
CREATE TABLE system_settings (
    id BIGSERIAL PRIMARY KEY,
    setting_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    setting_key VARCHAR(100) UNIQUE NOT NULL,
    setting_value TEXT,
    setting_type VARCHAR(20) DEFAULT 'STRING' CHECK (setting_type IN ('STRING', 'INTEGER', 'BOOLEAN', 'JSON', 'DECIMAL')),
    description TEXT,
    category VARCHAR(50), -- 설정 카테고리 (예: 'PAYMENT', 'NOTIFICATION', 'SECURITY', 'GENERAL')
    is_public BOOLEAN DEFAULT false, -- 공개 설정 여부
    is_editable BOOLEAN DEFAULT true, -- 관리자 편집 가능 여부
    created_by BIGINT REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 시스템 로그 테이블
CREATE TABLE system_logs (
    id BIGSERIAL PRIMARY KEY,
    log_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    log_level VARCHAR(10) NOT NULL CHECK (log_level IN ('DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL')),
    log_category VARCHAR(50) NOT NULL, -- 로그 카테고리 (예: 'AUTH', 'PAYMENT', 'RESERVATION', 'SYSTEM')
    message TEXT NOT NULL,
    details JSONB, -- 상세 정보 (JSON 형태)
    user_id BIGINT REFERENCES users(id),
    ip_address INET,
    user_agent TEXT,
    request_url VARCHAR(500),
    request_method VARCHAR(10),
    response_status INTEGER,
    execution_time_ms INTEGER, -- 실행 시간 (밀리초)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 관리자 활동 로그 테이블
CREATE TABLE admin_activity_logs (
    id BIGSERIAL PRIMARY KEY,
    activity_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    admin_user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    action VARCHAR(100) NOT NULL, -- 수행한 액션
    target_entity_type VARCHAR(50), -- 대상 엔티티 타입
    target_entity_id BIGINT, -- 대상 엔티티 ID
    old_values JSONB, -- 변경 전 값
    new_values JSONB, -- 변경 후 값
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 공지사항 테이블
CREATE TABLE announcements (
    id BIGSERIAL PRIMARY KEY,
    announcement_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    announcement_type VARCHAR(20) NOT NULL CHECK (announcement_type IN ('GENERAL', 'MAINTENANCE', 'UPDATE', 'SECURITY', 'PROMOTION')),
    priority VARCHAR(20) DEFAULT 'NORMAL' CHECK (priority IN ('LOW', 'NORMAL', 'HIGH', 'URGENT')),
    target_audience VARCHAR(20) DEFAULT 'ALL' CHECK (target_audience IN ('ALL', 'CUSTOMERS', 'CENTER_OWNERS', 'MECHANICS', 'ADMINS')),
    is_published BOOLEAN DEFAULT false,
    published_at TIMESTAMP,
    published_by BIGINT REFERENCES users(id),
    expires_at TIMESTAMP,
    is_sticky BOOLEAN DEFAULT false, -- 상단 고정 여부
    view_count INTEGER DEFAULT 0,
    created_by BIGINT REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 공지사항 조회 이력 테이블
CREATE TABLE announcement_views (
    id BIGSERIAL PRIMARY KEY,
    announcement_id BIGINT NOT NULL REFERENCES announcements(id) ON DELETE CASCADE,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    viewed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ip_address INET,
    user_agent TEXT,
    UNIQUE(announcement_id, user_id)
);

-- 이벤트/프로모션 테이블
CREATE TABLE events_promotions (
    id BIGSERIAL PRIMARY KEY,
    event_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    event_type VARCHAR(20) NOT NULL CHECK (event_type IN ('DISCOUNT', 'GIVEAWAY', 'SURVEY', 'CONTEST', 'WORKSHOP')),
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP NOT NULL,
    target_audience VARCHAR(20) DEFAULT 'ALL' CHECK (target_audience IN ('ALL', 'NEW_USERS', 'EXISTING_USERS', 'PREMIUM_USERS')),
    participation_conditions JSONB, -- 참여 조건 (JSON 형태)
    rewards JSONB, -- 보상 정보 (JSON 형태)
    max_participants INTEGER, -- 최대 참여자 수
    current_participants INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    is_featured BOOLEAN DEFAULT false,
    image_url VARCHAR(500),
    created_by BIGINT REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 이벤트 참여자 테이블
CREATE TABLE event_participants (
    id BIGSERIAL PRIMARY KEY,
    event_id BIGINT NOT NULL REFERENCES events_promotions(id) ON DELETE CASCADE,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    participation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'REGISTERED' CHECK (status IN ('REGISTERED', 'COMPLETED', 'CANCELLED', 'WINNER')),
    reward_claimed BOOLEAN DEFAULT false,
    reward_claimed_at TIMESTAMP,
    notes TEXT,
    UNIQUE(event_id, user_id)
);

-- 신고/문의 테이블
CREATE TABLE reports_inquiries (
    id BIGSERIAL PRIMARY KEY,
    report_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    reporter_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    report_type VARCHAR(20) NOT NULL CHECK (report_type IN ('BUG', 'FEATURE_REQUEST', 'COMPLAINT', 'INQUIRY', 'ABUSE', 'OTHER')),
    category VARCHAR(50), -- 신고/문의 카테고리
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    priority VARCHAR(20) DEFAULT 'NORMAL' CHECK (priority IN ('LOW', 'NORMAL', 'HIGH', 'URGENT')),
    status VARCHAR(20) DEFAULT 'OPEN' CHECK (status IN ('OPEN', 'IN_PROGRESS', 'RESOLVED', 'CLOSED', 'DUPLICATE')),
    assigned_to BIGINT REFERENCES users(id), -- 담당자
    related_entity_type VARCHAR(50), -- 관련 엔티티 타입
    related_entity_id BIGINT, -- 관련 엔티티 ID
    attachments JSONB, -- 첨부 파일 정보 (JSON 형태)
    resolution_notes TEXT, -- 해결 노트
    resolved_at TIMESTAMP,
    resolved_by BIGINT REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 신고/문의 답변 테이블
CREATE TABLE report_responses (
    id BIGSERIAL PRIMARY KEY,
    report_id BIGINT NOT NULL REFERENCES reports_inquiries(id) ON DELETE CASCADE,
    response_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    responder_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    is_internal BOOLEAN DEFAULT false, -- 내부 메모 여부
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 시스템 메트릭 테이블
CREATE TABLE system_metrics (
    id BIGSERIAL PRIMARY KEY,
    metric_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    metric_name VARCHAR(100) NOT NULL,
    metric_value NUMERIC(15,4) NOT NULL,
    metric_unit VARCHAR(20), -- 단위 (예: 'COUNT', 'PERCENTAGE', 'BYTES', 'SECONDS')
    metric_category VARCHAR(50), -- 메트릭 카테고리
    recorded_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 사용자 통계 테이블
CREATE TABLE user_statistics (
    id BIGSERIAL PRIMARY KEY,
    stats_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    date DATE NOT NULL,
    total_users INTEGER DEFAULT 0,
    new_users INTEGER DEFAULT 0,
    active_users INTEGER DEFAULT 0,
    premium_users INTEGER DEFAULT 0,
    deleted_users INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(date)
);

-- 정비소 통계 테이블
CREATE TABLE service_center_statistics (
    id BIGSERIAL PRIMARY KEY,
    stats_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    date DATE NOT NULL,
    total_centers INTEGER DEFAULT 0,
    new_centers INTEGER DEFAULT 0,
    active_centers INTEGER DEFAULT 0,
    verified_centers INTEGER DEFAULT 0,
    total_reservations INTEGER DEFAULT 0,
    completed_reservations INTEGER DEFAULT 0,
    cancelled_reservations INTEGER DEFAULT 0,
    total_revenue DECIMAL(15,2) DEFAULT 0.00,
    platform_fees DECIMAL(15,2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(date)
);

-- 인덱스 생성
CREATE INDEX idx_system_settings_setting_key ON system_settings(setting_key);
CREATE INDEX idx_system_settings_category ON system_settings(category);
CREATE INDEX idx_system_settings_is_public ON system_settings(is_public);
CREATE INDEX idx_system_logs_log_level ON system_logs(log_level);
CREATE INDEX idx_system_logs_log_category ON system_logs(log_category);
CREATE INDEX idx_system_logs_user_id ON system_logs(user_id);
CREATE INDEX idx_system_logs_created_at ON system_logs(created_at);
CREATE INDEX idx_admin_activity_logs_admin_user_id ON admin_activity_logs(admin_user_id);
CREATE INDEX idx_admin_activity_logs_action ON admin_activity_logs(action);
CREATE INDEX idx_admin_activity_logs_target_entity_type ON admin_activity_logs(target_entity_type);
CREATE INDEX idx_admin_activity_logs_created_at ON admin_activity_logs(created_at);
CREATE INDEX idx_announcements_announcement_type ON announcements(announcement_type);
CREATE INDEX idx_announcements_target_audience ON announcements(target_audience);
CREATE INDEX idx_announcements_is_published ON announcements(is_published);
CREATE INDEX idx_announcements_published_at ON announcements(published_at);
CREATE INDEX idx_announcements_expires_at ON announcements(expires_at);
CREATE INDEX idx_announcements_created_at ON announcements(created_at);
CREATE INDEX idx_announcement_views_announcement_id ON announcement_views(announcement_id);
CREATE INDEX idx_announcement_views_user_id ON announcement_views(user_id);
CREATE INDEX idx_events_promotions_event_type ON events_promotions(event_type);
CREATE INDEX idx_events_promotions_start_date ON events_promotions(start_date);
CREATE INDEX idx_events_promotions_end_date ON events_promotions(end_date);
CREATE INDEX idx_events_promotions_is_active ON events_promotions(is_active);
CREATE INDEX idx_event_participants_event_id ON event_participants(event_id);
CREATE INDEX idx_event_participants_user_id ON event_participants(user_id);
CREATE INDEX idx_event_participants_status ON event_participants(status);
CREATE INDEX idx_reports_inquiries_reporter_id ON reports_inquiries(reporter_id);
CREATE INDEX idx_reports_inquiries_report_type ON reports_inquiries(report_type);
CREATE INDEX idx_reports_inquiries_status ON reports_inquiries(status);
CREATE INDEX idx_reports_inquiries_priority ON reports_inquiries(priority);
CREATE INDEX idx_reports_inquiries_assigned_to ON reports_inquiries(assigned_to);
CREATE INDEX idx_reports_inquiries_created_at ON reports_inquiries(created_at);
CREATE INDEX idx_report_responses_report_id ON report_responses(report_id);
CREATE INDEX idx_report_responses_responder_id ON report_responses(responder_id);
CREATE INDEX idx_report_responses_is_internal ON report_responses(is_internal);
CREATE INDEX idx_system_metrics_metric_name ON system_metrics(metric_name);
CREATE INDEX idx_system_metrics_metric_category ON system_metrics(metric_category);
CREATE INDEX idx_system_metrics_recorded_at ON system_metrics(recorded_at);
CREATE INDEX idx_user_statistics_date ON user_statistics(date);
CREATE INDEX idx_service_center_statistics_date ON service_center_statistics(date);

-- 복합 인덱스
CREATE INDEX idx_system_logs_level_category_created ON system_logs(log_level, log_category, created_at);
CREATE INDEX idx_admin_activity_logs_admin_action_created ON admin_activity_logs(admin_user_id, action, created_at);
CREATE INDEX idx_announcements_published_expires ON announcements(is_published, expires_at);
CREATE INDEX idx_events_promotions_active_dates ON events_promotions(is_active, start_date, end_date);
CREATE INDEX idx_reports_inquiries_status_priority ON reports_inquiries(status, priority);
CREATE INDEX idx_system_metrics_name_recorded ON system_metrics(metric_name, recorded_at);

-- 뷰 생성: 시스템 요약 통계
CREATE VIEW system_summary_stats AS
SELECT 
    (SELECT COUNT(*) FROM users WHERE is_active = true) as total_active_users,
    (SELECT COUNT(*) FROM users WHERE created_at >= CURRENT_DATE - INTERVAL '30 days') as new_users_30_days,
    (SELECT COUNT(*) FROM service_centers WHERE is_active = true) as total_active_centers,
    (SELECT COUNT(*) FROM service_centers WHERE created_at >= CURRENT_DATE - INTERVAL '30 days') as new_centers_30_days,
    (SELECT COUNT(*) FROM reservations WHERE status = 'COMPLETED' AND created_at >= CURRENT_DATE - INTERVAL '30 days') as completed_reservations_30_days,
    (SELECT COUNT(*) FROM reservations WHERE status = 'PENDING') as pending_reservations,
    (SELECT COUNT(*) FROM payments WHERE status = 'COMPLETED' AND paid_at >= CURRENT_DATE - INTERVAL '30 days') as completed_payments_30_days,
    (SELECT COALESCE(SUM(amount), 0) FROM payments WHERE status = 'COMPLETED' AND paid_at >= CURRENT_DATE - INTERVAL '30 days') as total_revenue_30_days,
    (SELECT COUNT(*) FROM reviews WHERE created_at >= CURRENT_DATE - INTERVAL '30 days') as new_reviews_30_days,
    (SELECT AVG(overall_rating) FROM reviews WHERE created_at >= CURRENT_DATE - INTERVAL '30 days') as avg_rating_30_days;

-- 뷰 생성: 관리자 대시보드 통계
CREATE VIEW admin_dashboard_stats AS
SELECT 
    'USERS' as category,
    COUNT(*) as total_count,
    COUNT(CASE WHEN created_at >= CURRENT_DATE THEN 1 END) as today_count,
    COUNT(CASE WHEN created_at >= CURRENT_DATE - INTERVAL '7 days' THEN 1 END) as week_count,
    COUNT(CASE WHEN created_at >= CURRENT_DATE - INTERVAL '30 days' THEN 1 END) as month_count
FROM users
WHERE is_active = true

UNION ALL

SELECT 
    'SERVICE_CENTERS' as category,
    COUNT(*) as total_count,
    COUNT(CASE WHEN created_at >= CURRENT_DATE THEN 1 END) as today_count,
    COUNT(CASE WHEN created_at >= CURRENT_DATE - INTERVAL '7 days' THEN 1 END) as week_count,
    COUNT(CASE WHEN created_at >= CURRENT_DATE - INTERVAL '30 days' THEN 1 END) as month_count
FROM service_centers
WHERE is_active = true

UNION ALL

SELECT 
    'RESERVATIONS' as category,
    COUNT(*) as total_count,
    COUNT(CASE WHEN created_at >= CURRENT_DATE THEN 1 END) as today_count,
    COUNT(CASE WHEN created_at >= CURRENT_DATE - INTERVAL '7 days' THEN 1 END) as week_count,
    COUNT(CASE WHEN created_at >= CURRENT_DATE - INTERVAL '30 days' THEN 1 END) as month_count
FROM reservations

UNION ALL

SELECT 
    'PAYMENTS' as category,
    COUNT(*) as total_count,
    COUNT(CASE WHEN created_at >= CURRENT_DATE THEN 1 END) as today_count,
    COUNT(CASE WHEN created_at >= CURRENT_DATE - INTERVAL '7 days' THEN 1 END) as week_count,
    COUNT(CASE WHEN created_at >= CURRENT_DATE - INTERVAL '30 days' THEN 1 END) as month_count
FROM payments
WHERE status = 'COMPLETED';

-- 트리거 생성
CREATE TRIGGER update_system_settings_updated_at BEFORE UPDATE ON system_settings FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_announcements_updated_at BEFORE UPDATE ON announcements FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_events_promotions_updated_at BEFORE UPDATE ON events_promotions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_reports_inquiries_updated_at BEFORE UPDATE ON reports_inquiries FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_report_responses_updated_at BEFORE UPDATE ON report_responses FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_user_statistics_updated_at BEFORE UPDATE ON user_statistics FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_service_center_statistics_updated_at BEFORE UPDATE ON service_center_statistics FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 공지사항 발행 시 자동으로 published_at 업데이트하는 트리거 함수
CREATE OR REPLACE FUNCTION update_announcement_published_at()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.is_published = true AND OLD.is_published = false THEN
        NEW.published_at = CURRENT_TIMESTAMP;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 공지사항 발행 트리거
CREATE TRIGGER trigger_update_announcement_published_at
    BEFORE UPDATE ON announcements
    FOR EACH ROW
    EXECUTE FUNCTION update_announcement_published_at();

-- 신고/문의 해결 시 자동으로 resolved_at 업데이트하는 트리거 함수
CREATE OR REPLACE FUNCTION update_report_resolved_at()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'RESOLVED' AND OLD.status != 'RESOLVED' THEN
        NEW.resolved_at = CURRENT_TIMESTAMP;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 신고/문의 해결 트리거
CREATE TRIGGER trigger_update_report_resolved_at
    BEFORE UPDATE ON reports_inquiries
    FOR EACH ROW
    EXECUTE FUNCTION update_report_resolved_at();
