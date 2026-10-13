Select sum(customer_id is null or customer_id=" ") As missing_customer_id,
sum(customer_unique_id is null or customer_unique_id=" ") As missing_customer_unique_id,
sum(customer_zip_code_prefix is null or customer_zip_code_prefix=" ") As missing_customer_zip_code_prefixcustomer_city,
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
    
    
    










