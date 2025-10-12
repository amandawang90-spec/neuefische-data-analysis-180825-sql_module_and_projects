/* # Pre-SETUP 
 * In this encounter we will use tables 'students' and 'enrolments'
 * 
 * Also we will add a new table 'exam_grades'
 *  
 * Best practice is to add "DROP TABLE IF EXISTS <tablename>" clause, in case when we need 
 * to re-run or update our query. Ensuring the previous table will be "over-written".
 */ 
DROP TABLE IF EXISTS exam_grades;
CREATE TABLE exam_grades (
  seminar_name VARCHAR(255),
  student_id INT,
  grade NUMERIC
);

ALTER TABLE exam_grades
ADD FOREIGN KEY (student_id) REFERENCES students(student_id);

INSERT INTO exam_grades (seminar_name, student_id, grade)
VALUES 
('art', 5, 1.3)
,('ethics', 2, 1.0)
,('engineering', 4, 2.1)
,('politics', 1, 3.5);

-- Let's check our tables
SELECT * FROM students;
SELECT * FROM enrolments;
SELECT * FROM exam_grades;

/* # JOINS
 * 	To query data that exists in different tables you join the tables together and conduct the query 
 * 	on the combined table. As was seen in the module pandas' merging lecture, there are several 
 * 	different kinds of joins that deliver different results depending on the user’s goal.
 */

/* ### SYNTAX
 * 	We often have to add table names as prefixes to the column names in order to avoid confusion about 
 * 	which column is from which table, thus preventing ambiguity errors.
 */
		SELECT x_table.column_1, x_table.column_2 , y_table.column_1
		FROM x_table 
		JOIN y_table 
		ON x_table.column_1 = y_table.column_1;

/* ### JOIN or INNER JOIN
 * 	The default type of join in PostgreSQL is the inner join. When you write JOIN, the parser actually 
 *  interprets it as an INNER JOIN.
 */ 
SELECT * 
FROM students
JOIN enrolments
ON students.student_id = enrolments.student_id

/* ### LEFT JOIN
 * 	A LEFT JOIN, retrieves all records from the first table and matches them to the records in the 
 *	second table. If there’s no match for a specific record, you’ll get NULLs in the corresponding 
 * 	columns of the right table.
 * 
 *	Note: Let's give our table shorter aliases, which we can use for the ON clause.
 **/

SELECT * 
FROM students AS s
LEFT JOIN exam_grades AS eg
ON s.student_id = eg.student_id

/* ### RIGHT JOIN
 * A RIGHT JOIN combines data from two tables based on a common column. However, it returns all rows 
 * from the right table and only the matching rows from the left table. If there’s no match for a 
 * specific record, you’ll get NULLs in the corresponding columns of the left table.
 */

SELECT * 
FROM students AS s
RIGHT JOIN exam_grades AS eg
ON s.student_id = eg.student_id

/* ### FULL JOIN
 *  A FULL JOIN combines the rows from two tables, including both matching and non-matching rows.
 * 	Certainly! A FULL JOIN, also known as a FULL OUTER JOIN, combines the rows from two tables, 
 * 	including both matching and non-matching rows.
 *
 *	In our next example we need to join ON multiple columns (combined with AND). Because each student 
 *	can pick multiple seminars and also each seminar can enroll multiple students.
 */

SELECT * 
FROM enrolments AS er
FULL JOIN exam_grades AS eg
ON er.student_id = eg.student_id AND er.seminar_name = eg.seminar_name;

/* ### Curious Fact: 
 * 	All join types have two clause version, which can be used interchangeably:  
	 	JOIN = INNER JOIN
	 	LEFT JOIN = LEFT OUTER JOIN
	 	RIGHT JOIN = RIGHT OUTER JOIN
	 	FULL JOIN = FULL OUTER JOIN 
 */ 
 
/* ### USING
 *  If the column (or columns) that we want to join tables on have exactly the same name(s) in both tables, 
 * 	we can use the USING clause instead of the ON clause. The to-join-on column(s) have to be listed within 
 * 	parentheses.
 */
SELECT * 
FROM enrolments 
FULL JOIN exam_grades
USING (student_id, seminar_name)

/* ### Multiple Joins in a query
 * 	You can chain JOIN operations one after the other.
 */
SELECT * 
FROM students
LEFT JOIN enrolments USING (student_id)
FULL JOIN exam_grades
USING (student_id, seminar_name)
;

-------- BONUS 1 -------- 

/* ### VIEW
 * 	Views act as virtual tables defined by queries, allowing you to access data without storing redundant 
 *  copies. Each time you query a view, it dynamically executes the underlying defining query. 
 */

DROP VIEW IF EXISTS academy_total_view;
CREATE VIEW academy_total_view AS (
	SELECT * 
	FROM students
	LEFT JOIN enrolments USING (student_id)
	FULL JOIN exam_grades
	USING (student_id, seminar_name)
);

SELECT * from academy_total_view;

-- UPDATE 1: changing original table 'enrolments'. Now check the view again.
INSERT INTO enrolments (seminar_name, student_id) VALUES ('art', 3);

-- TEST 1: did the result change?
SELECT * from academy_total_view;

/* ### MATERIALIZED VIEW
 * A materialized view in PostgreSQL is similar to a regular view, but with one key difference: 
 * it stores the result set of the defining query as actual data. Unlike views, which execute 
 * the query each time they’re accessed, materialized views persist the data until explicitly 
 * refreshed or updated. They’re useful for precomputing and caching complex queries, improving 
 * performance by avoiding redundant calculations. as a materialized view.
 */
DROP MATERIALIZED VIEW IF EXISTS academy_total_mview;
CREATE MATERIALIZED VIEW academy_total_mview AS(
	SELECT * 
	FROM students
	LEFT JOIN enrolments USING (student_id)
	FULL JOIN exam_grades
	USING (student_id, seminar_name)
);

SELECT * from academy_total_mview;

/* More on Materialized Views:
 * https://www.postgresqltutorial.com/postgresql-views/postgresql-materialized-views/ 
 */

-- UPDATE 2: changing original table 'exam_grades'. 
INSERT INTO exam_grades (seminar_name, student_id, grade) VALUES ('art', 3, 2.3)

-- TEST 2.1: did the result change in the materialized view?
SELECT * from academy_total_mview;

-- TEST 2.2: did the result change in the view?
SELECT * from academy_total_view;

-- refresh the materialized view and check the it again.
-- REFRESH MATERIALIZED VIEW view_name;
-- REFRESH MATERIALIZED VIEW CONCURRENTLY view_name;

REFRESH MATERIALIZED VIEW academy_total_mview;

-- TEST 2.3: did the result change in the materialized view now?
SELECT * from academy_total_mview;

-------- BONUS 2 -------- 

/* ### UNION and UNION ALL
 * 	UNION combines result sets from two different SELECT queries. 
 * 	The column names and data types in both result sets must be compatible 
 * 	(i.e., in the same order)
 */

-- UNION (removes duplicate rows)
SELECT * FROM academy_total_mview
WHERE seminar_name in ('history', 'art')
UNION
SELECT * FROM academy_total_mview
WHERE grade < 2
;

-- UNION ALL (retains all rows, including duplicates)
SELECT * FROM academy_total_mview
WHERE seminar_name in ('history', 'art')
UNION
SELECT * FROM academy_total_mview
WHERE grade < 2
;

/* More on other Table Combining Statements
 * 
 * UNION, INTERSECT, EXCEPT 
 *
		https://www.postgresql.org/docs/current/queries-union.html
		https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-union/
		https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-intersect/
		https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-except/
*/
