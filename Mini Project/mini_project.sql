-- display all the tables for the mini projects

SELECT * FROM ext_customers

SELECT * FROM ext_orders 

SELECT * FROM ext_order_items 

SELECT * FROM ext_products

SELECT * FROM ext_promotions

-- ext_customers/pk
ALTER TABLE ext_customers 
ADD CONSTRAINT pk_ext_customer
    PRIMARY KEY (customer_id)

-- ext_orders/pk
ALTER TABLE ext_orders
ADD CONSTRAINT pk_ext_orders
    PRIMARY KEY (order_id);

-- ext_orders/fk
ALTER TABLE ext_orders
ADD CONSTRAINT fk_orders_customer
FOREIGN KEY (customer_id)
REFERENCES ext_customers(customer_id);


-- ext_products/pk
ALTER TABLE ext_products
ADD CONSTRAINT pk_ext_products
    PRIMARY KEY (product_id);


--ext_order_items/pk
ALTER TABLE ext_order_items
ADD CONSTRAINT pk_ext_order_items
    PRIMARY KEY (order_item_id);

--ext_order_items/fk
ALTER TABLE ext_order_items
ADD CONSTRAINT fk_order_items_product
    FOREIGN KEY (product_id)
    REFERENCES ext_products(product_id);

ALTER TABLE ext_order_items
ADD CONSTRAINT fk_order_id
    FOREIGN KEY (order_id) REFERENCES ext_orders(order_id)

--ext_promotions/pk
ALTER TABLE ext_promotions
ADD CONSTRAINT pk_ext_promotions
    PRIMARY KEY (promotion_id);

--ext_promotions/fk
ALTER TABLE ext_promotions
ADD CONSTRAINT fk_product_id
    FOREIGN KEY (product_id) REFERENCES ext_products(product_id);

1. `Customer segmentation:` How many customers are from each region? 

SELECT region,
       COUNT(customer_id) AS total_customers
FROM ext_customers
GROUP BY region

2. `Regional performance:` What’s the average order total per region?

SELECT region,
       avg(total_amount) AS avg_order_per_region
FROM ext_customers AS c
JOIN ext_orders AS o
ON c.customer_id=o.customer_id
GROUP BY c.region
ORDER BY avg_order_per_region

3. `Product mix analysis:` Which product categories have the highest average price?

SELECT category,
       avg(unit_price) AS avg_unit_price_per_category
FROM ext_products 
GROUP BY category
ORDER BY avg_unit_price_per_category

4. `Trend analysis:` Find the total revenue generated per month.

SELECT pg_typeof(order_date)
FROM ext_orders

--method 1:

--option 1:
SELECT DATE_PART('year', CAST(order_date AS TIMESTAMP)) AS order_year,
       DATE_PART('month', CAST(order_date AS TIMESTAMP)) AS order_month,
       SUM(total_amount) AS total_revenue_per_month
FROM ext_orders
GROUP BY order_year, order_month
ORDER BY order_year, order_month 
--option 2:
SELECT DATE_PART('year', order_date::TIMESTAMP) AS order_year,
       DATE_PART('month',order_date::TIMESTAMP) AS order_month,
       SUM(total_amount) AS total_revenue_per_month
FROM ext_orders
GROUP BY order_year, order_month
ORDER BY order_year, order_month 

--method 2:

--option 1:
SELECT DATE_TRUNC('month', CAST(order_date AS TIMESTAMP)) AS order_month,
       SUM(total_amount) AS total_revenue_per_month
FROM ext_orders
GROUP BY order_month
ORDER BY order_month 
--option 2:
SELECT DATE_TRUNC('month', order_date:: TIMESTAMP) AS order_month,
       SUM(total_amount) AS total_revenue_per_month
FROM ext_orders
GROUP BY order_month
ORDER BY order_month 

--method 3:

--option 1:
SELECT EXTRACT('year' FROM CAST(order_date AS TIMESTAMP)) AS order_year,
       EXTRACT('month' FROM CAST(order_date AS TIMESTAMP)) AS order_month,
       SUM(total_amount) AS total_revenue_per_month
FROM ext_orders
GROUP BY order_year, order_month
ORDER BY order_year, order_month 

--option 2:
SELECT EXTRACT('year' FROM order_date::TIMESTAMP) AS order_year,
       EXTRACT('month' FROM order_date::TIMESTAMP) AS order_month,
       SUM(total_amount) AS total_revenue_per_month
FROM ext_orders
GROUP BY order_year, order_month
ORDER BY order_year, order_month 

--method 4:
SELECT TO_CHAR(order_date::DATE, 'YYYY-MM') AS order_month,
       SUM(total_amount) AS total_revenue_per_month
FROM ext_orders
GROUP BY order_month
ORDER BY order_month 

--method 5:
SELECT TO_DATE(order_date, 'YYYY-MM') AS order_month,
       SUM(total_amount) AS total_revenue_per_month
FROM ext_orders
GROUP BY order_month
ORDER BY order_month 

--method 6:
SELECT TO_TIMESTAMP(order_date, 'YYYY-MM') AS order_month,
       SUM(total_amount) AS total_revenue_per_month
FROM ext_orders
GROUP BY order_month
ORDER BY order_month 

-- remarks:
--If your column is stored as varchar, always cast before using date functions:
--SELECT DATE_PART('month', my_text_date::date) FROM my_table;
--Or, if the format isn’t standard (YYYY-MM-DD), use TO_TIMESTAMP or TO_DATE:
-- For '21/10/2025'
--SELECT TO_DATE(my_text_date, 'DD/MM/YYYY') FROM my_table;
-- For '2025-10-21 15:43:27'
--SELECT TO_TIMESTAMP(my_text_date, 'YYYY-MM-DD HH24:MI:SS') FROM my_table;

5. `Product performance:` List the top 10 products by total sales quantity.

SELECT eoi.product_id,
       ep.product_name,
       SUM(quantity) AS total_sales_quantity
FROM ext_order_items  AS eoi
JOIN ext_products AS ep
ON eoi.product_id=ep.product_id
GROUP BY eoi.product_id, product_name
ORDER BY total_sales_quantity DESC
LIMIT 10;

6. `Customer loyalty / retention:` Which customers placed more than 5 orders in the past 6 months?

SELECT * FROM ext_orders 
ORDER BY order_date

-- 6 months: 2025-5-15 to 2025-10-15

SELECT 
    ec.first_name,
    ec.last_name,
    ec.customer_id,
    COUNT(eo.order_id) AS total_sales_per_customer
FROM ext_customers AS ec
JOIN ext_orders AS eo
    ON ec.customer_id = eo.customer_id
WHERE eo.order_date::DATE >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '6 months'
GROUP BY 
    ec.customer_id, 
    ec.first_name, 
    ec.last_name
ORDER BY 
    total_sales_per_customer DESC;

--AND (eo.order_date::DATE) BETWEEN '2025-5-15' AND '2025-10-15'

7. `Pricing analysis:` Find product categories whose average order item discount is greater than 10%.

SELECT pg_typeof(discount)
FROM ext_order_items

SELECT 
    ep.category,
    AVG(eoi.discount) AS avg_order_item_discount
FROM ext_order_items AS eoi
JOIN ext_products AS ep
    ON eoi.product_id = ep.product_id
GROUP BY 
    ep.category
HAVING 
    AVG(eoi.discount) > 0.1
ORDER BY 
    ep.category;

8. `Regional target checking:` Which regions have generated more than $50,000 in total sales?

SELECT pg_typeof(total_amount)
FROM ext_orders

SELECT 
    ec.region,
    SUM(eo.total_amount) AS total_sales_per_region
FROM ext_customers AS ec
JOIN ext_orders AS eo
    ON ec.customer_id = eo.customer_id
GROUP BY 
    ec.region
HAVING 
    SUM(eo.total_amount) > 50000
ORDER BY 
    total_sales_per_region DESC;

9. `RFM-style segmentation:` Identify customers whose average order value is above the overall average.

SELECT AVG(total_amount) AS avg_order_value
    FROM ext_orders  --2161.0301920827
    
SELECT 
    customer_id,
    AVG(total_amount) AS customer_average_order_value
FROM ext_orders AS eo
GROUP BY customer_id
HAVING AVG(total_amount) > 2161.0301920827
ORDER BY customer_average_order_value DESC;

SELECT AVG(total_amount) AS avg_order_value
    FROM ext_orders  --2161.0301920827
    
SELECT 
    customer_id,
    AVG(total_amount) AS customer_average_order_value
FROM ext_orders AS eo
GROUP BY customer_id
HAVING AVG(total_amount) > (SELECT AVG(total_amount) AS avg_order_value
    FROM ext_orders)
ORDER BY customer_average_order_value DESC;

WITH overall_avg AS (
    SELECT AVG(total_amount) AS avg_order_value
    FROM ext_orders
)
SELECT 
    eo.customer_id,
    AVG(eo.total_amount) AS customer_average_order_value
FROM ext_orders AS eo
CROSS JOIN overall_avg
GROUP BY eo.customer_id, overall_avg.avg_order_value
HAVING AVG(eo.total_amount) > overall_avg.avg_order_value
ORDER BY customer_average_order_value DESC;

10. `Catalog management:` Which products have never been sold?

SELECT *
FROM ext_products
WHERE product_id NOT IN (
    SELECT product_id
    FROM ext_order_items
);

SELECT *
FROM ext_products AS ep
LEFT JOIN ext_order_items AS eoi
ON ep.product_id = eoi.product_id
WHERE eoi.product_id IS NULL;

11. `Regional sales by segment:` Find the total revenue per category and region for the last quarter, showing only categories with total revenue above $10,000.

SELECT ec.region,
       ep.category,
       ROUND(SUM(eoi.quantity*eoi.unit_price*(1-eoi.discount))::NUMERIC,2) AS total_revenue
FROM ext_customers AS ec
JOIN ext_orders AS eo
  ON ec.customer_id = eo.customer_id 
JOIN ext_order_items AS eoi
  ON eo.order_id= eoi.order_id
JOIN ext_products AS ep
  ON eoi.product_id = ep.product_id
WHERE (eo.order_date::DATE) >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '3 months' AND eo.order_date::DATE < DATE_TRUNC('quarter', CURRENT_DATE)
GROUP BY ec.region, ep.category
HAVING SUM(eoi.quantity*eoi.unit_price*(1-discount))> 10000
ORDER BY total_revenue DESC

 

12. `Cross-category affinity:` Which customers bought products from more than 3 categories?

SELECT ec.customer_id,
       ec.first_name,
       ec.last_name,
       COUNT(DISTINCT ep.category) AS total_categories
FROM ext_customers AS ec
JOIN ext_orders AS eo
ON ec.customer_id = eo.customer_id 
JOIN ext_order_items AS eoi
  ON eo.order_id= eoi.order_id
JOIN ext_products AS ep
  ON eoi.product_id = ep.product_id
GROUP BY ec.customer_id
HAVING COUNT(DISTINCT ep.category) > 3
ORDER BY total_categories DESC

13. `Promotion performance:` Calculate the average discount applied per product category, but only include categories with at least 50 items sold.

SELECT ep.category,
       AVG(eoi.discount) AS average_discount_per_product_category
FROM ext_order_items AS eoi
JOIN ext_products AS ep
  ON eoi.product_id = ep.product_id
GROUP BY ep.category
HAVING SUM(eoi.quantity) >=50
ORDER BY average_discount_per_product_category DESC

14. `Campaign analysis:` Identify the top 5 customers who spent the most during an active promotion period.
-- discount in the ext_order_item table is the actual discount which has been adopted for the calculation of total amount,
-- discount in the promotion table may be applied when the condition for the products which are promoted are met, for example:
-- the customer can get 20% for the product_id 1 if the customer buys 100 items during promotion_id 1
-- if the condition is not met, the customer may gets another discount instead of the discount which is shown in the promotion table
-- but the promotion table hasn't shown the details for the promotion for specific products during different promotion period.
-- if the customer has met the conditions, then the actual discount which is adopted in the order item table should be consistent with the discount for the promotion perid for that specific product.

SELECT ec.customer_id,
       ROUND(SUM(eoi.quantity*eoi.unit_price*(1-eoi.discount))::NUMERIC, 2) AS total_promotion_sales_per_customer
FROM ext_customers AS ec
JOIN ext_orders AS eo
    ON ec.customer_id = eo.customer_id
JOIN ext_order_items AS eoi
    ON eo.order_id = eoi.order_id
JOIN ext_products AS ep
    ON eoi.product_id = ep.product_id
JOIN ext_promotions AS eps
    ON ep.product_id = eps.product_id
WHERE eo.order_date BETWEEN eps.start_date AND eps.end_date
GROUP BY 
    ec.customer_id
ORDER BY total_promotion_sales_per_customer DESC 
LIMIT 5

15. `Promo ROI :` For each promotion, calculate the total incremental revenue (total sales of that product during the promotion period).
-- discount in the ext_order_item table is the actual discount which has been adopted for the calculation of total amount,
-- discount in the promotion table may be applied when the condition for the products which are promoted are met, for example:
-- the customer can get 20% for the product_id 1 if the customer buys 100 items during promotion_id 1
-- if the condition is not met, the customer may gets another discount instead of the discount which is shown in the promotion table
-- but the promotion table hasn't shown the details for the promotion for specific products during different promotion period.
-- if the customer has met the conditions, then the actual discount which is adopted in the order item table should be consistent with the discount for the promotion perid for that specific product.

SELECT eps.promotion_id,
       eps.product_id,
       ep.product_name,
       ROUND(SUM(eoi.quantity*eoi.unit_price*(1-eoi.discount))::NUMERIC, 2) AS total_promotion_sales
FROM ext_orders AS eo
JOIN ext_order_items AS eoi
    ON eo.order_id = eoi.order_id
JOIN ext_products AS ep
    ON eoi.product_id = ep.product_id
JOIN ext_promotions AS eps
    ON ep.product_id = eps.product_id
WHERE eo.order_date BETWEEN eps.start_date AND eps.end_date
GROUP BY 
    eps.promotion_id, eps.product_id, ep.product_name
ORDER BY eps.promotion_id

-- CHECK
 SELECT 
	pm.promotion_id,
	product_name,
	SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) AS total_promo_revenue
FROM ext_orders o
JOIN ext_customers c ON o.customer_id = c.customer_id 
JOIN ext_order_items oi ON oi.order_id = o.order_id
JOIN ext_products pd ON pd.product_id = oi.product_id 
JOIN ext_promotions pm ON oi.product_id = pm.product_id
WHERE round(discount * 100::NUMERIC) = pm.discount_percent AND o.order_date::date BETWEEN pm.start_date::date AND pm.end_date::date
GROUP BY pm.promotion_id, product_name
ORDER BY total_promo_revenue DESC

SELECT 
	*,
	round(discount * 100::NUMERIC) AS applied_discount_percent
FROM ext_orders o
JOIN ext_customers c ON o.customer_id = c.customer_id 
JOIN ext_order_items oi ON oi.order_id = o.order_id
JOIN ext_products pd ON pd.product_id = oi.product_id 
JOIN ext_promotions pm ON pd.product_id = pm.product_id
WHERE round(discount * 100::NUMERIC) = pm.discount_percent AND o.order_date::date BETWEEN pm.start_date::date AND pm.end_date::date 
-- CHECK

6. `Post-campaign diagnostic:` Find products that had a promotion but still generated less than the average sales of their category.
WITH overall_avg AS (
    SELECT AVG(total_amount) AS avg_order_value
    FROM ext_orders
)


WITH average_category_sales AS (
     SELECT ep.category,
            AVG(eoi.quantity*eoi.unit_price*(1-eoi.discount)) AS average_sales_per_category                 
     FROM ext_orders AS eo
JOIN ext_order_items AS eoi
    ON eo.order_id = eoi.order_id
JOIN ext_products AS ep
    ON eoi.product_id = ep.product_id
GROUP BY ep.category
)    
SELECT 
       eps.product_id,
       SUM(eoi.quantity*eoi.unit_price*(1-eoi.discount)) AS total_promotion_sales
FROM ext_orders AS eo
JOIN ext_order_items AS eoi
    ON eo.order_id = eoi.order_id
JOIN ext_products AS ep
    ON eoi.product_id = ep.product_id
JOIN ext_promotions AS eps
    ON ep.product_id = eps.product_id
WHERE eo.order_date BETWEEN eps.start_date AND eps.end_date
GROUP BY 
    eps.product_id



