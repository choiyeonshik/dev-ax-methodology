-- =====================================================
-- DBeaver용 스키마 생성 스크립트
-- 실행 전: carfixdb 데이터베이스에 연결되어 있는지 확인
-- =====================================================

-- Create carfix schema if not exists
CREATE SCHEMA IF NOT EXISTS carfix;

-- Grant DDL privileges to Admin Role for carfix schema
GRANT ALL PRIVILEGES ON SCHEMA carfix TO carfix_admin_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA carfix TO carfix_admin_role;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA carfix TO carfix_admin_role;

-- Set default privileges for future objects in carfix schema
ALTER DEFAULT PRIVILEGES IN SCHEMA carfix GRANT ALL PRIVILEGES ON TABLES TO carfix_admin_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA carfix GRANT ALL PRIVILEGES ON SEQUENCES TO carfix_admin_role;

-- Grant DML privileges to Developer Role for carfix schema
GRANT USAGE ON SCHEMA carfix TO carfix_developer_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA carfix TO carfix_developer_role;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA carfix TO carfix_developer_role;

-- Set default privileges for future objects in carfix schema
ALTER DEFAULT PRIVILEGES IN SCHEMA carfix GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO carfix_developer_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA carfix GRANT USAGE ON SEQUENCES TO carfix_developer_role;

-- Grant schema ownership to admin role
ALTER SCHEMA carfix OWNER TO carfix_admin_role;

-- Grant CRUD privileges on interface tables to API Role
-- 예약 시스템 API 접근을 위한 권한
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE carfix.reservation TO carfix_api_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE carfix.reservation_detail TO carfix_api_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE carfix.reservation_status_history TO carfix_api_role;

-- 견적 시스템 API 접근을 위한 권한
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE carfix.quote TO carfix_api_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE carfix.quote_item TO carfix_api_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE carfix.quote_status_history TO carfix_api_role;

-- 결제 시스템 API 접근을 위한 권한
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE carfix.payment TO carfix_api_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE carfix.payment_method TO carfix_api_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE carfix.payment_status_history TO carfix_api_role;

-- 사용자 및 차량 정보 API 접근을 위한 권한
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE carfix.user TO carfix_api_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE carfix.vehicle TO carfix_api_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE carfix.service_center TO carfix_api_role;

-- Default privileges for future interface tables
ALTER DEFAULT PRIVILEGES IN SCHEMA carfix GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO carfix_api_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA carfix GRANT USAGE ON SEQUENCES TO carfix_api_role;

-- Grant read-only privileges to Read-Only Role for carfix schema
GRANT USAGE ON SCHEMA carfix TO carfix_readonly_role;
GRANT SELECT ON ALL TABLES IN SCHEMA carfix TO carfix_readonly_role;

-- Set default privileges for future objects in carfix schema
ALTER DEFAULT PRIVILEGES IN SCHEMA carfix GRANT SELECT ON TABLES TO carfix_readonly_role;

-- =====================================================
-- 스키마 생성 완료
-- 다음 단계: 테이블 생성 스크립트 실행
-- =====================================================

