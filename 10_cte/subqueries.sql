-- What is a Subquery?
/*A subquery is a query inside another query. It lets you:
 * Calculate a value
 * Create a temporary table
 * Filter or compare data based on other results
 */

-- DO YOU REMEMBER THE EXAMPLE FROM THE AGGREGATION EXERCISES?
/* Q10. Which airport has the lowest altitude?
 */

SELECT MIN(alt)
FROM airports;

SELECT name
FROM airports
WHERE alt = -1266;

-- let's do it with subqueries

SELECT name, alt
FROM airports
WHERE alt = (
    SELECT MIN(alt)
    FROM airports
);



-- Example: Find the origin airport(s) that had the most flights.


SELECT origin, COUNT(*) AS flight_count
FROM flights
GROUP BY origin   --grouping by the origin and counting the flights
HAVING COUNT(*) = (
    SELECT MAX(origin_flight_count)
    FROM (
        SELECT origin, COUNT(*) AS origin_flight_count
        FROM flights
        GROUP BY origin   
    ) AS subquery_counts
);

-- let's check it step by step:

-- part 1 shows how many flights departed from each airport.
SELECT origin, COUNT(*) AS flight_count
FROM flights
GROUP BY origin;

-- part 2 inner subquery again counts flights per origin. Then the outer part takes the MAX() to find the largest number.

SELECT MAX(origin_flight_count)
FROM (
    SELECT origin, COUNT(*) AS origin_flight_count
    FROM flights
    GROUP BY origin
) AS subquery_counts;

-- then we need to put them together with having and add group by




