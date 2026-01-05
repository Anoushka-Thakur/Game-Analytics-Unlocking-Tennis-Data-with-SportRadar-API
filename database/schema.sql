--- Database Schema Definition---
--- Creating tables for tennis data management ---

-- 1. Categories---
CREATE TABLE categories (
    category_id VARCHAR(50) PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

-- 2. Complexes
CREATE TABLE complexes (
    complex_id VARCHAR(50) PRIMARY KEY,
    complex_name VARCHAR(100) NOT NULL
);

-- 3. Competitors
CREATE TABLE competitors (
    competitor_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    country_code CHAR(3) NOT NULL,
    abbreviation VARCHAR(10) NOT NULL
);

-- 4. Competitions
CREATE TABLE competitions (
    competition_id VARCHAR(50) PRIMARY KEY,
    competition_name VARCHAR(100) NOT NULL,
    parent_id VARCHAR(50) NULL,
    type VARCHAR(20) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    category_id VARCHAR(50) NOT NULL,
    CONSTRAINT fk_competitions_category
        FOREIGN KEY (category_id) REFERENCES categories(category_id),
    CONSTRAINT fk_competitions_parent
        FOREIGN KEY (parent_id) REFERENCES competitions(competition_id)
);

-- 5. Venues
CREATE TABLE venues (
    venue_id VARCHAR(50) PRIMARY KEY,
    venue_name VARCHAR(100) NOT NULL,
    city_name VARCHAR(100) NOT NULL,
    country_name VARCHAR(100) NOT NULL,
    country_code CHAR(3) NOT NULL,
    timezone VARCHAR(100) NOT NULL,
    complex_id VARCHAR(50) NOT NULL,
    CONSTRAINT fk_venues_complex
        FOREIGN KEY (complex_id) REFERENCES complexes(complex_id)
);

-- 6. Competitor Rankings (SQL Server way)
CREATE TABLE competitor_rankings (
    rank_id INT IDENTITY(1,1) PRIMARY KEY,
    rank INT NOT NULL,
    points INT NOT NULL,
    competitor_id VARCHAR(50) NOT NULL,
    CONSTRAINT fk_rankings_competitor
        FOREIGN KEY (competitor_id) REFERENCES competitors(competitor_id)
);


--- Final quick checks ---
--- List all tables in the database---
SELECT name FROM sys.tables;

--- Alternative way to list all tables---
SELECT * FROM INFORMATION_SCHEMA.TABLES;

--- Data Ingestion using BULK INSERT---
--- 1. Ingest Categories Data---
BULK INSERT categories
FROM 'C:\\Users\\anous\\OneDrive\\Documents\\Desktop\\New folder\\microsoft\\Game-Analytics-Unlocking-Tennis-Data-with-SportRadar-API\\categories.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);
--- Verify data ingestion---
SELECT TOP 5 * FROM categories;

--- 2. Ingest Complexes Data---
Bulk insert complexes
FROM 'C:\\Users\\anous\\OneDrive\\Documents\\Desktop\\New folder\\microsoft\\Game-Analytics-Unlocking-Tennis-Data-with-SportRadar-API\\complexes.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);
--- Verify data ingestion---
SELECT COUNT(*) FROM complexes;
SELECT * FROM complexes;

--- 3. Ingest Competitions Data---
BULK INSERT competitions
FROM 'C:\\Users\\anous\\OneDrive\\Documents\\Desktop\\New folder\\microsoft\\Game-Analytics-Unlocking-Tennis-Data-with-SportRadar-API\\competitions.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);
--- Verify data ingestion---
SELECT COUNT(*) FROM competitions;
SELECT * FROM competitions;

--- 4. Ingest Competitor Rankings Data into staging table---
-- Create staging table---
CREATE TABLE rankings_staging (
    competitor_id VARCHAR(50),
    name VARCHAR(100),
    country VARCHAR(100),
    country_code VARCHAR(3),
    abbreviation VARCHAR(10),
    rank INT,
    points INT
);


--- Perform BULK INSERT into staging table---
BULK INSERT rankings_staging
FROM 'C:\Users\anous\OneDrive\Documents\Desktop\New folder\microsoft\Game-Analytics-Unlocking-Tennis-Data-with-SportRadar-API\double_competitor_rankings.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0d0a',
    CODEPAGE = '65001'
);

--- Verify data ingestion in staging table---
SELECT COUNT(*) AS total_rows FROM rankings_staging;
SELECT TOP 5 * FROM rankings_staging;

--- Insert unique competitors into competitors table---
SELECT COUNT(*) AS total_competitors FROM competitors;


--- Insert unique competitors into competitors table---
INSERT INTO competitors (competitor_id, name, country, country_code, abbreviation)
SELECT DISTINCT
    competitor_id,
    name,
    country,
    country_code,
    abbreviation
FROM rankings_staging;
SELECT COUNT(*) AS total_competitors_after_insert FROM competitors;


--- Insert rankings into competitor_rankings table---
INSERT INTO competitor_rankings (rank, points, competitor_id)
SELECT rank, points, competitor_id
FROM rankings_staging;


--- Verify data insertion into competitor_rankings table---
SELECT TOP 10 *
FROM competitor_rankings
ORDER BY rank;


--- 5. Ingest Venues Data---
BULK INSERT venues
FROM 'C:\Users\anous\OneDrive\Documents\Desktop\New folder\microsoft\Game-Analytics-Unlocking-Tennis-Data-with-SportRadar-API\venues.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);


--- Verify data ingestion---
SELECT 'categories' AS table_name, COUNT(*) AS rows FROM categories
UNION ALL
SELECT 'complexes', COUNT(*) FROM complexes
UNION ALL
SELECT 'competitors', COUNT(*) FROM competitors
UNION ALL
SELECT 'competitions', COUNT(*) FROM competitions
UNION ALL
SELECT 'venues', COUNT(*) FROM venues
UNION ALL
SELECT 'competitor_rankings', COUNT(*) FROM competitor_rankings;

--- Final quick checks---
SELECT TOP 5 * FROM categories;
SELECT TOP 5 * FROM complexes;
SELECT TOP 5 * FROM competitors;
SELECT TOP 5 * FROM competitions;
SELECT TOP 5 * FROM venues;
SELECT TOP 5 * FROM competitor_rankings;

--- Check for duplicate category IDs---
SELECT category_id, COUNT(*)
FROM categories
GROUP BY category_id
HAVING COUNT(*) > 1;


--- checking nulls--
-- Competitors
SELECT * FROM competitors
WHERE competitor_id IS NULL
   OR name IS NULL
   OR country IS NULL;

-- Venues
SELECT * FROM venues
WHERE venue_id IS NULL
   OR venue_name IS NULL
   OR complex_id IS NULL;

-- Rankings
SELECT * FROM competitor_rankings
WHERE competitor_id IS NULL
   OR rank IS NULL
   OR points IS NULL;

--- Clean up staging table---
DROP TABLE rankings_staging;



