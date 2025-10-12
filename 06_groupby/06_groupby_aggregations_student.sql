/*
 * ## GROUP BY
	  
 *		In SQL the GROUP BY clause is used with the SELECT statement to arrange data in groups based on 
 *		similarities. These results are often then aggregated to reveal various aspects of the data. 

 * ### Syntax

			SELECT column1, AGGREGATION_FUNCTION(column2)
			FROM table_name
			GROUP BY column1

 * *		Note: In this script we'll be working with a new table: life_expectancy
 *			This data is retrieved from the gapminder project, more context here: www.gapminder.org

 */
-- check out the table's content:
SELECT * FROM life_expectancy
ORDER BY country;

/* ### 1. Example - COUNT of total years by country.
 * 
 * 		The GROUP BY statement groups the 'life_expectancy' table by unique country names
 * 		The subsequent SELECT statement displays the country name along with the corresponding count of year values in each group.
 * 		Alternitively we could count rows in each group COUNT(*) and call it total_records. 
 */
SELECT country,
	   COUNT(year) AS total_years
FROM life_expectancy
GROUP BY country

-- What happens if the GROUP BY statement is left out? (Comment it out and check what the error says.)


/* ### 2. Try Out - COUNT of total years and average life_expectancy by country.
 * 		Complete the query below with the average function for life_expectancy
 */
SELECT country,
	   COUNT(*) AS total_years,
	   -- enter your code here
FROM life_expectancy
GROUP BY country


/* ### 3. Try Out - Average life expectancy per country and ORDER BY the descending average.
 * 		Use ROUND() to make the average life expectancy more readable. Round it to 2 decimals.
 * 		Use ORDER BY to order the result set.
 * 		
 * 		Note: Consider why each country group has multiple values? What are we aggregating/colapsing? 
 * 		Which column is not available after the GROUP BY?
 */
SELECT country,
	   AVG(life_expectancy) AS avg_life_expectancy, --keep it for the comparison
	   -- add your code here
FROM life_expectancy
GROUP BY country
-- add your code here


/* ### 4. GROUP BY and WHERE
 * 		The GROUP BY clause comes after WHERE (if used) and before ORDER BY (if used).
 * 		The WHERE clause filters rows before they are grouped by the GROUP BY clause. 
 * 		It allows you to specify conditions for inclusion. After filtering, the remaining rows are 
 * 		grouped based on specified columns, and aggregate functions can be applied to each group. 
 * 		Subsequently you can use ORDER BY to sort the groups based on aggregated values.
 * 
 * 		Here we filter for some countries in a WHERE clause before grouping by them.
 * 
 */
SELECT country,
		ROUND(AVG(life_expectancy)) AS avg_life_expectancy
FROM life_expectancy
WHERE country IN('United States','Chile','Italy','Germany','China')
GROUP BY country
ORDER BY avg_life_expectancy DESC;


/* ### Try Out - Countries that have an average life expectancy greater than or equal 50
 * 		What if we need to filter values we just aggregated?
 *  
 * 		Try to reuse the previous query, but instead of country filter the average life expectancy >= 50
 * 		No worries, it will result in an error. But what does it say?
 */

SELECT country,
		ROUND(AVG(life_expectancy)) AS avg_life_expectancy
FROM life_expectancy
WHERE -- add code here: filter the average life expectancy >= 50
GROUP BY country
ORDER BY avg_life_expectancy DESC;


/* ### 5. HAVING 
 * 		Because WHERE is executed before GROUP BY, the filtering of aggregated values has to be taken care by 
 * 		another clause: HAVING.
 * 
 * 		The HAVING clause is specifically designed to filter grouped data based on aggregate values. It operates after 
 * 		GROUP BY and allows you to specify conditions on aggregated results.
 * 
 * 		Example (corrrected): Countries that have an average life expectancy greater than or equal 50.
 */
SELECT country,
		ROUND(AVG(life_expectancy)) AS avg_life_expectancy
FROM life_expectancy
GROUP BY country
HAVING AVG(life_expectancy) >= 50
ORDER BY avg_life_expectancy DESC;

/* ### GROUP BY - Handling Multiple Columns 
 * 		To group by multiple columns you simply pass a coma-separated list to the GROUP BY.
 
  			SELECT column1, column2, AGGREGATION_FUNCTION(column3)
			FROM table_name
			GROUP BY column1, column2
			
 * 		The uniqueness of a group isn’t always determined by just one column (dimension). Sometimes, we need 
 * 		to break it down further using a second dimension (or more). For example, in a Car Dataset, you can have a general 
 * 		grouping by 'Brand' or you can create more detailed groups by combining 'Brand' and 'TypeOfCar'.
 * 
 * 		On the other hand, in our result set, we might want to see one or more measures. Regardless of how many 
 * 		measures we keep, in a query with a GROUP BY, each measure must be aggregated. Imagine that each measure group 
 * 		is a collection of values that needs to be collapsed into a single value. You’ll need to decide which aggregation 
 * 		function (e.g., COUNT, SUM, AVG, etc.) will handle this. That’s the primary purpose of grouping.
 * 		
 * 		General Guidelines:
 * 		Consider which columns you need in your result set, basically which columns will be mentioned in the SELECT statement. 
		- If it is a dimension, add it to the GROUP BY   
		- If it is a measure, choose an appropriate aggregation function for the SELECT statement
 * 
 */

/* ### EXAMPLE - Multiple Columns GROUP BY
 * 		Using 'flights' table find following statistics per day for each airline:
			- total flights
			- average delay
			- total cancelled 
			- total diverted
		HINT: always start by exploring the whole table SELECT * FROM 'flights'
 */

SELECT flight_date, airline, 
		COUNT(flight_number) AS total_flights, 
		AVG(arr_delay) AS delay_avg, 
		SUM(cancelled) AS cacelled_total, 
		SUM(diverted) AS diverted_total
FROM flights
GROUP BY airline, flight_date
