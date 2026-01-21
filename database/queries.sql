
-- SQL Analysis completed after data validation
    -- Foreign key relationships verified
-- Dataset limitations documented where applicable

/* =========================================================
   Tennis Analytics System – MSSQL Queries
   ========================================================= */



-- COMPETITIONS – ANALYSIS QUERIES
-- 1. List all competitions with their category name
SELECT c.competition_name, cat.category_name
FROM competitions c
JOIN categories cat
ON c.category_id = cat.category_id;

--2. Count competitions in each category
SELECT cat.category_name, COUNT(*) AS competition_count
FROM competitions c
JOIN categories cat
ON c.category_id = cat.category_id
GROUP BY cat.category_name;

-- 3. Find all doubles competitions
SELECT *
FROM competitions
WHERE type = 'doubles';

--4. Competitions under a specific category (e.g., ITF Men)
SELECT c.*
FROM competitions c
JOIN categories cat
ON c.category_id = cat.category_id
WHERE cat.category_name = 'ITF Men';

--5. Parent competitions with sub-competitions
SELECT parent.competition_name AS parent_competition,
       child.competition_name AS sub_competition
FROM competitions parent
JOIN competitions child
ON parent.competition_id = child.parent_id;

--6. Distribution of competition types by category
SELECT cat.category_name, c.type, COUNT(*) AS count
FROM competitions c
JOIN categories cat
ON c.category_id = cat.category_id
GROUP BY cat.category_name, c.type;

--7. Top-level competitions (no parent)
SELECT *
FROM competitions
WHERE parent_id IS NULL;

--2️ COMPLEXES & VENUES – ANALYSIS QUERIES
--1. List venues with complex name
SELECT v.venue_name, c.complex_name
FROM venues v
JOIN complexes c
ON v.complex_id = c.complex_id;

--2. Count venues per complex
SELECT c.complex_name, COUNT(v.venue_id) AS venue_count
FROM complexes c
LEFT JOIN venues v
ON c.complex_id = v.complex_id
GROUP BY c.complex_name;

--3. Venues in a specific country (e.g., Chile)
SELECT *
FROM venues
WHERE country_name = 'Chile';

--4. Venues with their timezones
SELECT venue_name, timezone
FROM venues;

--5. Complexes with more than one venue
SELECT c.complex_name
FROM complexes c
JOIN venues v
ON c.complex_id = v.complex_id
GROUP BY c.complex_name
HAVING COUNT(v.venue_id) > 1;

--6. Venues grouped by country
SELECT country_name, COUNT(*) AS venue_count
FROM venues
GROUP BY country_name;

--7. Venues for a specific complex (e.g., Nacional)
SELECT v.*
FROM venues v
JOIN complexes c
ON v.complex_id = c.complex_id
WHERE c.complex_name = 'Nacional';


--3️ COMPETITOR RANKINGS 
--1. Competitors with rank and points
SELECT c.name, r.rank, r.points
FROM competitors c
JOIN competitor_rankings r
ON c.competitor_id = r.competitor_id;

--2. Top 5 ranked competitors
SELECT c.name, r.rank
FROM competitors c
JOIN competitor_rankings r
ON c.competitor_id = r.competitor_id
WHERE r.rank <= 5;

--3. Competitors with no rank movement
SELECT c.name
FROM competitors c
JOIN competitor_rankings r
ON c.competitor_id = r.competitor_id
WHERE r.movement = 0;

--4. Total points by country (e.g., Croatia)
SELECT c.country, SUM(r.points) AS total_points
FROM competitors c
JOIN competitor_rankings r
ON c.competitor_id = r.competitor_id
WHERE c.country = 'Croatia'
GROUP BY c.country;

--5. Competitor count per country
SELECT country, COUNT(*) AS competitor_count
FROM competitors
GROUP BY country;

--6. Competitor(s) with highest points
SELECT c.name, r.points
FROM competitors c
JOIN competitor_rankings r
ON c.competitor_id = r.competitor_id
WHERE r.points = (
    SELECT MAX(points)
    FROM competitor_rankings
);

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'competitor_rankings';


