-- Functions for Aggregation Data in SQL

SELECT *
FROM flights;

SELECT *
FROM airports;

/* Q1.1 What is the total number of rows in the flights table?
 * 		Please provide the query and answer below.
 */

SELECT COUNT(*) --if i use *, i will include the null values, if i select dep_time, then i will exclude the null values
FROM flights;

/* Q1.2 What is the total number of unique airlines in the flights table?
 * 		Please provide the query and answer below.
 */

SELECT COUNT(DISTINCT (airline))
FROM flights;

/* Q3. How many airports does Germany have?
 *     Please provide the query and answer below.
 */

SELECT COUNT(*)
FROM airports
WHERE country = 'Germany';


/* Q4. How many flights had a departure delay smaller or equal to 0?
 *     Please provide the query and answer below.
 */

SELECT COUNT(*) AS total_flights
FROM flights
WHERE dep_delay <=0;

/* Q5. What's the first day and what's the last day of flight_dates in the flights table?
 *     Please provide the query and answer below.
 */

SELECT MIN(flight_date) AS first_day,
	   MAX(flight_date) AS last_day
FROM flights;

/* Q6. What was the average departure delay of all flights on January 1, 2024.
 *     Please provide the query and answer below.
 */

SELECT AVG(dep_delay) AS avg_dep_delay
FROM flights
WHERE flight_date = '2024-01-01'

/* Q7.1 How many flights have a missing value (NULL value) as their departure time?
 *      Please provide the query and answer below.
 */

SELECT COUNT(*) AS no_dep_time
FROM flights 
WHERE dep_time IS NULL;


/* Q7.2 Out of all flights how many flights were cancelled? 
 *      Is this number equal to the number of flights that have a NULL value as their departure time above?
 *      Please provide the query and answer below.
 */

SELECT COUNT(cancelled) AS num_cancelled_flights
FROM flights 
WHERE cancelled = 1;

SELECT SUM (cancelled) 
FROM flights;

/* Q7.3 The number of canceled_flights (Q7.2) is higher than the no_dep_time (Q7.1), 
 * 		which means there are flight records with departure time (flight started) but the flights were stil cancelled.
 * 		Show those canceled flight with departure time.
 */

SELECT *
FROM flights 
WHERE cancelled = 1 
AND dep_time IS NOT NULL;


/* Q8. What's the total number of flights on January 1, 2024 that have a departure time of NULL or were cancelled?
 *      Please provide the query and answer below.
 */

SELECT COUNT(*) AS total_flights
FROM flights 
WHERE flight_date = '2024-01-01'
	AND (cancelled = 1 OR dep_time IS NULL);


/* Q9. What's the number of airlines that had flights on January 1, 2024 that have a departure time of NULL or were cancelled?
 *      Please provide the query and answer below.
 */

SELECT COUNT(DISTINCT airline) AS total_flights
FROM flights 
WHERE flight_date = '2024-01-01'
	AND (cancelled = 1 OR dep_time IS NULL);

/* Q10. Which airport has the lowest altitude?
 *      Please provide the query and answer below.
 */

SELECT name, alt 
FROM airports
WHERE alt = (SELECT MIN(alt) FROM airports);

/*
 * 
 */

SELECT MIN(alt)
FROM airports;

SELECT name
FROM airports;

SELECT name, alt
FROM airports 
ORDER BY alt
LIMIT 1;

/*
 * 
 */
SELECT name, alt 
FROM airports
ORDER BY alt ASC
LIMIT 1;

/*
 * 
 */
SELECT MIN(alt) FROM airports --output: -1266

SELECT name, alt 
FROM airports
WHERE alt = '-1266'; --input: the result from the query SELECT MIN(alt) FROM airports