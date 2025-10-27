## Scenario Overview

You are analyzing sales for ShopSmart, an online retail platform. You have received raw data and your job is to understand relationships between tables, identify primary and foreign keys, and prepare the data for analysis.

### Table Descriptions

#### Customers

Purpose: Store information about each registered customer.

Columns:

- customer_id → unique ID for each customer 

- name → full name of customer

- email → customer email address (unique)

- city → city where the customer lives

- sign up_date → date when the customer registered

#### Products

Purpose: Store information about products available for sale.

Columns:

- product_id → unique product ID 

- product_name → name of the product

- category → product category

- price → unit price of the product

#### Orders

Purpose: Records each order made by a customer.

Columns:

- order_id → unique order ID 

- customer_id → ID of the customer who placed the order 

- order_date → date when the order was placed

- status → order status (e.g., delivered, pending, cancelled)

#### Order_Items

Purpose: Each row represents a line item in an order (a specific product and quantity).

Columns:

- order_item_id → unique ID for the order line 

- order_id → ID of the order 
- product_id → ID of the product 

- quantity → number of units ordered