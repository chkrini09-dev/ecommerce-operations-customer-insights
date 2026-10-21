use ecommerce_operations;

-- Record the result as the number of missing or blank order statuses
select count(*) from orders where trim(orders.order_status) = ""   or orders.order_status is null;

-- What order statuses exist in the dataset, and are any unexpected values present
select count(*),orders.order_status from orders group by order_status;

-- What percentage of all orders have a delivered status?
Select (count(*) * 100 /(select count(*) from orders)) as prec_delivered from orders where order_status="delivered";

-- Calculate the non-delivered percentage
Select (count(*) * 100 /(select count(*) from orders)) as prec_delivered from orders where order_status !="delivered";

-- How many orders fall into each non-delivered status, and what percentage of all non-delivered orders does each status represent?
select count(*),orders.order_status,(count(*) * 100 /(select count(*) from orders where order_status !="delivered")) as prec_not_delivered from orders where order_status!="delivered" group by order_status ;






