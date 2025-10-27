-- getting all the data from airports table
select *
from airports;

-- getting all the data from flights
/* 
 * 
 * 
 * 
 */


SELECT name
FROM airports;


select city,
	   country
FROM airports;

SELECT *
FROM flights
LIMIT 1;

SELECT name, 
	   city, 
	   country
FROM airports
ORDER BY country ASC, city DESC;

SELECT *
FROM life_expectancy
ORDER BY life_expectancy ASC
LIMIT 5;

SELECT *
FROM airports
ORDER BY country;

SELECT DISTINCT airline
FROM flights
ORDER BY airline;

SELECT 
    city, 
    country,
    alt,
    UPPER(country) as country_caps,
		'anything' as random_text,
		alt as alt_ft,
		alt / 3.28084 as alt_m	 
FROM airports
ORDER BY alt;

SELECT flight_date,
	   CASE WHEN dep_delay < 0 THEN 'Early'
			WHEN dep_delay = 0 THEN 'On time'
			ELSE 'Delayed'
	   END AS dep_punctuality   
FROM flights;

SELECT flight_date, dep_delay,
	   CASE WHEN dep_delay < 0 THEN 'Early'
			WHEN dep_delay = 0 THEN 'On time'
	   END AS dep_punctuality   
FROM flights;

Select * 
from flights
limit 20;

Select flight_date, 
			origin,
			dest,
			cancelled
from flights
limit 20;

SELECT name
FROM airports
ORDER BY name DESC;

SELECT DISTINCT country, 
				name
FROM airports;

SELECT country,
		city,
		name
FROM airports
ORDER BY name DESC;

SELECT lat
FROM airports
ORDER BY lat ASC;


SELECT 
    lat,
    -lat AS lat_opp
FROM airports
ORDER BY lat_opp ASC;

SELECT flight_date, 
		dep_delay 
FROM flights;

SELECT flight_date, dep_delay,
	   CASE WHEN dep_delay < -15 THEN '> 15 min Early'
			WHEN dep_delay < 0 AND dep_delay >=-15 THEN '<= 15 min Early'
			WHEN dep_delay = 0 THEN 'On time'
			WHEN dep_delay > 0 AND dep_delay <=15 THEN '<= 15 min Delayed'
			WHEN dep_delay > 15 THEN '> 15 min Delayed'
	   END AS dep_punctuality   
FROM flights;

SELECT  * 
FROM flights
LIMIT 20;

SELECT flight_date, 
		origin,
		dest,
		cancelled
FROM flights
LIMIT 20;

SELECT name,
	   faa
FROM airports
ORDER BY faa DESC;

SELECT DISTINCT country
FROM airports;

SELECT country,
	   city,
	   name
FROM airports
ORDER BY city ASC, name DESC;

SELECT lat
FROM airports
ORDER BY lat ASC;

SELECT faa AS airport_code,
       lat AS latitude,
       lon AS longitude,
       alt AS altitude_feet,
       tz AS timezone_offset_utc,
       dst AS daylight_saving_time
FROM airports;

SELECT faa,
	   name, 
	   city, 
	   country,
	   alt
FROM airports
WHERE faa LIKE 'XS%';

SELECT faa,
       name, 
       city, 
       country,
       alt
FROM airports
WHERE name LIKE '%Love%';

SELECT name, 
       city, 
       country, 
       tz
FROM airports
WHERE tz <= -11
ORDER BY tz;

SELECT name, 
	   city, 
	   country,
	   alt
FROM airports
WHERE alt >= 12400
ORDER BY alt;

SELECT name, 
       city, 
       country
FROM airports
WHERE city = 'London';

SELECT name, 
	   city, 
	   country
FROM airports
WHERE country = 'Iceland';

SELECT name, 
	   city, 
	   country,
	   alt
FROM airports
WHERE city IN ('Hamburg', 'Berlin');

SELECT airline
FROM flights
WHERE airline LIKE '%DL%'
   OR airline LIKE '%NK%'
   OR airline LIKE '%HA%'
   OR airline LIKE '%AS%';

SELECT *
FROM airports
WHERE alt BETWEEN 11001 AND 13355
ORDER BY alt;

SELECT *
FROM flights
WHERE flight_date BETWEEN '2024-01-01' AND '2024-01-03'
ORDER BY flight_date;

SELECT name, 
	   city, 
	   country,
	   alt
FROM airports
WHERE NOT alt >= 12400 AND country <> 'China'
ORDER BY alt;

SELECT name, 
	   city, 
	   country,
	   alt
FROM airports
WHERE country = 'China' OR country = 'Nepal'
ORDER BY country;

SELECT name, 
	   city, 
	   country,
	   alt
FROM airports
WHERE alt >= 12400 AND (country = 'China' OR country = 'Nepal')
ORDER BY alt;

SELECT name, 
       city, 
       country, 
       lat, 
       lon
FROM airports
WHERE (lat < -60 OR lat > 80)
   OR (lon < -179 OR lon > 179)
ORDER BY lat, lon;

SELECT "name", 
       "city", 
       country, 
       lat, 
       lon
FROM airports
WHERE (lat < -60 OR lat > 80)
   OR (lon < -179 OR lon > 179)
ORDER BY lat, lon;

SELECT name, 
	   city, 
	   country
FROM airports
WHERE country = 'Germany' AND city NOT IN ('Hamburg', 'Berlin')
ORDER BY city;

SELECT *
FROM airports
WHERE alt < 12400 OR country NOT IN ('China', 'Nepal')
ORDER BY alt;

SELECT name, 
	   city, 
	   country
FROM airports
WHERE country = 'Philippines' AND city IS NULL;

SELECT name, 
       city, 
       country, 
       tz
FROM airports
WHERE tz IS NULL
  AND city IS NOT NULL;

SELECT name,
       country
FROM airports
WHERE country = 'Canada';

SELECT name,
       alt
FROM airports
WHERE alt BETWEEN 500 AND 1500;

SELECT *
FROM flights
WHERE dep_delay >=0;

SELECT *
FROM flights
WHERE dep_time IS NULL;

SELECT *
FROM airports;

SELECT *
FROM airports
WHERE country in ('Belgium', 'Netherlands', 'Luxembourg');

SELECT *
FROM airports
WHERE country in ('Belgium', 'Netherlands', 'Luxembourg') AND alt<0;

SELECT *
FROM airports
WHERE alt<0;

SELECT * 
FROM flights;

SELECT *
FROM flights
WHERE flight_date = '2023-12-31'
  AND (dep_time IS NULL OR cancelled = 1);

SELECT country,
	   city,
	   name
FROM airports
WHERE city IS NOT NULL
ORDER BY city DESC, name ASC
LIMIT 1;

SELECT alt
FROM airports
ORDER BY alt ASC;

SELECT alt,
       name,
	   - alt AS alt_opp
FROM airports
ORDER BY alt_opp ASC;

SELECT dep_delay,
 	   CASE WHEN dep_delay < -15 THEN '> 15 min Early'
 			WHEN dep_delay < 0 AND dep_delay >=-15 THEN '<= 15 min Early'
			WHEN dep_delay = 0 THEN 'On time'
			WHEN dep_delay > 0 AND dep_delay <=15 THEN '<= 15 min Delayed'
			WHEN dep_delay > 15 THEN '> 15 min Delayed'
	   END AS dep_punctuality   
FROM flights;

SELECT flight_date, dep_delay,
 	   CASE WHEN dep_delay < -15 THEN '> 15 min Early'
 			WHEN dep_delay BETWEEN -15 AND 0 THEN '<= 15 min Early'
			WHEN dep_delay = 0 THEN 'On time'
			WHEN dep_delay BETWEEN 0 AND 15 THEN '<= 15 min Delayed'
			WHEN dep_delay > 15 THEN '> 15 min Delayed'
	   END AS dep_punctuality   
FROM flights;

SELECT flight_date, dep_delay,
 	   CASE WHEN dep_delay < -15 THEN '> 15 min Early'
 			WHEN dep_delay BETWEEN -15 AND -1 THEN '<= 15 min Early'
			WHEN dep_delay = 0 THEN 'On time'
			WHEN dep_delay BETWEEN 1 AND 15 THEN '<= 15 min Delayed'
			WHEN dep_delay > 15 THEN '> 15 min Delayed'
	   END AS dep_punctuality   
FROM flights;

SELECT *
FROM flights
WHERE flight_date = '2023-12-31'
AND (dep_time IS NULL OR cancelled = 1);

SELECT *
FROM flights

SELECT *
FROM flights
WHERE flight_date BETWEEN '2024-01-01' AND '2024-01-03'
ORDER BY flight_date;