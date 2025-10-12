## ER Diagrams

Entity Relationship Diagrams visually depict the relationships of entity sets stored in a database. ER diagrams help to explain the logical structure of databases. They are often used by database designers as a blueprint during the data modeling stage. An ER diagram can be drawn using a paper and pencil or a program like **DBeaver** or **pg_admin** 

### Adding tables to your schema
We need to copy two tables from schema 'public' to your schema. Open a new SQL script and select active schema to your schema.
This will the SQL file for this exercise. You can save it (e.g. as "add_constrains_exercise.sql").

```sql
CREATE TABLE life_expectancy AS
SELECT * FROM public.life_expectancy; -- Note: the source table is in the schema 'public'

CREATE TABLE regions AS
SELECT * FROM public.regions; -- Note: the source table is in the schema 'public'
```

### ER Diagram for you schema
Right-Click on your schema and select "View Diagram". Among other tables you should see tables `life_expectancy`, `regions`, `countries` and `countries_selection`. 

We created `countries` and `countries_selection` in the **07_create_insert_update_delete** encouter. If the tables are missing, please re-create them with the queries from the encounter.

### Exercise 1

On paper draft an ERD drawing for the tables `life_expectancy`, `regions`, `countries` and `countries_selection`.  
For which columns would you establish a relationship? What would be the primary key and what could be the foreign key?

Draft it before you go to the next exercise. Feel free to discuss it with your colleagues (~20 min).  
**Hint**: Keep in mind:  
        - a table can have only one PK  
        - a table can have multiple FKs

### Exercise 2

#### Establish a primary-foreign key relationship between tables:
1. `regions` and `life_expectancy`
2. `countries` and `life_expectancy`
3. `regions` and `countries`
4. `countries_selection` and `countries`
5. `countries_selection` and `regions`

Make sure that this operation was successful. In DBeaver find for each Table the Folders "Constraints" and "Foreign Keys". The new constraints should be in there.

Check the ER Diagram now.

#### Attempt to drop the `regions` table. 
What result is returned?
**Note:** If you actally manage to drop the tables, find the SQL files with queries that used to create it (see the groupby encounter)