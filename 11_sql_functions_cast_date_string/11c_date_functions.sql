/* Date/Time Functions
 * In this file you will find Date/Time functions that are already hard coded into postgreSQL.
 * Make sure to understand what each function takes as input, what happens to the input and what output is returned.
 * Syntax: function(input type) -> return type: definition
 * dp = double precision
 * More info about Date/Time functions: https://www.postgresql.org/docs/current/functions-datetime.html
 */

/* 1. Current Dates & Times
 * 		PostgreSQL provides a number of functions that return current timestamps, dates or times.
 * 			CURRENT_TIMESTAMP or NOW() : retrieves the current TIMESTAMP with time zone
 * 			CURRENT_DATE : retrieves the current DATE
 * 			CURRENT_TIME : retrieves the current TIME
 */
 
SELECT NOW() AS timestamp_with_time_zone;
SELECT CURRENT_TIMESTAMP AS curr_timestamp_with_time_zone;
SELECT CURRENT_DATE AS curr_date_without_time_zone;
SELECT CURRENT_TIME AS curr_date_without_time_zone;

/* 2. DATE_PART() 
 * 		As was seen in pandas a timestamps allows access to different time related features.
 * 		The DATE_PART() function extracts a subfield from a date or time value. 
 * 		
 * 		Example: Decode flight_date column into day, month and year columns separately for the future analysis. 
 */

SELECT flight_date, 
		DATE_PART('day', flight_date) AS flight_day,
		DATE_PART('month', flight_date) AS flight_month,
		DATE_PART('year', flight_date) AS flight_year,
		tail_number
FROM flights;

-- other options: https://www.postgresqltutorial.com/postgresql-date-functions/postgresql-date_part/

/* 3. EXTRACT() 
 * 		EXTRACT(field from a date/time value) -> double precision(float)
 * 		The EXTRACT() function extracts a field from a date/time value, which can be a timestamp or an interval
 * 		
 * 		Example: Decode flight_date column into day, month and year columns separately for the future analysis. 
 */
SELECT flight_date, 
		EXTRACT(DAY FROM flight_date) AS flight_day,
		EXTRACT(MONTH FROM flight_date) AS flight_month,
		EXTRACT(WEEK FROM flight_date) AS flight_year,
		tail_number
FROM flights;

/* 4. TO_CHAR() 
 * 		The TO_CHAR() function converts a timestamp, an interval, an integer, a double-precision (float), 
 * 		or a numeric value to a string.
 * 		
 * 		For more detail about TO_CHAR formatting: https://www.postgresql.org/docs/current/functions-formatting.html
 */
SELECT flight_date,
	   TO_CHAR(flight_date, 'YYYYMMDD')
FROM flights

-- Example: we can make use of it and correct the column with the military time so we can CAST it as TIME
SELECT flight_date,
	   dep_time,
	   TO_CHAR(dep_time, 'fm0000')::TIME AS dep_time_TIME,
	   flight_date + TO_CHAR(dep_time, 'fm0000')::TIME AS date_time
FROM flights

-- Note: Timestamps can also be used to filter easily using different comparison operators.

/* 5. DATE_TRUNC() 
 * 		DATE_TRUNC(field, source [,time_zone]) -> timestamp
 * 		The DATE_TRUNC() function truncates a TIMESTAMP, a TIMESTAMP WITH TIME ZONE, or an  INTERVAL value to a specified precision.
 * 		
 * 		A full list of accepted values for text can be found here: 
 * 		https://www.postgresql.org/docs/current/functions-datetime.html#FUNCTIONS-DATETIME-TRUNC
 */

SELECT DATE_TRUNC('decade', TIMESTAMP '2021-06-27 10:30:45') AS trunc_decade;
SELECT DATE_TRUNC('quarter', TIMESTAMP '2021-06-27 10:30:45') AS trunc_quarter;
SELECT DATE_TRUNC('year', TIMESTAMP '2021-06-27 10:30:45') AS trunc_year;
SELECT DATE_TRUNC('week', TIMESTAMP '2021-06-27 10:30:45') AS trunc_week;
SELECT DATE_TRUNC('hour', TIMESTAMP '2021-06-27 10:30:45') AS trunc_hour;
SELECT DATE_TRUNC('minute', TIMESTAMP '2021-06-27 10:30:45') AS trunc_hour;

-- Example: Get all year+month combinations for a groupby aggregation:
SELECT DATE_TRUNC('month', flight_date) AS yearmonth, 
	   origin, 
	   dest, 
	   COUNT(*) AS monthly_count 	
FROM flights
GROUP BY yearmonth, origin, dest;

-- Alternative workaround is to CAST datetime values as text or VARCHAR and the apply string functions.
SELECT LEFT(flight_date::VARCHAR, 7) AS yearmonth, 
	   origin, 
	   dest, 
	   COUNT(*) AS monthly_count 	
FROM flights
GROUP BY yearmonth, origin, dest;

/* 6. TO_TIMESTAMP()
 * 		TO_TIMESTAMP(timestamp, format) -> timestamp
 * 
 * 		The TO_TIMESTAMP() function converts a string to a timestamp based on a **specified** format
 */

SELECT TO_TIMESTAMP('2017-03-31 9:30:20', 'YYYY-MM-DD HH:MI:SS');

WITH monthly_total AS (
	SELECT LEFT(flight_date::VARCHAR, 10) AS yearmonth, 
		   origin, 
		   dest, 
		   COUNT(*) AS monthly_count 	
	FROM flights
	GROUP BY yearmonth, origin, dest
)
SELECT TO_TIMESTAMP(monthly_count::VARCHAR, 'YYYY-MM-DD HH:MI:SS'),
		monthly_count
FROM monthly_total

/* Example: let's use the query from before where we split a timestamp into parts 
 * and using MAKE_DATE() we'll create a DATE from it.
 */

SELECT LEFT(flight_date::VARCHAR, 10) 	
FROM daily_totals
GROUP BY yearmonth, origin, dest;

/* 7. MAKE_DATE(year int, month int, day int) -> date: 
 * 		Create date from year, month and day fields
 */

SELECT MAKE_DATE(2021, 1, 1) AS new_date;

/* Example: let's use the query from before where we split a timestamp into parts 
 * and using MAKE_DATE() we'll create a DATE from it.
 */

WITH timestamp_split AS (
	SELECT flight_date, 
			DATE_PART('day', flight_date)::INT AS flight_day,
			DATE_PART('month', flight_date)::INT AS flight_month,
			DATE_PART('year', flight_date)::INT AS flight_year,
			tail_number
	FROM flights
)
SELECT MAKE_DATE(flight_year, flight_month, flight_day) AS recreated_datetime
FROM timestamp_split;

/* 8. MAKE_INTERVAL(years int DEFAULT 0, months int DEFAULT 0, weeks int DEFAULT 0, days int DEFAULT 0, 
 * 	  hours int DEFAULT 0, mins int DEFAULT 0, secs double precision DEFAULT 0.0) -> interval
 * 
 * 		The MAKE_INTERVAL() function allows you to create an interval from years, months, weeks, days, hours, 
 * 		minutes, and seconds.
 */
SELECT MAKE_INTERVAL(years => 10) AS ten_years_interval;
SELECT MAKE_INTERVAL(months => 10) AS ten_months_interval;
SELECT MAKE_INTERVAL(weeks => 10) AS ten_weeks_interval;
SELECT MAKE_INTERVAL(days => 10) AS ten_days_interval;
SELECT MAKE_INTERVAL(mins => 10) AS ten_mins_interval;

-- this function will fail if you provide a column that is not of type INT. Use cast to fix this.
-- this will fail because actual_elapsed_time is of type float/ double 
SELECT MAKE_INTERVAL(mins => actual_elapsed_time) AS ten_mins_interval from flights;
-- this will work
SELECT MAKE_INTERVAL(min => actual_elapsed_time::INT) AS ten_mins_interval from flights;


/* 9. Date/Time arithmetic operations
 */ 
-- 1. date + integer -> date: Add a number of days to a date
SELECT DATE '2021-01-01' + 7;
-- 2. date + interval -> timestamp: Add an interval to a date
SELECT DATE '2021-01-01' + INTERVAL '7 hour';
-- 3. date + time -> timestamp: Add a time-of-day to a date
SELECT DATE '2021-01-01' + TIME '07:00';
-- 4. interval + interval -> interval: Add intervals
SELECT INTERVAL '7 day' + INTERVAL '7 hour';
-- 5. timestamp + interval -> timestamp: Add an interval to a timestamp
SELECT TIMESTAMP '2021-01-01 07:00' + INTERVAL '7 hour';
-- 6. time + interval -> time: Add an interval to a time
SELECT TIME '07:00' + INTERVAL '77 hour';
-- 7. - interval -> interval: Negate an interval
SELECT - INTERVAL '7 hour';
-- 8. date - date -> integer: Subtract dates, producing the number of days elapsed
SELECT DATE '2021-01-01' - DATE '2020-12-25';
-- 9. date - integer -> date: Subtract a number of days from a date
SELECT DATE '2021-01-01' - 7;
-- 10. date - interval -> timestamp: Subtract an interval from a date
SELECT DATE '2021-01-01' - INTERVAL '7 hour';
-- 11. time - time -> interval: Subtract times
SELECT TIME '07:00' - TIME '07:00' AS substract_times;
-- 12. time - interval -> time: Subtract an interval from a time
SELECT TIME '07:00' - INTERVAL '7 minute' ;
-- 13. timestamp - interval -> timestamp: Subtract an interval from a timestamp
SELECT TIMESTAMP '2021-01-01 07:00' - INTERVAL '7 hour';
-- 14. interval - interval -> interval: Subtract intervals
SELECT INTERVAL '7 day 7 hour' - INTERVAL '7 hour';
-- 15. timestamp - timestamp -> interval: Subtract timestamps (converting 24-hour intervals into days)
SELECT TIMESTAMP '2021-01-31 07:00' - TIMESTAMP '2021-01-01 07:00';


