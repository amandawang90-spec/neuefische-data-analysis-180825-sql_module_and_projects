/* THE CASE OPERATOR 
 * With the CASE operator we can run a conditional query. It’s like if/else in other programming languages. 
 */

/* Example: 
 * Using the table 'flights' categorize early and late flights:
--   'early': arr_delay < 0 
--   'slightly late': arr_delay between 0-15
--   'late': arr_delay between 15-60 
--   'very late': arr_delay > 60

-- CASE can be used to bucketize a column...
 */

SELECT flight_date::DATE, 
		origin, 
		dest, 
		arr_delay, 
		CASE 
			WHEN arr_delay < 0 THEN 'early'
			WHEN arr_delay BETWEEN 0 AND 15 THEN 'slightly late'
			WHEN arr_delay BETWEEN 15 AND 60 THEN 'late'
			WHEN arr_delay > 60 THEN 'very late'
		END
FROM flights;


SELECT flight_date::DATE, 
		(CASE 
		  WHEN arr_delay < 0 THEN 'early'
		  WHEN arr_delay BETWEEN 0 AND 15 THEN 'slightly late'
		  WHEN arr_delay BETWEEN 15 AND 60 THEN 'late'
		  WHEN arr_delay > 60 THEN 'very late'
	 	END) AS status ,
		COUNT(arr_delay)
FROM flights
GROUP BY flight_date, status;
 

-- Or to quickly calculate a relative frequency count:

SELECT AVG(CASE 
				WHEN country IN ('UK', 'USA', 'Italy') THEN 1 
				ELSE 0 
		   END)
FROM regions;


-- The CASE operator can be used in SELECT, in WHERE and even in the ORDER BY
SELECT *
FROM flights
WHERE arr_delay >= 
                (CASE 
	                WHEN distance < 100 THEN 15
	                WHEN distance BETWEEN 100 AND 600 THEN 30
	                ELSE 60
                END) 
