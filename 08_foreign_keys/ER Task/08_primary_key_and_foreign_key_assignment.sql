SELECT * FROM customers

SELECT * FROM orders 

SELECT * FROM order_items 

SELECT * FROM products

ALTER TABLE customers 
ADD PRIMARY KEY (customer_id)

ALTER TABLE customers
DROP PRIMARY KEY;  

--In PostgreSQL, you cannot just write DROP PRIMARY KEY. 
--You need to drop the primary key constraint by its name. 
--PostgreSQL automatically names the primary key constraint unless you explicitly named it when creating the table.

SELECT conname
FROM pg_constraint
WHERE conrelid = 'customers'::regclass
  AND contype = 'p';

ALTER TABLE customers                    --Drop the primary key using the constraint name
DROP CONSTRAINT customers_pkey CASCADE;  --This will remove the primary key and any foreign keys in other tables that reference it.

ALTER TABLE customers 
ADD CONSTRAINT pk_customer
    PRIMARY KEY (customer_id)
    
    ALTER TABLE customers                    --Drop the primary key using the constraint name
DROP CONSTRAINT pk_customer CASCADE; 

ALTER TABLE customers 
ADD CONSTRAINT pk_customers
    PRIMARY KEY (customer_id)

ALTER TABLE orders
ADD CONSTRAINT pk_orders
    PRIMARY KEY (order_id)

ALTER TABLE orders
ADD CONSTRAINT fk_customer
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id);

ALTER TABLE orders
DROP CONSTRAINT fk_customer CASCADE;

ALTER TABLE orders 
ADD CONSTRAINT fk_orders
    FOREIGN KEY (customer_id) REFERENCES customers (customer_id);

ALTER TABLE order_items 
ADD CONSTRAINT pk_order_items
    PRIMARY KEY (order_item_id)
    
ALTER TABLE products 
ADD CONSTRAINT pk_products
    PRIMARY KEY (product_id)
    
ALTER TABLE order_items
    ADD CONSTRAINT fk_order_id
        FOREIGN KEY (order_id) REFERENCES orders(order_id),
    ADD CONSTRAINT fk_product_id
        FOREIGN KEY (product_id) REFERENCES products(product_id);
  
