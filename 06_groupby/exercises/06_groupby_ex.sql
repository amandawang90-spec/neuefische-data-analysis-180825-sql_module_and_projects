-- GROUP BY Exercises

SELECT *
FROM flights;

SELECT *
FROM airports;

/* Q1.1 Which country has the highest number of airports?
 *       Please provide the query and answer below.
 */

SELECT country,
	   COUNT(*) AS total_airports
FROM airports
GROUP BY country
ORDER BY total_airports DESC;

 /* Q1.2 Change the query of Q1, so that we also see the timezone along with the country.
 *       Please provide the query and answer below.
 */

SELECT country,
       tz,
	   COUNT(*) AS total_airports
FROM airports
GROUP BY country, tz
ORDER BY total_airports DESC;

/* Q2. Which city has the highest number of airports?
         Hint: there are many cities with the same name.
 *       Please provide the query and answer below.
 */
SELECT country,
	   city,
       COUNT(*) AS total_airports
FROM airports
WHERE city IS NOT NULL
GROUP BY country, city
ORDER BY total_airports DESC;


 /* Q3. What's the average altitude of airports per country?
 *       Please provide the query and answer below.
 */

SELECT 
    country,
    AVG(alt) AS avg_airport_altitude,  -- using average
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY alt)  -- using median instead of average, in oracle we can use median directly, different databases have different dialects.
        AS median_airport_altitude
FROM airports
GROUP BY country
ORDER BY avg_airport_altitude DESC;


/* Q4. Only show airports of the US. Which city of the US has the highest number of airports?
 * 		 (bonus: Which city of the US has the airport with the highest altitude?) 
 *       Please provide the query and answer below.
 */

SELECT city,
       COUNT(faa) AS total_airports,
       --MAX(alt) AS max_airport_altitude
FROM airports
WHERE country = 'United States'
GROUP BY city
ORDER BY total_airports DESC;
-- ORDER BY avg_airport_altitude DESC;

/* Q5. Which plane has flown the most flights? Provide the plane number, the airline it belongs to, and how often was it in the air?
 *      Hint: cancelled is not "in the air"
 *      Please provide the query and answer below.
 */

SELECT 
    tail_number,
    airline,
    COUNT(*) AS total_flights
FROM flights
WHERE tail_number IS NOT NULL AND cancelled != 1
GROUP BY tail_number, airline
ORDER BY total_flights DESC;

/* Q6. How many planes have flown just a single flight?
 * 		Please provide the query and answer below.
 */

SELECT 
    tail_number,
    COUNT(*) AS total_flights
FROM flights
WHERE cancelled = 0 AND tail_number IS NOT NULL 
GROUP BY tail_number
HAVING COUNT(*)='1';

/* Q7. Let's understand our airlines a bit better...
* Please summarize in one table the following performance metrics per airline:
* - the nr of total flights
* - the average time in the air per flight
* - the average distance flown per flight
* - the maximum delay on arriving
 */

SELECT 
     airline,
     COUNT(*) AS total_flights,
     AVG(actual_elapsed_time) AS avg_airtime,
     AVG(distance) AS avg_distance,
     MAX(arr_delay) * '1 minute':: INTERVAL AS max_delay_hh_mm_ss
FROM flights
WHERE cancelled != 1
GROUP BY airline
ORDER BY total_flights DESC;

