-- Purpose: 자동차 정비예약 시스템의 DB 역할 및 사용자 생성/권한 부여 스크립트
-- Scope: 초기 환경 구축 및 권한 관리 자동화에 사용

-- PostgreSQL Role and User Creation Script
-- Description: Creates roles and users for Car Center Management System
-- Author: Claude
-- Date: 2024

-- Create Admin Role with DDL privileges
CREATE ROLE carfix_admin_role;

-- Create Admin User
CREATE USER carfix_admin WITH PASSWORD 'Admin@123' IN ROLE carfix_admin_role;

-- Create database (after role and user are created)
CREATE DATABASE carfixdb OWNER carfix_admin;
-- Create carfix schema if not exists

CREATE SCHEMA IF NOT EXISTS carfix;

-- =====================================================
-- IMPORTANT: After running this script, manually switch to 'carfixdb' database in DBeaver
-- Then run the schema creation scripts
-- =====================================================

-- Grant DDL privileges to Admin Role for carfix schema
GRANT ALL PRIVILEGES ON SCHEMA carfix TO carfix_admin_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA carfix TO carfix_admin_role;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA carfix TO carfix_admin_role;

-- Set default privileges for future objects in carfix schema
ALTER DEFAULT PRIVILEGES IN SCHEMA carfix GRANT ALL PRIVILEGES ON TABLES TO carfix_admin_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA carfix GRANT ALL PRIVILEGES ON SEQUENCES TO carfix_admin_role;

-- Create Developer Role with DML privileges
CREATE ROLE carfix_developer_role;

-- Grant DML privileges to Developer Role for carfix schema
GRANT USAGE ON SCHEMA carfix TO carfix_developer_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA carfix TO carfix_developer_role;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA carfix TO carfix_developer_role;

-- Set default privileges for future objects in carfix schema
ALTER DEFAULT PRIVILEGES IN SCHEMA carfix GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO carfix_developer_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA carfix GRANT USAGE ON SEQUENCES TO carfix_developer_role;

-- Create Developer User
CREATE USER carfix_developer WITH PASSWORD 'Dev@123' IN ROLE carfix_developer_role;

-- Grant schema ownership to admin role
ALTER SCHEMA carfix OWNER TO carfix_admin_role;

-- Create API Role for external interface integration
CREATE ROLE carfix_api_role;


-- Default privileges for future interface tables
ALTER DEFAULT PRIVILEGES IN SCHEMA carfix GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO carfix_api_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA carfix GRANT USAGE ON SEQUENCES TO carfix_api_role;

-- Create API User
CREATE USER carfix_api WITH PASSWORD 'Api@123' IN ROLE carfix_api_role;

-- Create Read-Only Role for reporting and analytics
CREATE ROLE carfix_readonly_role;

-- Grant read-only privileges to Read-Only Role for carfix schema
GRANT USAGE ON SCHEMA carfix TO carfix_readonly_role;
GRANT SELECT ON ALL TABLES IN SCHEMA carfix TO carfix_readonly_role;

-- Set default privileges for future objects in carfix schema
ALTER DEFAULT PRIVILEGES IN SCHEMA carfix GRANT SELECT ON TABLES TO carfix_readonly_role;

-- Create Read-Only User
CREATE USER carfix_readonly WITH PASSWORD 'Read@123' IN ROLE carfix_readonly_role;

-- Note: Please change the password in production environment

-- Note: The actual passwords should be stored securely and not in version control 
