-- 데이터베이스 생성 (이미 생성되어 있으므로 주석 처리)
-- CREATE DATABASE car_center_db WITH ENCODING 'UTF8' LC_COLLATE='ko_KR.UTF-8' LC_CTYPE='ko_KR.UTF-8';

-- 사용자 권한 설정
GRANT ALL PRIVILEGES ON DATABASE car_center_db TO car_center_user;

-- 스키마 생성
CREATE SCHEMA IF NOT EXISTS car_center;
GRANT ALL ON SCHEMA car_center TO car_center_user;

-- 기본 확장 모듈 설치
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 타임존 설정
SET timezone = 'Asia/Seoul';
