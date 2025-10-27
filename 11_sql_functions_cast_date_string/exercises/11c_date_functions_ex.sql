/* Exercises
 * Now it's time to put what you've learned into practice.
 * The following exercises need to be solved using the flights and airports table from the PostgreSQL database 
 * you've already worked with.
 * Challenge your understanding and try to come up with the correct solution.
 *
 *
 * 1. What's the current date?
 *    Please provide the query below.
 */

SELECT NOW() AS timestamp_with_time_zone;
SELECT CURRENT_TIMESTAMP AS curr_timestamp_with_time_zone;
SELECT CURRENT_DATE AS curr_date_without_time_zone;
SELECT CURRENT_TIME AS curr_date_without_time_zone;


/* 2.1 Return the current timestamp and truncate it to the current month.
 *     Please provide the query below.
 */   

SELECT DATE_TRUNC('month', CURRENT_TIMESTAMP) AS trunc_month;

SELECT DATE_TRUNC('month', NOW ()) AS trunc_month;

SELECT DATE_PART('month', CURRENT_TIMESTAMP) AS timestamp_month;

/* 2.2 Return a sorted list of all unique flight dates available in the flights table.
 *     Please provide the query below.
 */   

SELECT DISTINCT (LEFT(CAST(flights.flight_date AS VARCHAR), 10)) AS flight_date_cleaned
FROM flights
ORDER BY flight_date_cleaned

/* 2.3 Return a sorted list of all unique flight dates available in the flights table and add 30 days and 12 hours to each date.
 *     Please provide the query below.
 */   

SELECT DISTINCT (CAST(LEFT(CAST(flights.flight_date AS VARCHAR), 10) AS TIMESTAMP) + INTERVAL '30 days' + INTERVAL '12 hours') AS flight_date_cleaned
FROM flights
ORDER BY flight_date_cleaned


/* 3.1 Return the hour of the current timestamp.
 *     Please provide the query below.
 */

SELECT DATE_TRUNC('hour', CURRENT_TIMESTAMP) AS trunc_hour;

/* 3.2 Sum up all unique days of the flight dates available in the flights table.
 *     Please provide the query below.
 */
SELECT DATE_TRUNC('day', flights.flight_date) AS trunc_day
FROM flights

--method 1:
SELECT SUM(DISTINCT EXTRACT (DAY FROM flight_date))
FROM flights;

--method 2:
SELECT SUM(DISTINCT CAST(SUBSTRING(CAST(flights.flight_date AS VARCHAR) FROM 9 FOR 2) AS INT)) AS sum_flight_day
FROM flights;

--method 3:
SELECT SUM(DISTINCT DATE_PART('day', flight_date)) AS sum_flight_day
FROM flights

/*
 * 3.3 Split all unique flight dates into three separate columns: year, month, day. 
 *     Use these columns in an outer query and recreate an ordered list of all flight_dates.
 */
SELECT DISTINCT 
       DATE_PART('year', flight_date) AS flight_year,
       DATE_PART('month', flight_date) AS flight_month,
       DATE_PART('day', flight_date) AS flight_day
FROM flights

