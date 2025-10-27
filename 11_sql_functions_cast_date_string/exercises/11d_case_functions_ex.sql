/* Q1. For each airport get some summary statistics about the flights acitivity:
 *      How many incoming and departing flights per day on average?
 * 	    How many departing flights that are delayed, on_time or too_early per day on average? 
 * 	    How many connecting airports?
 *		Can you come up with some more interesting metrics?
 * 	    Answer all questions with a single query.
 */

SELECT *
FROM flights

SELECT *
FROM airports

SELECT pg_typeof(flight_date)
FROM flights

How many incoming and departing flights per day on average?

--CTE method:
WITH daily_counts AS (
       SELECT flight_date::DATE,
           COUNT(dep_time) AS departing_flights,
           COUNT(arr_time) AS incoming_flights
       FROM flights
       WHERE cancelled = 0
       GROUP BY flight_date 
)
SELECT 
    ROUND(AVG(departing_flights), 2) AS avg_departing_flights_per_day,
    ROUND(AVG(incoming_flights), 2) AS avg_incoming_flights_per_day
FROM daily_counts 
    
--Subquery:

SELECT 
    ROUND(AVG(departing_flights), 2) AS avg_departing_flights_per_day,
    ROUND(AVG(incoming_flights), 2) AS avg_incoming_flights_per_day
FROM (
    SELECT 
       COUNT(dep_time) AS departing_flights,
       COUNT(arr_time) AS incoming_flights
    FROM flights
    WHERE cancelled = 0
    GROUP BY flight_date 
) AS daily_counts

How many departing flights that are delayed, on_time or too_early per day on average? 

--Check how many flights have no information of arrival delay which means the status is unkown
SELECT flight_date,
       COUNT(flight_date) AS unkown_flights
FROM flights
WHERE arr_delay IS NULL 
GROUP BY flight_date

--cte method:
WITH status_check AS (
     SELECT flight_date::DATE,
            (CASE 
		         WHEN arr_delay < 0 THEN 'too_early'
		         WHEN arr_delay = 0 THEN 'on time'
		         WHEN arr_delay > 0 THEN 'delayed'
		         ELSE 'unkown'  -- there are missing arrival delay information
	 	     END) AS status 
	 FROM flights
),
count_flights AS (
      SELECT flight_date, 
             status,
		     COUNT(status) AS total_flights
	  FROM status_check
      GROUP BY flight_date, status
)
SELECT 
    count_flights.status,
    ROUND(AVG(total_flights),2) AS avg_flights
FROM count_flights
GROUP BY count_flights.status  
ORDER BY avg_flights DESC

--cte method:
WITH status_check AS (
     SELECT flight_date::DATE,
            (CASE 
		         WHEN arr_delay < 0 THEN 'too_early'
		         WHEN arr_delay = 0 THEN 'on time'
		         WHEN arr_delay > 0 THEN 'delayed'
		         ELSE 'unkown'  -- there are missing arrival delay information
	 	     END) AS status 
	 FROM flights
),
count_flights AS (
      SELECT flight_date, 
             status,
		     COUNT(status) AS total_flights
	  FROM status_check
      GROUP BY flight_date, status
),
count_average_flights AS (
      SELECT 
          count_flights.status,
          ROUND(AVG(total_flights),2) AS avg_flights
      FROM count_flights
      GROUP BY count_flights.status  
)
SELECT 
   count_average_flights.status,
   count_average_flights.avg_flights
FROM count_average_flights
GROUP BY count_average_flights.status, count_average_flights.avg_flights
ORDER BY count_average_flights.avg_flights DESC

-- normal method: Rewrite
SELECT 
  ROUND(AVG(total_flights),2) AS avg_flights
FROM (
   SELECT 
      flight_date::DATE,
      CASE 
         WHEN arr_delay < 0 THEN 'too_early'
         WHEN arr_delay = 0 THEN 'on_time'
         WHEN arr_delay > 0 THEN 'delayed'
         ELSE 'unknown'  -- handle missing values
      END AS status,
      COUNT(*) AS total_flights
  FROM flights
  GROUP BY flight_date, status
  ORDER BY flight_date, status
) AS punctuality_counts

How many connecting airports?

WITH count_connecting_airports AS (
    SELECT COUNT(*) AS total_connecting_airports
    FROM airports AS a
    WHERE a.faa NOT IN (
        SELECT origin FROM flights WHERE origin IS NOT NULL
    )
    AND a.faa NOT IN (
        SELECT dest FROM flights WHERE dest IS NOT NULL
    )
)
SELECT *
FROM count_connecting_airports;


SELECT *
FROM airports
WHERE faa NOT IN (
    SELECT origin
    FROM flights
)
AND faa NOT IN (
    SELECT dest
    FROM flights
)


SELECT COUNT(faa) AS total_connecting_airports
FROM airports
WHERE faa NOT IN (
    SELECT origin
    FROM flights
    WHERE origin IS NOT NULL
)
AND faa NOT IN (
    SELECT dest
    FROM flights
    WHERE dest IS NOT NULL 
)

Answer all questions with a single query.
--method 1: CTE without base

WITH 
daily_counts AS (
  SELECT 
     ROUND(AVG(departing_flights), 2) AS avg_departing_flights_per_day,
     ROUND(AVG(incoming_flights), 2) AS avg_incoming_flights_per_day
  FROM (
     SELECT 
        COUNT(dep_time) AS departing_flights,
        COUNT(arr_time) AS incoming_flights
     FROM flights
     WHERE cancelled = 0
     GROUP BY flight_date 
       ) AS counts_per_day
),
WITH status_check AS (
     SELECT flight_date::DATE,
            (CASE 
		         WHEN arr_delay < 0 THEN 'too_early'
		         WHEN arr_delay = 0 THEN 'on time'
		         WHEN arr_delay > 0 THEN 'delayed'
		         ELSE 'unkown'  -- there are missing arrival delay information
	 	     END) AS status 
	 FROM flights
),
count_flights AS (
      SELECT flight_date, 
             status,
		     COUNT(status) AS total_flights
	  FROM status_check
      GROUP BY flight_date, status
),
count_average_flights AS (
      SELECT 
          count_flights.status,
          ROUND(AVG(total_flights),2) AS avg_flights
      FROM count_flights
      GROUP BY count_flights.status  
),
connecting_airports_counts AS (
  SELECT COUNT(faa) AS total_connecting_airports
  FROM airports
  WHERE faa NOT IN (
    SELECT origin
    FROM flights
    WHERE origin IS NOT NULL
  )
  AND faa NOT IN (
    SELECT dest
    FROM flights
    WHERE dest IS NOT NULL 
  )
)
SELECT 
    daily_counts.avg_departing_flights_per_day,
    daily_counts.avg_incoming_flights_per_day,
    punctuality_counts.avg_flights_per_day,
    connecting_airports_counts.total_connecting_airports
FROM daily_counts 
CROSS JOIN punctuality_counts
CROSS JOIN connecting_airports_counts 

--Method 2: CTE with base
WITH base AS (
    SELECT flight_date::DATE, dep_time, arr_time, arr_delay, cancelled, origin, dest
    FROM flights
),
daily_counts AS (
  SELECT 
     ROUND(AVG(departing_flights), 2) AS avg_departing_flights_per_day,
     ROUND(AVG(incoming_flights), 2) AS avg_incoming_flights_per_day  -- to calculate the average of all the daily departing and incoming flights 
  FROM (
     SELECT 
        COUNT(dep_time) AS departing_flights,
        COUNT(arr_time) AS incoming_flights
     FROM base
     WHERE cancelled = 0
     GROUP BY flight_date 
       ) AS counts_per_day  --Subquery to count the total number of departing and incoming flights per day
),  
punctuality_counts AS (
  SELECT 
     ROUND(AVG(total_flights),2) AS avg_flights_per_day
  FROM (
     SELECT 
        flight_date::DATE,
        CASE 
           WHEN arr_delay < 0 THEN 'too_early'
           WHEN arr_delay = 0 THEN 'on_time'
           WHEN arr_delay > 0 THEN 'delayed'
           ELSE 'unknown'  
        END AS status,
        COUNT(*) AS total_flights
     FROM base
     GROUP BY flight_date, status
     ) AS daily_status_counts
),
connecting_airports_counts AS (
  SELECT COUNT(faa) AS total_connecting_airports
  FROM airports
  WHERE faa NOT IN (
    SELECT origin
    FROM base
    WHERE origin IS NOT NULL
  )
  AND faa NOT IN (
    SELECT dest
    FROM base
    WHERE dest IS NOT NULL 
  )
)
SELECT 
    daily_counts.avg_departing_flights_per_day,
    daily_counts.avg_incoming_flights_per_day,
    punctuality_counts.flight_date::DATE,
    punctuality_counts.status,
    punctuality_counts.total_flights,
    connecting_airports_counts.total_connecting_airports
FROM daily_counts 
CROSS JOIN punctuality_counts
CROSS JOIN connecting_airports_counts 
ORDER BY punctuality_counts.flight_date, punctuality_counts.status;

--method 3: 
-- 1️⃣ Daily averages
SELECT 
    ROUND(AVG(departing_flights), 2) AS avg_departing_flights_per_day,
    ROUND(AVG(incoming_flights), 2) AS avg_incoming_flights_per_day
FROM (
    SELECT 
       COUNT(dep_time) AS departing_flights,
       COUNT(arr_time) AS incoming_flights
    FROM flights
    WHERE cancelled = 0
    GROUP BY flight_date 
) AS daily_counts

-- 2️⃣ Delay breakdown
SELECT 
    flight_date::DATE,
    CASE 
        WHEN arr_delay < 0 THEN 'too_early'
        WHEN arr_delay = 0 THEN 'on_time'
        WHEN arr_delay > 0 THEN 'delayed'
        ELSE 'unknown'
    END AS status,
    COUNT(*) AS total_flights
FROM flights
GROUP BY flight_date, status
ORDER BY flight_date, status;

-- 3️⃣ Connecting airports
SELECT COUNT(faa) AS total_connecting_airports
FROM airports
WHERE faa NOT IN (
    SELECT origin FROM flights WHERE dest IS NOT NULL
)
AND faa NOT IN (
    SELECT dest FROM flights WHERE dest IS NOT NULL
);

