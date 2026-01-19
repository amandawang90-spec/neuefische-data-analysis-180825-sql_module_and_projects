1) How many customers are from each region?

Step-by-step hint

- Select region.

- Count rows per region.

- Group by region and order by count

2) What’s the average order total per region?

Hint (step-by-step)

- Join orders → customers on customer_id.

- Group by region.

- Compute AVG(total_amount) per region.

Round for readability and sort.

 3) Which product categories have the highest average price?

Hint (step-by-step)

- Use the products table.

- Group by category.

- Compute AVG(unit_price) and sort descending.

 4) Find the total revenue generated per month.

 Hint (step-by-step)

- Use the orders table.

- Truncate order_date to month (grouping key).

- Sum total_amount per month.

- Order chronologically.

 5) List the top 10 products by total sales quantity.

 Hint (step-by-step)

- Join order_items → products to get product names.

- Group by product name (or product_id + name).

- Sum quantity.

 6) Which customers placed more than 5 orders in the past 6 months?

 Hint (step-by-step)

- Filter orders by order_date ≥ CURRENT_DATE - INTERVAL '6 months'.

- Join to customers.

- Group by customer.

- Use HAVING COUNT(*) > 5.

 7) Find product categories whose average order item discount is greater than 10%.

 Hint (step-by-step)

- Join order_items → products.

- Group by category.

- Compute AVG(discount) and filter with HAVING > 0.10.

- Present as percentage.

 8) Which regions have generated more than $50,000 in total sales?

 Hint (step-by-step)

- Join orders → customers.

- Group by region.

- Sum total_amount.

- Use HAVING SUM(...) > 50000.


 9) Identify customers whose average order value is above the overall average.

 Hint (step-by-step)

- Compute each customer’s AVG(total_amount) by grouping orders by customer.

- Compute overall average with a scalar subquery (SELECT AVG(total_amount) FROM orders).

- Use HAVING to compare customer average > overall average.

- Order by customer average descending.

 10) Which products have never been sold?

 Hint (step-by-step)

- Left join products → order_items on product_id.

- Keep rows where order_items.product_id IS NULL.

- Return product id/name/category.


 11) Total revenue per category and region for the last quarter, showing only category-region combos with > $10,000.

 Hint (step-by-step)

- Filter orders to last quarter using DATE_TRUNC('quarter', CURRENT_DATE) - INTERVAL '1 quarter'.

- Join: orders → customers → order_items → products.

- For each (category, region) sum quantity * unit_price * (1 - discount).

- Use HAVING SUM(...) > 10000.

- Order by revenue desc.

 12) Which customers bought products from more than 3 categories?

Hint (step-by-step)

- Join orders → order_items → products → customers.

- Group by customer.

- Count distinct category per customer.

13) Average discount per category, only for categories with ≥ 50 items sold.

Hint (step-by-step)

- Join order_items → products.

- Group by category.

- Compute SUM(quantity) and AVG(discount).

- Use HAVING SUM(quantity) >= 50 to restrict categories.

14) Top 5 customers who spent the most during an active promotion period.

Hint (step-by-step)

- Join orders → order_items → promotions → customers via product match.

- Filter rows where order_date BETWEEN promotion.start_date AND promotion.end_date.

- For each customer sum quantity * unit_price * (1 - discount) (actual charged value).

- Group by customer, order desc, limit 5.

15) For each promotion, calculate total revenue during the promo period.

Hint (step-by-step)

- Join promotions → products → order_items → orders.
 
- Filter orders to o.order_date BETWEEN pr.start_date AND pr.end_date.
 
- Group by promotion_id and product_name.

- Sum quantity * unit_price * (1 - discount).

16) Find products that had a promotion but still generated less than their category’s average sales.

Hint (step-by-step)

- Restrict to products present in promotions by joining products → promotions.

- For each product, compute total sales = SUM(quantity * unit_price * (1 - discount)).

- For the product’s category compute the average product sales (subquery: per-product SUM grouped by product, then AVG of those sums).

- Use HAVING product_sales < category_average (correlated subquery).

17) List regions where the average order value increased month over month (no window functions).

Hint (step-by-step)

- Aggregate to compute average order value per region per month (use DATE_TRUNC('month', order_date)).

- Self-join the monthly aggregates to match each month to its previous month for the same region (join on region and month = prev_month + INTERVAL '1 month').

- Keep rows where current_month_avg > previous_month_avg.

- Return region, current month and values.


18) Find customers who bought both Electronics and Sports products.

Hint (step-by-step)

- Join orders → order_items → products → customers.

- Group by customer.

- Use conditional aggregation to count categories per customer (COUNT(DISTINCT CASE WHEN category = 'X' THEN category END)).

- Require both counts > 0 in HAVING.

19) Compute unique customers per category and identify categories with ≥ 40 unique buyers.

Hint (step-by-step)

- Join order_items → products → orders to link category → customer_id.

- Group by category.

- Use COUNT(DISTINCT customer_id) and HAVING >= 40.

20) Find the most discounted products (by total discount amount applied) in each category — no window functions.

Hint (step-by-step)

- For each product compute total_discount = SUM(quantity * unit_price * discount).

- For each category compute the maximum total_discount across its products (use a derived subquery that groups per product then computes MAX(...)).

- Select products whose total_discount equals the category maximum (correlated subquery in HAVING).