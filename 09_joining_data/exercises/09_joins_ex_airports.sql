/* # JOINS - Exercises */

/* JOINS with Tables: 'flights' and 'airports'  */

/* Q1. What was the longest flight? (not using JOIN yet) 
 * Hint: NULL values are the first in a descending ORDER BY. You might need a filter for that.
 */



/* Q2. From which airport the longest flight? (now with JOIN)
 * Hint: NULL values are the first in a descending ORDER BY. You might need a filter for that.
 */



/* Q3. The table 'flights' is about domestic flights in US. 
 * 		Let's double-check! 
 * 		Find unique country names for all departures.
 */



/* Q4. How many departures per 'country' happened on the first day of our data? (Bonus: on the first month)
 * 
 * 		Hints: 
 * 			- some listed flights were cancelled, let's filter them out
 * 			- 'timestamp' and 'date' types can be compared to (filtered on) strings representing a date, for example to '2020-12-31'
 * 			- to find the first date you can check the MIN(flight_date)
 */ 
  


/* Q5. Which airport and in which city had the most departures during the first month?
 * 
 * 		Hints: 
 			- filter out cancelled flights
			- filter for flight_date BETWEEN 'start-date' AND 'end-date'
			- use LIMIT to focus on the highest departures, but also check whether only one airport has the most
 */



/* Q6. To which city/cities does the airport with the second most arrivals over all time belong?
 * 
 * 		Hint: 
 			- similar to the LIMIT clause limiting a number of rows the clause OFFSET skips a number of rows
 */


/* Q7. Filter the data to one date and count all rows for that day so that your result set has two columns: flight_date, total_flights.  
 * 		Repeat this step, but this time only include data from another date.
 * 		Combine the two result sets using UNION.
 */

--> UNION combines the distinct results of two or more SELECT statements


/* Q8. The last query can be optimized, right?
 * 		Rewrite the query above so that you get the same output, but this time you are not allowed to use UNION.
 * 
 * 		Hint: we can use a filter to get only the data for those 2 days. 
 */



/* Q9. Show flights with a departure delay of more than 30 minutes over all time?
 *      How big was the delay?
 * 	    What was the plane's tail number?
 * 	    On which date and in which city did the plane depart?   
 * 	    Answer all questions with a single query.
 */



/* Q10. Per airport, over all time, show
 *		- the city and the airport name
 * 		- how many flights had a departure delay of more than 30 minutes?
 *      - what was the average arrival delay for these flights?
 * 		- how many unique airplanes were involved?
 */



/* Q11. Find city names with :
 * 		- the most daily total departures
 * 		- the most daily unique planes departed
 * 		- the most daily unique airlines
 *
 * Use VIEWs to create the final join query:
 * 		1. VIEW calculating counts (departures, tails, airlines) per flight date and city. (Hint: filter out cancelled flights)
 * 		2. VIEW (querying from the 1st view) finding the max daily values over all for counts of departures, tails and airlines
 * 		3. In the final query join the 1st view to the 2nd on the max values 
 *    		Hint #1: the ON takes OR keywords
 *    		Hint #2: to tackle the case that the same airport has highscores on multiple days add a group by city and aggregate the metrics.
 * 
 * OPTIONAL: to count the number of the airports in a city STRING_AGG(DISTINCT origin, ', ')
 */


