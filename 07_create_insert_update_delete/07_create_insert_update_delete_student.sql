/* # CREATING, MODIFYING AND DELETING TABLES
 * 
 * 		The output of a query is a result set, a table presented temporary after the query execution.
 *		One option to make a temporary result set persistent is to create a new table.
 */

/* ### Heads Up: Switching schemas in DBeaver
 * 		So far we've worked only in the schema public, a default schema which comes when you create a database.
 * 		In the following lectures we would need to work on individual tables in your own schemas.
 * 
	 	>>> SIDE BAR: What Is a Database Schema?
	  	>		A database schema serves as a blueprint for organizing data within your database. It defines the 
	  	>		structure of logical elements such as tables, fields, records, columns, triggers, functions, procedures, 
	  	>		indexes, and keys. By efficiently designing your schema, you can enhance query response times and overall 
	  	>		usability. (more: https://www.postgresqltutorial.com/postgresql-administration/postgresql-schema/)
 *  
 * 		In the tool-bar above, you can now switch the "Active catalog/schema" to your schema.
 * 
 * 		As long as the schemas exist within the same database, you can reference tables from any schema in your 
 * 		current script. Simply prefix the schema name before the table, like this 'your_schema_name.table_name'
 * 
		For example:
 	
 			public.life_expectancy  
 */

/* ### Let's define a query for a table with:
 * 			- average life expectancy
 * 			- first year and
 * 			- last year of recorded data 
 * 			- for each country
 */
SELECT country,
	   AVG(life_expectancy) AS avg_life_expectancy,
	   MIN(year) as first_year,
	   MAX(year) as last_year
FROM public.life_expectancy -- if the active schema of this script is not 'public' we still can address it.
GROUP BY country
ORDER BY country;

/* ### Creating a table 'countries' in your schema
 * 
 * 		To create a new table we simply need to add "CREATE TABLE new_table_name AS" before the query.
 * 
 * 		Unlike pure SELECT queries, we don’t receive a result set as an output when creating a new table. 
 * 		Instead, if everything worked correctly, we’ll receive a confirmation about the executed query. 
 * 		The 'Start Time' and 'Finish Time' indicate how long it took. Keep in mind that some queries can run for hours.
 *  
 * 		NOTE: in DBeaver you need to right-click the Schema -> select "Refresh" in order to see the new table
 */
CREATE TABLE countries AS
SELECT country,
	   AVG(life_expectancy) AS avg_life_expectancy,
	   MIN(year) as first_year,
	   MAX(year) as last_year
FROM public.life_expectancy
GROUP BY country
ORDER BY country;

-- now you can query directly from the aggregated data
SELECT * FROM countries;

/* ### DROP TABLE 
 * 		We can delete tables -> DROP TABLE IF EXISTS table_name;
 * 
 *		Careful! There is no "undo" in SQL. If you successfully dropped anything, it is gone.
 *		Make sure you always save the original table creation query. 
 */
DROP TABLE IF EXISTS countries;

/*  	we could also simply write 'DROP TABLE countries', but if there is no table, it will return an error. 
 * 		Try it. Then try the IF EXISTS version again.
 */  
DROP TABLE countries;

/* 		In case we need to recover the table after it was accidentally changed we need to overwrite the existing table. 
 * 		We simply combine both queries. First the query to delete the table and then the query to create it anew. 
 * 		This would be the query to save (e.g. in production documentation).
*/
DROP TABLE IF EXISTS countries;
CREATE TABLE countries AS
SELECT country,
	   AVG(life_expectancy) AS avg_life_expectancy,
	   MIN(year) as first_year,
	   MAX(year) as last_year
FROM public.life_expectancy
GROUP BY country
ORDER BY country;

-- check the table
SELECT * FROM countries;


/* ## BONUS 1: UPDATING and ALTERING TABLES
 * 		We can add rows with data, add new columns and fill them with data 
*/

/* ### ADDING A ROW
 * 		Insert a new row into the 'countries' table with values for each column.
 * 		NOTE:The values inside paranthesis have to match the order of the table's columns
 * 		p.s.: We refer to the land of vampires in our example, hence the age and year :)
 */
INSERT INTO countries VALUES ('Transylvania', 200.99999, 1200, 2016);

/* ### ADDING A COLUMN
 * 		Add a new column named 'period_len' of type numeric to the 'countries' table.
 * 		Note: On creation all values are NULL
 */
ALTER TABLE countries ADD COLUMN period_length numeric;

/* ### FILLING COLUMN WITH DATA (updating table )
 * 		Update the table 'countries' by setting 'period_len' column as the difference between 'last_year' and 'first_year' columns.
 */
UPDATE countries SET period_length = last_year - first_year;

/* ### UPDATING A ROW
 * 		Actually, the vampire records start in 1500s. We need to correct our data.
 * 		Update 'first_year' to 1500 and 'total_records' to the difference between 2016 and 1500
 * 		for the row where the country is 'Transylvania'.
 */
UPDATE countries SET first_year = 1500, period_length = last_year - 1500 WHERE country = 'Transylvania';
	 
/* ### DELETING ROWS and COLUMS
 * 		We can also delete rows and columns. 
 */

-- Delete the row(s) from the 'countries' table with a condition "country = 'Transylvania'".
DELETE FROM countries WHERE country = 'Transylvania';

-- Delete the column 'period_length' from the 'countries' table 
ALTER TABLE countries DROP COLUMN period_length;

-- actually, we need this column later. There is no "undo" in PostgreSQL, but we still have the query and can quickly recreate it.
ALTER TABLE countries ADD COLUMN period_length numeric;
UPDATE countries SET period_length = last_year - first_year;


/* BONUS 2
 * 
 * ## CREATING EMPTY TABLES AND FILLING THEM WITH DATA
 * 
 * Initially when setting a databas a common way is to create empty tables specifying: 
 * - column names 
 * - data type of each columns
 * - constraints (unique, not null, primary key, references...)
 * Then in the second step the data is filled in manually, as a bulk, or live from a real-time source
 */

CREATE TABLE countries_selection (
	   state VARCHAR(255) UNIQUE, -- column accepts only unique values
	   le_avg NUMERIC NOT NULL, -- the column is not allowing NULL values
	   record_start INTEGER,
	   record_end INTEGER,
	   record_duration INTEGER
	   );
	  
-- Check it out. The table is empty. But we have the structure: columns and constraints. 
SELECT * FROM countries_selection;
	  
/* ### INSERTING DATA INTO an predefined table. 
 * 		There are numerous use cases and optional sources from which we can import data. 
 * 		Let’s explore one option for inserting data into a table from a query.
 */ 
	  
-- Add data to the table 'countries_selection' from a query filtering the table 'countries' 
-- for 5 countries, also rounding the avg_life_expectancy
INSERT INTO countries_selection (state, le_avg, record_start, record_end, record_duration)
SELECT country, 
	   ROUND(avg_life_expectancy::NUMERIC, 2), 
	   first_year, 
	   last_year, 
	   period_length
FROM countries
WHERE country IN ('Andorra', 'Brazil', 'Germany', 'Nepal', 'Iceland' );

-- check the new table
SELECT * FROM countries_selection;

-- To clear all data, but keep the table structure use TRUNCATE
TRUNCATE countries_selection

-- delete table
DROP TABLE IF EXISTS countries_selection;


/* ### Recovering deleted table - 'countries_selection'
 *		We will need it for the next lecture's excercise. 
 *		Please copy queries from above which 
 *		- create the 'countries_selection' 
 * 		- fill it with data
 *		and paste it here below.
 */




/* Bonus topic: figure out a query to create a table and insert data from a csv file. 
 * Don't take Graphic interface shortcuts, use queries. */ 

-- https://www.postgresqltutorial.com/postgresql-tutorial/import-csv-file-into-posgresql-table/
