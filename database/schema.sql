--- Database Schema Definition---
--- Creating tables for tennis data management ---

-- =========================================
-- Tennis Analytics System – MSSQL Schema
-- =========================================

-- =====================
-- 1. Categories
-- =====================
CREATE TABLE categories (
    category_id VARCHAR(50) PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);
-- =====================
-- 2. Complexes
CREATE TABLE complexes (
    complex_id VARCHAR(50) PRIMARY KEY,
    complex_name VARCHAR(100) NOT NULL
);


-- =====================
-- 3. Competitors
-- =====================
CREATE TABLE competitors (
    competitor_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    country_code CHAR(3) NOT NULL,
    abbreviation VARCHAR(10) NOT NULL
);


-- =====================
-- 4. Competitions
-- =====================
CREATE TABLE competitions (
    competition_id VARCHAR(50) PRIMARY KEY,
    competition_name VARCHAR(100) NOT NULL,
    parent_id VARCHAR(50),
    type VARCHAR(20) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    category_id VARCHAR(50),
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    FOREIGN KEY (parent_id) REFERENCES competitions(competition_id)
);



-- =====================
-- 5. Venues
-- =====================
CREATE TABLE venues (
    venue_id VARCHAR(50) PRIMARY KEY,
    venue_name VARCHAR(100) NOT NULL,
    city_name VARCHAR(100) NOT NULL,
    country_name VARCHAR(100) NOT NULL,
    country_code CHAR(3) NOT NULL,
    timezone VARCHAR(100) NOT NULL,
    complex_id VARCHAR(50),
    FOREIGN KEY (complex_id) REFERENCES complexes(complex_id)
);




