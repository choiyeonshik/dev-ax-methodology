-- =====================================================
-- 리뷰 시스템 스키마
-- =====================================================

-- 리뷰 기본 정보 테이블
CREATE TABLE reviews (
    id BIGSERIAL PRIMARY KEY,
    review_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    reservation_id BIGINT NOT NULL REFERENCES reservations(id) ON DELETE CASCADE,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    service_center_id BIGINT NOT NULL REFERENCES service_centers(id) ON DELETE CASCADE,
    overall_rating INTEGER NOT NULL CHECK (overall_rating >= 1 AND overall_rating <= 5),
    service_quality_rating INTEGER CHECK (service_quality_rating >= 1 AND service_quality_rating <= 5),
    price_rating INTEGER CHECK (price_rating >= 1 AND price_rating <= 5),
    communication_rating INTEGER CHECK (communication_rating >= 1 AND communication_rating <= 5),
    cleanliness_rating INTEGER CHECK (cleanliness_rating >= 1 AND cleanliness_rating <= 5),
    timeliness_rating INTEGER CHECK (timeliness_rating >= 1 AND timeliness_rating <= 5),
    title VARCHAR(255),
    content TEXT NOT NULL,
    is_anonymous BOOLEAN DEFAULT false,
    is_verified BOOLEAN DEFAULT false, -- 실제 정비 완료 고객인지 확인
    is_helpful_count INTEGER DEFAULT 0, -- 도움됨 카운트
    is_helpful_voted_by TEXT, -- 도움됨 투표한 사용자 ID들 (JSON 배열)
    is_visible BOOLEAN DEFAULT true,
    status VARCHAR(20) DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'HIDDEN', 'DELETED', 'REPORTED')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(reservation_id)
);

-- 리뷰 사진 테이블
CREATE TABLE review_images (
    id BIGSERIAL PRIMARY KEY,
    review_id BIGINT NOT NULL REFERENCES reviews(id) ON DELETE CASCADE,
    image_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    image_url VARCHAR(500) NOT NULL,
    image_type VARCHAR(20) CHECK (image_type IN ('BEFORE', 'AFTER', 'GENERAL')),
    description TEXT,
    display_order INTEGER DEFAULT 0,
    file_size INTEGER, -- 바이트 단위
    file_format VARCHAR(10),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 리뷰 답글 테이블 (정비소 응답)
CREATE TABLE review_replies (
    id BIGSERIAL PRIMARY KEY,
    review_id BIGINT NOT NULL REFERENCES reviews(id) ON DELETE CASCADE,
    reply_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    author_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    is_visible BOOLEAN DEFAULT true,
    status VARCHAR(20) DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'HIDDEN', 'DELETED')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 리뷰 신고 테이블
CREATE TABLE review_reports (
    id BIGSERIAL PRIMARY KEY,
    review_id BIGINT NOT NULL REFERENCES reviews(id) ON DELETE CASCADE,
    report_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    reporter_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    report_reason VARCHAR(50) NOT NULL CHECK (report_reason IN ('SPAM', 'INAPPROPRIATE', 'FALSE_INFO', 'HARASSMENT', 'OTHER')),
    report_details TEXT,
    status VARCHAR(20) DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'REVIEWED', 'RESOLVED', 'DISMISSED')),
    reviewed_by BIGINT REFERENCES users(id),
    reviewed_at TIMESTAMP,
    resolution_notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 리뷰 태그 테이블
CREATE TABLE review_tags (
    id BIGSERIAL PRIMARY KEY,
    tag_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    name VARCHAR(50) NOT NULL UNIQUE,
    category VARCHAR(50), -- 태그 카테고리 (예: 'SERVICE', 'PRICE', 'QUALITY')
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    usage_count INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 리뷰-태그 연결 테이블
CREATE TABLE review_tag_relations (
    id BIGSERIAL PRIMARY KEY,
    review_id BIGINT NOT NULL REFERENCES reviews(id) ON DELETE CASCADE,
    tag_id BIGINT NOT NULL REFERENCES review_tags(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(review_id, tag_id)
);

-- 리뷰 좋아요/싫어요 테이블
CREATE TABLE review_reactions (
    id BIGSERIAL PRIMARY KEY,
    review_id BIGINT NOT NULL REFERENCES reviews(id) ON DELETE CASCADE,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    reaction_type VARCHAR(10) NOT NULL CHECK (reaction_type IN ('LIKE', 'DISLIKE')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(review_id, user_id)
);

-- 정비소 평점 통계 테이블 (리뷰 기반)
CREATE TABLE service_center_review_stats (
    id BIGSERIAL PRIMARY KEY,
    service_center_id BIGINT NOT NULL REFERENCES service_centers(id) ON DELETE CASCADE,
    stats_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    total_reviews INTEGER DEFAULT 0,
    average_overall_rating NUMERIC(3,2) DEFAULT 0.0,
    average_service_quality_rating NUMERIC(3,2) DEFAULT 0.0,
    average_price_rating NUMERIC(3,2) DEFAULT 0.0,
    average_communication_rating NUMERIC(3,2) DEFAULT 0.0,
    average_cleanliness_rating NUMERIC(3,2) DEFAULT 0.0,
    average_timeliness_rating NUMERIC(3,2) DEFAULT 0.0,
    five_star_count INTEGER DEFAULT 0,
    four_star_count INTEGER DEFAULT 0,
    three_star_count INTEGER DEFAULT 0,
    two_star_count INTEGER DEFAULT 0,
    one_star_count INTEGER DEFAULT 0,
    last_review_date TIMESTAMP,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(service_center_id)
);

-- 리뷰 알림 테이블
CREATE TABLE review_notifications (
    id BIGSERIAL PRIMARY KEY,
    review_id BIGINT NOT NULL REFERENCES reviews(id) ON DELETE CASCADE,
    notification_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    notification_type VARCHAR(50) NOT NULL CHECK (notification_type IN ('NEW_REVIEW', 'REVIEW_REPLY', 'REVIEW_REPORT', 'REVIEW_HELPFUL')),
    recipient_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(255),
    message TEXT NOT NULL,
    is_sent BOOLEAN DEFAULT false,
    sent_at TIMESTAMP,
    is_read BOOLEAN DEFAULT false,
    read_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 인덱스 생성
CREATE INDEX idx_reviews_reservation_id ON reviews(reservation_id);
CREATE INDEX idx_reviews_user_id ON reviews(user_id);
CREATE INDEX idx_reviews_service_center_id ON reviews(service_center_id);
CREATE INDEX idx_reviews_overall_rating ON reviews(overall_rating);
CREATE INDEX idx_reviews_is_verified ON reviews(is_verified);
CREATE INDEX idx_reviews_is_visible ON reviews(is_visible);
CREATE INDEX idx_reviews_status ON reviews(status);
CREATE INDEX idx_reviews_created_at ON reviews(created_at);
CREATE INDEX idx_review_images_review_id ON review_images(review_id);
CREATE INDEX idx_review_images_image_type ON review_images(image_type);
CREATE INDEX idx_review_replies_review_id ON review_replies(review_id);
CREATE INDEX idx_review_replies_author_id ON review_replies(author_id);
CREATE INDEX idx_review_replies_status ON review_replies(status);
CREATE INDEX idx_review_reports_review_id ON review_reports(review_id);
CREATE INDEX idx_review_reports_reporter_id ON review_reports(reporter_id);
CREATE INDEX idx_review_reports_status ON review_reports(status);
CREATE INDEX idx_review_tags_name ON review_tags(name);
CREATE INDEX idx_review_tags_category ON review_tags(category);
CREATE INDEX idx_review_tags_is_active ON review_tags(is_active);
CREATE INDEX idx_review_tag_relations_review_id ON review_tag_relations(review_id);
CREATE INDEX idx_review_tag_relations_tag_id ON review_tag_relations(tag_id);
CREATE INDEX idx_review_reactions_review_id ON review_reactions(review_id);
CREATE INDEX idx_review_reactions_user_id ON review_reactions(user_id);
CREATE INDEX idx_review_reactions_reaction_type ON review_reactions(reaction_type);
CREATE INDEX idx_service_center_review_stats_service_center_id ON service_center_review_stats(service_center_id);
CREATE INDEX idx_service_center_review_stats_average_overall_rating ON service_center_review_stats(average_overall_rating);
CREATE INDEX idx_review_notifications_review_id ON review_notifications(review_id);
CREATE INDEX idx_review_notifications_recipient_id ON review_notifications(recipient_id);
CREATE INDEX idx_review_notifications_notification_type ON review_notifications(notification_type);
CREATE INDEX idx_review_notifications_is_sent ON review_notifications(is_sent);

-- 복합 인덱스
CREATE INDEX idx_reviews_center_rating ON reviews(service_center_id, overall_rating);
CREATE INDEX idx_reviews_center_created ON reviews(service_center_id, created_at);
CREATE INDEX idx_reviews_user_created ON reviews(user_id, created_at);

-- 뷰 생성: 리뷰 요약 정보
CREATE VIEW review_summary AS
SELECT 
    r.id,
    r.review_uuid,
    r.reservation_id,
    r.user_id,
    r.service_center_id,
    r.overall_rating,
    r.service_quality_rating,
    r.price_rating,
    r.communication_rating,
    r.cleanliness_rating,
    r.timeliness_rating,
    r.title,
    r.content,
    r.is_anonymous,
    r.is_verified,
    r.is_helpful_count,
    r.is_visible,
    r.status,
    r.created_at,
    r.updated_at,
    u.name as reviewer_name,
    sc.name as service_center_name,
    res.scheduled_date,
    st.name as service_type_name,
    v.license_plate,
    COUNT(ri.id) as image_count,
    COUNT(rr.id) as reply_count,
    COUNT(rr2.id) as report_count
FROM reviews r
JOIN users u ON r.user_id = u.id
JOIN service_centers sc ON r.service_center_id = sc.id
JOIN reservations res ON r.reservation_id = res.id
JOIN service_types st ON res.service_type_id = st.id
JOIN vehicles v ON res.vehicle_id = v.id
LEFT JOIN review_images ri ON r.id = ri.review_id
LEFT JOIN review_replies rr ON r.id = rr.review_id AND rr.status = 'ACTIVE'
LEFT JOIN review_reports rr2 ON r.id = rr2.review_id AND rr2.status = 'PENDING'
GROUP BY r.id, u.name, sc.name, res.scheduled_date, st.name, v.license_plate;

-- 뷰 생성: 정비소 리뷰 통계
CREATE VIEW service_center_review_summary AS
SELECT 
    sc.id as service_center_id,
    sc.name as service_center_name,
    scrs.total_reviews,
    scrs.average_overall_rating,
    scrs.average_service_quality_rating,
    scrs.average_price_rating,
    scrs.average_communication_rating,
    scrs.average_cleanliness_rating,
    scrs.average_timeliness_rating,
    scrs.five_star_count,
    scrs.four_star_count,
    scrs.three_star_count,
    scrs.two_star_count,
    scrs.one_star_count,
    scrs.last_review_date,
    scrs.last_updated,
    CASE 
        WHEN scrs.total_reviews >= 10 THEN 'HIGH_VOLUME'
        WHEN scrs.total_reviews >= 5 THEN 'MEDIUM_VOLUME'
        ELSE 'LOW_VOLUME'
    END as review_volume_category,
    CASE 
        WHEN scrs.average_overall_rating >= 4.5 THEN 'EXCELLENT'
        WHEN scrs.average_overall_rating >= 4.0 THEN 'GOOD'
        WHEN scrs.average_overall_rating >= 3.0 THEN 'AVERAGE'
        ELSE 'POOR'
    END as rating_category
FROM service_centers sc
LEFT JOIN service_center_review_stats scrs ON sc.id = scrs.service_center_id;

-- 트리거 생성
CREATE TRIGGER update_reviews_updated_at BEFORE UPDATE ON reviews FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_review_replies_updated_at BEFORE UPDATE ON review_replies FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_review_reports_updated_at BEFORE UPDATE ON review_reports FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_review_tags_updated_at BEFORE UPDATE ON review_tags FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_service_center_review_stats_updated_at BEFORE UPDATE ON service_center_review_stats FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 리뷰 작성 시 정비소 평점 통계 자동 업데이트 트리거 함수
CREATE OR REPLACE FUNCTION update_service_center_review_stats()
RETURNS TRIGGER AS $$
BEGIN
    -- 새 리뷰 추가 시
    IF TG_OP = 'INSERT' THEN
        INSERT INTO service_center_review_stats (
            service_center_id,
            total_reviews,
            average_overall_rating,
            average_service_quality_rating,
            average_price_rating,
            average_communication_rating,
            average_cleanliness_rating,
            average_timeliness_rating,
            five_star_count,
            four_star_count,
            three_star_count,
            two_star_count,
            one_star_count,
            last_review_date,
            last_updated
        )
        SELECT 
            NEW.service_center_id,
            1,
            NEW.overall_rating,
            COALESCE(NEW.service_quality_rating, 0),
            COALESCE(NEW.price_rating, 0),
            COALESCE(NEW.communication_rating, 0),
            COALESCE(NEW.cleanliness_rating, 0),
            COALESCE(NEW.timeliness_rating, 0),
            CASE WHEN NEW.overall_rating = 5 THEN 1 ELSE 0 END,
            CASE WHEN NEW.overall_rating = 4 THEN 1 ELSE 0 END,
            CASE WHEN NEW.overall_rating = 3 THEN 1 ELSE 0 END,
            CASE WHEN NEW.overall_rating = 2 THEN 1 ELSE 0 END,
            CASE WHEN NEW.overall_rating = 1 THEN 1 ELSE 0 END,
            NEW.created_at,
            CURRENT_TIMESTAMP
        ON CONFLICT (service_center_id) DO UPDATE SET
            total_reviews = service_center_review_stats.total_reviews + 1,
            average_overall_rating = (service_center_review_stats.average_overall_rating * service_center_review_stats.total_reviews + NEW.overall_rating) / (service_center_review_stats.total_reviews + 1),
            average_service_quality_rating = CASE WHEN NEW.service_quality_rating IS NOT NULL 
                THEN (service_center_review_stats.average_service_quality_rating * service_center_review_stats.total_reviews + NEW.service_quality_rating) / (service_center_review_stats.total_reviews + 1)
                ELSE service_center_review_stats.average_service_quality_rating END,
            average_price_rating = CASE WHEN NEW.price_rating IS NOT NULL 
                THEN (service_center_review_stats.average_price_rating * service_center_review_stats.total_reviews + NEW.price_rating) / (service_center_review_stats.total_reviews + 1)
                ELSE service_center_review_stats.average_price_rating END,
            average_communication_rating = CASE WHEN NEW.communication_rating IS NOT NULL 
                THEN (service_center_review_stats.average_communication_rating * service_center_review_stats.total_reviews + NEW.communication_rating) / (service_center_review_stats.total_reviews + 1)
                ELSE service_center_review_stats.average_communication_rating END,
            average_cleanliness_rating = CASE WHEN NEW.cleanliness_rating IS NOT NULL 
                THEN (service_center_review_stats.average_cleanliness_rating * service_center_review_stats.total_reviews + NEW.cleanliness_rating) / (service_center_review_stats.total_reviews + 1)
                ELSE service_center_review_stats.average_cleanliness_rating END,
            average_timeliness_rating = CASE WHEN NEW.timeliness_rating IS NOT NULL 
                THEN (service_center_review_stats.average_timeliness_rating * service_center_review_stats.total_reviews + NEW.timeliness_rating) / (service_center_review_stats.total_reviews + 1)
                ELSE service_center_review_stats.average_timeliness_rating END,
            five_star_count = service_center_review_stats.five_star_count + CASE WHEN NEW.overall_rating = 5 THEN 1 ELSE 0 END,
            four_star_count = service_center_review_stats.four_star_count + CASE WHEN NEW.overall_rating = 4 THEN 1 ELSE 0 END,
            three_star_count = service_center_review_stats.three_star_count + CASE WHEN NEW.overall_rating = 3 THEN 1 ELSE 0 END,
            two_star_count = service_center_review_stats.two_star_count + CASE WHEN NEW.overall_rating = 2 THEN 1 ELSE 0 END,
            one_star_count = service_center_review_stats.one_star_count + CASE WHEN NEW.overall_rating = 1 THEN 1 ELSE 0 END,
            last_review_date = NEW.created_at,
            last_updated = CURRENT_TIMESTAMP;
    END IF;
    
    -- 리뷰 수정 시
    IF TG_OP = 'UPDATE' THEN
        -- 기존 리뷰의 평점을 제거하고 새로운 평점을 추가하는 방식으로 업데이트
        -- 실제 구현에서는 더 복잡한 로직이 필요할 수 있음
        UPDATE service_center_review_stats 
        SET last_updated = CURRENT_TIMESTAMP
        WHERE service_center_id = NEW.service_center_id;
    END IF;
    
    -- 리뷰 삭제 시
    IF TG_OP = 'DELETE' THEN
        -- 기존 리뷰의 평점을 제거하는 로직
        UPDATE service_center_review_stats 
        SET last_updated = CURRENT_TIMESTAMP
        WHERE service_center_id = OLD.service_center_id;
    END IF;
    
    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

-- 리뷰 변경 트리거
CREATE TRIGGER trigger_update_review_stats
    AFTER INSERT OR UPDATE OR DELETE ON reviews
    FOR EACH ROW
    EXECUTE FUNCTION update_service_center_review_stats();
