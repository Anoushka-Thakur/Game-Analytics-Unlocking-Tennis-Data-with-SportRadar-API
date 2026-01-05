
-- SQL Analysis completed after data validation
-- Foreign key relationships verified
-- Staging tables dropped post-load
-- Dataset limitations documented where applicable

--- SQL ANALYSIS QUERIES---

--- COMPETITION & CATEGORY SQL QUERIES---

---1 List all competitions along with their category name---
SELECT
    comp.competition_id,
    comp.competition_name,
    cat.category_name
FROM competitions comp
JOIN categories cat
    ON comp.category_id = cat.category_id
ORDER BY cat.category_name, comp.competition_name;

---2 Count the number of competitions in each category---
SELECT
    cat.category_name,
    COUNT(comp.competition_id) AS total_competitions
FROM categories cat
LEFT JOIN competitions comp
    ON cat.category_id = comp.category_id
GROUP BY cat.category_name
ORDER BY total_competitions DESC;

--- 3 Find all competitions of type 'doubles'---
SELECT
    competition_id,
    competition_name,
    type
FROM competitions
WHERE LOWER(type) = 'doubles';

--- 4 Get competitions that belong to a specific category---
SELECT
    comp.competition_id,
    comp.competition_name
FROM competitions comp
JOIN categories cat
    ON comp.category_id = cat.category_id
WHERE cat.category_name = 'ATP';

SELECT DISTINCT category_name
FROM categories;

--- 5 Identify parent competitions and their sub-competitions---
SELECT
    parent.competition_name AS parent_competition,
    child.competition_name AS sub_competition
FROM competitions child
JOIN competitions parent
    ON child.parent_id = parent.competition_id
ORDER BY parent_competition;

SELECT COUNT(*) AS parent_links
FROM competitions
WHERE parent_id IS NOT NULL;

-- Note: No parent-child competition relationships exist in the dataset.
-- parent_id values are NULL, so this query returns no rows.

--- 6 Analyze the distribution of competition types by category---
SELECT
    cat.category_name,
    comp.type,
    COUNT(*) AS total_competitions
FROM competitions comp
JOIN categories cat
    ON comp.category_id = cat.category_id
GROUP BY cat.category_name, comp.type
ORDER BY cat.category_name, total_competitions DESC;

---7 List all competitions with no parent (top-level competitions)---
SELECT
    competition_id,
    competition_name
FROM competitions
WHERE parent_id IS NULL;


---VENUE & COMPLEX SQL QUERIES---

---1 List all venues along with their complex name---
SELECT
    v.venue_id,
    v.venue_name,
    c.complex_name
FROM venues v
JOIN complexes c
    ON v.complex_id = c.complex_id
ORDER BY c.complex_name, v.venue_name;

---2 Count the number of venues in each complex---
SELECT
    c.complex_name,
    COUNT(v.venue_id) AS total_venues
FROM complexes c
LEFT JOIN venues v
    ON c.complex_id = v.complex_id
GROUP BY c.complex_name
ORDER BY total_venues DESC;

--- 3 Get details of venues in a specific country---
SELECT
    venue_id,
    venue_name,
    city_name,
    country_name,
    timezone
FROM venues
WHERE country_name = 'Chile';

---4 Identify all venues and their timezones
SELECT
    venue_name,
    timezone
FROM venues
ORDER BY timezone;

---5 Find complexes that have more than one venue---
SELECT
    c.complex_name,
    COUNT(v.venue_id) AS total_venues
FROM complexes c
JOIN venues v
    ON c.complex_id = v.complex_id
GROUP BY c.complex_name
HAVING COUNT(v.venue_id) > 1;

---6 List venues grouped by country---
SELECT
    country_name,
    COUNT(*) AS total_venues
FROM venues
GROUP BY country_name
ORDER BY total_venues DESC;

---7 Find all venues for a specific complex---
SELECT
    v.venue_id,
    v.venue_name,
    v.city_name
FROM venues v
JOIN complexes c
    ON v.complex_id = c.complex_id
WHERE c.complex_name = 'Nacional Tennis Complex';

SELECT DISTINCT complex_name FROM complexes;


--- COMPETITOR & RANKING SQL QUERIES---

---1 Get all competitors with their rank and points---
SELECT
    c.competitor_id,
    c.name,
    c.country,
    cr.rank,
    cr.points
FROM competitors c
JOIN competitor_rankings cr
    ON c.competitor_id = cr.competitor_id
ORDER BY cr.rank;

---2 Find competitors ranked in the Top 5---
SELECT
    c.name,
    c.country,
    cr.rank,
    cr.points
FROM competitors c
JOIN competitor_rankings cr
    ON c.competitor_id = cr.competitor_id
WHERE cr.rank <= 5
ORDER BY cr.rank;

---3 List competitors with no rank movement (stable rank)---
-- Rank movement analysis cannot be performed
-- because the dataset does not contain previous_rank or historical rankings.

---4 Get total points of competitors from a specific country---
SELECT
    c.country,
    SUM(cr.points) AS total_points
FROM competitors c
JOIN competitor_rankings cr
    ON c.competitor_id = cr.competitor_id
WHERE c.country = 'Croatia'
GROUP BY c.country;

---5 Count the number of competitors per country---
SELECT
    country,
    COUNT(*) AS total_competitors
FROM competitors
GROUP BY country
ORDER BY total_competitors DESC;

---6 Find competitors with the highest points in the current week---
SELECT
    c.name,
    c.country,
    cr.points
FROM competitors c
JOIN competitor_rankings cr
    ON c.competitor_id = cr.competitor_id
WHERE cr.points = (
    SELECT MAX(points) FROM competitor_rankings
);

---Final quick checks---
SELECT COUNT(*) FROM competitors;
SELECT COUNT(*) FROM competitor_rankings;
SELECT COUNT(*) FROM venues;
SELECT COUNT(*) FROM competitions;
