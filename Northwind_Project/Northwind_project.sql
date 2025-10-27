
SELECT pg_typeof (discount) FROM northwind_order_details;

ALTER TABLE northwind_order_details
ALTER COLUMN discount TYPE REAL;




### Part 1 — Data Familiarization (5 questions) ~1.5 hours

1. List all tables in the Northwind database and briefly describe what each represents.

SELECT * 
FROM northwind_customers

SELECT *
FROM northwind_orders

SELECT *
FROM northwind_order_details

SELECT *
FROM northwind_products

SELECT *
FROM northwind_categories

SELECT *
FROM northwind_suppliers

SELECT *
FROM northwind_shippers

SELECT *
FROM northwind_employees

SELECT *
FROM northwind_employee_territories

SELECT *
FROM northwind_territories


--check if the table of customers match with the table of orders in terms of country and ship_country.

SELECT nc.customer_id AS all_customers,
       nos.customer_id AS order_customers,
       nc.country,
       nos.ship_country
FROM northwind_customers AS nc
LEFT JOIN northwind_orders AS nos
   ON nc.customer_id = nos.customer_id
   
--check if the table of products match with the table of order_details in terms of unit_price
SELECT DISTINCT ON (np.product_id)
     np.product_id AS product_id_of_product_table,
     nod.product_id AS product_id_of_order_details_table,
     np.unit_price AS unit_price_of_product_table,
     nod.unit_price AS unit_price_of_order_details_table,
     ROUND((np.unit_price - nod.unit_price)::NUMERIC,2) AS difference_of_two_unit_prices
FROM northwind_products AS np
LEFT JOIN northwind_order_details AS nod
   ON np.product_id = nod.product_id
WHERE ROUND((np.unit_price - nod.unit_price)::NUMERIC,2) != 0
ORDER BY np.product_id
  
SELECT DISTINCT ON (np.product_id)
     np.product_id AS product_id_of_product_table,
     nod.product_id AS product_id_of_order_details_table,
     np.unit_price AS unit_price_of_product_table,
     nod.unit_price AS unit_price_of_order_details_table
FROM northwind_products AS np
LEFT JOIN northwind_order_details AS nod
   ON np.product_id = nod.product_id
ORDER BY np.product_id

2. Show the first 10 rows of the orders table.

SELECT *
FROM northwind_orders 
LIMIT 10

3.Find all distinct countries where customers are located.

SELECT DISTINCT country
FROM northwind_customers
WHERE country IS NOT NULL  -- NOTE: There is no null value in the column of country in this case.
ORDER BY country

4. Get all customers from Germany and their contact names, ordered by company name.

SELECT contact_name,
       company_name,
       country
FROM northwind_customers 
WHERE country = 'Germany'
ORDER BY company_name

5. List the top 10 most expensive products by unit price.

SELECT product_id,
       product_name,
       unit_price
FROM northwind_products
ORDER BY unit_price DESC
LIMIT 10

### Part 2 — Aggregation & Summaries (5 questions) ~1.5–2 hours

6. Count how many customers are in each country (descending order).

SELECT 
    country,
    COUNT(customer_id) AS total_customers_per_country
FROM northwind_customers 
GROUP BY country
ORDER BY total_customers_per_country DESC

7. Calculate the total number of orders placed per year.

SELECT pg_typeof(order_date)
FROM northwind_orders

--METHOD 1: USING date_part
SELECT 
   DATE_PART('year', order_date::DATE) AS order_year,
   COUNT(order_id) AS total_orders_per_year
FROM northwind_orders 
GROUP BY DATE_PART('year', order_date::DATE)
ORDER BY order_year

--METHOD 2: USING extract
SELECT 
   EXTRACT (YEAR FROM order_date::DATE) AS order_year,
   COUNT(order_id) AS total_orders_per_year
FROM northwind_orders 
GROUP BY EXTRACT (YEAR FROM order_date::DATE)
ORDER BY order_year

--METHOD 2: USING date_trunc
SELECT 
   DATE_TRUNC('year', order_date::DATE) AS order_year
   COUNT(order_id) AS total_orders_per_year
FROM northwind_orders 
GROUP BY DATE_TRUNC('year', order_date::DATE)
ORDER BY order_year

8. Find the average freight cost per shipping country.

SELECT pg_typeof(freight)
FROM northwind_orders

SELECT 
   ship_country,
   ROUND(AVG(freight::NUMERIC),2) AS avg_freight_cost_per_shipping_country
FROM northwind_orders
GROUP BY ship_country
ORDER BY ship_country

9. Show each category’s average product price and total number of products.

SELECT pg_typeof(unit_price)
FROM northwind_products 

SELECT 
   category_id,
   ROUND(AVG(unit_price::NUMERIC),2) AS avg_unit_price_per_category,
   COUNT(product_id) AS total_products
FROM northwind_products 
GROUP BY category_id
ORDER BY category_id

SELECT 
   np.category_id,
   ncs.category_name,
   ROUND(AVG(unit_price::NUMERIC),2) AS avg_unit_price_per_category,
   COUNT(product_id) AS total_products
FROM northwind_products AS np
JOIN northwind_categories AS ncs
  ON np.category_id = ncs.category_id
GROUP BY np.category_id,ncs.category_name
ORDER BY np.category_id

10. Compute the total sales (revenue) per customer using the formula:
    `unitPrice * quantity * (1 - discount)`
    
SELECT pg_typeof(discount)
FROM northwind_order_details
 
WITH search_total_sales_per_customer AS (
       SELECT 
           nos.customer_id,
           ROUND(SUM(nod.unit_price*quantity*(1-discount))::NUMERIC,2) AS total_sales_per_customer
       FROM northwind_order_details AS nod
       JOIN northwind_orders AS nos
         ON nod.order_id=nos.order_id
       GROUP BY nos.customer_id
       ORDER BY total_sales_per_customer DESC
)
SELECT 
    stspc.customer_id,
    nc.contact_name,
    nc.company_name,
    stspc.total_sales_per_customer
FROM search_total_sales_per_customer AS stspc
JOIN northwind_customers AS nc
   ON stspc.customer_id=nc.customer_id
ORDER BY stspc.total_sales_per_customer DESC

### Part 3 — Joins & Relationships (5 questions) ~2 hours

11. List all orders with customer name, employee name, and ship country.

WITH northwind_customers_orders AS (     
      SELECT 
           nos.order_id,
           nc.contact_name,
           nc.company_name,
           nos.ship_country,
           nos.employee_id
      FROM northwind_orders AS nos
      JOIN northwind_customers AS nc
        ON nos.customer_id = nc.customer_id
) 
SELECT
    nco.order_id,
    nco.contact_name,
    nco.company_name,
    nco.employee_id,
    ne.last_name,
    ne.first_name,
    nco.ship_country
FROM northwind_customers_orders AS nco
JOIN northwind_employees AS ne
   ON nco.employee_id = ne.employee_id
ORDER BY nco.order_id 

12. Find the total sales value per employee.

SELECT nos.employee_id,
       ROUND(SUM(nod.unit_price*quantity*(1-discount))::NUMERIC,2) AS total_sales_per_employee
FROM northwind_order_details AS nod
JOIN northwind_orders AS nos
  ON nod.order_id=nos.order_id
GROUP BY nos.employee_id
ORDER BY nos.employee_id

WITH search_employee_total_sales AS (
       SELECT 
          nos.employee_id,
          ROUND(SUM(nod.unit_price*quantity*(1-discount))::NUMERIC,2) AS total_sales_per_employee
       FROM northwind_order_details AS nod
       JOIN northwind_orders AS nos
          ON nod.order_id=nos.order_id
       GROUP BY nos.employee_id
       ORDER BY nos.employee_id
)
SELECT
    setss.employee_id,
    setss.total_sales_per_employee,
    ne.last_name,
    ne.first_name
FROM search_employee_total_sales AS setss
JOIN northwind_employees AS ne
   ON setss.employee_id = ne.employee_id
ORDER BY total_sales_per_employee DESC

13. Find customers who have never placed an order.

--method 1:
SELECT 
     nc.contact_name,
     nc.customer_id
FROM northwind_customers AS nc
LEFT JOIN northwind_orders AS nos 
   ON nc.customer_id=nos.customer_id 
WHERE nos.customer_id IS NULL

--method 2:
select customer_id, 
       contact_name 
from northwind_customers 
where customer_id not in (select customer_id from northwind_orders)

--method 3:
SELECT nc.customer_id
FROM northwind_customers AS nc
WHERE NOT EXISTS (
    SELECT nos.customer_id
    FROM northwind_orders AS nos
    WHERE nos.customer_id = nc.customer_id
)
ORDER BY nc.customer_id;


14. Show the top 10 best-selling products by total revenue.

SELECT 
    nod.product_id,
    ROUND(SUM(nod.unit_price*quantity*(1-discount))::NUMERIC,2) AS total_sales_per_product
FROM northwind_order_details AS nod
GROUP BY nod.product_id

WITH search_ten_best_selling_products AS (
      SELECT 
           nod.product_id,
           ROUND(SUM(nod.unit_price*quantity*(1-discount))::NUMERIC,2) AS total_sales_per_product
      FROM northwind_order_details AS nod
      GROUP BY nod.product_id
)
SELECT
     np.product_name,
     stbsp.product_id,
     stbsp.total_sales_per_product
FROM search_ten_best_selling_products AS stbsp
JOIN northwind_products AS np
   ON stbsp.product_id=np.product_id
ORDER BY stbsp.total_sales_per_product DESC
LIMIT 10

15. For each category, show the most expensive product.

SELECT pg_typeof(unit_price)
FROM northwind_products

--MERGING THE TABLE OF CATEGORIES AND PRODUCTS
SELECT *
FROM northwind_categories AS ncs
LEFT JOIN northwind_products AS np
   ON ncs.category_id=np.category_id
ORDER BY ncs.category_id

--FIND THE MAX PRODUCT PRICE IN EACH CATEGORY
WITH northwind_products_categories AS (
        SELECT 
            ncs.category_id,
            np.product_id,
            np.unit_price
        FROM northwind_categories AS ncs
        LEFT JOIN northwind_products AS np
           ON ncs.category_id=np.category_id
        GROUP BY ncs.category_id,np.product_id,np.unit_price
)
SELECT 
    npc.category_id,
    MAX(unit_price::NUMERIC) AS max_product_unit_price_per_category
FROM northwind_products_categories AS npc
GROUP BY npc.category_id

--AFTER DOING IT, THEN TRY TO MERGE WITH TABLE OF PRODUCTS AGAIN TO GET MORE INFORMATION OF THE PRODUCTS LIKE NAME, UNIT PRICE ETC.

WITH northwind_products_categories AS (
        SELECT 
            ncs.category_id,
            np.product_id,
            np.unit_price
        FROM northwind_categories AS ncs
        LEFT JOIN northwind_products AS np
           ON ncs.category_id=np.category_id
        GROUP BY ncs.category_id,np.product_id,np.unit_price
),
search_max_product_unit_price_per_category AS (
    SELECT 
        npc.category_id,
        MAX(unit_price::NUMERIC) AS max_product_unit_price_per_category
    FROM northwind_products_categories AS npc
    GROUP BY npc.category_id
)
SELECT np.category_id,
       np.product_name,
       np.product_id,
       np.unit_price,
       smpuppc.category_id AS category_of_max_product_unit_price_per_category,
       smpuppc.max_product_unit_price_per_category
FROM northwind_products AS np
LEFT JOIN search_max_product_unit_price_per_category AS smpuppc
  ON smpuppc.category_id=np.category_id
WHERE np.unit_price::NUMERIC= smpuppc.max_product_unit_price_per_category
ORDER BY smpuppc.category_id

### Part 4 — Analytical Queries (6 questions) ~2 hours

16. Find the top 3 countries by total sales value.

SELECT pg_typeof(unit_price)
FROM northwind_products

--check if the table of northwind_order_details is consistent with the table of northwind_orders: YES
--In total, there are 830 orders.

SELECT DISTINCT order_id
FROM northwind_order_details AS nod  

SELECT order_id
FROM northwind_orders AS nos

--check if the table of customers match with the table of orders in terms of country and ship_country.

SELECT nc.customer_id AS all_customers,
       nos.customer_id AS order_customers,
       nc.country,
       nos.ship_country
FROM northwind_customers AS nc
LEFT JOIN northwind_orders AS nos
   ON nc.customer_id = nos.customer_id


SELECT *
FROM northwind_order_details AS nod
JOIN northwind_orders AS nos
  ON nod.order_id=nos.order_id
  
-- THE BEST 3 COUNTRIES BY TOTAL SALES VALUE ARE USA, GERMANY AND AUSTRIA 
SELECT 
    nos.ship_country,
    ROUND(SUM(nod.unit_price*quantity*(1-discount))::NUMERIC,2) AS total_sales_per_country
FROM northwind_order_details AS nod
JOIN northwind_orders AS nos
  ON nod.order_id=nos.order_id
GROUP BY ship_country
ORDER BY total_sales_per_country DESC
LIMIT 3

17. Show for each of those top countries the best-selling category.

--FIST STEP:
SELECT 
    nos.order_id,
    nos.ship_country,
    nod.product_id,
    nod.unit_price,
    nod.quantity,
    nod.discount
FROM northwind_orders AS nos
JOIN northwind_order_details AS nod
   ON nos.order_id=nod.order_id
WHERE nos.ship_country IN ('USA', 'Germany', 'Austria')
   
--SECOND STEP   
WITH northwind_orders_order_details AS (
       SELECT 
           nos.order_id,
           nos.ship_country,
           nod.product_id,
           nod.unit_price,
           nod.quantity,
           nod.discount
       FROM northwind_orders AS nos
       JOIN northwind_order_details AS nod
          ON nos.order_id=nod.order_id
       WHERE nos.ship_country IN ('USA', 'Germany', 'Austria')
)
SELECT 
    nood.order_id,
    nood.ship_country,
    nood.product_id,
    nood.unit_price,
    nood.quantity,
    nood.discount,
    np.category_id
FROM northwind_orders_order_details AS nood
JOIN northwind_products AS np
   ON nood.product_id=np.product_id

THIRD STEP:
WITH northwind_orders_order_details AS (
       SELECT 
           nos.order_id,
           nos.ship_country,
           nod.product_id,
           nod.unit_price,
           nod.quantity,
           nod.discount
       FROM northwind_orders AS nos
       JOIN northwind_order_details AS nod
          ON nos.order_id=nod.order_id
       WHERE nos.ship_country IN ('USA', 'Germany', 'Austria')
),
northwind_orders_order_details_products AS (
       SELECT 
            nood.order_id,
            nood.ship_country,
            nood.product_id,
            nood.unit_price,
            nood.quantity,
            nood.discount,
            np.category_id
       FROM northwind_orders_order_details AS nood
       JOIN northwind_products AS np
          ON nood.product_id=np.product_id
)
SELECT 
    ship_country,
    category_id,
    ROUND(SUM(noodp.unit_price*quantity*(1-discount))::NUMERIC,2) AS total_sales_per_category
FROM northwind_orders_order_details_products AS noodp
GROUP BY ship_country, category_id
ORDER BY ship_country, category_id
            
--FOURTH STEP:         
WITH northwind_orders_order_details AS (
       SELECT 
           nos.order_id,
           nos.ship_country,
           nod.product_id,
           nod.unit_price,
           nod.quantity,
           nod.discount
       FROM northwind_orders AS nos
       JOIN northwind_order_details AS nod
          ON nos.order_id=nod.order_id
       WHERE nos.ship_country IN ('USA', 'Germany', 'Austria')
),
northwind_orders_order_details_products AS (
       SELECT 
            nood.order_id,
            nood.ship_country,
            nood.product_id,
            nood.unit_price,
            nood.quantity,
            nood.discount,
            np.category_id
       FROM northwind_orders_order_details AS nood
       JOIN northwind_products AS np
          ON nood.product_id=np.product_id
),
search_total_sales_per_category AS (
       SELECT 
           ship_country,
           category_id,
           ROUND(SUM(noodp.unit_price*quantity*(1-discount))::NUMERIC,2) AS total_sales_per_category
       FROM northwind_orders_order_details_products AS noodp
       GROUP BY ship_country, category_id
       ORDER BY ship_country, category_id
)
SELECT 
    ship_country,
    MAX(total_sales_per_category)
FROM search_total_sales_per_category AS stspc
GROUP BY ship_country
 
--FIFTH STEP:
WITH northwind_orders_order_details AS (
       SELECT 
           nos.order_id,
           nos.ship_country,
           nod.product_id,
           nod.unit_price,
           nod.quantity,
           nod.discount
       FROM northwind_orders AS nos
       JOIN northwind_order_details AS nod
          ON nos.order_id=nod.order_id
       WHERE nos.ship_country IN ('USA', 'Germany', 'Austria')
),
northwind_orders_order_details_products AS (
       SELECT 
            nood.order_id,
            nood.ship_country,
            nood.product_id,
            nood.unit_price,
            nood.quantity,
            nood.discount,
            np.category_id
       FROM northwind_orders_order_details AS nood
       JOIN northwind_products AS np
          ON nood.product_id=np.product_id
),
search_total_sales_per_category AS (
       SELECT 
           ship_country,
           category_id,
           ROUND(SUM(noodp.unit_price*quantity*(1-discount))::NUMERIC,2) AS total_sales_per_category
       FROM northwind_orders_order_details_products AS noodp
       GROUP BY ship_country, category_id
       ORDER BY ship_country, category_id
),
search_country_of_max_total_sales_per_country AS (
       SELECT 
           ship_country,
           MAX(total_sales_per_category) AS max_total_sales_by_category_per_country
       FROM search_total_sales_per_category AS stspc
       GROUP BY ship_country
)
SELECT stspc.ship_country,
       stspc.category_id,
       scoomtspc.max_total_sales_by_category_per_country
FROM search_total_sales_per_category AS stspc
JOIN search_country_of_max_total_sales_per_country AS scoomtspc
  ON stspc.ship_country=scoomtspc.ship_country
WHERE stspc.total_sales_per_category = scoomtspc.max_total_sales_by_category_per_country

--SIXTH STEP:
WITH northwind_orders_order_details AS (
       SELECT 
           nos.order_id,
           nos.ship_country,
           nod.product_id,
           nod.unit_price,
           nod.quantity,
           nod.discount
       FROM northwind_orders AS nos
       JOIN northwind_order_details AS nod
          ON nos.order_id=nod.order_id
       WHERE nos.ship_country IN ('USA', 'Germany', 'Austria') --I can delete the ship country if i want to know for all the countries
),
northwind_orders_order_details_products AS (
       SELECT 
            nood.order_id,
            nood.ship_country,
            nood.product_id,
            nood.unit_price,
            nood.quantity,
            nood.discount,
            np.category_id
       FROM northwind_orders_order_details AS nood
       JOIN northwind_products AS np
          ON nood.product_id=np.product_id
),
search_total_sales_per_category AS (
       SELECT 
           ship_country,
           category_id,
           ROUND(SUM(noodp.unit_price*quantity*(1-discount))::NUMERIC,2) AS total_sales_per_category
       FROM northwind_orders_order_details_products AS noodp
       GROUP BY ship_country, category_id
       ORDER BY ship_country, category_id
),
search_country_of_max_total_sales_per_country AS (
       SELECT 
           ship_country,
           MAX(total_sales_per_category) AS max_total_sales_by_category_per_country
       FROM search_total_sales_per_category AS stspc
       GROUP BY ship_country
),
search_category_of_max_total_sales_per_country AS (
       SELECT 
           stspc.ship_country,
           stspc.category_id,
           scoomtspc.max_total_sales_by_category_per_country
       FROM search_total_sales_per_category AS stspc
       JOIN search_country_of_max_total_sales_per_country AS scoomtspc
          ON stspc.ship_country=scoomtspc.ship_country
       WHERE stspc.total_sales_per_category = scoomtspc.max_total_sales_by_category_per_country
)
SELECT 
    scaomtspc.ship_country,
    scaomtspc.category_id,
     ncs.category_name,
    scaomtspc.max_total_sales_by_category_per_country
FROM search_category_of_max_total_sales_per_country AS scaomtspc
JOIN northwind_categories AS ncs
    ON scaomtspc.category_id=ncs.category_id
    
18. Find the month with the highest total sales overall.

SELECT pg_typeof(order_date)
FROM northwind_orders

SELECT 
   EXTRACT(MONTH FROM nos.order_date::DATE) AS order_month,
   ROUND(SUM(nod.unit_price*quantity*(1-discount))::NUMERIC,2) AS total_sales_per_month
FROM northwind_order_details AS nod
JOIN northwind_orders AS nos
  ON nod.order_id=nos.order_id 
GROUP BY order_month
ORDER BY total_sales_per_month DESC
LIMIT 1

19. Compare average order value for domestic vs international shipments (relative to the company’s country — assume “UK”).

WITH search_domestic_avg_order_value AS (
    SELECT 
        ROUND(AVG(nod.unit_price * quantity * (1 - discount))::NUMERIC, 2) AS uk_avg_order_value
    FROM northwind_orders AS nos
    JOIN northwind_order_details AS nod
        ON nos.order_id = nod.order_id 
    WHERE nos.ship_country = 'UK'
),
search_international_avg_order_values AS (
    SELECT 
        ROUND(AVG(nod.unit_price * quantity * (1 - discount))::NUMERIC, 2) AS international_avg_order_value
    FROM northwind_orders AS nos
    JOIN northwind_order_details AS nod
        ON nos.order_id = nod.order_id 
    WHERE nos.ship_country != 'UK'
)
SELECT 
    sdaov.uk_avg_order_value,
    siaov.international_avg_order_value,
    ROUND(sdaov.uk_avg_order_value - siaov.international_avg_order_value, 2) AS difference
FROM search_domestic_avg_order_value AS sdaov
CROSS JOIN search_international_avg_order_values AS siaov;


20. Identify the top 5 customers by number of orders and their total revenue.

--FIRST STEP:
SELECT 
   customer_id,
   COUNT(*) AS total_orders_per_customer
FROM northwind_orders
GROUP BY customer_id
ORDER BY total_orders_per_customer DESC
LIMIT 5

--SECOND STEP:
WITH search_five_top_customers_by_total_orders AS (
       SELECT 
           customer_id,
           COUNT(*) AS total_orders_per_customer
       FROM northwind_orders
       GROUP BY customer_id
       ORDER BY total_orders_per_customer DESC
       LIMIT 5
)
SELECT 
     nos.customer_id,
     nos.order_id,
     nod.product_id,
     nod.unit_price,
     nod.quantity,
     nod.discount
FROM northwind_order_details AS nod
JOIN northwind_orders AS nos
   ON nos.order_id=nod.order_id

--THIRD STEP:
WITH search_five_top_customers_by_total_orders AS (
       SELECT 
           customer_id,
           COUNT(*) AS total_orders_per_customer
       FROM northwind_orders
       GROUP BY customer_id
       ORDER BY total_orders_per_customer DESC
       LIMIT 5
),
northwind_orders_order_details AS (
       SELECT 
           nos.customer_id,
           nos.order_id,
           nod.product_id,
           nod.unit_price,
           nod.quantity,
           nod.discount
      FROM northwind_order_details AS nod
      JOIN northwind_orders AS nos
         ON nos.order_id=nod.order_id
)
SELECT 
    nood.customer_id,
    ROUND(SUM(nood.unit_price * quantity * (1 - discount))::NUMERIC, 2) AS total_revenue_per_customer
FROM northwind_orders_order_details AS nood
GROUP BY nood.customer_id
LIMIT 5       

--FOURTH STEP:
--OPTION 1
WITH search_five_top_customers_by_total_orders AS (
       SELECT 
           customer_id,
           COUNT(*) AS total_orders_per_customer
       FROM northwind_orders
       GROUP BY customer_id
       ORDER BY total_orders_per_customer DESC
       LIMIT 5
),
northwind_orders_order_details AS (
       SELECT 
           nos.customer_id,
           nos.order_id,
           nod.product_id,
           nod.unit_price,
           nod.quantity,
           nod.discount
      FROM northwind_order_details AS nod
      JOIN northwind_orders AS nos
         ON nos.order_id=nod.order_id
),
search_five_top_customers_by_total_revenues AS (
      SELECT 
          nood.customer_id,
          ROUND(SUM(nood.unit_price * quantity * (1 - discount))::NUMERIC, 2) AS total_revenue_per_customer
      FROM northwind_orders_order_details AS nood
      GROUP BY nood.customer_id
      LIMIT 5
)
SELECT *
FROM search_five_top_customers_by_total_orders AS sftcbto
FULL JOIN search_five_top_customers_by_total_revenues AS sftcbtr
   ON sftcbto.customer_id=sftcbtr.customer_id
   
--FOURTH STEP:
--OPTION 2:   
WITH search_five_top_customers_by_total_orders AS (
       SELECT 
           customer_id,
           COUNT(*) AS total_orders_per_customer
       FROM northwind_orders
       GROUP BY customer_id
       ORDER BY total_orders_per_customer DESC
       LIMIT 5
),
northwind_orders_order_details AS (
       SELECT 
           nos.customer_id,
           nos.order_id,
           nod.product_id,
           nod.unit_price,
           nod.quantity,
           nod.discount
      FROM northwind_order_details AS nod
      JOIN northwind_orders AS nos
         ON nos.order_id=nod.order_id
),
search_five_top_customers_by_total_revenues AS (
      SELECT 
          nood.customer_id,
          ROUND(SUM(nood.unit_price * quantity * (1 - discount))::NUMERIC, 2) AS total_revenue_per_customer
      FROM northwind_orders_order_details AS nood
      GROUP BY nood.customer_id
      LIMIT 5
)
SELECT 
    customer_id,
    total_orders_per_customer::TEXT AS metric_value
FROM search_five_top_customers_by_total_orders
UNION ALL
SELECT 
    customer_id,
    total_revenue_per_customer::TEXT AS metric_value
FROM search_five_top_customers_by_total_revenues;

21. Determine which employees generate the most revenue on average per order.

--FIRST STEP:
SELECT 
    nos.employee_id,
    nod.product_id,
    nod.unit_price,
    nod.quantity,
    nod.discount
FROM northwind_order_details AS nod
JOIN northwind_orders AS nos
   ON nod.order_id=nos.order_id

--SECOND STEP:
WITH northwind_orders_order_details AS (
      SELECT 
          nos.employee_id,
          nod.product_id,
          nod.unit_price,
          nod.quantity,
          nod.discount
      FROM northwind_order_details AS nod
      JOIN northwind_orders AS nos
        ON nod.order_id=nos.order_id
)
SELECT 
    nood.employee_id,
    ROUND(SUM(nood.unit_price * quantity * (1 - discount))::NUMERIC, 2) AS total_revenue_per_employee
FROM northwind_orders_order_details AS nood
GROUP BY nood.employee_id
ORDER BY nood.employee_id

--THIRD STEP:
WITH northwind_orders_order_details AS (
      SELECT 
          nos.employee_id,
          nod.product_id,
          nod.unit_price,
          nod.quantity,
          nod.discount
      FROM northwind_order_details AS nod
      JOIN northwind_orders AS nos
        ON nod.order_id=nos.order_id
),
search_total_revenue_per_employee AS (
      SELECT 
          nood.employee_id,
          ROUND(SUM(nood.unit_price * quantity * (1 - discount))::NUMERIC, 2) AS total_revenue_per_employee
      FROM northwind_orders_order_details AS nood
      GROUP BY nood.employee_id
)
SELECT 
     employee_id,
     COUNT(order_id) AS total_orders_per_employee
FROM northwind_orders
GROUP BY employee_id
ORDER BY employee_id


--FOURTH STEP:
WITH northwind_orders_order_details AS (
      SELECT 
          nos.employee_id,
          nod.product_id,
          nod.unit_price,
          nod.quantity,
          nod.discount
      FROM northwind_order_details AS nod
      JOIN northwind_orders AS nos
        ON nod.order_id=nos.order_id
),
search_total_revenue_per_employee AS (
      SELECT 
          nood.employee_id,
          ROUND(SUM(nood.unit_price * quantity * (1 - discount))::NUMERIC, 2) AS total_revenue_per_employee
      FROM northwind_orders_order_details AS nood
      GROUP BY nood.employee_id
),
search_total_orders_per_employee AS (
      SELECT 
          employee_id,
          COUNT(order_id) AS total_orders_per_employee
      FROM northwind_orders
      GROUP BY employee_id
      ORDER BY employee_id
)
SELECT 
    strpe.employee_id,
    strpe.total_revenue_per_employee,
    stope.total_orders_per_employee
FROM search_total_revenue_per_employee AS strpe
JOIN search_total_orders_per_employee AS stope
  ON strpe.employee_id=stope.employee_id

  --FIFTH STEP:
WITH northwind_orders_order_details AS (
      SELECT 
          nos.employee_id,
          nod.product_id,
          nod.unit_price,
          nod.quantity,
          nod.discount
      FROM northwind_order_details AS nod
      JOIN northwind_orders AS nos
        ON nod.order_id=nos.order_id
),
search_total_revenue_per_employee AS (
      SELECT 
          nood.employee_id,
          ROUND(SUM(nood.unit_price * quantity * (1 - discount))::NUMERIC, 2) AS total_revenue_per_employee
      FROM northwind_orders_order_details AS nood
      GROUP BY nood.employee_id
),
search_total_orders_per_employee AS (
      SELECT 
          employee_id,
          COUNT(order_id) AS total_orders_per_employee
      FROM northwind_orders
      GROUP BY employee_id
      ORDER BY employee_id
),
merging_strpe_and_stope AS (
      SELECT 
          strpe.employee_id,
          strpe.total_revenue_per_employee,
          stope.total_orders_per_employee
      FROM search_total_revenue_per_employee AS strpe
      JOIN search_total_orders_per_employee AS stope
         ON strpe.employee_id=stope.employee_id
)  
SELECT 
    msas.employee_id,
    msas.total_revenue_per_employee,
    msas.total_orders_per_employee,
    ROUND((msas.total_revenue_per_employee/msas.total_orders_per_employee),2) AS total_revenue_per_order_per_employee
FROM merging_strpe_and_stope AS msas
ORDER BY total_revenue_per_order_per_employee DESC

 --SIXTH STEP:
WITH northwind_orders_order_details AS (
      SELECT 
          nos.employee_id,
          nod.product_id,
          nod.unit_price,
          nod.quantity,
          nod.discount
      FROM northwind_order_details AS nod
      JOIN northwind_orders AS nos
        ON nod.order_id=nos.order_id
),
search_total_revenue_per_employee AS (
      SELECT 
          nood.employee_id,
          ROUND(SUM(nood.unit_price * quantity * (1 - discount))::NUMERIC, 2) AS total_revenue_per_employee
      FROM northwind_orders_order_details AS nood
      GROUP BY nood.employee_id
),
search_total_orders_per_employee AS (
      SELECT 
          employee_id,
          COUNT(order_id) AS total_orders_per_employee
      FROM northwind_orders
      GROUP BY employee_id
      ORDER BY employee_id
),
merging_strpe_and_stope AS (
      SELECT 
          strpe.employee_id,
          strpe.total_revenue_per_employee,
          stope.total_orders_per_employee
      FROM search_total_revenue_per_employee AS strpe
      JOIN search_total_orders_per_employee AS stope
         ON strpe.employee_id=stope.employee_id
),
search_total_revenue_per_order_per_employee AS (
      SELECT 
          msas.employee_id,
          msas.total_revenue_per_employee,
          msas.total_orders_per_employee,
          ROUND((msas.total_revenue_per_employee/msas.total_orders_per_employee),2) AS total_revenue_per_order_per_employee
      FROM merging_strpe_and_stope AS msas
      ORDER BY total_revenue_per_order_per_employee DESC
)
SELECT
    strpope.employee_id,
    ne.last_name,
    ne.first_name,
    strpope.total_revenue_per_employee,
    strpope.total_orders_per_employee,
    strpope.total_revenue_per_order_per_employee
FROM search_total_revenue_per_order_per_employee AS strpope
JOIN northwind_employees AS ne
   ON strpope.employee_id=ne.employee_id
ORDER BY strpope.total_revenue_per_order_per_employee DESC


### Part 5 — Business Insights & Reporting (4 questions) ~2.5 hours + presentation/write-up

22. Customer Profitability: What percentage of total sales comes from your top 10 customers?

--FIRST STEP: MERGING ORDER DETAILS AND ORDERS
SELECT 
          nos.customer_id,
          nos.order_id,
          nod.product_id,
          nod.unit_price,
          nod.quantity,
          nod.discount
     FROM northwind_order_details AS nod
     JOIN northwind_orders AS nos
        ON nos.order_id=nod.order_id


--SECOND STEP: top 10 customers by total_revenue are:
WITH northwind_order_details_orders AS (
      SELECT 
          nos.customer_id,
          nos.order_id,
          nod.product_id,
          nod.unit_price,
          nod.quantity,
          nod.discount
     FROM northwind_order_details AS nod
     JOIN northwind_orders AS nos
        ON nos.order_id=nod.order_id
)
SELECT 
    nodo.customer_id,
    ROUND(SUM(nodo.unit_price * quantity * (1 - discount))::NUMERIC, 2) AS total_revenue_per_customer
FROM northwind_order_details_orders AS nodo
GROUP BY nodo.customer_id
ORDER BY total_revenue_per_customer DESC
LIMIT 10

--THIRD STEP: AGGREGATE TOTAL REVENUES OF THE 10 TOP CUSTOMERS TOGETHER
WITH northwind_order_details_orders AS (
      SELECT 
          nos.customer_id,
          nos.order_id,
          nod.product_id,
          nod.unit_price,
          nod.quantity,
          nod.discount
     FROM northwind_order_details AS nod
     JOIN northwind_orders AS nos
        ON nos.order_id=nod.order_id
),
search_ten_top_customers_by_total_revenues AS (
     SELECT 
         nodo.customer_id,
         ROUND(SUM(nodo.unit_price * quantity * (1 - discount))::NUMERIC, 2) AS total_revenue_per_customer
     FROM northwind_order_details_orders AS nodo
     GROUP BY nodo.customer_id
     ORDER BY total_revenue_per_customer DESC
     LIMIT 10
)
SELECT SUM(sttcbtr.total_revenue_per_customer ) AS total_revenue_of_the_top_ten_customers
FROM search_ten_top_customers_by_total_revenues AS sttcbtr
      

--FOURTH STEP:
WITH northwind_order_details_orders AS (
      SELECT 
          nos.customer_id,
          nos.order_id,
          nod.product_id,
          nod.unit_price,
          nod.quantity,
          nod.discount
     FROM northwind_order_details AS nod
     JOIN northwind_orders AS nos
        ON nos.order_id=nod.order_id
),
search_ten_top_customers_by_total_revenues AS (
     SELECT 
         nodo.customer_id,
         ROUND(SUM(nodo.unit_price * quantity * (1 - discount))::NUMERIC, 2) AS total_revenue_per_customer
     FROM northwind_order_details_orders AS nodo
     GROUP BY nodo.customer_id
     ORDER BY total_revenue_per_customer DESC
     LIMIT 10
),
search_total_revenues_of_the_ten_top_customers AS (
      SELECT SUM(sttcbtr.total_revenue_per_customer) AS total_revenue_of_the_top_ten_customers
      FROM search_ten_top_customers_by_total_revenues AS sttcbtr
)
SELECT 
    ROUND(SUM(nod.unit_price * quantity * (1 - discount))::NUMERIC, 2) AS total_revenue_of_all_customers
FROM northwind_order_details AS nod


--FIFTH STEP: MERGE THE TABLE OF search_ten_top_customers_by_total_revenues AND search_total_revenues_of_the_ten_top_customers TOGETHER.

WITH northwind_order_details_orders AS (
      SELECT 
          nos.customer_id,
          nos.order_id,
          nod.product_id,
          nod.unit_price,
          nod.quantity,
          nod.discount
     FROM northwind_order_details AS nod
     JOIN northwind_orders AS nos
        ON nos.order_id=nod.order_id
),
search_ten_top_customers_by_total_revenues AS (
     SELECT 
         nodo.customer_id,
         ROUND(SUM(nodo.unit_price * quantity * (1 - discount))::NUMERIC, 2) AS total_revenue_per_customer
     FROM northwind_order_details_orders AS nodo
     GROUP BY nodo.customer_id
     ORDER BY total_revenue_per_customer DESC
     LIMIT 10
),
search_total_revenues_of_the_ten_top_customers AS (
      SELECT SUM(sttcbtr.total_revenue_per_customer) AS total_revenue_of_the_top_ten_customers
      FROM search_ten_top_customers_by_total_revenues AS sttcbtr
),
search_total_revenues_of_all_customers AS (
      SELECT 
          ROUND(SUM(nod.unit_price * quantity * (1 - discount))::NUMERIC, 2) AS total_revenue_of_all_customers
      FROM northwind_order_details AS nod
)
SELECT *
FROM search_total_revenues_of_the_ten_top_customers AS strottc
CROSS JOIN search_total_revenues_of_all_customers AS stroac


--SIXTH STEP: CALCULATE THE PERCENTAGE OF THE TOP 10 CUSTOMERS BY REVENUE IN TOTAL SALES

WITH northwind_order_details_orders AS (
      SELECT 
          nos.customer_id,
          nos.order_id,
          nod.product_id,
          nod.unit_price,
          nod.quantity,
          nod.discount
     FROM northwind_order_details AS nod
     JOIN northwind_orders AS nos
        ON nos.order_id=nod.order_id
),
search_ten_top_customers_by_total_revenues AS (
     SELECT 
         nodo.customer_id,
         ROUND(SUM(nodo.unit_price * quantity * (1 - discount))::NUMERIC, 2) AS total_revenue_per_customer
     FROM northwind_order_details_orders AS nodo
     GROUP BY nodo.customer_id
     ORDER BY total_revenue_per_customer DESC
     LIMIT 10
),
search_total_revenues_of_the_ten_top_customers AS (
      SELECT SUM(sttcbtr.total_revenue_per_customer) AS total_revenue_of_the_top_ten_customers
      FROM search_ten_top_customers_by_total_revenues AS sttcbtr
),
search_total_revenues_of_all_customers AS (
      SELECT 
          ROUND(SUM(nod.unit_price * quantity * (1 - discount))::NUMERIC, 2) AS total_revenue_of_all_customers
      FROM northwind_order_details AS nod
),
merging_of_strottc_and_stroac AS (
       SELECT *
       FROM search_total_revenues_of_the_ten_top_customers AS strottc
       CROSS JOIN search_total_revenues_of_all_customers AS stroac
)
SELECT 
    ROUND(mosas.total_revenue_of_the_top_ten_customers / mosas.total_revenue_of_all_customers::NUMERIC,2)*100 AS ratio_top10_to_all
FROM merging_of_strottc_and_stroac AS mosas;

--SEVENTH STEP: MERGE

WITH northwind_order_details_orders AS (
      SELECT 
          nos.customer_id,
          nos.order_id,
          nod.product_id,
          nod.unit_price,
          nod.quantity,
          nod.discount
     FROM northwind_order_details AS nod
     JOIN northwind_orders AS nos
        ON nos.order_id=nod.order_id
),
search_ten_top_customers_by_total_revenues AS (
     SELECT 
         nodo.customer_id,
         ROUND(SUM(nodo.unit_price * quantity * (1 - discount))::NUMERIC, 2) AS total_revenue_per_customer
     FROM northwind_order_details_orders AS nodo
     GROUP BY nodo.customer_id
     ORDER BY total_revenue_per_customer DESC
     LIMIT 10
),
search_total_revenues_of_the_ten_top_customers AS (
      SELECT SUM(sttcbtr.total_revenue_per_customer) AS total_revenue_of_the_top_ten_customers
      FROM search_ten_top_customers_by_total_revenues AS sttcbtr
),
search_total_revenues_of_all_customers AS (
      SELECT 
          ROUND(SUM(nod.unit_price * quantity * (1 - discount))::NUMERIC, 2) AS total_revenue_of_all_customers
      FROM northwind_order_details AS nod
),
merging_of_strottc_and_stroac AS (
       SELECT *
       FROM search_total_revenues_of_the_ten_top_customers AS strottc
       CROSS JOIN search_total_revenues_of_all_customers AS stroac
),
search_ratio_of_top_ten_to_all AS (
       SELECT 
           ROUND(mosas.total_revenue_of_the_top_ten_customers / mosas.total_revenue_of_all_customers::NUMERIC,2)*100 AS ratio_top10_to_all
       FROM merging_of_strottc_and_stroac AS mosas
)
SELECT *
FROM merging_of_strottc_and_stroac
CROSS JOIN search_ratio_of_top_ten_to_all AS srottta

23. Discount Effectiveness: Do discounted orders have a higher or lower average total value?

--ZERO STEP
SELECT *
FROM northwind_order_details

--FIRST STEP:
SELECT 
    nod.order_id,
    nod.discount,
    ROUND(SUM(nod.unit_price * nod.quantity * (1 - nod.discount))::NUMERIC, 2) AS total_revenue_of_all_orders
FROM northwind_order_details AS nod
GROUP BY nod.order_id, nod.discount
ORDER BY nod.order_id

--SECOND STEP:

WITH search_total_revenue_of_all_orders AS (
      SELECT 
          nod.order_id,
          nod.discount,
          ROUND(SUM(nod.unit_price * nod.quantity * (1 - nod.discount))::NUMERIC, 2) AS total_revenue
      FROM northwind_order_details AS nod
      GROUP BY nod.order_id, nod.discount
      ORDER BY nod.order_id
)
SELECT 
    stroao.order_id,
    stroao.total_revenue
FROM search_total_revenue_of_all_orders AS stroao
WHERE discount !=0

--THIRD STEP:

WITH search_total_revenue_of_all_orders AS (
      SELECT 
          nod.order_id,
          nod.discount,
          ROUND(SUM(nod.unit_price * nod.quantity * (1 - nod.discount))::NUMERIC, 2) AS total_revenue
      FROM northwind_order_details AS nod
      GROUP BY nod.order_id, nod.discount
      ORDER BY nod.order_id
),
search_total_revenue_of_discounted_orders AS (
      SELECT 
          stroao.order_id,
          stroao.total_revenue
      FROM search_total_revenue_of_all_orders AS stroao
      WHERE discount !=0
)
SELECT 
    ROUND(AVG(strodo.total_revenue),2) AS avg_total_revenue_of_discounted_orders
FROM search_total_revenue_of_discounted_orders AS strodo

--FOURTH STEP:

WITH search_total_revenue_of_all_orders AS (
      SELECT 
          nod.order_id,
          nod.discount,
          ROUND(SUM(nod.unit_price * nod.quantity * (1 - nod.discount))::NUMERIC, 2) AS total_revenue
      FROM northwind_order_details AS nod
      GROUP BY nod.order_id, nod.discount
      ORDER BY nod.order_id
),
search_total_revenue_of_discounted_orders AS (
      SELECT 
          stroao.order_id,
          stroao.total_revenue
      FROM search_total_revenue_of_all_orders AS stroao
      WHERE discount !=0
),
search_avg_total_value_of_discounted_orders AS (
      SELECT 
          ROUND(AVG(strodo.total_revenue),2) AS avg_total_revenue_of_discounted_orders
      FROM search_total_revenue_of_discounted_orders AS strodo
)
SELECT 
    ROUND(AVG(stroao.total_revenue),2) AS avg_total_revenue_of_undiscounted_orders
FROM search_total_revenue_of_all_orders AS stroao 
WHERE discount =0

--FOURTH STEP:

WITH search_total_revenue_of_all_orders AS (
      SELECT 
          nod.order_id,
          nod.discount,
          ROUND(SUM(nod.unit_price * nod.quantity * (1 - nod.discount))::NUMERIC, 2) AS total_revenue
      FROM northwind_order_details AS nod
      GROUP BY nod.order_id, nod.discount
      ORDER BY nod.order_id
),
search_total_revenue_of_discounted_orders AS (
      SELECT 
          stroao.order_id,
          stroao.total_revenue
      FROM search_total_revenue_of_all_orders AS stroao
      WHERE discount !=0
),
search_avg_total_value_of_discounted_orders AS (
      SELECT 
          ROUND(AVG(strodo.total_revenue),2) AS avg_total_revenue_of_discounted_orders
      FROM search_total_revenue_of_discounted_orders AS strodo
),
search_avg_total_value_of_undiscounted_orders AS (
      SELECT 
          ROUND(AVG(stroao.total_revenue),2) AS avg_total_revenue_of_undiscounted_orders
      FROM search_total_revenue_of_all_orders AS stroao 
      WHERE discount = 0
)
SELECT *
FROM search_avg_total_value_of_undiscounted_orders AS satvouo
CROSS JOIN search_avg_total_value_of_discounted_orders AS satvodo

24. Product Mix: Which categories contribute most to total revenue? Are there any underperforming ones?

--FIRST STEP:

SELECT 
    nod.product_id,
    nod.unit_price,
    nod.quantity,
    nod.discount,
    np.category_id
FROM northwind_order_details AS nod
JOIN northwind_products AS np 
   ON nod.product_id = np.product_id
   
--SECOND STEP:
   
WITH northwind_order_details_products AS (
       SELECT 
           nod.product_id,
           nod.unit_price,
           nod.quantity,
           nod.discount,
           np.category_id
       FROM northwind_order_details AS nod
       JOIN northwind_products AS np 
          ON nod.product_id = np.product_id
)
SELECT 
    nodp.category_id,
    ROUND(SUM(nodp.unit_price * quantity * (1 - discount))::NUMERIC, 2) AS total_revenue_per_category
FROM northwind_order_details_products AS nodp
GROUP BY nodp.category_id
ORDER BY total_revenue_per_category DESC

--THIRD STEP:

WITH northwind_order_details_products AS (
       SELECT 
           nod.product_id,
           nod.unit_price,
           nod.quantity,
           nod.discount,
           np.category_id
       FROM northwind_order_details AS nod
       JOIN northwind_products AS np 
          ON nod.product_id = np.product_id
),
search_total_revenue_per_category AS (
       SELECT 
           nodp.category_id,
           ROUND(SUM(nodp.unit_price * quantity * (1 - discount))::NUMERIC, 2) AS total_revenue_per_category
       FROM northwind_order_details_products AS nodp
       GROUP BY nodp.category_id
       ORDER BY total_revenue_per_category DESC
)
SELECT 
     SUM(strpc.total_revenue_per_category) AS total_revenues_of_all_categories
FROM search_total_revenue_per_category AS strpc 

--FOURTH STEP:

WITH northwind_order_details_products AS (
       SELECT 
           nod.product_id,
           nod.unit_price,
           nod.quantity,
           nod.discount,
           np.category_id
       FROM northwind_order_details AS nod
       JOIN northwind_products AS np 
          ON nod.product_id = np.product_id
),
search_total_revenue_per_category AS (
       SELECT 
           nodp.category_id,
           ROUND(SUM(nodp.unit_price * quantity * (1 - discount))::NUMERIC, 2) AS total_revenue_per_category
       FROM northwind_order_details_products AS nodp
       GROUP BY nodp.category_id
       ORDER BY total_revenue_per_category DESC
),
search_total_revenue_of_all_categories AS (
       SELECT 
           SUM(strpc.total_revenue_per_category) AS total_revenue_of_all_categories
       FROM search_total_revenue_per_category AS strpc 
)
SELECT *
FROM search_total_revenue_per_category AS strpc
CROSS JOIN search_total_revenue_of_all_categories  AS stroac

--FIFTH STEP:

WITH northwind_order_details_products AS (
       SELECT 
           nod.product_id,
           nod.unit_price,
           nod.quantity,
           nod.discount,
           np.category_id
       FROM northwind_order_details AS nod
       JOIN northwind_products AS np 
          ON nod.product_id = np.product_id
),
search_total_revenue_per_category AS (
       SELECT 
           nodp.category_id,
           ROUND(SUM(nodp.unit_price * quantity * (1 - discount))::NUMERIC, 2) AS total_revenue_per_category
       FROM northwind_order_details_products AS nodp
       GROUP BY nodp.category_id
       ORDER BY total_revenue_per_category DESC
),
search_total_revenue_of_all_categories AS (
       SELECT 
           SUM(strpc.total_revenue_per_category) AS total_revenue_of_all_categories
       FROM search_total_revenue_per_category AS strpc 
),
merging_strpc_and_stroac AS (
       SELECT *
       FROM search_total_revenue_per_category AS strpc
       CROSS JOIN search_total_revenue_of_all_categories  AS stroac
)
SELECT msas.category_id,
       msas.total_revenue_per_category,
       msas.total_revenue_of_all_categories,
       ROUND((msas.total_revenue_per_category/msas.total_revenue_of_all_categories)*100,2) AS ratio_per_category_to_all
FROM merging_strpc_and_stroac AS msas

--SIXTH STEP:

WITH northwind_order_details_products AS (
       SELECT 
           nod.product_id,
           nod.unit_price,
           nod.quantity,
           nod.discount,
           np.category_id
       FROM northwind_order_details AS nod
       JOIN northwind_products AS np 
          ON nod.product_id = np.product_id
),
search_total_revenue_per_category AS (
       SELECT 
           nodp.category_id,
           ROUND(SUM(nodp.unit_price * quantity * (1 - discount))::NUMERIC, 2) AS total_revenue_per_category
       FROM northwind_order_details_products AS nodp
       GROUP BY nodp.category_id
       ORDER BY total_revenue_per_category DESC
),
search_total_revenue_of_all_categories AS (
       SELECT 
           SUM(strpc.total_revenue_per_category) AS total_revenue_of_all_categories
       FROM search_total_revenue_per_category AS strpc 
),
merging_strpc_and_stroac AS (
       SELECT *
       FROM search_total_revenue_per_category AS strpc
       CROSS JOIN search_total_revenue_of_all_categories  AS stroac
),
search_ration_per_category_to_all AS (
       SELECT
           msas.category_id,
           msas.total_revenue_per_category,
           msas.total_revenue_of_all_categories,
           ROUND((msas.total_revenue_per_category/msas.total_revenue_of_all_categories)*100,2) AS ratio_per_category_to_all
       FROM merging_strpc_and_stroac AS msas
)
SELECT 
    srpcta.category_id,
    ncs.category_name,
    srpcta.total_revenue_per_category,
    srpcta.total_revenue_of_all_categories,
    srpcta.ratio_per_category_to_all 
FROM search_ration_per_category_to_all AS srpcta
JOIN northwind_categories AS ncs
   ON srpcta.category_id = ncs.category_id
ORDER BY ratio_per_category_to_all Desc

25. Employee Performance: Rank employees by total revenue generated and average order size. Which employees should be recognized?

-- RANK employees by total revenue:

--FIRST STEP:
SELECT
     nos.order_id,
     nod.unit_price,
     nod.quantity,
     nod.discount,
     nos.employee_id
FROM northwind_order_details AS nod
JOIN northwind_orders AS nos
  ON nod.order_id=nos.order_id
  
  
--SECOND STEP:
WITH northwind_order_details_orders AS (
       SELECT
           nos.order_id,
           nod.unit_price,
           nod.quantity,
           nod.discount,
           nos.employee_id
       FROM northwind_order_details AS nod
       JOIN northwind_orders AS nos
         ON nod.order_id=nos.order_id
)
SELECT 
   nodo.order_id,
   nodo.unit_price,
   nodo.quantity,
   nodo.discount,
   nodo.employee_id,
   ne.last_name,
   ne.first_name
FROM northwind_order_details_orders AS nodo
JOIN northwind_employees AS ne
   ON nodo.employee_id = ne.employee_id
   
   
--THIRD STEP:
   
WITH northwind_order_details_orders AS (
       SELECT
           nos.order_id,
           nod.unit_price,
           nod.quantity,
           nod.discount,
           nos.employee_id
       FROM northwind_order_details AS nod
       JOIN northwind_orders AS nos
         ON nod.order_id=nos.order_id
),
northwind_order_details_orders_employees AS (
       SELECT 
           nodo.order_id,
           nodo.unit_price,
           nodo.quantity,
           nodo.discount,
           nodo.employee_id,
           ne.last_name,
           ne.first_name
      FROM northwind_order_details_orders AS nodo
      JOIN northwind_employees AS ne
         ON nodo.employee_id = ne.employee_id
)
SELECT
    nodoe.employee_id,
    nodoe.last_name,
    nodoe.first_name,
    ROUND(SUM(nodoe.unit_price * nodoe.quantity * (1 - nodoe.discount))::NUMERIC, 2) AS total_revenue_per_employee
FROM northwind_order_details_orders_employees AS nodoe
GROUP BY nodoe.employee_id, nodoe.last_name, nodoe.first_name
ORDER BY total_revenue_per_employee DESC

-- RANK employees by order size:

--FIRST STEP:
SELECT
     nos.employee_id,
     COUNT(nos.order_id) AS total_orders_per_employee
FROM northwind_orders AS nos
GROUP BY nos.employee_id
ORDER BY nos.employee_id
  
--SECOND STEP:

WITH northwind_order_details_orders AS (
       SELECT
           nos.order_id,
           nod.unit_price,
           nod.quantity,
           nod.discount,
           nos.employee_id
       FROM northwind_order_details AS nod
       JOIN northwind_orders AS nos
         ON nod.order_id=nos.order_id
),
northwind_order_details_orders_employees AS (
       SELECT 
           nodo.order_id,
           nodo.unit_price,
           nodo.quantity,
           nodo.discount,
           nodo.employee_id,
           ne.last_name,
           ne.first_name
      FROM northwind_order_details_orders AS nodo
      JOIN northwind_employees AS ne
         ON nodo.employee_id = ne.employee_id
),
search_total_revenue_per_employee AS (
      SELECT
         nodoe.employee_id,
         nodoe.last_name,
         nodoe.first_name,
         ROUND(SUM(nodoe.unit_price * nodoe.quantity * (1 - nodoe.discount))::NUMERIC, 2) AS total_revenue_per_employee
      FROM northwind_order_details_orders_employees AS nodoe
      GROUP BY nodoe.employee_id, nodoe.last_name, nodoe.first_name
      ORDER BY nodoe.employee_id
)
SELECT
     nos.employee_id,
     COUNT(nos.order_id) AS total_orders_per_employee
FROM northwind_orders AS nos
GROUP BY nos.employee_id
ORDER BY nos.employee_id

--THIRD STEP:
WITH northwind_order_details_orders AS (
       SELECT
           nos.order_id,
           nod.unit_price,
           nod.quantity,
           nod.discount,
           nos.employee_id
       FROM northwind_order_details AS nod
       JOIN northwind_orders AS nos
         ON nod.order_id=nos.order_id
),
northwind_order_details_orders_employees AS (
       SELECT 
           nodo.order_id,
           nodo.unit_price,
           nodo.quantity,
           nodo.discount,
           nodo.employee_id,
           ne.last_name,
           ne.first_name
      FROM northwind_order_details_orders AS nodo
      JOIN northwind_employees AS ne
         ON nodo.employee_id = ne.employee_id
),
search_total_revenue_per_employee AS (
      SELECT
         nodoe.employee_id,
         nodoe.last_name,
         nodoe.first_name,
         ROUND(SUM(nodoe.unit_price * nodoe.quantity * (1 - nodoe.discount))::NUMERIC, 2) AS total_revenue_per_employee
      FROM northwind_order_details_orders_employees AS nodoe
      GROUP BY nodoe.employee_id, nodoe.last_name, nodoe.first_name
      ORDER BY nodoe.employee_id
),
search_total_orders_per_employee AS (
       SELECT
          nos.employee_id,
          COUNT(nos.order_id) AS total_orders_per_employee
       FROM northwind_orders AS nos
       GROUP BY nos.employee_id
       ORDER BY nos.employee_id
)
SELECT *
FROM search_total_orders_per_employee AS stope

--FOURTH STEP:
WITH northwind_order_details_orders AS (
       SELECT
           nos.order_id,
           nod.unit_price,
           nod.quantity,
           nod.discount,
           nos.employee_id
       FROM northwind_order_details AS nod
       JOIN northwind_orders AS nos
         ON nod.order_id=nos.order_id
),
northwind_order_details_orders_employees AS (
       SELECT 
           nodo.order_id,
           nodo.unit_price,
           nodo.quantity,
           nodo.discount,
           nodo.employee_id,
           ne.last_name,
           ne.first_name
      FROM northwind_order_details_orders AS nodo
      JOIN northwind_employees AS ne
         ON nodo.employee_id = ne.employee_id
),
search_total_revenue_per_employee AS (
      SELECT
         nodoe.employee_id,
         nodoe.last_name,
         nodoe.first_name,
         ROUND(SUM(nodoe.unit_price * nodoe.quantity * (1 - nodoe.discount))::NUMERIC, 2) AS total_revenue_per_employee
      FROM northwind_order_details_orders_employees AS nodoe
      GROUP BY nodoe.employee_id, nodoe.last_name, nodoe.first_name
      ORDER BY nodoe.employee_id
),
search_total_orders_per_employee AS (
       SELECT
          nos.employee_id,
          COUNT(nos.order_id) AS total_orders_per_employee
       FROM northwind_orders AS nos
       GROUP BY nos.employee_id
       ORDER BY nos.employee_id
)
SELECT 
     strpe.employee_id,
     strpe.last_name,
     strpe.first_name,
     strpe.total_revenue_per_employee,
     stope.total_orders_per_employee
FROM search_total_revenue_per_employee AS strpe
JOIN search_total_orders_per_employee AS stope
   ON strpe.employee_id=stope.employee_id
ORDER BY total_orders_per_employee DESC
   
--FOURTH STEP:
WITH northwind_order_details_orders AS (
       SELECT
           nos.order_id,
           nod.unit_price,
           nod.quantity,
           nod.discount,
           nos.employee_id
       FROM northwind_order_details AS nod
       JOIN northwind_orders AS nos
         ON nod.order_id=nos.order_id
),
northwind_order_details_orders_employees AS (
       SELECT 
           nodo.order_id,
           nodo.unit_price,
           nodo.quantity,
           nodo.discount,
           nodo.employee_id,
           ne.last_name,
           ne.first_name
      FROM northwind_order_details_orders AS nodo
      JOIN northwind_employees AS ne
         ON nodo.employee_id = ne.employee_id
),
search_total_revenue_per_employee AS (
      SELECT
         nodoe.employee_id,
         nodoe.last_name,
         nodoe.first_name,
         ROUND(SUM(nodoe.unit_price * nodoe.quantity * (1 - nodoe.discount))::NUMERIC, 2) AS total_revenue_per_employee
      FROM northwind_order_details_orders_employees AS nodoe
      GROUP BY nodoe.employee_id, nodoe.last_name, nodoe.first_name
      ORDER BY nodoe.employee_id
),
search_total_orders_per_employee AS (
       SELECT
          nos.employee_id,
          COUNT(nos.order_id) AS total_orders_per_employee
       FROM northwind_orders AS nos
       GROUP BY nos.employee_id
       ORDER BY nos.employee_id
),
merging_strpe_and_stope AS (
       SELECT 
           strpe.employee_id,
           strpe.last_name,
           strpe.first_name,
           strpe.total_revenue_per_employee,
           stope.total_orders_per_employee
      FROM search_total_revenue_per_employee AS strpe
      JOIN search_total_orders_per_employee AS stope
         ON strpe.employee_id=stope.employee_id
)
SELECT
    msas.employee_id,
    msas.last_name,
    msas.first_name,
    msas.total_revenue_per_employee,
    msas.total_orders_per_employee,
    ROUND(msas.total_revenue_per_employee/msas.total_orders_per_employee,2) AS avg_order_value_per_employee
FROM merging_strpe_and_stope AS msas
ORDER BY avg_order_value_per_employee DESC

