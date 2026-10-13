Select sum(customer_id is null or customer_id=" ") As missing_customer_id,
sum(customer_unique_id is null or customer_unique_id=" ") As missing_customer_unique_id,
sum(customer_zip_code_prefix is null or customer_zip_code_prefix=" ") As missing_customer_zip_code_prefixcustomer_city,
sum(customer_city is null or customer_city=" ") As missing_customer_city,
sum(customer_state is null or customer_state=" ") As missing_customer_state
from customers;customer_unique_id