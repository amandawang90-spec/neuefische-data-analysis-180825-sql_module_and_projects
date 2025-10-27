# Business Scenario: ShopSmart Online Retail

Context:
ShopSmart is an online retail company that sells various products across different categories. The business team wants insights from sales data to understand customer behavior, category performance, and the effectiveness of promotions.

## Tables Overview

### PART A
5 Tables: Identify the PK and Fk for the tables.
Visualise an ER Diagram first and then add them to your DB,this will not take too long since it is an extension of a previous task 

`Customers`
1. customer_id
2. first_name
3. last_name
4. region
5. signup_date

`Products`
1. product_id
2. category
3. product_name
4. unit_price

`Orders`
1. order_id
2.customer_id
3. order_date
4. total_amount

`Order_items`
1. order_item_id 
2. order_id 
3. product_id 
4. quantity
5. unit_price
6. discount

`Promotions`
1. promotion_id 
2. product_id 
3. start_date
4. end_date
5. discount_percent

### PART B

1. `Customer segmentation:` How many customers are from each region? 

2. `Regional performance:` What’s the average order total per region?

3. `Product mix analysis:` Which product categories have the highest average price?

4. `Trend analysis:` Find the total revenue generated per month.

5. `Product performance:` List the top 10 products by total sales quantity.

6. `Customer loyalty / retention:` Which customers placed more than 5 orders in the past 6 months?

7. `Pricing analysis:` Find product categories whose average order item discount is greater than 10%.

8. `Regional target checking:` Which regions have generated more than $50,000 in total sales?

9. `RFM-style segmentation:` Identify customers whose average order value is above the overall average.

10. `Catalog management:` Which products have never been sold?

11. `Regional sales by segment:` Find the total revenue per category and region for the last quarter, showing only categories with total revenue above $10,000.

12. `Cross-category affinity:` Which customers bought products from more than 3 categories?

13. `Promotion performance:` Calculate the average discount applied per product category, but only include categories with at least 50 items sold.

14. `Campaign analysis:` Identify the top 5 customers who spent the most during an active promotion period.

15. `Promo ROI :` For each promotion, calculate the total incremental revenue (total sales of that product during the promotion period).

16. `Post-campaign diagnostic:` Find products that had a promotion but still generated less than the average sales of their category.

17. `Trend evaluation:` List regions where the average order value increased month over month.

18.  `Cross-sell / market basket:` Find customers who bought both Electronics and Sports products.

19. `Market penetration:` Compute the total number of unique customers per category and identify categories that have at least 40 unique buyers.

20. `Pricing / margin impact:` Find the most discounted products (by total discount amount applied) in each category.