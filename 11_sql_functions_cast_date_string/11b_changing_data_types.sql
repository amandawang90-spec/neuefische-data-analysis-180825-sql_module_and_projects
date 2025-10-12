/* Datatypes
Let's take a closer look at data types. So what are data types in PostgresSQL? 
Well, a data type is basically a guideline for SQL to understand what type of data is supposed to 
be in each column. Data types are important in SQL because especially when you're importing 
data into PostgresSQL, you have to specify which column has what data type. 
If there is bad data in that column and it doesn't follow the data type that you have specified, 
it may exclude that data when it's actually importing the data into that table.
Data types also identify how SQL is going to interact with the data in those tables. 
So if you have a date data, you're going to be able to use date functions on it, 
which you would not be able to use with just integers or numeric data. 

There are three main categories of data types. We have strings, numeric, Date and time. 
For each of them there are different data types how you can store datal, the goal of choosing 
the right data type is to be as storage efficient as possible. 
We've summarized the mostly used data types for you in the table below. 
For a complete picture, please have a look at: https://www.postgresql.org/docs/current/datatype.html

**** Commonly used numeric Data types *****
|    Name                                 |  Alias               | Description                                                  
|-----------------------------------------|----------------------|-----------------------------------------------------|
| int8                                    |                      | signed eight-byte integer                           |  
| integer                                 | int, int4            | signed four-byte integer                            |   
| smallint                                | int2                 | signed two-byte integer                             |   
| numeric [ (p, s) ]                      | decimal [ (p, s) ]   | exact numeric of selectable precision               |   
| real                                    | float4               | single precision floating-point number (4 bytes)    |   
| double precision                        | float8               | double precision floating-point number (8 bytes)    |   

**** Commonly used string Data types *****
| character [ (n) ]                       | char [ (n) ]          | fixed-length character string                       |   
| character varying [ (n) ]               | varchar [ (n) ]       | variable-length character string                    |  
| text                                    |                       | variable-length character string                    |  

**** Commonly used date and time Data types *****
| date                                    |                       | calendar date (year, month, day)                    |   
| interval [ fields ] [ (p) ]             |                       | time span                                           |   
| time [ (p) ] [ without time zone ]      |                       | time of day (no time zone)                          |   
| time [ (p) ] with time zone             | timetz                | time of day, including time zone                    |   
| timestamp [ (p) ] [ without time zone ] |                       | date and time (no time zone)                        |  
| timestamp [ (p) ] with time zone        | timestamptz           | date and time, including time zone                  |   

**** Boolean data type ****
| boolean                                 | bool                   | logical Boolean (true/false)                        |   
*/


/* CAST
 * with type casting you can 'cast' a object to a new data type. this only works when the object is 
 * 'castable' to that type, for instance you can cast a integer to text, but you cannot cast 
 the string 'dog' to date.
 */

-- We can either CAST the flight_date column to type VARCHAR to resolve this
SELECT CAST(flight_number AS VARCHAR)
FROM flights;

-- or use the ::TYPE notation
SELECT flight_number::VARCHAR
FROM flights;

-- CAST string to date type
SELECT flight_date, 
	   CAST(flight_date AS DATE),
	   flight_date::DATE
FROM flights

-- create a column of a specific type 
-- create a column as date (passing a string)
SELECT country, 
	   DATE '2020-01-01' AS one_date,
	   INT '2030' AS the_year
FROM regions;


/* In the example below we want to extract the year and the month from the flight_date column.
 * For that we need to extract the first 7 characters. The function LEFT() is perfect for this.
 * Hoever, this function only works with character type columns.
 * flight_date is of type DATE. We can change this by casting the column to type TEXT or VARCHAR.
*/

SELECT LEFT(flight_date::TEXT, 7) AS month_year
from flights

