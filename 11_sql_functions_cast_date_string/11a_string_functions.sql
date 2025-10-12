/* String Functions
 * String functions help us look at and kind of manipulate text and string data.  
 * More info about string functions: https://www.postgresql.org/docs/current/functions-string.html
 */

/* 1. String length: number of characters in string:
 * 
 * 		CHAR_LENGTH(string) -> int 
 * 		same as CHARACTER_LENGTH(string)
 * 
 * 		LENGTH(string) -> int
 * 
 * Both the functions are string functions and return the number of characters present in the string. 
 * But they differ in the concept that CHAR_LENGTH() function measures the string length in 'characters' 
 * whereas LENGTH() function measures the string length in 'bytes'.
 */

SELECT student_name,
	   LENGTH(student_name) AS name_in_bytes,
	   CHAR_LENGTH(student_name) AS name_characters
FROM students;

/* 2. String filtering: Returns true if string starts with prefix.
 * 
 * 		STARTS_WITH(string, prefix) -> bool: 
 */
SELECT STARTS_WITH('SPICED', 'SP') AS string_position;

SELECT *
FROM regions
WHERE STARTS_WITH(country, 'Li');

/* 3. String concatenation (NULL arguments are ignored.)
 * 
 * 		CONCAT(str "any" [, str "any" [, ...] ]) -> text 
 * 		CONCAT_WS(sep text, str "any" [, str "any" [, ...] ]) -> text (The first argument is used as the separator string.)
 */

SELECT CONCAT(country, region) AS string_concat 
FROM regions;

SELECT CONCAT_WS(' ', country, 'in', region) AS string_concat_ws
FROM regions;

/* 4. String letter case */

 -- LOWER(string) -> text: Convert string to lower case
SELECT student_name, 
	   LOWER(student_name) AS name_lower
FROM students;

-- UPPER(string) -> text: Convert string to upper case
SELECT student_name, 
	   UPPER(student_name) AS name_lower
FROM students;

 -- INITCAP(string) -> text: Convert the first letter of each word to upper case and the rest to lower case.
SELECT seminar_name, 
	   INITCAP(seminar_name) AS Seminar
FROM enrolments;

/* 5. String extraction by index
 * 
 * LEFT(str text, n int) -> text
 * Return first n characters in the string. When n is negative, return all but last |n| characters.
 */
SELECT LEFT(student_name, 2) AS string_from_left
FROM students;

/* RIGHT(str text, n int) -> text
 * Return last n characters in the string. When n is negative, return all but first |n| characters.
 */
SELECT RIGHT(student_name, 3) AS string_from_right
FROM students;

/* SUBSTRING(string [from int] [for int]) -> text: 
 * Extract substring
 */
SELECT SUBSTRING(student_name FROM 3 FOR 2) AS string_substring
FROM students;


/* 6. Extraction by splitting
 * split_part(string text, delimiter text, field int) -> text: Split string on delimiter and return the given field (counting from one)
 */
SELECT country, 
	   SPLIT_PART(country, ' ', 2) AS string_split
FROM regions;


/* 7. String replacing
 * 1. overlay(string placing string from int [for int]) -> text: Replace substring
 * 2. replace(string text, from text, to text) -> text: Replace all occurrences in string of substring from with substring to
 * 3. regexp_replace(string text, pattern text, replacement text [, flags text]) -> text: Replace substring(s) matching a POSIX regular expression.
 */
SELECT country, region, REPLACE(region,'fri','me') AS region_changed
FROM regions;








/* 
Teaching Tips:
it works well to do this code-along as a group work.
post this in slack as task description:
Try to understand the function of your group. use the documentation for that. 
Have alook what parameters the function requires.
after 15 minutes, present the function(s) that were introduced in your part. 
max 5 min per presentation
For the Presentation:
- Show us the documentation of the https://www.postgresql.org/docs/9.1/functions-string.html. especially go through al the parameters the function requires.
- Show us the examples in the script in dbeaver

Ella, XYZ - Group 1
Sascha, XYZ - Group 2
Jeremie,... - Group 3
....
*/
