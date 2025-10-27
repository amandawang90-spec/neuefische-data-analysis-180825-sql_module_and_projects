CREATE TABLE life_expectancy_2 AS
SELECT * FROM public.life_expectancy;

SELECT * FROM life_expectancy_2

CREATE TABLE regions_2 AS
SELECT * FROM public.regions;

SELECT * FROM regions_2;

#### Establish a primary-foreign key relationship between tables:
1. `regions` and `life_expectancy`
/*
 * 
*/

-- Region is the parent table, and life expectancy is the child table

-- PK in region table : country 
-- FK in region table : country 

-- PK in life expectancy table : country, year
-- FK in life expectancy table : country

2. `countries` and `life_expectancy`
/*
 * 
*/

-- Life expectancy is the parent table, and countries is the child table

-- PK in life expectancy table : country, year
-- FK in life expectancy table : country 

-- PK in country table : country
-- FK in country table : country 


3. `regions` and `countries`
/*
 * 
*/
-- regions is the parent table, and countries is the child table

-- PK in regions table : country
-- FK in regions table : country 

-- PK in country table : country
-- FK in country table : country 


4. `countries_selection` and `countries`
/*
 * 
*/
-- countries is the parent table, and countries_selection is the child table

-- PK in countries table : country
-- FK in countries table : country 

-- PK in countries_selection table : state
-- FK in countries_selection : state

5. `countries_selection` and `regions`
/*
 * 
*/
-- regions is the parent table, and countries_selection is the child table

-- PK in regions table : country
-- FK in regions table : country 

-- PK in countries_selection table : state
-- FK in countries_selection : state
