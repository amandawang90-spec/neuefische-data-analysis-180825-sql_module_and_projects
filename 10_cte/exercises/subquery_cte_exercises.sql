SELECT * FROM ext_customers

SELECT * FROM ext_orders 

SELECT * FROM ext_order_items 

SELECT * FROM ext_products

SELECT * FROM ext_promotions

--Key difference BETWEEN JOIN/LEFT join
--| JOIN type      | What happens when no match?                                                             | Example usage                                                             |
--| -------------- | --------------------------------------------------------------------------------------- | ------------------------------------------------------------------------- |
--| **INNER JOIN** | Rows **without matching categories** are **excluded**                                   | When you only care about products in known categories                     |
--| **LEFT JOIN**  | Rows **without matching categories** are **included**, with `NULL` for missing averages | When you want to keep *all* products, even with missing category averages 

/*For each of the following questions try:
    a. subquery
    b. CTE
You can do it in whichever order you prefer
*/

/*1. Find the most expensive product
    Find the product(s) with the highest unit price.
*/
-- CTE method: inner join/join
WITH max_price AS (
    SELECT MAX(unit_price) AS highest_unit_price
    FROM ext_products
)
SELECT ep.product_id, 
       ep.product_name, 
       ep.unit_price
FROM ext_products ep
JOIN max_price mp
    ON ep.unit_price = mp.highest_unit_price
--Remark: By default, JOIN means INNER JOIN in SQL.
    
-- CTE method: left join
WITH max_price AS (
    SELECT MAX(unit_price) AS highest_unit_price
    FROM ext_products
)
SELECT ep.product_id, 
       ep.product_name, 
       ep.unit_price
FROM ext_products ep
LEFT JOIN max_price mp
    ON ep.unit_price = mp.highest_unit_price
WHERE ep.unit_price = mp.highest_unit_price

-- CTE method: cross join
WITH max_price AS (
    SELECT MAX(unit_price) AS highest_unit_price
    FROM ext_products
)
SELECT ep.product_id, 
       ep.product_name, 
       ep.unit_price
FROM ext_products ep
CROSS JOIN max_price mp
WHERE ep.unit_price = mp.highest_unit_price
--Remark: If there are m rows in Customers and n in Orders, CROSS JOIN returns m × n rows.

-- CTE method: without join
WITH max_price AS (
    SELECT MAX(unit_price) AS highest_unit_price
    FROM ext_products
)
SELECT ep.product_id, 
       ep.product_name, 
       ep.unit_price
FROM ext_products ep
WHERE ep.unit_price = (SELECT highest_unit_price FROM max_price)

-- Subquery method
SELECT product_id, 
       product_name, 
       unit_price
FROM ext_products ep
WHERE ep.unit_price = (
          SELECT MAX(unit_price) AS highest_unit_price
          FROM ext_products
)

/*2. Customers who signed up after the average signup date
    Compare each customer’s signup_date to the average signup date.
*/
SELECT pg_typeof(signup_date)
FROM ext_customers
--Remark: signup_date is varchar

-- CTE method: cross join/TIMESTAMP
WITH search_avg_signup_date AS (
    SELECT AVG(EXTRACT(EPOCH FROM signup_date::TIMESTAMP)) AS avg_signup_date
    FROM ext_customers
)
SELECT ec.customer_id,
       ec.first_name,
       ec.last_name,
       ec.region,
       ec.signup_date
FROM ext_customers AS ec
CROSS JOIN search_avg_signup_date AS sasd  
WHERE EXTRACT(EPOCH FROM ec.signup_date::TIMESTAMP) > sasd.avg_signup_date;  
--CTE method: cross join/DATE
WITH search_avg_signup_date AS (
    SELECT AVG(EXTRACT(EPOCH FROM signup_date::DATE)) AS avg_signup_date
    FROM ext_customers
)
SELECT ec.customer_id,
       ec.first_name,
       ec.last_name,
       ec.region,
       ec.signup_date
FROM ext_customers AS ec
CROSS JOIN search_avg_signup_date AS sasd  
WHERE EXTRACT(EPOCH FROM ec.signup_date::DATE) > sasd.avg_signup_date; 

--remark:
--search_avg_signup_date only has one row (the average signup date).
--So the CROSS JOIN effectively attaches that single value to every row in ext_customers, 
--letting you compare each customer’s signup_date to the average.

--CTE method: join
WITH search_avg_signup_date AS (
    SELECT AVG(EXTRACT(EPOCH FROM signup_date::TIMESTAMP)) AS avg_signup_date
    FROM ext_customers
)
SELECT ec.customer_id,
       ec.first_name,
       ec.last_name,
       ec.region,
       ec.signup_date
FROM ext_customers AS ec
JOIN search_avg_signup_date AS sasd  
  ON EXTRACT(EPOCH FROM ec.signup_date::TIMESTAMP) > sasd.avg_signup_date

--CTE method: left join
WITH search_avg_signup_date AS (
    SELECT AVG(EXTRACT(EPOCH FROM signup_date::DATE)) AS avg_signup_date
    FROM ext_customers
)
SELECT ec.customer_id,
       ec.first_name,
       ec.last_name,
       ec.region,
       ec.signup_date
FROM ext_customers AS ec
LEFT JOIN search_avg_signup_date AS sasd  
      ON EXTRACT(EPOCH FROM ec.signup_date::DATE) > sasd.avg_signup_date

--CTE method without join 
      
WITH search_avg_signup_date AS (
    SELECT AVG(EXTRACT(EPOCH FROM signup_date::DATE)) AS avg_signup_date
    FROM ext_customers
)
SELECT ec.customer_id,
       ec.first_name,
       ec.last_name,
       ec.region,
       ec.signup_date
FROM ext_customers AS ec
WHERE EXTRACT(EPOCH FROM ec.signup_date::DATE) > (SELECT avg_signup_date FROM search_avg_signup_date)  
      
-- Subquery method/TIMESTAMP
SELECT *
FROM ext_customers
WHERE EXTRACT(EPOCH FROM signup_date::TIMESTAMP) >
      (SELECT AVG(EXTRACT(EPOCH FROM signup_date::TIMESTAMP))
       FROM ext_customers);
-- Subquery method/DATE
SELECT *
FROM ext_customers
WHERE EXTRACT(EPOCH FROM signup_date::DATE) >
      (SELECT AVG(EXTRACT(EPOCH FROM signup_date::DATE))
       FROM ext_customers);

--Remark:
--In PostgreSQL, AVG() cannot be applied directly to timestamp or date 
--we need to convert the timestamp data tyoe to a numeric data type (like epoch seconds) before averaging
-- For example:
--EXTRACT(EPOCH FROM signup_date:: DATE)
--EXTRACT(EPOCH FROM signup_date:: TIMESTAMP)
-- In this case the signup_date is varchar, first convert it into DATE or TIMESTAMP and then use extract(epoch from ***)

/*3. Products cheaper than the average price in their category
    For each product, find if its price is below the category’s average.
*/
SELECT pg_typeof(unit_price)
FROM ext_products

--Remark: unit price is real in terms of data type

--CTE method: join
WITH search_avg_category_price AS (
    SELECT 
        category,
        ROUND(AVG(unit_price::NUMERIC), 2) AS avg_unit_price_per_category
    FROM ext_products
    GROUP BY category
)
SELECT 
    ep.product_id,
    ep.category,
    ep.unit_price,
    sacp.avg_unit_price_per_category 
FROM ext_products AS ep
JOIN search_avg_category_price AS sacp
    ON ep.category = sacp.category
WHERE ep.unit_price::NUMERIC < sacp.avg_unit_price_per_category;

--join on category without filtering
WITH search_avg_category_price AS (
    SELECT 
        category,
        ROUND(AVG(unit_price::NUMERIC), 2) AS avg_unit_price_per_category
    FROM ext_products
    GROUP BY category
)
SELECT 
    ep.product_id,
    ep.category AS product_category,
    ep.unit_price AS product_unit_price,
    sacp.category AS sacp_category,
    sacp.avg_unit_price_per_category
FROM ext_products AS ep
JOIN search_avg_category_price AS sacp
    ON ep.category = sacp.category
    
--Remark: if i join on category, join or inner join will match the category of the product with the category of the cte,
--and it will return the corresponding average unit price for that category to that product.
--However, it is not a boolean which can compare the product unit price with the average unit price for the whole category.
--Therefore, we need the condtion (WHERE ep.unit_price::NUMERIC < sacp.avg_unit_price_per_category) to filter out the rows that we dont need.
    
--CTE method: left join
WITH search_avg_category_price AS (
    SELECT 
        category,
        ROUND(AVG(unit_price::NUMERIC), 2) AS avg_unit_price_per_category
    FROM ext_products
    GROUP BY category
)
SELECT 
    ep.product_id,
    ep.category,
    ep.unit_price,
    sacp.avg_unit_price_per_category
FROM ext_products AS ep
LEFT JOIN search_avg_category_price AS sacp
    ON ep.category = sacp.category
WHERE sacp.avg_unit_price_per_category IS NULL
   OR ep.unit_price::NUMERIC < sacp.avg_unit_price_per_category;

--Remark:
--Rows where sacp.avg_unit_price_per_category is NULL (i.e., unmatched categories) will not appear in the result —
--since any comparison with NULL returns FALSE.
--So effectively, this behaves like an INNER JOIN for the rows that pass this condition.

-- left join on category without filtering
WITH search_avg_category_price AS (
    SELECT 
        category,
        ROUND(AVG(unit_price::NUMERIC), 2) AS avg_unit_price_per_category
    FROM ext_products
    GROUP BY category
)
SELECT 
    ep.product_id,
    ep.category,
    ep.unit_price,
    sacp.category,
    sacp.avg_unit_price_per_category
FROM ext_products AS ep
LEFT JOIN search_avg_category_price AS sacp
    ON ep.category = sacp.category

--CTE method: cross join
WITH search_avg_category_price AS (
    SELECT 
        category,
        ROUND(AVG(unit_price::NUMERIC), 2) AS avg_unit_price_per_category
    FROM ext_products
    GROUP BY category
)
SELECT DISTINCT ON (product_id)
    ep.product_id,
    ep.category,
    ep.unit_price,
    sacp.avg_unit_price_per_category
FROM ext_products AS ep
CROSS JOIN search_avg_category_price AS sacp
WHERE ep.unit_price::NUMERIC < sacp.avg_unit_price_per_category;

WITH search_avg_category_price AS (
    SELECT 
        category,
        ROUND(AVG(unit_price::NUMERIC), 2) AS avg_unit_price_per_category
    FROM ext_products
    GROUP BY category
)
SELECT DISTINCT ON (product_id)
    ep.product_id,
    ep.category,
    ep.unit_price,
    sacp.category,
    sacp.avg_unit_price_per_category
FROM ext_products AS ep
CROSS JOIN search_avg_category_price AS sacp

--CTE method: without join
WITH search_avg_category_price AS (
    SELECT 
        category,
        ROUND(AVG(unit_price::NUMERIC), 2) AS avg_unit_price_per_category
    FROM ext_products
    GROUP BY category
)
SELECT DISTINCT ON (product_id)
    ep.product_id,
    ep.category,
    ep.unit_price
FROM ext_products AS ep
WHERE ep.unit_price::NUMERIC < (
         SELECT avg_unit_price_per_category 
         FROM search_avg_category_price AS sacp
         WHERE ep.category = sacp.category
)

--Subquery method
SELECT 
    ep.product_id,
    ep.category,
    ep.unit_price,
    sacp.avg_unit_price_per_category
FROM ext_products AS ep
JOIN (
   SELECT 
      category,
      ROUND(AVG(unit_price::NUMERIC), 2) AS avg_unit_price_per_category
   FROM ext_products
   GROUP BY category
) AS sacp
    ON ep.category = sacp.category
WHERE ep.unit_price::NUMERIC < sacp.avg_unit_price_per_category;

-- windows function:
SELECT DISTINCT ON (category)
    category,
    product_name,
    unit_price,
    ROUND(AVG(unit_price) OVER (PARTITION BY category)::NUMERIC,2) AS avg_category_price
FROM ext_products;

/*4.Orders larger than the average order total
    Find all orders where total_amount > average of all orders.
*/
SELECT pg_typeof(total_amount)
FROM ext_orders

--Remark: total_amount is real in terms of data type

--CTE method: join/inner join
WITH search_avg_order_value AS (
      SELECT ROUND(AVG(total_amount::NUMERIC),2) AS avg_value_per_order
      FROM ext_orders
)
SELECT eo.order_id,
       eo.customer_id,
       eo.order_date,
       saov.avg_value_per_order,
       ROUND(eo.total_amount::NUMERIC,2) AS avg_order_value
FROM ext_orders AS eo
JOIN search_avg_order_value AS saov
   ON eo.total_amount > saov.avg_value_per_order
ORDER BY customer_id
--logic:
--For every ext_orders row:
--If total_amount > saov.avg_value_per_order, condition is TRUE → row is joined.
--If not, condition is FALSE → row is excluded.

--remark: only returns the avg_order_values when the condition (eo.total_amount > saov.avg_value_per_order) is true, 
--the rows that dont match will not be merged after doing the join or inner join, the rows will be deleted that we dont see
--So the on of join function can be used to compare like a boolean.

--SUMMARY ABOUT JOIN
--(ON eo.total_amount > saov.avg_value_per_order) works like:
--WHERE eo.total_amount > (SELECT avg_value_per_order FROM search_avg_order_value)

--| Concept                        | Explanation                                                               |
--| ------------------------------ | ------------------------------------------------------------------------- |
--| **JOIN with `>` works**        | Because JOINs can use any boolean expression, not just equality.          |
--| **Why no duplication happens** | Your CTE returns only one row.                                            |
--| **Why it behaves like WHERE**  | Each row of `ext_orders` either passes or fails the join condition once.  |
--| **What would break it**        | If your CTE returned multiple rows, you could get many matches per order. |

--CTE method: left join
WITH search_avg_order_value AS (
      SELECT ROUND(AVG(total_amount::NUMERIC),2) AS avg_value_per_order
      FROM ext_orders
)
SELECT eo.order_id,
       eo.customer_id,
       eo.order_date,
       saov.avg_value_per_order,
       ROUND(eo.total_amount::NUMERIC,2) AS avg_order_value
FROM ext_orders AS eo
LEFT JOIN search_avg_order_value AS saov
  ON eo.total_amount > saov.avg_value_per_order
ORDER BY customer_id
--logic:
----For every ext_orders row:
--If total_amount > saov.avg_value_per_order → condition TRUE → join succeeds → avg_value_per_order is populated.
--If not → condition FALSE → join fails → avg_value_per_order becomes NULL.

--As we can see, if the condition (eo.total_amount > saov.avg_value_per_order) is met, 
--then it fills the column of saov.avg_value_per_order with the value, otherwise this column will be filled with null.
--if we don't want to see the rows with null values where the condition is not met,
--we need to use WHERE saov.avg_value_per_order IS NOT NULL to filter out the rows.
-- the difference between join and left join is that join functions like filtering the rows
--while the left join basically returns all the rows back even when the condition is not met,
--which needs where clause to filter it out again.

WITH search_avg_order_value AS (
      SELECT ROUND(AVG(total_amount::NUMERIC),2) AS avg_value_per_order
      FROM ext_orders
)
SELECT eo.order_id,
       eo.customer_id,
       eo.order_date,
       saov.avg_value_per_order,
       ROUND(eo.total_amount::NUMERIC,2) AS avg_order_value
FROM ext_orders AS eo
LEFT JOIN search_avg_order_value AS saov
  ON eo.total_amount > saov.avg_value_per_order
WHERE saov.avg_value_per_order IS NOT NULL 
ORDER BY customer_id

--WHERE saov.avg_value_per_order IS NOT NULL 
--This line filters out all rows where the join failed (i.e. NULLs).
--Effectively, you’re keeping only the “above-average” orders.

--Remark: After using the condtion (WHERE saov.avg_value_per_order IS NOT NULL) to filter
--we don't see the rows that the condition (eo.total_amount > saov.avg_value_per_order) is not met
--in other words, we filter the rows where the value of saov.avg_value_per_order is null.

-- SUMMARY ABOUT LEFT JOIN
-- TL;DR
--| Join type                              | Keeps all rows? | Shows avg value?       | Filters out below-average? |
--| -------------------------------------- | --------------- | ---------------------- | -------------------------- |
--| **LEFT JOIN … ON total_amount > avg**  | ✅ Yes           | Only for above-average | ❌ No                       |
--| **INNER JOIN … ON total_amount > avg** | ❌ No            | Yes                    | ✅ Yes                      |

--CTE method: cross join
WITH search_avg_order_value AS (
      SELECT ROUND(AVG(total_amount::NUMERIC),2) AS avg_value_per_order
      FROM ext_orders
)
SELECT eo.order_id,
       eo.customer_id,
       eo.order_date,
       saov.avg_value_per_order,
       ROUND(eo.total_amount::NUMERIC,2) AS avg_order_value
FROM ext_orders AS eo
CROSS JOIN search_avg_order_value AS saov
WHERE eo.total_amount > saov.avg_value_per_order 
ORDER BY customer_id

WITH search_avg_order_value AS (
      SELECT ROUND(AVG(total_amount::NUMERIC),2) AS avg_value_per_order
      FROM ext_orders
)
SELECT eo.order_id,
       eo.customer_id,
       eo.order_date,
       saov.avg_value_per_order,
       ROUND(eo.total_amount::NUMERIC,2) AS avg_order_value
FROM ext_orders AS eo
CROSS JOIN search_avg_order_value AS saov
ORDER BY customer_id

--CTE method: without join
WITH search_avg_order_value AS (
      SELECT ROUND(AVG(total_amount::NUMERIC),2) AS avg_value_per_order
      FROM ext_orders
)
SELECT eo.order_id,
       eo.customer_id,
       eo.order_date,
       ROUND(eo.total_amount::NUMERIC,2)
FROM ext_orders AS eo
WHERE eo.total_amount > (SELECT avg_value_per_order FROM search_avg_order_value)
ORDER BY customer_id

-- Subquery method
SELECT *
FROM ext_orders
WHERE total_amount::NUMERIC > (SELECT ROUND(AVG(total_amount::NUMERIC),2) AS avg_value_per_order FROM ext_orders)
ORDER BY customer_id



/*5.  Find the earliest order date per customer
    For each customer, get their first order date.
*/

SELECT pg_typeof(order_date)
FROM ext_orders

--Remark: order_date is varchar in terms of data type

--method 1:
SELECT customer_id,
       MIN(order_date::DATE)
FROM ext_orders
GROUP BY customer_id
ORDER BY customer_id

--method 2:
SELECT DISTINCT ON (customer_id) *
FROM ext_orders
ORDER BY customer_id, order_date::DATE ASC;


-- Subquery method
SELECT *
FROM ext_orders eo
WHERE order_date::DATE = (
    SELECT MIN(order_date::DATE)
    FROM ext_orders
    WHERE customer_id = eo.customer_id
);

-- CTE method
WITH search_earliest_order_date AS (
       SELECT eo.customer_id,
              MIN(order_date::DATE) AS earliest_order_date
       FROM ext_orders eo 
       WHERE customer_id = eo.customer_id
       GROUP BY customer_id
)
SELECT *
FROM search_earliest_order_date 
ORDER BY customer_id

/* 6. Find categories whose average price > global average
    Compare category-level averages to overall product average.
*/

SELECT pg_typeof(unit_price)
FROM ext_products

--Remark: unit_price is real in terms of data type

-- CTE method:  it is wrong
WITH search_global_average AS (
       SELECT AVG(unit_price::NUMERIC) AS global_avg
       FROM ext_products
)
SELECT ep.category,
       AVG(ep.unit_price::NUMERIC) AS category_avg
FROM ext_products AS ep
CROSS JOIN search_global_average AS sga
GROUP BY ep.category
HAVING AVG(unit_price::NUMERIC) > sga.global_avg 

--HAVING AVG(unit_price::NUMERIC) > sga.global_avg 
--wrong, Even though sga.global_avg is a single constant value (from the CTE), 
--PostgreSQL doesn’t treat it as such in the logical order of query execution.

WITH search_global_average AS (
       SELECT ROUND(AVG(unit_price::NUMERIC),2) AS global_avg  -- global_avg: 236.85
       FROM ext_products AS ep
),
search_category_average AS (
       SELECT 
          category,
          ROUND(AVG(unit_price::NUMERIC),2) AS category_avg
       FROM ext_products AS ep
       GROUP BY ep.category
)
SELECT eca.category,
       eca.category_avg
FROM search_category_average AS eca
CROSS JOIN search_global_average AS sga
WHERE eca.category_avg > sga.global_avg 

--Subquery method:

SELECT eca.category,
       eca.category_avg
FROM (
   SELECT 
       category,
       ROUND(AVG(unit_price::NUMERIC),2) AS category_avg
   FROM ext_products AS ep
   GROUP BY ep.category
) AS eca
CROSS JOIN (
  SELECT ROUND(AVG(unit_price::NUMERIC),2) AS global_avg  -- global_avg: 236.85
  FROM ext_products AS ep
) AS sga
WHERE eca.category_avg > sga.global_avg 

/* 7. Customers who placed more than 3 orders
*/

--CTE method

WITH search_total_orders AS (
      SELECT 
         eo.customer_id,
         COUNT(eo.customer_id) AS total_orders_per_customer
      FROM ext_orders AS eo
      GROUP BY eo.customer_id
)
SELECT *
FROM search_total_orders AS sto
WHERE sto.total_orders_per_customer > 3
ORDER BY sto.customer_id

-- Subquery method:

SELECT eo.customer_id,
       COUNT(eo.customer_id) AS total_orders_per_customer
FROM ext_orders AS eo
GROUP BY eo.customer_id
HAVING COUNT(eo.customer_id) > 3
ORDER BY customer_id
  

/* 8. Products that have ever been in a promotion
*/
--method 1:
SELECT DISTINCT eps.product_id
FROM ext_promotions AS eps
GROUP BY eps.product_id

--method 2:
SELECT DISTINCT ON (ep.product_id)
    ep.product_id,
    ep.product_name,
    eps.promotion_id
FROM ext_promotions AS eps
JOIN ext_products AS ep
    ON eps.product_id = ep.product_id
ORDER BY ep.product_id

-- CTE method

WITH ext_promotions_products_table AS (
       SELECT 
          eps.product_id,
          ep.product_name,
          eps.promotion_id
       FROM ext_promotions AS eps
       JOIN ext_products AS ep
           ON eps.product_id = ep.product_id
)
SELECT DISTINCT ON (product_id)
       product_id,
       product_name,
       promotion_id
FROM ext_promotions_products_table
ORDER BY product_id


/* 9. Total quantity sold per product
*/

-- method 1:
SELECT DISTINCT ON (eoi.product_id)
       eoi.product_id,
       ep.product_name,
       eoi.quantity
FROM ext_order_items AS eoi
JOIN ext_products AS ep
  ON eoi.product_id = ep.product_id
  
  
-- CTE method
  
WITH ext_order_items_products_table AS (
       SELECT 
          eoi.product_id,
          eoi.quantity,
          ep.product_name
       FROM ext_order_items AS eoi
       JOIN ext_products AS ep
           ON eoi.product_id = ep.product_id
)
SELECT DISTINCT ON (product_id)
   product_id,
   quantity,
   product_name
FROM ext_order_items_products_table 


/* 10. Customers who haven’t ordered anything
*/
--method 1:
SELECT 
    ec.customer_id,
    ec.first_name,
    ec.last_name
FROM ext_customers AS ec
LEFT JOIN ext_orders AS eo
    ON ec.customer_id = eo.customer_id
WHERE eo.order_id IS NULL
ORDER BY ec.customer_id

--CTE method
WITH ext_customer_orders_table AS (
       SELECT 
          ec.customer_id,
          ec.first_name,
          ec.last_name,
          eo.order_id
       FROM ext_customers AS ec
       LEFT JOIN ext_orders AS eo
           ON ec.customer_id = eo.customer_id
)
SELECT 
   customer_id,
   first_name,
   last_name
FROM ext_customer_orders_table
WHERE order_id IS NULL
ORDER BY customer_id

--Subquery method
SELECT 
    ec.customer_id,
    ec.first_name,
    ec.last_name
FROM ext_customers AS ec
WHERE ec.customer_id NOT IN (
    SELECT eo.customer_id
    FROM ext_orders AS eo
)
ORDER BY ec.customer_id

/*11. Find each region’s total revenue and the top region
*/
-- method 1:
SELECT ec.region,
       SUM(total_amount) AS total_revenue
FROM ext_orders AS eo
JOIN ext_customers AS ec
  ON eo.customer_id = ec.customer_id
GROUP BY ec.region
ORDER BY total_revenue DESC

--CTE method
WITH search_total_revenue_per_region AS (
        SELECT ec.region,
               SUM(total_amount) AS total_revenue
        FROM ext_orders AS eo
        JOIN ext_customers AS ec
           ON eo.customer_id = ec.customer_id
        GROUP BY ec.region
),
search_max_total_revenue AS (
        SELECT MAX(total_revenue) AS max_total_revenue
        FROM search_total_revenue_per_region AS strpr
)
SELECT *
FROM search_total_revenue_per_region AS strpr
CROSS JOIN search_max_total_revenue AS smtr  
WHERE strpr.total_revenue = smtr.max_total_revenue

/*12. Top 3 customers by total spending
*/

--method 1:
SELECT eo.customer_id,
       ec.first_name,
       ec.last_name,
       ROUND(SUM(eo.total_amount)::NUMERIC,2) AS total_spending_per_customer
FROM ext_orders AS eo
JOIN ext_customers AS ec
   ON eo.customer_id=ec.custome r_id
GROUP BY eo.customer_id, ec.first_name, ec.last_name
ORDER BY total_spending_per_customer DESC
LIMIT 3

--CTE method
WITH ext_customers_orders_table AS (
       SELECT eo.customer_id,
              ec.first_name,
              ec.last_name,
              eo.total_amount
       FROM ext_orders AS eo
       JOIN ext_customers AS ec
         ON eo.customer_id=ec.customer_id
)
SELECT 
    customer_id,
    first_name,
    last_name,
    ROUND(SUM(total_amount)::NUMERIC,2) AS total_spending_per_customer
FROM ext_customers_orders_table 
GROUP BY customer_id, first_name, last_name
ORDER BY total_spending_per_customer DESC
LIMIT 3

--Subquery method
