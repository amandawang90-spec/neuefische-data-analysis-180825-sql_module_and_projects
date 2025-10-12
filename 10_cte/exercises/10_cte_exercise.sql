/* Airport Stats
 *
 * In one table, show per airport in separate columns:
 *  - count of departures 
 *  - count of arrivals 
 *
 * BONUS: what other stats can be added?
 */








/* Solve the Q11. question from JOINs exercise in  "09_joins_ex_airports.sql" 
 * but now with CTEs:
 *
 *      Q11. Find city names with :
 * 		        - the most daily total departures
 * 		        - the most daily unique planes departed
 * 		        - the most daily unique airlines
 *
 * We can use CTE to make it easier to understand the query. But, there is no "The best way."
 *
 * We can adapt the 3 Steps we did using Views, but now with CTEs:
 *      1. Calculate counts (departures, tails, airlines) per flight date and city. 
                (Hint: filter out cancelled flights)
 * 		2. (Querying from the 1st CTE) Find the max daily values over all for counts of departures, tails and airlines
 * 		3. In the final query join the 1st view to the 2nd on the max values 
 *    		Hint #1: the ON takes OR keywords
 *    		Hint #2: to tackle the case that the same airport has highscores on multiple days add a group by city and aggregate the metrics.
 * 
 * OPTIONAL: to count the number of the airports in a city STRING_AGG(DISTINCT origin, ', ')
 */


 