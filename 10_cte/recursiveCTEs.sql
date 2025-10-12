--Exercise 1

--Use a recursive CTE to generate a list of all odd numbers between 1 and 100.
--Hint: You should be able to do this with just a couple slight tweaks to the code 
--from our first example in the video.

WITH RECURSIVE
odd_numbers AS (
                SELECT 1 AS myNumber
                UNION ALL
                SELECT myNumber+2 
                FROM odd_numbers
                WHERE myNumber < 99
                )
SELECT myNumber FROM odd_numbers


--Exercise 2

--Use a recursive CTE to generate a date series of all FIRST days of the month 
--(1/1/2021, 2/1/2021, etc.)

--from 1/1/2020 to 12/1/2029.
--Hints:
--Use the DATEADD function strategically in your recursive member.
--You may also have to modify MAXRECURSION.

WITH RECURSIVE first_dates AS ( 
								SELECT DATE('2020-01-01') as first_day 
								UNION ALL 
								SELECT DATE(first_day + INTERVAL '1 MONTH')
								FROM first_dates 
								WHERE first_day < DATE('2029-12-01') 
) 
SELECT first_day 
FROM first_dates;