
/* Exercise on string functions and data cleaning!
* As a data analyst you will work with customer data in many situations, 
* typical customer data is company or customer name, addresses and email addresses,...
* this is all text data so we can apply SQL string functions for data cleaning and transformation.
* In this exercise we provide you a realistic example dataset and some hands-on exercises how you would clean up such data :-)
*/ 
-- Q0:
SELECT * FROM messy_customer_data
/*
 * 1. We want the customer names in a consistent format.
 * The first task for this is to bring all initial letters of each word upper case
 * and all following letters lower case.
 */ 
--Q1:
SELECT *, 
	   INITCAP(customer_name) AS customer_name_cleaned
FROM messy_customer_data
 /*
* 2. Hang on! There is one exception. for the special case of 'Gmbh' we want it to be 'GmbH'
 */ 
--Q2:
SELECT *, 
	   REPLACE(INITCAP(customer_name),'Gmbh','GmbH') AS customer_name_cleaned
FROM messy_customer_data
 /*
 * 3. Let's move to the email addresses, for later analysis we would like to store the email provider in a seperate column.
 * Please extract the email provider from all email addresses and store it in a new column called 'email_provider'
  */ 
--Q3:
SELECT *, 
	   SPLIT_PART(email, '@', 2) AS email_provider
FROM messy_customer_data;

/*
 * 4. let's have a look at the 'address' column. First we would like to split street and house number. 
 * Create one column called 'street' that only contains the street information
 * Create another column called 'house_number' that stores that house number.
 *
 * There are many ways to achieve it. Try to use tools you already learned first!
 *
 */*
 * Hint #1: We can assume the house number is always last 
 */
 
 /*
 * Hint #2: We can use SPLIT_PART(string, delimiter, position) to get the house number. https://neon.tech/postgresql/postgresql-string-functions/postgresql-split_part
 * Challenge is - how do we find which part is the number, if the number of words in the street name is varying? :)
 */
  
/* 
 * Hint #3 (optional): using research or asking AI you will also find different solutions with Regular Expressions (RegEx) which is a huge topic on its own.
 * IMPORTANT: It is not required for our lecture! If you are interested, you would need to do some research. Here is a start: https://www.youtube.com/watch?v=zPeEU9dP83M
 * But you can eplore functions like REGEXP_SPLIT_TO_ARRAY() and REGEXP_MATCHES(). - Google ;)
 * Or we could use SUBSTRING() and its RegEx capability.
 */

--Q4:
--method 1:
WITH addr AS (
    SELECT address,
           string_to_array(address, ' ') AS arr
    FROM messy_customer_data
)
SELECT 
    address,
    array_to_string(arr[1:array_length(arr,1)-1], ' ') AS street,
    arr[array_length(arr,1)] AS house_number
FROM addr;

--method 2:
SELECT 
    address,
    substring(address FROM '^(.*)\s+\d+$') AS street,
    substring(address FROM '\d+$') AS house_number
FROM messy_customer_data;

--method 3:
SELECT *,
      regexp_replace(address, '\s+\d+$', '') AS street,
      regexp_replace(address, '.*\s+(\d+)$', '\1') AS house_number
      FROM messy_customer_data;

--method 4:
SELECT 
    address,
    reverse(address) AS reversed_address
FROM messy_customer_data;

-- method 5:
SELECT 
    address,
    left(address, length(address) - strpos(reverse(address), ' ') ) AS street,
    right(address, strpos(reverse(address), ' ') - 1) AS house_number
FROM messy_customer_data;

--method 6:
SELECT 
    address,
    split_part(reverse(address), ' ', 1) AS reversed_house_number
FROM messy_customer_data;

SELECT 
    address,
    reverse(split_part(reverse(address), ' ', 1)) AS house_number
FROM messy_customer_data;

SELECT 
    address,
    split_part(reverse(address), ' ', 2) AS reversed_street
FROM messy_customer_data;

SELECT 
    address,
    reverse(split_part(reverse(address), ' ', 2)) AS street
FROM messy_customer_data;


SELECT 
    address,
    reverse(split_part(reverse(address), ' ', 2)) AS street,
    reverse(split_part(reverse(address), ' ', 1)) AS house_number,
FROM messy_customer_data;

SELECT 
    address,
    left(address, length(address) - strpos(reverse(address), ' ') ) AS street,
    right(address, strpos(reverse(address), ' ') - 1) AS house_number
FROM messy_customer_data;

--method 7
SELECT address, REGEXP_REPLACE(address, '([0-9]+)', '/\1') AS adress_changed
FROM messy_customer_data;
-- ([0-9]+) captures one or more digits as group 1
-- '/\1' inserts a slash before the digits captured in group 1

SELECT 
    address,
    SPLIT_PART(REGEXP_REPLACE(address, '([0-9]+)', '/\1'), '/', 1) AS street,
    SPLIT_PART(REGEXP_REPLACE(address, '([0-9]+)', '/\1'), '/', 2) AS house_number
FROM messy_customer_data;


/*SPLIT_PART(..., '/', n) splits the string using '/' as a delimiter and returns the n-th part.
SPLIT_PART(str, '/', 1) returns the first part before the '/' → the street name.
SPLIT_PART(str, '/', 2) returns the second part after the '/' → the house number.*/

/*
  * 5. Furthermore, we want all street names to be in a consistent format.
  * For that, please make sure all the different version of street in german (str, Str, strasse, straße, Strasse) are replaced by simply 'street'.
  */
-- Q5:

SELECT
    *,
    -- Extract street
    left(address, length(address) - strpos(reverse(address), ' ')) AS street,
    -- Standardize German suffixes to 'street'
    REGEXP_REPLACE(
        left(address, length(address) - strpos(reverse(address), ' ')),
        '(strasse|straße|str)(?=\s|$)',
        'street',
        'gi'
    ) AS street_standardized,
    -- Extract house number
    right(address, strpos(reverse(address), ' ') - 1) AS house_number
FROM messy_customer_data;

/*
 * 6. Continuing with cleaning the street names... we want all street names and the word street to be connected without a whitespace. 
 * For example "Berlin street" shall be "Berlinstreet". Please make sure all street names are in that format.
 */
-- Q6:
SELECT
    customer_name,
    email,
    address,
    -- Extract street
    LEFT(address, length(address) - strpos(reverse(address), ' ')) AS street,
    -- Extract house number
    RIGHT(address, strpos(reverse(address), ' ') - 1) AS house_number,
    -- Standardize German suffixes to 'street'
    REGEXP_REPLACE(
        LEFT(address, length(address) - strpos(reverse(address), ' ')),
        '(strasse|straße|str)(?=\s|$)',
        'street',
        'gi'
    ) AS street_standardized,
    -- Remove any space before the word 'street'
    REGEXP_REPLACE(
        REGEXP_REPLACE(
            LEFT(address, length(address) - strpos(reverse(address), ' ')),
            '(strasse|straße|str)(?=\s|$)',
            'street',
            'gi'
        ),
        '\s+(street)$',
        '\1',
        'i'
    ) AS street_cleaned
FROM messy_customer_data;

/*
 * 7. For some customers the address field is empty. Please fill the empty space with the string 'NA' and call the column 'address_final'.
 * Please do so with street and street_number as well and call the columns 'street_final' and 'house_number_final'.
 */
--- Q7

SELECT
    customer_name,
    email,
    address,
    -- Extract street
    LEFT(address, length(address) - strpos(reverse(address), ' ')) AS street,
    -- Extract house number
    RIGHT(address, strpos(reverse(address), ' ') - 1) AS house_number,
    -- Standardize German suffixes to 'street'
    REGEXP_REPLACE(
        LEFT(address, length(address) - strpos(reverse(address), ' ')),
        '(strasse|straße|str)(?=\s|$)',
        'street',
        'gi'
    ) AS street_standardized,
    -- Remove any space before the word 'street'
    REGEXP_REPLACE(
        REGEXP_REPLACE(
            LEFT(address, length(address) - strpos(reverse(address), ' ')),
            '(strasse|straße|str)(?=\s|$)',
            'street',
            'gi'
        ),
        '\s+(street)$',
        '\1',
        'i'
    ) AS street_cleaned,
    COALESCE(address, 'NA') AS address_final,
    COALESCE(REGEXP_REPLACE(
        REGEXP_REPLACE(
            LEFT(address, length(address) - strpos(reverse(address), ' ')),
            '(strasse|straße|str)(?=\s|$)',
            'street',
            'gi'
        ),
        '\s+(street)$',
        '\1',
        'i'), 'NA') AS street_final,
    COALESCE(RIGHT(address, strpos(reverse(address), ' ') - 1), 'NA') AS house_number_final
FROM messy_customer_data;

/* 8. BONUS (optional)
 * Combine the final results in one query. Feel free to modyfy and experiment, but here is a suggested order of columns in the result table
 * - customer_name
 * - country
 * - adress
 * - street_name
 * - house_number
 * - email
 * - email_provider
 *
 * Hint: Otionally you could solve this task also step by step with CTEs (Note: in some cohorts CTE lecture will be the next)
 */
--Q8

WITH step1 AS (
    SELECT *, 
           REPLACE(INITCAP(customer_name),'Gmbh','GmbH') AS customer_name_cleaned  --replace of Gmbh and capitalization 
    FROM messy_customer_data
),
step2 AS (
    SELECT *,
           SPLIT_PART(email, '@', 2) AS email_provider  -- extract email provider
    FROM step1
),
step3 AS (
    SELECT *,
           LEFT(address, LENGTH(address) - STRPOS(REVERSE(address), ' ') ) AS street,  -- separate street and house number
           RIGHT(address, strpos(reverse(address), ' ') - 1) AS house_number
    FROM step2
),
step4 AS (
    SELECT *,
           REGEXP_REPLACE(street, '(strasse|straße|str)(?=\s|$)', 'street', 'gi') AS street_standardized  -- street standardization
    FROM step3
),
step5 AS (
    SELECT *,
           REGEXP_REPLACE(street_standardized, '\s+(street)$', '\1', 'i') AS street_cleaned  --delete whitespace between street and a word
    FROM step4
),
step6 AS (
    SELECT *,
           COALESCE(address, 'NA') AS address_final,    --fill in the missing data with NA in the address column
           COALESCE(street_cleaned, 'NA') AS street_final,  --fill in the missing data with NA in the street column
           COALESCE(house_number, 'NA') AS house_number_final  --fill in the missing data with NA in the house_number column
FROM step5
)
SELECT customer_name_cleaned,  --display specific columns
       country,
       address_final,
       street_final,
       house_number_final,
       email,
       email_provider
FROM step6;
 