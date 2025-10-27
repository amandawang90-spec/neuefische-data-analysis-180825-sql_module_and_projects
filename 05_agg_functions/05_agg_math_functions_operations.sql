/* FUNCTIONS for DATA AGGREGATION - Key Element of Data Analytics
 * 
 * Aggregate functions, such as AVG(), SUM(), and COUNT(), compute a single result from a set of values. 
 * They allow us to condense large and complex sets of values into meaningful summary measures. 
 * The aggregated results provide a general overview that simplifies analysis.
 * 
 * Aggregated data can reveal trends, patterns, and insights that may not be apparent when examining 
 * individual data points.
 * 
 * Some common methods of summarizing are:
		
		- Minimum
		- Maximum
		- Count
		- Distinct Count
		- Mean
		- Sum
*/

/* 1. MIN() and MAX()
 * What is the highest and the lowest airport altitude?  
 */
SELECT MAX(alt) AS maximum_altitude
FROM airports;

SELECT MIN(alt) AS minimum_altitude
FROM airports;

-- TRY: find the first and last date in the table 'flights' 


/* 2. COUNT
 * Find out how many rows total are in the table.
 */
SELECT COUNT(*)
FROM airports;

-- TRY: Combine count with a condition: How many airports are listed for Germany?


SELECT COUNT(*)
FROM airports
where country='Germany'

/* 3. COUNT DISTINCT 
 * We've learned how to show only unique values of a column by using DISTINCT
 */
SELECT DISTINCT country
FROM airports;

 /* To find out how many unique values are in a column we need to wrapt it in a COUNT() function
 */
SELECT COUNT(DISTINCT country)
FROM airports;

/*
-- TRY: In one query from the 'flights' table count: 
			- number of unique origin airport codes
			- number of unique tail numbers
			- number of unique airlines 
 */
SELECT
  COUNT(DISTINCT origin) AS num_unique_origin_airports,
  COUNT(DISTINCT tail_number) AS num_unique_tail_numbers,
  COUNT(DISTINCT airline) AS num_unique_airlines
FROM flights;

-- 4. AVG()
/* What is the average altitude of airports overall?
 */
SELECT AVG(alt) AS average_altitude
FROM airports;

--TRY: What is the average flight time from Boston (BOS) to Honolulu (HNL)
--	Hint: Use WHERE with two conditions.

SELECT
  AVG(actual_elapsed_time) AS average_flight_time_minutes
FROM flights
WHERE
  origin = 'BOS' AND dest = 'HNL';

-- 5. SUM()
/* Find total distance of all flights in on the 1st of January 2024
 */
SELECT SUM(distance) AS total_altitude
FROM flights
WHERE flight_date = '2024-01-01';

-- TRY: check the total flight time, basically how long would one plane to fly that distance 
SELECT
  AVG(distance / actual_elapsed_time) AS average_speed_units_per_minute
FROM flights
WHERE
  actual_elapsed_time > 0; -- Avoid division by zero if there are flights with 0 time


/* MATHEMATICAL FUNCTIONS and OPERATORS - Essential Tools for Data Manipulation
 * 
 * Mathematical functions, such as ROUND(), FLOOR(), and CEILING(), perform various
 * calculations on numerical data. They enable us to transform and manipulate data to derive 
 * meaningful insights and perform precise computations.
 
 * These functions are crucial for refining data, ensuring accuracy, and facilitating complex 
 * mathematical operations. By applying these functions, we can streamline data processing and 
  * enhance the quality of our analyses.
*/

/* ROUND() Function:
	The ROUND() function is used to round a numeric value to a specified number of decimal places. 
	It takes two arguments: the numeric value to be rounded and the number of decimal places.
	For example, ROUND(5.7, 0) would yield 6, and ROUND(3.14159, 2) would yield 3.14.
*/
SELECT AVG(air_time) AS avg_air_time,
		ROUND(AVG(air_time), 2) AS avg_air_time_rounded
FROM flights
WHERE origin = 'BOS' AND dest = 'HNL';

/*	NOTE: The function ROUND() allows rounding to n decimals only for numeric type. If you try to round 
 		a float, for example, to 2 decimals it will cause an error. 
		FYI, we will cover changing data types (casting) in the later lectures
 */ 		
SELECT ROUND(3.456457, 2), 
	   --ROUND(3.456457::FLOAT, 2), -- this will cause an error. floats cannot be rounded to a decimal
		ROUND(3.456457::NUMERIC, 2)
		
SELECT ROUND(3.456457, 2) :

SELECT ROUND(3.456457::FLOAT, 2), -- this will cause an error. floats cannot be rounded to a decimal
		
SELECT ROUND(3.456457::NUMERIC, 2)	

SELECT pg_typeof(3.456457) -- check the data type
		
/* FLOOR() Function:
	The FLOOR() function rounds a numeric value down to the nearest integer that is less than or 
	equal to the input value.
	For instance, FLOOR(5.7) results in 5, and FLOOR(-42.8) yields -43.
*/
SELECT AVG(air_time) AS avg_air_time,
		FLOOR(AVG(air_time)) AS avg_air_time_floor
FROM flights
WHERE origin = 'BOS' AND dest = 'HNL';

/* CEILING() Function:
	The CEILING() function rounds a numeric value up to the nearest integer that is greater than or 
	equal to the input value.
	For example, CEILING(3.2) results in 4, and CEILING(-2.5) yields -2.
*/
SELECT AVG(air_time) AS avg_air_time,
		CEILING(AVG(air_time)) AS avg_air_time_ceiling
FROM flights
WHERE origin = 'BOS' AND dest = 'HNL';

-- REVIEW: Compare the different outcomes
SELECT FLOOR(2.75), CEILING(2.75), ROUND(2.75, 1)

/* Let’s explore DIVISION OPERATIONS in PostgreSQL

You’ll notice that division with only integers and division with decimal numbers yield different 
results. And what is result of the Modulo?
*/

/* Floor Division (Integer Division):
	When dividing two integers (e.g., 5 / 2), PostgreSQL truncates the result towards zero, 
	resulting in an integer quotient. Floor Division ensures that the result is always an integer, 
	discarding any fractional part. 
	In this case, 5 / 2 yields 2, and (-5) / 2 yields -2.
*/

-- show full airtime as minutes and as full hours (but no fractions)
SELECT flight_date,
	   origin,
       dest, 
       air_time AS air_time_minutes,
       air_time / 60 AS air_time_hours --only result in whole number
FROM flights;


/* Division with Decimal Numbers:
	To perform division with decimal numbers, simply use the / operator with . 
	For example, 10.5 / 2.5 results in 4.2.
*/

SELECT AVG(air_time) AS avg_air_time,
	   AVG(distance) AS avg_distance,
	   AVG(distance) / AVG(air_time) miles_per_min
FROM flights
WHERE origin = 'BOS' AND dest = 'HNL';

/* Modulo Operator:
	The modulo operator (%) calculates the remainder when dividing one number by another.
	For instance, 7 % 3 yields 1, as 7 divided by 3 leaves a remainder of 1.
 */

SELECT
	COUNT(faa) AS airports_total,
	COUNT(DISTINCT country) unique_country_total,
	COUNT(faa) / COUNT(DISTINCT country) AS avg_airports_per_country,
	COUNT(faa) % COUNT(DISTINCT country) AS remainder_airports, -- the modulo example
	COUNT(faa)*1.0 / COUNT(DISTINCT country) AS true_ratio_avg_airports_per_country -- *1.0 turns the first value into NUMERIC type
	FROM airports;

/* BONUS - Some practical examples */

/* Practical Example ROUND():
 * Filter airports for countries China or Nepal with the altitude higher than 12400,
 * show altitude in separate columns measured in feet, in meters and in kilometers
 */
SELECT name, 
	   city, 
	   country,
	   alt AS altitude_in_feet,
	   ROUND(alt/3.281, 2) AS altitude_in_m,
	   ROUND((alt/3.281) / 1000.0, 3) AS altitude_in_km
FROM airports
WHERE alt >= 12400
  AND (country = 'China' OR country = 'Nepal');

/* Practical Example - Floor Division and Modulo:
 * How long is the total airtime on the 1st of January 2024 in days + hours + minutes?
 */

SELECT *
FROM flights
ORDER BY flight_date;

SELECT 
    SUM(air_time) / 60 / 24 AS days,       -- dividing total minutes into whole days
    SUM(air_time) / 60 % 24 AS hours,      -- remaining hours after dividing into days
    SUM(air_time) % 60 AS minutes          -- remaining minutes after dividing into hours
FROM flights
WHERE flight_date = '2024-01-01';

/* DOCUMENTATION:
 * Aggregate Functions - https://www.postgresql.org/docs/current/functions-aggregate.html
 * Mathematical Functions and Operators - https://www.postgresql.org/docs/current/functions-math.html
*/

--float/double precision/numeric/decimal differences and relationships

--CREATE TABLE test_float (
    --f_float FLOAT,
    --f_double DOUBLE PRECISION
--);

--INSERT INTO test_float VALUES (0.1234567890123456789, 0.1234567890123456789);

--SELECT f_float, f_double FROM test_float;

--import numpy as np

# 定义一个需要高精度表示的小数
value = 0.1234567890123456789

# 分别使用单精度 (float32) 和双精度 (float64) 表示
f32 = np.float32(value)
f64 = np.float64(value)

print("原始值：       ", value)
print("单精度 float32:", f32)
print("双精度 float64:", f64)

# 再看看累积误差：将小数加一百万次
sum_f32 = np.float32(0.0)
sum_f64 = np.float64(0.0)

for _ in range(1_000_000):
    sum_f32 += f32
    sum_f64 += f64

print("\n累加 1,000,000 次结果：")
print("单精度 float32:", sum_f32)
print("双精度 float64:", sum_f64)

原始值：        0.12345678901234568
单精度 float32: 0.12345679
双精度 float64: 0.12345678901234568

累加 1,000,000 次结果：
单精度 float32: 123455.7890625
双精度 float64: 123456.78901234568

--| 类型             | 精度        | 累加误差           | 说明       |
--| -------------- | --------- | -------------- | -------- |
--| `float32`（单精度） | 约 7 位     | 明显误差（少了约 1 单位） | 误差在累积中放大 |
--| `float64`（双精度） | 约 15–17 位 | 几乎无误差          | 保留更多有效位  |

--float(32) vs float(64):double precision
--| 类型                 | 存储结果                  | 实际有效数字       | 说明                |
--| ------------------ | --------------------- | ------------ | ----------------- |
--| `FLOAT`            | `0.12345679104328156` | ≈7 位有效数字     | 精度丢失，从第 8 位开始误差明显 |
--| `DOUBLE PRECISION` | `0.12345678901234568` | ≈15–16 位有效数字 | 保留更多有效数字，误差更小     |


-- float vs numeric
--| Value Inserted     | `FLOAT` Stored As     | `NUMERIC(18,6)` Stored As |
--| ------------------ | --------------------- | ------------------------- |
--| `0.1 + 0.2`        | `0.30000000000000004` | `0.300000`                |
--| `123456789.123456` | `123456792.0`         | `123456789.123456`        |

--numeric vs decimal
--| Feature               | `NUMERIC`             | `DECIMAL`                                        |
--| --------------------- | --------------------- | ------------------------------------------------ |
--| Type                  | Exact numeric         | Exact numeric                                    |
--| Defined precision     | Must be exact         | May be equal or greater (theoretical difference) |
--| Storage               | Same in most DBs      | Same in most DBs                                 |
--| Typical use           | Financial, accounting | Financial, accounting                            |
--| Real-world difference | None                  | None                                             |


--float/double precision vs numeric/decimal
--| Feature     | `FLOAT` / `DOUBLE`       | `NUMERIC` / `DECIMAL`                   |
--| ----------- | ------------------------ | --------------------------------------- |
--| Type        | Approximate              | Exact                                   |
--| Precision   | Limited (~7–17 digits)   | User-defined (up to hundreds of digits) |
--| Errors      | Rounding errors possible | No rounding error                       |
--| Performance | Faster                   | Slower                                  |
--| Typical use | Scientific data          | Money, financial data                   |

DECIMAL AND BINARY:
HOW TO CHANGE A DECIMAL INTO A BINARY: 0B MEANS BINARY
WHERE 13 IS DECIMAL AND 1101 IS THE BINARY
HOW TO CHANGE A BINARY INTO A DECIMAL:
int('1101', 2)== 13
WHERE 1101 IS BINARY AND 13 IS THE DECIMAL

bit（比特） 是计算机中最小的数据单位，只能是 0 或 1。
1 bit → 可以表示 2 个状态：0 或 1
2 bit → 可以表示 4 个状态：00、01、10、11
