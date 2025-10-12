/* 
 * Welcome to Introduction to SQL!
 * This document includes practical examples of all basic SQL commands you will learn in this lecture.

 * How to use this file:
 * This file includes practical examples already pre-coded for you.
 * They will show you how they can be applied in reality and how the output changes based on each SQL command.
 * To execute an example simply click anywhere in the query and press 'Ctrl + ENTER' simultaneously.
 * This shortcut will execute the SQL statement and return the output below as a table, also called "result set".

 * The lecture will cover a lot of SQL commands, but don't worry we have a lot of practical exercises prepared for you.
 * With the exercises you will build up your SQL skills in no time! 
 */ 


-- 1. Your first SQL query
/* The SQL operation that is most often performed is querying of data. 
 * The SELECT statement is used to select a specific query of data from a database. 
 * The data returned is stored in a result table, called the result-set.
 * SELECT * (aka 'star') stands for "select all columns" 
 */
SELECT * FROM airports;

-- TRY it with another table e.g. 'flights':


-- 2. SELECT specific columns from the table 'airports'
/* Instead of the *, you select the name of the column to select.
 */
SELECT name
FROM airports;

-- TRY it with another column:


-- To select multiple columns from a table, simply separate the column names with commas
SELECT faa,
	   name,
	   city,
	   country
FROM airports;

-- TRY changing the order of columns, or select same column twice:


-- 4. LIMIT the output 
/* For example we can limit our result to the first 15 rows and all columns from a table 
 */
SELECT *
FROM airports
LIMIT 15;

-- TRY it with 'flights', e.g. limit it to 1:


-- 5. ORDER BY - Sorting Data
/* The ORDER BY command is used to sort the result set in ascending or descending order.
 * we can also sort by a primary column and a secondary column (or more)
 */
SELECT name, 
	   city, 
	   country
FROM airports
ORDER BY country ASC, city DESC;

-- TRY it with the table 'life_expectancy' order it by the column 'life_expectancy'
-- how could you find the top 5 life_expectancy values?:


-- 6. SELECT DISTINCT (unique)
/* If we order the table airports by 'country'
 * we can see that that most country names appear multiple times.
 */ 
SELECT *
FROM airports
ORDER BY country;

/* To find unique values in a column we need to add DISTINCT before the column name.
 * This time we get only unique country names.
 */ 
SELECT DISTINCT country
FROM airports
ORDER BY country
  
-- TRY finding unique airlines in the table 'flights':


-- 7. Forming the result set
/* In a SELECT statement, we shape the output — the result table. 
 * The comma-separated elements can represent columns from a source table, 
 * or they can be new columns derived from calculations or value modifications.
 * 
 * It’s all about defining what information we want to see in the final result!
 */

-- check out the output of this query
SELECT name, 
	   city, 
	   country,
	   alt,
FROM airports
ORDER BY alt;

/* TRY: NOT selecting the column 'name' 
 * also add two columns with some repeating text and a calculation of altitude from feet to meters:
		UPPER(country),
		'anything',
	 	alt / 3.28084
 */ 


-- 8. Aliasing column names
/* you can change names of columns (aliasing) by adding them with an AS keyword

-- TRY changing to: 
		UPPER(country) as country_caps,
		'anything' AS random_text,
		alt AS alt_ft,
		alt / 3.28084 AS alt_m	   
*/


--9. Documenting Code
/* Adding comments or disabling parts of your query for tests (commenting-out).
*/

	-- This is a Single-line comment
	
	/* This is a Multi-line
	 * Comment
	 * and one more line... click here and hit ENTER
	*/

/* It is quite handy to put comma in front of the selected items
 * So it will not cause an error when the last element is commented out
 */
SELECT faa
	   ,name
--	   ,city
	   ,country
FROM airports
ORDER BY faa;

-- TRY commenting out 'country' and the order by clause in the above query. 


/* 10. To sum up: 
 * In a SELECT statement, we shape the output — the result table.
 * Note: The output of a SELECT statement is temporary and not persistent, no physical table is saved yet.
 * 
 * Some of the main elements of a SQL query follow that syntax order:

	SELECT columns
	FROM table
	WHERE condition -- will be covered in the next lecture 'filtering'
	ORDER BY column ASC|DESC
	LIMIT number;
 
 *
 */

-- BONUS: doesn't fit to basics introduction. Should appear later. 
-- AlexS Recommendation (Delete the Bonus.)


/* Conditional Expressions
 * CASE
 * In this example we use CASE to translate the department_delay into a categorical variable.
 * Depending on the delay a flight will be either 'Early', 'On time' or 'Delayed'
 */
SELECT flight_date,
	   CASE WHEN dep_delay < 0 THEN 'Early'
			WHEN dep_delay = 0 THEN 'On time'
			ELSE 'Delayed'
	   END AS dep_punctuality   
FROM flights

-- you can leave out ELSE and it will fill it with NULL
SELECT flight_date, dep_delay,
	   CASE WHEN dep_delay < 0 THEN 'Early'
			WHEN dep_delay = 0 THEN 'On time'
	   END AS dep_punctuality   
FROM flights





