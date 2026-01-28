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

-- Adding pks

ALTER TABLE northwind_customers
ADD CONSTRAINT pk_northwind_customers
    PRIMARY KEY (customer_id)
    

ALTER TABLE northwind_orders
ADD CONSTRAINT pk_northwind_orders
    PRIMARY KEY (order_id)  
    

ALTER TABLE northwind_order_details
ADD CONSTRAINT pk_northwind_order_details
    PRIMARY KEY (order_id, product_id)  
    
    
ALTER TABLE northwind_products
ADD CONSTRAINT pk_northwind_products
    PRIMARY KEY (product_id)  
    
    
ALTER TABLE northwind_categories
ADD CONSTRAINT pk_northwind_categories
    PRIMARY KEY (category_id) 
    
    
ALTER TABLE northwind_employees
ADD CONSTRAINT fk_northwind_employees
    PRIMARY KEY (employee_id)  

ALTER TABLE northwind_employees                    
DROP CONSTRAINT fk_northwind_employees CASCADE 

ALTER TABLE northwind_employees
ADD CONSTRAINT pk_northwind_employees
    PRIMARY KEY (employee_id)  
    
    
ALTER TABLE northwind_territories 
ADD CONSTRAINT fk_northwind_territories
    PRIMARY KEY (territory_id) 

ALTER TABLE northwind_territories                   
DROP CONSTRAINT fk_northwind_territories CASCADE 

ALTER TABLE northwind_territories 
ADD CONSTRAINT pk_northwind_territories
    PRIMARY KEY (territory_id) 
    

ALTER TABLE northwind_employee_territories
ADD CONSTRAINT fk_northwind_employee_territories
    PRIMARY KEY (territory_id)  
    
ALTER TABLE northwind_employee_territories                  
DROP CONSTRAINT fk_northwind_employee_territories CASCADE     
    
ALTER TABLE northwind_employee_territories
ADD CONSTRAINT pk_northwind_employee_territories
    PRIMARY KEY (territory_id)        
    
ALTER TABLE northwind_shippers 
ADD CONSTRAINT pk_northwind_shippers
    PRIMARY KEY (shipper_id) 
    
-- Adding fks
ALTER TABLE northwind_orders 
ADD CONSTRAINT fk_northwind_orders
    FOREIGN KEY (customer_id) REFERENCES northwind_customers (customer_id)

ALTER TABLE northwind_orders                
DROP CONSTRAINT fk_northwind_orders CASCADE    

ALTER TABLE northwind_orders 
ADD CONSTRAINT fk_northwind_orders_customer_id
    FOREIGN KEY (customer_id) REFERENCES northwind_customers (customer_id)

ALTER TABLE northwind_orders 
ADD CONSTRAINT fk_northwind_orders_employee_id
    FOREIGN KEY (employee_id) REFERENCES northwind_employees (employee_id);
    
ALTER TABLE northwind_orders 
ADD CONSTRAINT fk_northwind_orders_ship_via
    FOREIGN KEY (ship_via) REFERENCES northwind_shippers (shipper_id) 

    

ALTER TABLE northwind_order_details
    ADD CONSTRAINT fk_northwind_order_details_order_id
        FOREIGN KEY (order_id) REFERENCES northwind_orders(order_id),
    ADD CONSTRAINT fk_northwind_order_details_product_id
        FOREIGN KEY (product_id) REFERENCES northwind_products(product_id);

ALTER TABLE northwind_products
ADD CONSTRAINT fk_northwind_categories
    FOREIGN KEY (category_id) REFERENCES northwind_categories(category_id);

ALTER TABLE northwind_employee_territories
ADD CONSTRAINT fk_northwind_employee_territories
    FOREIGN KEY (employee_id) REFERENCES northwind_employees (employee_id); 
    
    
ALTER TABLE northwind_employee_territories
ADD CONSTRAINT fk_northwind_employees_territories_territory_id
    FOREIGN KEY (territory_id) REFERENCES northwind_territories (territory_id); 




