-- 1. Customer details check

USE ecommerce_operations;

-- Duplicate customer IDs and repeated customer identities.
Select sum(customer_id is null or TRIM(customer_id)=" ") As missing_customer_id,
sum(customer_unique_id is null or customer_unique_id=" ") As missing_customer_unique_id,
sum(customer_zip_code_prefix is null or customer_zip_code_prefix=" ") As missing_customer_zip_code_prefix,
sum(customer_city is null or customer_city=" ") As missing_customer_city,
sum(customer_state is null or customer_state=" ") As missing_customer_state
from customers;

Select customer_id, COUNT(*) AS occurrences from customers GROUP BY customer_id HAVING COUNT(*) > 1; 

SELECT COUNT(*) AS total_records, COUNT(DISTINCT customer_id) AS distinct_customer_ids, COUNT(DISTINCT customer_unique_id) AS distinct_unique_customers
FROM customers;

SELECT customer_unique_id, COUNT(*) AS record_count FROM customers
GROUP BY customer_unique_id HAVING COUNT(*) > 1 ORDER BY record_count DESC LIMIT 10;

SELECT COUNT(*) AS repeated_customer_identities FROM (SELECT customer_unique_id FROM customers GROUP BY customer_unique_id
HAVING COUNT(*) > 1 ) AS repeated_customers;

SELECT SUM(record_count) AS records_with_repeated_identities FROM ( SELECT COUNT(*) AS record_count FROM customers
    GROUP BY customer_unique_id HAVING COUNT(*) > 1) AS repeated_customers;

SELECT SUM(record_count - 1) AS additional_records FROM ( SELECT COUNT(*) AS record_count FROM customers
    GROUP BY customer_unique_id HAVING COUNT(*) > 1) AS repeated_customers;    
    
    
    
-- Key Uniqueness and Order Item Checks
USE ecommerce_operations;

-- Check order ID uniqueness
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS unique_order_ids
FROM orders;

-- Check customer ID uniqueness
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_id) AS unique_customer_ids
FROM customers;

-- Check order item IDs and product/seller references
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS orders_in_items,
    COUNT(DISTINCT product_id) AS products_in_items,
    COUNT(DISTINCT seller_id) AS sellers_in_items
FROM order_items;

-- Does the orders table contain exactly one record per order?
select count(order_id) as Total_Orders , count(distinct order_id) as Total_Distinct_Order_Id from orders;

-- Does every order reference a customer that exists in the customers table?
select o.order_id,c.customer_id from orders o Left Join customers c On o.customer_id=c.customer_id where c.customer_id is Null;

-- Does every record in order_items refer to an existing order in orders?
Select oi.order_item_id,o.order_id from order_items oi Left Join orders o on oi.order_id=o.order_id where o.order_id is Null;

-- Does every order-item record refer to a product that exists in the products table?

Select oi.order_item_id,p.product_id from order_items oi Left Join products p On oi.product_id=p.product_id where p.product_id is Null;

-- Does every order-item record refer to a seller that exists in the sellers table?
select oi.order_item_id,s.seller_id from order_items oi left join sellers s on oi.seller_id=s.seller_id where s.seller_id is null;








