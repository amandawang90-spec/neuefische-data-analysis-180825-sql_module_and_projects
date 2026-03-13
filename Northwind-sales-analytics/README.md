# Northwind Sales Analytics — SQL Project

## 📌 Project Overview

This project analyses sales, customer, employee and product performance data for Northwind Traders using SQL and PostgreSQL. The goal is to extract meaningful KPIs, uncover business patterns and deliver data-driven insights to support business decision-making across sales, operations and customer management.

The analysis progresses from data familiarisation through to complex analytical queries and business reporting — covering 10 interrelated tables with entity relationships defined using primary and foreign keys.

---

## 🛠️ Tools & Tech Stack

| Tool | Purpose |
|---|---|
| PostgreSQL | Relational database management and querying |
| AWS RDSCloud-hosted database instance | Cloud-hosted database instance |
| SQL | Data extraction, transformation and analysis |
| DBeaver | Database interface for running and managing queries|
| GitHub | Version control |

---

## 🗂️ Data Model

The database consists of **10 interrelated tables**, with entity relationships defined using primary and foreign keys:

| Table | Description |
|---|---|
| `customers` | Customer details and contact information |
| `employees` | Employee records and territories |
| `orders` | Order headers including dates and shipping info |
| `order_details` | Line items per order with price, quantity and discount |
| `products` | Product catalogue with pricing |
| `categories` | Product category groupings |
| `shippers` | Shipping carrier information |
| `suppliers` | Supplier details |
| `territories` | Sales territory definitions |
| `employee_territories` | Mapping of employees to territories |

---

## ❓ Key Questions Answered

### Part 1 — Data Familiarisation
- Overview of all tables and their relationships
- Customer distribution by country
- Top 10 most expensive products

### Part 2 — Aggregation & Summaries
- Total orders placed per year
- Average freight cost per shipping country
- Total sales revenue per customer
- Average product price and product count per category

### Part 3 — Joins & Relationships
- Orders with customer name, employee name and ship country
- Total sales value per employee
- Customers who have never placed an order
- Top 10 best-selling products by total revenue

### Part 4 — Analytical Queries
- Top 3 countries by total sales value and their best-selling categories
- Month with highest total sales
- Domestic vs international average order value comparison
- Top 5 customers by order count and total revenue
- Employees ranked by average revenue per order

### Part 5 — Business Insights & Reporting
- Customer profitability: top 10 customers' share of total revenue
- Discount effectiveness: impact on average order value
- Product mix: category contribution to total revenue and underperformers
- Employee performance ranking by total revenue and average order size

---

## ▶️ How to Run the Project

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd northwind-sales-analytics
   ```

2. **Set up the database**
   - Import the provided CSV files into PostgreSQL
   - Create tables and define entity relationships (PK/FK constraints)
   - Or use the provided schema setup script if available

3. **Run the queries**
   - Open your SQL client (pgAdmin or DBeaver)
   - Connect to your PostgreSQL instance
   - Execute the `.sql` files in order (Part 1 → Part 5)

---

## 📈 Key Findings & Insights

- **Customer Profitability** — the top 10 customers account for a disproportionate share of total revenue, highlighting the importance of key account management
- **Employee Performance** — significant variation in revenue generated per employee, with top performers driving a large proportion of total sales
- **Product Mix** — certain categories consistently outperform others; some categories show low revenue contribution and may warrant review
- **Discount Effectiveness** — analysis of whether discounts drive higher order values or erode margins
- **Seasonal Trends** — identified the peak sales month, enabling better inventory and resource planning

> 📝 Detailed findings and query results are available in the project notebooks and business report.

---

## 📁 Project Structure

```
northwind-sales-analytics/
│
├── data/                          # Raw CSV files
├── sql/
│   ├── entity_relationships.sql   # Table creation and PK/FK constraints
│   └── queries.sql                # All analytical queries
├── report/                        # Business report / presentation
└── README.md

```
