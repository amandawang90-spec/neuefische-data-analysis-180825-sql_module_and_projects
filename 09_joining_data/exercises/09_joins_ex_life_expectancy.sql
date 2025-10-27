/* # JOINS - Exercises */
/* JOINS with Tables: 'life_expectancy' and 'regions'  */

SELECT * FROM life_expectancy AS le

SELECT * FROM regions AS r

CREATE TABLE  merged_life_expectancy AS
SELECT 
    le.*,           -- all columns from life_expectancy
    r.region        -- only the non-overlapping columns from regions
FROM life_expectancy AS le
FULL JOIN regions AS r
ON le.country = r.country;

DROP VIEW merged_life_expectancy 

SELECT * FROM merged_life_expectancy 

/* Q1. Please calculate the average life expectancy for each country.
 * 	 		Include the names of the region and of the country.
 * 			Include information what are the first and last year considered.
 */ 

SELECT country,
       region,
       round(AVG(life_expectancy),2) AS avg_life_expectancy,
       MIN(year) AS first_year,
       MAX(year) AS last_year
FROM merged_life_expectancy
WHERE country IS NOT NULL AND region IS NOT NULL 
GROUP BY country, region
ORDER BY avg_life_expectancy DESC;

/* Q2. Please calculate the average life expectancy per region. 
 * 			Include the number of countries that were considered, the years for period_start and period_end 
 * 			in your output.
 * 			Which region has the highest? 
 * 			
 * 			Note: We compressed a lot of countries and different years.
 */ 

SELECT region,
       count(DISTINCT country) AS total_countries,
       round(AVG(life_expectancy),2) AS avg_life_expectancy,
       MIN(year) AS period_start,
       MAX(year) AS period_end
FROM merged_life_expectancy
WHERE country IS NOT NULL AND region IS NOT NULL 
GROUP BY region
ORDER BY avg_life_expectancy DESC;

/* Q3. What was the average life expectancy per region in year 2024
 */ 
SELECT region,
       year,
       count(DISTINCT country) AS total_countries,
       round(AVG(life_expectancy),2) AS avg_life_expectancy
FROM merged_life_expectancy
WHERE country IS NOT NULL AND region IS NOT NULL AND YEAR = '2024'
GROUP BY region, year
ORDER BY avg_life_expectancy DESC;

/* Q4. Present the global development of the average life expectancy over time.
 */ 

SELECT region,
       year,
       count(DISTINCT country) AS total_countries,
       round(AVG(life_expectancy),2) AS avg_life_expectancy
FROM merged_life_expectancy
WHERE country IS NOT NULL AND region IS NOT NULL
GROUP BY region, year
ORDER BY region;

SELECT country,
       year,
       round(AVG(life_expectancy),2) AS avg_life_expectancy
FROM merged_life_expectancy
WHERE country IS NOT NULL AND region IS NOT NULL
GROUP BY country, year
ORDER BY country, year;

/* BONUS: Should be done with JOIN only, without Window functions (not covered yet)
 * Show country and life expectancy in this and last year, add column showing the change in %
 */

ALTER TABLE merged_life_expectancy
ADD COLUMN life_expectancy_change NUMERIC;

ALTER TABLE merged_life_expectancy
DROP COLUMN life_expectancy_change;

DROP TABLE IF EXISTS merged_life_expectancy_2023

CREATE TABLE merged_life_expectancy_2023 AS
SELECT *
FROM merged_life_expectancy 
WHERE YEAR = '2023'

SELECT * FROM merged_life_expectancy_2023

DROP TABLE IF EXISTS merged_life_expectancy_2024

CREATE TABLE merged_life_expectancy_2024 AS
SELECT *
FROM merged_life_expectancy 
WHERE YEAR = '2024'

SELECT * FROM merged_life_expectancy_2024

CREATE TABLE merged_life_expectancy_2023_and_2024 AS
SELECT 
    a.country,
    a.region,
    a.life_expectancy AS life_expectancy_2023,
    b.life_expectancy AS life_expectancy_2024,
    (b.life_expectancy - a.life_expectancy) AS life_expectancy_change
FROM merged_life_expectancy_2023 AS a
JOIN merged_life_expectancy_2024 AS b
ON a.country = b.country;

SELECT * FROM merged_life_expectancy_2023_and_2024

ALTER TABLE merged_life_expectancy_2023_and_2024
ADD COLUMN life_expectancy_change_percentage NUMERIC;

SELECT * FROM merged_life_expectancy_2023_and_2024

UPDATE merged_life_expectancy_2023_and_2024
SET life_expectancy_change_percentage = 
    ((life_expectancy_2024 - life_expectancy_2023) / life_expectancy_2023) * 100
WHERE life_expectancy_2023 <> 0 
 
SELECT * FROM merged_life_expectancy_2023_and_2024

DROP TABLE IF EXISTS merged_life_expectancy_2023

DROP TABLE IF EXISTS merged_life_expectancy_2024

DROP TABLE IF EXISTS merged_life_expectancy_2023_and_2024

SELECT 
    mle_current.country,
    mle_current.year,
    mle_current.life_expectancy AS current_life_expectancy,
    mle_previous.life_expectancy AS previous_life_expectancy,
    ((mle_current.life_expectancy / mle_previous.life_expectancy - 1) * 100) AS "change_in_percent"
FROM merged_life_expectancy AS mle_current
LEFT JOIN merged_life_expectancy AS mle_previous
    ON mle_current.country = mle_previous.country
    AND mle_current.year = mle_previous.year + 1;


-- what if we need it per region
CREATE TABLE region_avg_life_expectancy AS 
SELECT region,
       year,
       count(DISTINCT country) AS total_countries,
       round(AVG(life_expectancy),2) AS avg_life_expectancy
FROM merged_life_expectancy
WHERE country IS NOT NULL AND region IS NOT NULL
GROUP BY region, year
ORDER BY region;

SELECT * FROM region_avg_life_expectancy AS rale

SELECT 
    rale_current.region,
    rale_current.year,
    rale_current.avg_life_expectancy AS current_avg_life_expectancy,
    rale_previous.avg_life_expectancy AS previous_avg_life_expectancy,
    ((rale_current.avg_life_expectancy / rale_previous.avg_life_expectancy - 1) * 100) AS "change_in_percent"
FROM region_avg_life_expectancy AS rale_current
LEFT JOIN region_avg_life_expectancy AS rale_previous
    ON rale_current.region = rale_previous.region 
    AND rale_current.year = rale_previous.year + 1
ORDER BY rale_current.region, rale_current.year;
