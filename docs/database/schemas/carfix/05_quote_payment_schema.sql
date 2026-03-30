-- =====================================================
-- 견적 및 결제 시스템 스키마
-- =====================================================

-- 견적서 기본 정보 테이블
CREATE TABLE quotes (
    id BIGSERIAL PRIMARY KEY,
    quote_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    reservation_id BIGINT NOT NULL REFERENCES reservations(id) ON DELETE CASCADE,
    quote_number VARCHAR(50) UNIQUE NOT NULL, -- 견적서 번호 (예: QT-2024-001)
    status VARCHAR(20) NOT NULL DEFAULT 'DRAFT' CHECK (status IN ('DRAFT', 'SENT', 'APPROVED', 'REJECTED', 'EXPIRED', 'MODIFIED')),
    labor_cost DECIMAL(10,2) DEFAULT 0.00, -- 공임비
    parts_cost DECIMAL(10,2) DEFAULT 0.00, -- 부품비
    tax_amount DECIMAL(10,2) DEFAULT 0.00, -- 세금
    discount_amount DECIMAL(10,2) DEFAULT 0.00, -- 할인액
    total_amount DECIMAL(10,2) DEFAULT 0.00, -- 총액
    valid_until TIMESTAMP, -- 견적 유효기간
    notes TEXT, -- 견적 관련 메모
    terms_conditions TEXT, -- 견적 조건
    created_by BIGINT REFERENCES users(id),
    approved_by BIGINT REFERENCES users(id),
    approved_at TIMESTAMP,
    rejected_reason TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 견적서 상세 항목 테이블
CREATE TABLE quote_items (
    id BIGSERIAL PRIMARY KEY,
    quote_id BIGINT NOT NULL REFERENCES quotes(id) ON DELETE CASCADE,
    item_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    item_type VARCHAR(20) NOT NULL CHECK (item_type IN ('LABOR', 'PART', 'MATERIAL', 'SUBCONTRACT')),
    category VARCHAR(50), -- 항목 카테고리
    description TEXT NOT NULL, -- 항목 설명
    part_number VARCHAR(100), -- 부품 번호
    brand VARCHAR(100), -- 브랜드
    quantity INTEGER DEFAULT 1, -- 수량
    unit_price DECIMAL(10,2) NOT NULL, -- 단가
    total_price DECIMAL(10,2) NOT NULL, -- 총액
    warranty_months INTEGER, -- 보증 기간 (개월)
    is_required BOOLEAN DEFAULT true, -- 필수 항목 여부
    notes TEXT, -- 항목별 메모
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 견적서 상태 변경 이력 테이블
CREATE TABLE quote_status_history (
    id BIGSERIAL PRIMARY KEY,
    quote_id BIGINT NOT NULL REFERENCES quotes(id) ON DELETE CASCADE,
    history_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    from_status VARCHAR(20),
    to_status VARCHAR(20) NOT NULL,
    changed_by BIGINT REFERENCES users(id),
    reason TEXT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 할인 쿠폰 테이블
CREATE TABLE discount_coupons (
    id BIGSERIAL PRIMARY KEY,
    coupon_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    coupon_code VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    discount_type VARCHAR(20) NOT NULL CHECK (discount_type IN ('PERCENTAGE', 'FIXED_AMOUNT')),
    discount_value DECIMAL(10,2) NOT NULL, -- 할인율(%) 또는 할인액
    minimum_amount DECIMAL(10,2) DEFAULT 0.00, -- 최소 사용 금액
    maximum_discount DECIMAL(10,2), -- 최대 할인액 (퍼센트 할인 시)
    valid_from TIMESTAMP NOT NULL,
    valid_until TIMESTAMP NOT NULL,
    usage_limit INTEGER, -- 전체 사용 제한 횟수
    usage_count INTEGER DEFAULT 0, -- 현재 사용 횟수
    per_user_limit INTEGER DEFAULT 1, -- 사용자당 사용 제한 횟수
    applicable_service_types TEXT, -- 적용 가능한 서비스 타입 (JSON)
    is_active BOOLEAN DEFAULT true,
    created_by BIGINT REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 사용자 쿠폰 사용 이력 테이블
CREATE TABLE user_coupon_usage (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    coupon_id BIGINT NOT NULL REFERENCES discount_coupons(id) ON DELETE CASCADE,
    quote_id BIGINT REFERENCES quotes(id) ON DELETE SET NULL,
    used_at TIMESTAMP NOT NULL,
    discount_amount DECIMAL(10,2) NOT NULL, -- 실제 적용된 할인액
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 결제 기본 정보 테이블
CREATE TABLE payments (
    id BIGSERIAL PRIMARY KEY,
    payment_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    reservation_id BIGINT NOT NULL REFERENCES reservations(id) ON DELETE CASCADE,
    quote_id BIGINT REFERENCES quotes(id) ON DELETE SET NULL,
    payment_number VARCHAR(50) UNIQUE NOT NULL, -- 결제 번호 (예: PAY-2024-001)
    amount DECIMAL(10,2) NOT NULL, -- 결제 금액
    payment_method VARCHAR(20) NOT NULL CHECK (payment_method IN ('CARD', 'BANK_TRANSFER', 'MOBILE', 'CASH', 'KAKAO_PAY', 'NAVER_PAY', 'TOSS_PAY')),
    payment_gateway VARCHAR(50), -- 결제 게이트웨이
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'PROCESSING', 'COMPLETED', 'FAILED', 'CANCELLED', 'REFUNDED', 'PARTIAL_REFUNDED')),
    transaction_id VARCHAR(255), -- 외부 결제 시스템 거래 ID
    receipt_url VARCHAR(500), -- 영수증 URL
    paid_at TIMESTAMP, -- 실제 결제 완료 시간
    refunded_at TIMESTAMP, -- 환불 시간
    refund_amount DECIMAL(10,2) DEFAULT 0.00, -- 환불 금액
    refund_reason TEXT, -- 환불 사유
    notes TEXT, -- 결제 관련 메모
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 결제 상태 변경 이력 테이블
CREATE TABLE payment_status_history (
    id BIGSERIAL PRIMARY KEY,
    payment_id BIGINT NOT NULL REFERENCES payments(id) ON DELETE CASCADE,
    history_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    from_status VARCHAR(20),
    to_status VARCHAR(20) NOT NULL,
    changed_by BIGINT REFERENCES users(id),
    reason TEXT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 결제 카드 정보 테이블 (암호화된 형태로 저장)
CREATE TABLE payment_cards (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    card_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    card_type VARCHAR(20) CHECK (card_type IN ('CREDIT', 'DEBIT', 'CHECK')),
    card_issuer VARCHAR(50), -- 카드 발행사
    masked_card_number VARCHAR(20), -- 마스킹된 카드 번호 (예: 1234-****-****-5678)
    expiry_month INTEGER CHECK (expiry_month >= 1 AND expiry_month <= 12),
    expiry_year INTEGER CHECK (expiry_year >= 2020),
    card_holder_name VARCHAR(100),
    is_default BOOLEAN DEFAULT false, -- 기본 결제 카드 여부
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 정산 정보 테이블
CREATE TABLE settlements (
    id BIGSERIAL PRIMARY KEY,
    settlement_uuid UUID UNIQUE NOT NULL DEFAULT gen_random_uuid(),
    service_center_id BIGINT NOT NULL REFERENCES service_centers(id) ON DELETE CASCADE,
    settlement_period VARCHAR(7) NOT NULL, -- 정산 기간 (예: 2024-12)
    total_revenue DECIMAL(12,2) DEFAULT 0.00, -- 총 매출
    platform_fee DECIMAL(12,2) DEFAULT 0.00, -- 플랫폼 수수료
    settlement_amount DECIMAL(12,2) DEFAULT 0.00, -- 정산 금액
    status VARCHAR(20) DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'PROCESSING', 'COMPLETED', 'CANCELLED')),
    settlement_date DATE, -- 정산 완료일
    bank_account_info TEXT, -- 은행 계좌 정보 (JSON)
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(service_center_id, settlement_period)
);

-- 정산 상세 내역 테이블
CREATE TABLE settlement_details (
    id BIGSERIAL PRIMARY KEY,
    settlement_id BIGINT NOT NULL REFERENCES settlements(id) ON DELETE CASCADE,
    payment_id BIGINT NOT NULL REFERENCES payments(id) ON DELETE CASCADE,
    revenue_amount DECIMAL(10,2) NOT NULL, -- 해당 결제의 매출
    fee_amount DECIMAL(10,2) NOT NULL, -- 해당 결제의 수수료
    net_amount DECIMAL(10,2) NOT NULL, -- 해당 결제의 순수익
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 인덱스 생성
CREATE INDEX idx_quotes_reservation_id ON quotes(reservation_id);
CREATE INDEX idx_quotes_quote_number ON quotes(quote_number);
CREATE INDEX idx_quotes_status ON quotes(status);
CREATE INDEX idx_quotes_valid_until ON quotes(valid_until);
CREATE INDEX idx_quotes_created_at ON quotes(created_at);
CREATE INDEX idx_quote_items_quote_id ON quote_items(quote_id);
CREATE INDEX idx_quote_items_item_type ON quote_items(item_type);
CREATE INDEX idx_quote_status_history_quote_id ON quote_status_history(quote_id);
CREATE INDEX idx_quote_status_history_to_status ON quote_status_history(to_status);
CREATE INDEX idx_discount_coupons_coupon_code ON discount_coupons(coupon_code);
CREATE INDEX idx_discount_coupons_valid_until ON discount_coupons(valid_until);
CREATE INDEX idx_discount_coupons_is_active ON discount_coupons(is_active);
CREATE INDEX idx_user_coupon_usage_user_id ON user_coupon_usage(user_id);
CREATE INDEX idx_user_coupon_usage_coupon_id ON user_coupon_usage(coupon_id);
CREATE INDEX idx_payments_reservation_id ON payments(reservation_id);
CREATE INDEX idx_payments_quote_id ON payments(quote_id);
CREATE INDEX idx_payments_payment_number ON payments(payment_number);
CREATE INDEX idx_payments_status ON payments(status);
CREATE INDEX idx_payments_payment_method ON payments(payment_method);
CREATE INDEX idx_payments_transaction_id ON payments(transaction_id);
CREATE INDEX idx_payments_paid_at ON payments(paid_at);
CREATE INDEX idx_payments_created_at ON payments(created_at);
CREATE INDEX idx_payment_status_history_payment_id ON payment_status_history(payment_id);
CREATE INDEX idx_payment_status_history_to_status ON payment_status_history(to_status);
CREATE INDEX idx_payment_cards_user_id ON payment_cards(user_id);
CREATE INDEX idx_payment_cards_is_default ON payment_cards(is_default);
CREATE INDEX idx_payment_cards_is_active ON payment_cards(is_active);
CREATE INDEX idx_settlements_service_center_id ON settlements(service_center_id);
CREATE INDEX idx_settlements_settlement_period ON settlements(settlement_period);
CREATE INDEX idx_settlements_status ON settlements(status);
CREATE INDEX idx_settlement_details_settlement_id ON settlement_details(settlement_id);
CREATE INDEX idx_settlement_details_payment_id ON settlement_details(payment_id);

-- 복합 인덱스
CREATE INDEX idx_quotes_status_valid_until ON quotes(status, valid_until);
CREATE INDEX idx_payments_status_paid_at ON payments(status, paid_at);
CREATE INDEX idx_settlements_center_period ON settlements(service_center_id, settlement_period);

-- 뷰 생성: 견적서 요약 정보
CREATE VIEW quote_summary AS
SELECT 
    q.id,
    q.quote_uuid,
    q.reservation_id,
    q.quote_number,
    q.status,
    q.labor_cost,
    q.parts_cost,
    q.tax_amount,
    q.discount_amount,
    q.total_amount,
    q.valid_until,
    q.created_at,
    q.updated_at,
    r.scheduled_date,
    r.status as reservation_status,
    sc.name as service_center_name,
    st.name as service_type_name,
    u.name as customer_name,
    v.license_plate
FROM quotes q
JOIN reservations r ON q.reservation_id = r.id
JOIN service_centers sc ON r.service_center_id = sc.id
JOIN service_types st ON r.service_type_id = st.id
JOIN users u ON r.user_id = u.id
JOIN vehicles v ON r.vehicle_id = v.id;

-- 뷰 생성: 결제 요약 정보
CREATE VIEW payment_summary AS
SELECT 
    p.id,
    p.payment_uuid,
    p.reservation_id,
    p.quote_id,
    p.payment_number,
    p.amount,
    p.payment_method,
    p.payment_gateway,
    p.status,
    p.transaction_id,
    p.paid_at,
    p.refund_amount,
    p.created_at,
    p.updated_at,
    r.scheduled_date,
    r.status as reservation_status,
    sc.name as service_center_name,
    u.name as customer_name,
    v.license_plate,
    q.total_amount as quote_total_amount
FROM payments p
JOIN reservations r ON p.reservation_id = r.id
JOIN service_centers sc ON r.service_center_id = sc.id
JOIN users u ON r.user_id = u.id
JOIN vehicles v ON r.vehicle_id = v.id
LEFT JOIN quotes q ON p.quote_id = q.id;

-- 트리거 생성
CREATE TRIGGER update_quotes_updated_at BEFORE UPDATE ON quotes FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_discount_coupons_updated_at BEFORE UPDATE ON discount_coupons FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_payments_updated_at BEFORE UPDATE ON payments FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_payment_cards_updated_at BEFORE UPDATE ON payment_cards FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_settlements_updated_at BEFORE UPDATE ON settlements FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 견적서 상태 변경 시 자동으로 이력 기록하는 트리거 함수
CREATE OR REPLACE FUNCTION log_quote_status_change()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.status IS DISTINCT FROM NEW.status THEN
        INSERT INTO quote_status_history (
            quote_id, 
            from_status, 
            to_status, 
            changed_by, 
            created_at
        ) VALUES (
            NEW.id, 
            OLD.status, 
            NEW.status, 
            NEW.created_by,
            CURRENT_TIMESTAMP
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 결제 상태 변경 시 자동으로 이력 기록하는 트리거 함수
CREATE OR REPLACE FUNCTION log_payment_status_change()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.status IS DISTINCT FROM NEW.status THEN
        INSERT INTO payment_status_history (
            payment_id, 
            from_status, 
            to_status, 
            changed_by, 
            created_at
        ) VALUES (
            NEW.id, 
            OLD.status, 
            NEW.status, 
            NULL, -- 실제로는 현재 로그인한 사용자 ID를 사용해야 함
            CURRENT_TIMESTAMP
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 트리거 생성
CREATE TRIGGER trigger_quote_status_change
    AFTER UPDATE ON quotes
    FOR EACH ROW
    EXECUTE FUNCTION log_quote_status_change();

CREATE TRIGGER trigger_payment_status_change
    AFTER UPDATE ON payments
    FOR EACH ROW
    EXECUTE FUNCTION log_payment_status_change();
