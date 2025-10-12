/*   As a Data Analyst, it is crucial that you can rely on the quality of your data at all times.
 *   The data in the actual_elapsed_time column in the flights table seems to be about the time from departure to arrival.
 *   Currently, this is only an assumption. Based on this assumption, do you feel confident in using this column in your 
 *   analysis and giving out business recommendations?
 *   If your answer is no, you're on a good path to becoming an analyst.
 *
 * 1.Using the data in the remaining columns in the flights table, can you think of a way to verify our assumption?
 *   Please provide the answer below.
 */

-- Yes, we can calculate the difference between departure and arrival time and compare it to the values in the 
-- actual_elapsed_time column to check if they're equal.

/*   Don't worry if you couldn't figure this one out. To verify our assumption, we can calculate the difference between 
 *   departure and arrival time and compare the result to the values in the actual_elapsed_time column to check if they're equal.
 */

/* 2.1 The first step is to become familiar with the dep_time, arr_time and actual_elapsed_time columns.
 *     Based on the column names and what you already know from previous exercises about the information that is stored 
 *     in these three columns, what are your assumptions about the data types of the values?
 */

-- arr_time: TIME value in the format XX:XX e.g. 11:30
-- dep_time: TIME value in the format XX:XX e.g. 11:30
-- actual_elapsed_time: Either in seconds, minutes or hours; stored as INT or INTERVAL in the format XX:XX:XX e.g. 00:10:00


/* 2.2 Retrieve all unique values from these columns in three separate queries and order them in descending order.
 *     Did your assumptions turn out to be correct?
 * 	   Please provide the queries below.
 */

SELECT DISTINCT arr_time
FROM flights f
ORDER BY arr_time DESC;
-- arr_time is stored as a hundred or thousand number

SELECT DISTINCT dep_time
FROM flights f
ORDER BY dep_time DESC;
-- dep_time is stored as a hundred or thousand number

SELECT DISTINCT actual_elapsed_time 
FROM flights f
ORDER BY actual_elapsed_time DESC;
-- actual_elapsed_time is stored in minutes as INT/FLOAT

/* 3.1 Next, calculate the difference of dep_time and arr_time and call it flight_duration.
 * 	   Please provide the query below.
 */


/* 3.2 Are the calculated flight duration values correct? If not, what's the problem and how can we solve it?
 *     Please provide the answer below.
 */

-- No, the values are not correct. dep_time and arr_time are not in time formats and the difference is not in minutes.

/* 4 In order to calculate correct flight duration values we need to convert dep_time, arr_time and actual_elapsed_time 
 *   into useful data types first.
 *   Change dep_time and arr_time into TIME variables, call them dep_time_f and arr_time_f. (Hint: 100% focus on the remainder)
 *   Change actual_elapsed_time into an INTERVAL variable, call it actual_elapsed_time_f.
 *   Query flight_date, origin, dest, dep_time, dep_time_f, arr_time, arr_time_f, actual_elapsed_time and actual_elapsed_time_f.
 *   Please provide the query below.
 *   Tip: use (dep_time::INT / 100) for the hour and (dep_time::INT % 100) for the minutes
 */


/* 5.1 Querying the raw columns next to the ones we have transformed, makes it a lot easier to compare the result to the input.
 *     This allows for quick prototyping and debugging and helps to understand how functions work. 
 *     To optimize our query in terms of performance and readability, we can always remove unneccessary columns in the end. 
 *     Use the previous query and calculate the difference of arr_time_f and dep_time_f and call it flight_duration_f.
 * 	   Please provide the query below.
 */
 
/*     NOTE: From now on we will provide you with a
 *     - long solution: easy to debug -> includes additional columns that are not necessary to solve the exercise
 *     - short solution: optimised for performance and readability -> without any unecessary columns
 *       as well as alternative solutions using one or multiple subqueries and detailed explanations where necessary.
 */


/* 5.2 Compare the calculated flight duration values in flight_duration_f with the values in the actual_elapsed_time_f column and 
 * 	   calculate the percentage of values that are equal in both columns.
 * 	   Please provide the query below.
 */

/* Explanation of the solution: 
 * The output of comparing two numbers, actual_elapsed_time_f and flight_duration_f, results in TRUE/FALSE of type BOOLEAN
 * Casting a BOOLEAN into an INTEGER turns TRUE=1 and FALSE=0, summing up the values gives the total number of equal values
 * In order to calculate the percentage, we can simply divide it by the total number of flights using COUNT(*)
 * Remember: In SQL, dividing two INTEGERS results in an INTEGER. Therefore we need to cast one value into a float using * 1.0.
 */


/* 5.3 Given the percentage of matching values, can you come up with possible explanations for why the rate is so low?
 *     Please provide the answer below.
 */



/* 6.1 Differences due to time zones might be one reason for the low rate of matching values.
 *     To make sure the dep_time and arr_time values are all in the same time zone we need to know in which time zone they are.
 *     Take your query from exercise 5.1 and add the time zone values from the airports table.
 * 	   Make sure to transform them to INTERVAL and change their names to origin_tz and dest_tz.
 *     Please provide the query below.
 */




/* 6.2 Use the time zone columns to convert dep_time_f and arr_time_f to UTC and call them dep_time_f_utc and arr_time_f_utc.
 * 	   Calculate the difference of both columns and call it flight_duration_f_utc.
 *     Please provide the query below.
 */


/* 6.3 Again, calculate the percentage of matching records using the new flight_duration_f_utc column.
 *     Try to round the result to two decimals.
 *     Explain the increase in matching records.
 *     Please provide the query and answer below.
 */


/* Extra Challenge
 * For the essential part of the SQL challenge, it's ok if you just read through the SQL query.
 * Queries 7.1 and 7.2 are just there to make you aware of the problem...
 * Query 7.3 actual implements a solution. Pay especially attention to the CASE WHEN statement.
 * this is the statement that fixes the issue for overnight flights
 * 7.1 We managed to increase the rate of matching records to >80%, but it's still not at 100%.
 *     Could overnight flights be an issue?
 *     What is special about values in the flight_duration_f_utc column for overnight flights?
 *     Please provide the answer below.
 */


/* 7.2 Calculate the total number of flights that arrived after midnight UTC.
 *     Please provide the query below.
 */


/* 7.3 Use your knowledge from 7.1 and 7.2 to increase the rate of matching records even further.
 *     Please provide the query below.
 */


/*
* ok great! we get a match of 98,77%! We leave it at that for now...
* After this long part of verifying the column actual_elapsed_time we feel confident
* to make analysis based on this column and give out business recommendations.
*
* The flight-scheduling department needs support with their monthly review of scheduled 
* flight durations. Their job is it to define the most accurate flight durations for all
* available routes. It works the following: you have 'scheduled departing time'
* and the flight-scheduling department is in charge of defining the 'scheduled arrival time'. 
* Given these two times, you can calculate the 'scheduled flight duration'.
* 
* The 'scheduled flight duration' is the metric the department wants to review. 
* How accurate is the metric 'scheduled flight duration' compared to the 'actual_elapsed_time'? 
* The team is especially interested if 'scheduled flight duration' is shorter than 'actual_elapsed_time'.
* They want to know which routes have the highest share of flights where 
* the 'scheduled flight duration' is shorter than 'actual_elapsed_time'? 
* and what's the average difference for flights on that route? 
* To make it worthwhile, they focus on routes that had at least 30 flights in January.
*
* You as an analyst are asked to answer these questions with the help of the available data.
* You are asked to summarize your main findings in a short text.
*/