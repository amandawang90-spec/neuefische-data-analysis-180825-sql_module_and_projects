

-- SQL - Filtering data with the WHERE clause

/* The WHERE clause in SQL is used to filter rows returned by a SELECT statement. 
 * It allows you to specify conditions that determine which rows are included in the result set. 
 * By applying conditions, you can retrieve specific data based on your criteria.
 *  
 * Syntax:
		SELECT select_list
		FROM table_name
		WHERE condition
		ORDER BY sort_expression;
 *
 * Operators in the WHERE clause:
		=: Equal
		>: Greater than
		<: Less than
		>=: Greater than or equal
		<=: Less than or equal
		<> or !=: Not equal
		LIKE / ILIKE: Returns true if a value matches a pattern
		IN: Returns true if a value matches any value in a list
		BETWEEN: Returns true if a value is between a range of values
		AND: Logical operator (both conditions must be true)
		OR: Logical operator (at least one condition must be true)
		NOT: Negates the result of other operators
		IS NULL: Returns true if a value is NULL
 */

-- 1. Operator: =
 /* It allows you to check whether a value in a column is equal to a specified value.
  */
SELECT name, 
	   city, 
	   country
FROM airports
WHERE country = 'Iceland';

-- TRY: find all airports in London

SELECT name, 
       city, 
       country
FROM airports
WHERE city = 'London';


-- 2: Operators: >= and <=

/* The >= operator checks whether a value is greater than or equal to a specified value.
 * Similarly, the <= operator checks whether a value is less than or equal to a specified value. 
 */
SELECT name, 
	   city, 
	   country,
	   alt
FROM airports
WHERE alt >= 12400
ORDER BY alt;

-- TRY: find airports where the timezone (tz) is smaller or equal to -11

SELECT name, 
       city, 
       country, 
       tz
FROM airports
WHERE tz <= -11
ORDER BY tz;

-- 3. Pattern matching operators: LIKE and ILIKE
/* The LIKE operator checks whether a text matches a specified pattern.
 * The ILIKE operator is a case-insensitive variant of LIKE.
 * The pattern can be written with wildcard operators: '%abc%', '%abc', 'abc%', 'a_c', '_bc' etc  
 * The % wildcard operator which represents any sequence of characters at this position.
 * The _ wildcard operator represents exactly one character. 
 */
SELECT faa,
	   name, 
	   city, 
	   country,
	   alt
FROM airports
WHERE faa LIKE 'XS%';

-- TRY: find airports with 'Love' in their names 

SELECT faa,
       name, 
       city, 
       country,
       alt
FROM airports
WHERE name LIKE '%Love%';


-- 4: Operator: IN
/* The IN operator in PostgreSQL is a Boolean operator that checks whether a specified value 
 * exists within a list of values.
 */
SELECT name, 
	   city, 
	   country,
	   alt
FROM airports
WHERE city IN ('Hamburg', 'Berlin');

-- TRY: select only the rows for these airlines: DL, NK, HA, AS

-- select faa from airports
-- where  faa in ('DL', 'NK', 'HA', 'AS');

SELECT faa
FROM airports
WHERE faa LIKE '%DL%'
   OR faa LIKE '%NK%'
   OR faa LIKE '%HA%'
   OR faa LIKE '%AS%';

-- 5: Operator: BETWEEN
/*  The BETWEEN operator allows you to check if a value falls within a specified interval. 
 *  Note: the BETWEEN clause is inclusive of both endpoints.
 */
SELECT *
FROM airports
WHERE alt BETWEEN 11001 AND 13355
ORDER BY alt;

-- TRY: From flights table select only flights during the period: 2024-01-01 until 2024-01-03 

SELECT *
FROM flights
WHERE flight_date BETWEEN '2024-01-01' AND '2024-01-03'
ORDER BY flight_date;


-- 6: Conjunctive logical operators: AND, OR
/* They allow you to combine multiple conditions in a query to narrow down selected data.
 */

-- AND - Combines multiple conditions and returns true only if all the conditions are true.
SELECT name, 
	   city, 
	   country,
	   alt
FROM airports
WHERE NOT alt >= 12400 AND country <> 'China'
ORDER BY alt;

-- OR - Combines multiple conditions and returns true if any of the conditions are true. 
SELECT name, 
	   city, 
	   country,
	   alt
FROM airports
WHERE country = 'China' OR country = 'Nepal'
ORDER BY country;

-- AND + OR
SELECT name, 
	   city, 
	   country,
	   alt
FROM airports
WHERE alt >= 12400 AND (country = 'China' OR country = 'Nepal')
ORDER BY alt;


/*
--TRY: find airports closest to the extreme latitude and longitude values
	with latidute above 80 or below -60 
	or 
	with longitude above 179 or below -179   

*/

-- SELECT name, 
--        city, 
--        country, 
--        lat, 
--        lon
-- FROM airports
-- WHERE lat > 80 OR lon < -60
--    OR lon > 179 OR lat < -179
-- ORDER BY lat, lon;

SELECT "name", 
       "city", 
       country, 
       lat, 
       lon
FROM airports
WHERE (lat < -60 OR lat > 80)
   OR (lon < -179 OR lon > 179)
ORDER BY lat, lon;

-- 7: Negation logical operator: NOT
/* The NOT operator negates a boolean expression. It inverts a condition.
 * For example, if you have a condition like NOT (age > 18), it checks whether the age is not greater than 18.
 */
SELECT name, 
	   city, 
	   country
FROM airports
WHERE country = 'Germany' AND city NOT IN ('Hamburg', 'Berlin')
ORDER BY city;

/*
-- TRY: find the opposite for this condition using NOT
		WHERE alt >= 12400 AND (country = 'China' OR country = 'Nepal') 
 */

SELECT *
FROM airports
WHERE alt < 12400 OR country NOT IN ('China', 'Nepal')
ORDER BY alt;


-- 8:
/* WHERE with NULL values
  
 * A NULL value represents the absence of data. It’s not a specific value like a number or string; 
 * rather, it indicates that no valid data exists for a particular field.
  
 * As NULL is not a value itself, it isn’t directly comparable to other values using standard operators.
 
 * The special clause IS NULL or IS NOT NULL is needed to check NULL value exists or not in a table.
  */

-- This query will not return any records because you can't compare a value to NULL
SELECT name, 
	   city, 
	   country
FROM airports
WHERE country = 'Philippines' AND city = NULL;

/* This query will run successfully when using IS NULL.
 */
SELECT name, 
	   city, 
	   country
FROM airports
WHERE country = 'Philippines'
  AND city IS NULL;

-- TRY: find airports with missing tz values, but not missing city values

SELECT name, 
       city, 
       country, 
       tz
FROM airports
WHERE tz IS NULL
  AND city IS NOT NULL;

 
