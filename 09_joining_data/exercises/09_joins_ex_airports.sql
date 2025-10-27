/* # JOINS - Exercises */

/* JOINS with Tables: 'flights' and 'airports'  */

SELECT * FROM flights 

SELECT * FROM airports

CREATE TABLE merged_flights AS
SELECT * 
FROM flights
JOIN airports
ON flights.origin = airports.faa

SELECT * FROM merged_flights

/* Q1. What was the longest flight? (not using JOIN yet) 
 * Hint: NULL values are the first in a descending ORDER BY. You might need a filter for that.
 */

SELECT MAX(air_time) AS longest_flight
FROM flights 

SELECT MAX(air_time) AS longest_flight  --723
FROM merged_flights 

/* Q2. From which airport the longest flight? (now with JOIN)
 * Hint: NULL values are the first in a descending ORDER BY. You might need a filter for that.
 */

SELECT airline,
       air_time
FROM merged_flights
WHERE air_time =(SELECT MAX(air_time) AS longest_flight FROM merged_flights)  --OPTION 1

SELECT name,
       air_time
FROM merged_flights
WHERE air_time ='723' --option 2: using the max(air_time)

SELECT airline,
       distance 
FROM merged_flights
WHERE distance =(SELECT MAX(distance) AS longest_flight FROM merged_flights) 

/* Q3. The table 'flights' is about domestic flights in US. 
 * 		Let's double-check! 
 * 		Find unique country names for all departures.
 */

SELECT DISTINCT country
FROM merged_flights

/* Q4. How many departures per 'country' happened on the first day of our data? 
 * 
 * 		Hints: 
 * 			- some listed flights were cancelled, let's filter them out
 * 			- 'timestamp' and 'date' types can be compared to (filtered on) strings representing a date, for example to '2020-12-31'
 * 			- to find the first date you can check the MIN(flight_date)
 */ 
 
SELECT MIN(flight_date) AS first_day
FROM merged_flights  -- first day is 2024-01-01

SELECT country,
       COUNT(*) AS total_departures
FROM merged_flights
WHERE cancelled = 0 AND flight_date = '2024-01-01'  --option 1
GROUP BY country 

SELECT country,
       COUNT(*) AS total_departures
FROM merged_flights
WHERE cancelled = 0 AND flight_date = (SELECT MIN (flight_date) AS first_day FROM merged_flights)  --option 2
GROUP BY country 

/* Q4. How many departures per 'country' happened on the first month of our data?
 * 
 */

SELECT country,
       COUNT(*) AS total_departures
FROM merged_flights
WHERE cancelled = 0 AND flight_date BETWEEN '2024-01-01' AND '2024-01-31'  
GROUP BY country 

/* Q5. Which airport and in which city had the most departures during the first month?
 * 
 * 		Hints: 
 			- filter out cancelled flights
			- filter for flight_date BETWEEN 'start-date' AND 'end-date'
			- use LIMIT to focus on the highest departures, but also check whether only one airport has the most
 */

SELECT name,
       city,
       COUNT(*) AS total_departures
FROM merged_flights
WHERE cancelled = 0 AND flight_date BETWEEN '2024-01-01' AND '2024-01-31'  --option 2
GROUP BY name, city
ORDER BY total_departures DESC
LIMIT 1


SELECT * FROM airports
WHERE city = 'Atlanta'

SELECT * FROM flights 
WHERE dest = 'FTY' OR origin = 'FTY'

SELECT city,
       name,
       count (DISTINCT origin)
FROM merged_flights 
WHERE city = 'Atlanta'
GROUP BY city, name

/* Q6. To which city/cities does the airport with the second most arrivals over all time belong?
 * 
 * 		Hint: 
 			- similar to the LIMIT clause limiting a number of rows the clause OFFSET skips a number of rows
 */

SELECT MAX(flight_date)

SELECT city,
       COUNT(*) AS total_arrivals
FROM merged_flights
WHERE cancelled = 0  
GROUP BY city
ORDER BY total_arrivals DESC
OFFSET 1
LIMIT 1

/* Q7. Filter the data to one date and count all rows for that day so that your result set has two columns: flight_date, total_flights.  
 * 		Repeat this step, but this time only include data from another date.
 * 		Combine the two result sets using UNION.
 */
CREATE TABLE flight_2024_01_01 AS
SELECT flight_date,
       COUNT(*) AS total_flights
FROM merged_flights
WHERE cancelled = 0 AND flight_date = '2024-01-01'  
GROUP BY flight_date

SELECT * FROM flight_2024_01_01

CREATE TABLE flight_2024_01_02 AS
SELECT flight_date,
       COUNT(*) AS total_flights
FROM merged_flights
WHERE cancelled = 0 AND flight_date = '2024-01-02'  
GROUP BY flight_date

SELECT * FROM flight_2024_01_02

SELECT flight_date, total_flights
FROM flight_2024_01_01
UNION
SELECT flight_date, total_flights
FROM flight_2024_01_02

--> UNION combines the distinct results of two or more SELECT statements


/* Q8. The last query can be optimized, right?
 * 		Rewrite the query above so that you get the same output, but this time you are not allowed to use UNION.
 * 
 * 		Hint: we can use a filter to get only the data for those 2 days. 
 */
SELECT flight_date,
       COUNT(*) AS total_flights
FROM merged_flights
WHERE cancelled = 0 AND flight_date BETWEEN '2024-01-01' AND '2024-01-02'  
GROUP BY flight_date

/* Q9. Show flights with a departure delay of more than 30 minutes over all time?
 *      How big was the delay?
 * 	    What was the plane's tail number?
 * 	    On which date and in which city did the plane depart?   
 * 	    Answer all questions with a single query.
 */

SELECT dep_delay AS total_delay,
       flight_number,
       tail_number,
       city
FROM merged_flights
WHERE cancelled = 0 AND dep_delay >=30
GROUP BY dep_delay, flight_number, tail_number, city
ORDER BY dep_delay DESC; 

/* Q10. Per airport, over all time, show
 *		- the city and the airport name
 * 		- how many flights had a departure delay of more than 30 minutes?
 *      - what was the average arrival delay for these flights?
 * 		- how many unique airplanes were involved?
 */

SELECT city,
       name,
       COUNT(*) AS total_delays,
       ROUND(AVG(arr_delay),2) AS avg_arrival_delay,
       COUNT(DISTINCT tail_number) AS total_airplanes
FROM merged_flights
WHERE dep_delay >30
GROUP BY city, name
ORDER BY total_delays DESC

/* Q11. Find city names with :
 * 		- the most daily total departures
 * 		- the most daily unique planes departed
 * 		- the most daily unique airlines
 */
 
SELECT flight_date,
       city,
       COUNT(*) AS daily_departures
FROM merged_flights
WHERE cancelled = 0
GROUP BY flight_date, city
ORDER BY daily_departures DESC

SELECT flight_date,
       city,
       COUNT(DISTINCT tail_number) AS daily_airplanes
FROM merged_flights
WHERE cancelled = 0
GROUP BY flight_date, city
ORDER BY daily_airplanes DESC

SELECT flight_date,
       city,
       COUNT(DISTINCT airline) AS total_airlines
FROM merged_flights
WHERE cancelled = 0
GROUP BY flight_date, city
ORDER BY total_airlines DESC

 /*
 * Use VIEWs to create the final join query:
 * 		1. VIEW calculating counts (departures, tails, airlines) per flight date and city. (Hint: filter out cancelled flights)
 * 		2. VIEW (querying from the 1st view) finding the max daily values over all for counts of departures, tails and airlines
 * 		3. In the final query join the 1st view to the 2nd on the max values 
 *    		Hint #1: the ON takes OR keywords
 *    		Hint #2: to tackle the case that the same airport has highscores on multiple days add a group by city and aggregate the metrics.
 */
CREATE VIEW Summary_flights AS 
SELECT flight_date,
       city,
       COUNT(*) AS total_departures,
       COUNT(DISTINCT tail_number) AS total_airplanes,
       COUNT(DISTINCT airline) AS total_airlines       
FROM merged_flights
WHERE cancelled = 0
GROUP BY flight_date, city

SELECT * FROM summary_flights

CREATE VIEW max_flights AS 
SELECT MAX(total_departures) AS max_daily_departures,
       MAX(total_airplanes) AS max_daily_airplanes,
       MAX(total_airlines) AS max_daily_airlines
FROM summary_flights

SELECT * FROM max_flights

SELECT
    s.city,
    MAX(s.total_departures) AS total_departures,
    MAX(s.total_airplanes) AS total_airplanes,
    MAX(s.total_airlines) AS total_airlines,
    STRING_AGG(DISTINCT CAST(s.flight_date AS VARCHAR), ', ') AS record_dates
FROM summary_flights s
JOIN max_flights m
    ON s.total_departures = m.max_daily_departures
    OR s.total_airplanes = m.max_daily_airplanes
    OR s.total_airlines = m.max_daily_airlines
GROUP BY s.city;

 * OPTIONAL: to count the number of the airports in a city STRING_AGG(DISTINCT origin, ', ')
 */

SELECT * FROM airports

SELECT 
    city,
    COUNT(DISTINCT name) AS total_airports,
    STRING_AGG(DISTINCT CAST(airports.name AS VARCHAR), ', ') AS airport_names
FROM airports
WHERE city IS NOT NULL
GROUP BY city
ORDER BY total_airports DESC
