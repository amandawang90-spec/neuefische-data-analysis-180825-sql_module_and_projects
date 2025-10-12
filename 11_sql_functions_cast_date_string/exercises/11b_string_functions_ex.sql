
/* Exercise on string functions and data cleaning!
* As a data analyst you will work with customer data in many situations, 
* typical customer data is company or customer name, addresses and email addresses,...
* this is all text data so we can apply SQL string functions for data cleaning and transformation.
* In this exercise we provide you a realistic example dataset and some hands-on exercises how you would clean up such data :-)
*/ 

/*
 * 1. We want the customer names in a consistent format.
 * The frist task for this is to bring all initial letters of each word upper case
 * and all following letters lower case.
 * 
 * 2. Hang on! There is one exception. for the special case of 'Gmbh' we want it to be 'GmbH'
 * 
 * 3. Let's move to the email addresses, for later analysis we would like to store the email provider in a seperate column.
 * Please extract the email provider from all email addresses and store it in a new column called 'email_provider'
 * 
 * 4. let's have a look at the 'address' column. First we would like to split street and house number. 
 * Create one column called 'street' that only contains the street information
 * Create another column called 'house_number' that stores that house number.
 *
 * There are many ways to achieve it. Try to use tools you already learned first!
 * 
 * Hint #1: We can assume the house number is always last 
 *
 * Hint #2: We can use SPLIT_PART(string, delimiter, position) to get the house number. https://neon.tech/postgresql/postgresql-string-functions/postgresql-split_part
 * Challenge is - how do we find which part is the number, if the number of words in the street name is varying? :)
 * 
 * Hint #3 (optional): using research or asking AI you will also find different solutions with Regular Expressions (RegEx) which is a huge topic on its own.
 * IMPORTANT: It is not required for our lecture! If you are interested, you would need to do some research. Here is a start: https://www.youtube.com/watch?v=zPeEU9dP83M
 * But you can eplore functions like REGEXP_SPLIT_TO_ARRAY() and REGEXP_MATCHES(). - Google ;)
 * Or we could use SUBSTRING() and its RegEx capability.
 *
 * 5. Furthermore, we want all street names to be in a consistent format.
 * For that, please make sure all the different version of street in german (str, Str, strasse, straße, Strasse) are replaced by simply 'street'.
 *
 * 6. Continuing with cleaning the street names... we want all street names and the word street to be connected without a whitespace. 
 * For example "Berlin street" shall be "Berlinstreet". Please make sure all street names are in that format.
 *
 * 7. For some customers the address field is empty. Please fill the empty space with the string 'NA' and call the column 'address_final'.
 * Please do so with street and street_number as well and call the columns 'street_final' and 'house_number_final'.
 *
 */

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