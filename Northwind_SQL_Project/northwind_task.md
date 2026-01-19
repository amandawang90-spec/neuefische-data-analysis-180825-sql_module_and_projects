# SQL Analyst Project — Northwind Sales Analytics

## Context

You’ve just joined Northwind Traders as a junior data analyst.
Your manager wants actionable insights about the company’s sales, customers, employees, and product performance.
All data lives in a SQL database.

Your goal: answer the questions below using SQL, summarize patterns, and prepare a short business report or presentation.

### Data Model

Tables used:

- customers

- employees

- orders

- order_details

- products

- categories

- shippers

- suppliers

## Project Structure (25 Questions Total)

### Part 1 — Data Familiarization (5 questions) ~1.5 hours

1. List all tables in the Northwind database and briefly describe what each represents.

2. Show the first 10 rows of the orders table.

3.Find all distinct countries where customers are located.

4. Get all customers from Germany and their contact names, ordered by company name.

5. List the top 10 most expensive products by unit price.


### Part 2 — Aggregation & Summaries (5 questions) ~1.5–2 hours

6. Count how many customers are in each country (descending order).

7. Calculate the total number of orders placed per year.

8. Find the average freight cost per shipping country.

9. Show each category’s average product price and total number of products.

10. Compute the total sales (revenue) per customer using the formula:
    `unitPrice * quantity * (1 - discount)`

### Part 3 — Joins & Relationships (5 questions) ~2 hours

11. List all orders with customer name, employee name, and ship country.

12. Find the total sales value per employee.

13. Find customers who have never placed an order.

14. Show the top 10 best-selling products by total revenue.

15. For each category, show the most expensive product.


### Part 4 — Analytical Queries (6 questions) ~2 hours

16. Find the top 3 countries by total sales value.

17. Show for each of those top countries the best-selling category.

18. Find the month with the highest total sales overall.

19. Compare average order value for domestic vs international shipments (relative to the company’s country — assume “UK”).

20. Identify the top 5 customers by number of orders and their total revenue.

21. Determine which employees generate the most revenue on average per order.


### Part 5 — Business Insights & Reporting (4 questions) ~2.5 hours + presentation/write-up

22. Customer Profitability: What percentage of total sales comes from your top 10 customers?

23. Discount Effectiveness: Do discounted orders have a higher or lower average total value?

24. Product Mix: Which categories contribute most to total revenue? Are there any underperforming ones?

25. Employee Performance: Rank employees by total revenue generated and average order size. Which employees should be recognized?


### Optional Stretch REQUIRES RESEARCH

Use a window function to rank customers by total revenue.

Compute month-over-month revenue growth using EXTRACT(YEAR FROM orderDate) and EXTRACT(MONTH FROM orderDate).

Identify “dormant customers” who haven’t placed an order in the last 365 days (relative to the max order date).

Find the top supplier by total sales of their products.

Calculate the proportion of orders handled by each shipper.



