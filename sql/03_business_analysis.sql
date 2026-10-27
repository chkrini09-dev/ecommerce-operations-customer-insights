use ecommerce_operations;
-- Order performance
-- Order status distribution, delivery rate, cancellation rate, and delivery timeliness


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

-- Among orders marked delivered, how many have a missing actual customer-delivery timestamp?

select count(*) from orders where order_status="delivered" and (trim(order_delivered_customer_date) = "" or order_delivered_customer_date is null);

-- How many delivered orders have a missing or blank order_estimated_delivery_date?

select count(*) from orders where order_status="delivered" and (trim(order_estimated_delivery_date) = "" or order_estimated_delivery_date is null);

-- Of the delivered orders with valid dates, how many arrived early, on the estimated date, or late?
select count(order_id), 
			Case 
				when date_format(order_delivered_customer_date,'%Y-%m-%d') < date_format(order_estimated_delivery_date,'%Y-%m-%d') Then 'Early'
                when date_format(order_delivered_customer_date,'%Y-%m-%d') > date_format(order_estimated_delivery_date,'%Y-%m-%d') Then 'Late'
                when date_format(order_delivered_customer_date,'%Y-%m-%d') = date_format(order_estimated_delivery_date,'%Y-%m-%d') Then 'On time'
            End As Delivery_Timeline,
            (COUNT(order_id) * 100.0 / (select count(order_id) from orders where order_status ="delivered" and trim(order_delivered_customer_date) !='' 
 and order_delivered_customer_date is not null )) AS percentage
 from orders where order_status='delivered' and trim(order_delivered_customer_date) !='' 
 and order_delivered_customer_date is not null group by  Delivery_Timeline;  
 
 -- Measure delivery delay in days
 Select datediff(date_format(order_delivered_customer_date,'%Y-%m-%d'),date_format(order_estimated_delivery_date,'%Y-%m-%d')) 
 as delayed_days from orders where date_format(order_delivered_customer_date,'%Y-%m-%d') > date_format(order_estimated_delivery_date,'%Y-%m-%d') ;
 
 -- Calculate summary metrics
 Select count(*) as total_late_order, round(avg(datediff(date_format(order_delivered_customer_date,'%Y-%m-%d'),date_format(order_estimated_delivery_date,'%Y-%m-%d'))),2) as Avg_Delay, 
 min(datediff(date_format(order_delivered_customer_date,'%Y-%m-%d'),date_format(order_estimated_delivery_date,'%Y-%m-%d'))) as Min_Delay,
 max(datediff(date_format(order_delivered_customer_date,'%Y-%m-%d'),date_format(order_estimated_delivery_date,'%Y-%m-%d'))) as Max_Delays
 from orders where date_format(order_delivered_customer_date,'%Y-%m-%d') > date_format(order_estimated_delivery_date,'%Y-%m-%d') ;
 
 -- Find the order with the maximum delay and display its order_id, purchase date, estimated delivery date, and actual delivery date.
 select order_id as order_id,order_purchase_timestamp as purchase_date,order_approved_at as approve_date ,order_delivered_carrier_date as deliver_at_carrier
 ,order_delivered_customer_date as deliver_to_customer ,order_estimated_delivery_date as est_delivery_date from orders where
 datediff(date_format(order_delivered_customer_date,'%Y-%m-%d'),date_format(order_estimated_delivery_date,'%Y-%m-%d')) 
 =(Select max(datediff(date_format(order_delivered_customer_date,'%Y-%m-%d'),date_format(order_estimated_delivery_date,'%Y-%m-%d'))) Max_Delays
 from orders where date_format(order_delivered_customer_date,'%Y-%m-%d') > date_format(order_estimated_delivery_date,'%Y-%m-%d'));
 
 -- Find the 2nd maximum delay
SELECT MAX(datediff(date_format(order_delivered_customer_date,'%Y-%m-%d'),date_format(order_estimated_delivery_date,'%Y-%m-%d'))) as second_Max_delay
FROM orders
WHERE datediff(date_format(order_delivered_customer_date,'%Y-%m-%d'),date_format(order_estimated_delivery_date,'%Y-%m-%d')) < (
    SELECT MAX(datediff(date_format(order_delivered_customer_date,'%Y-%m-%d'),date_format(order_estimated_delivery_date,'%Y-%m-%d')))
    FROM orders where order_status='delivered' and trim(order_delivered_customer_date) !='' 
 and order_delivered_customer_date is not null and 
 date_format(order_delivered_customer_date,'%Y-%m-%d') > date_format(order_estimated_delivery_date,'%Y-%m-%d')) and order_status='delivered' and trim(order_delivered_customer_date) !='' 
 and order_delivered_customer_date is not null and 
 date_format(order_delivered_customer_date,'%Y-%m-%d') > date_format(order_estimated_delivery_date,'%Y-%m-%d');
 
-- Details for second maximum delay 
 select order_id as order_id,order_purchase_timestamp as purchase_date,order_approved_at as approve_date ,order_delivered_carrier_date as deliver_at_carrier
 ,order_delivered_customer_date as deliver_to_customer ,order_estimated_delivery_date as est_delivery_date from orders where
 datediff(date_format(order_delivered_customer_date,'%Y-%m-%d'),date_format(order_estimated_delivery_date,'%Y-%m-%d')) 
 = (SELECT MAX(datediff(date_format(order_delivered_customer_date,'%Y-%m-%d'),date_format(order_estimated_delivery_date,'%Y-%m-%d'))) as second_Max_delay
FROM orders
WHERE datediff(date_format(order_delivered_customer_date,'%Y-%m-%d'),date_format(order_estimated_delivery_date,'%Y-%m-%d')) < (
    SELECT MAX(datediff(date_format(order_delivered_customer_date,'%Y-%m-%d'),date_format(order_estimated_delivery_date,'%Y-%m-%d')))
    FROM orders where order_status='delivered' and trim(order_delivered_customer_date) !='' 
 and order_delivered_customer_date is not null and 
 date_format(order_delivered_customer_date,'%Y-%m-%d') > date_format(order_estimated_delivery_date,'%Y-%m-%d')) and order_status='delivered' and trim(order_delivered_customer_date) !='' 
 and order_delivered_customer_date is not null and 
 date_format(order_delivered_customer_date,'%Y-%m-%d') > date_format(order_estimated_delivery_date,'%Y-%m-%d'));

 -- Delivery delay by order month
 SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS Order_month,
    COUNT(order_id) AS total_order,
    ROUND(
        AVG(
            DATEDIFF(
                DATE_FORMAT(order_delivered_customer_date, '%Y-%m-%d'),
                DATE_FORMAT(order_estimated_delivery_date, '%Y-%m-%d')
            )
        ),
        2
    ) AS Avg_Delay,
    ROUND(
        SUM(
            CASE
                WHEN DATE_FORMAT(order_delivered_customer_date, '%Y-%m-%d')
                     > DATE_FORMAT(order_estimated_delivery_date, '%Y-%m-%d')
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(order_id),
        2
    ) AS late_delivery_percentage

FROM orders

WHERE order_status = 'delivered'
  AND TRIM(order_delivered_customer_date) != ''
  AND order_delivered_customer_date IS NOT NULL
  AND TRIM(order_estimated_delivery_date) != ''
  AND order_estimated_delivery_date IS NOT NULL

GROUP BY DATE_FORMAT(order_purchase_timestamp, '%Y-%m')
ORDER BY Order_month;
 
-- Delivery Performance: March 2018 Late Orders
-- Purpose: Measure the number of late delivered orders and their average delay.


 Select count(order_id), round( avg(datediff(order_delivered_customer_date,order_estimated_delivery_date)),2) As Avg_Delay from orders where order_status='delivered' 
 and date_format(order_purchase_timestamp , '%Y-%m')='2018-03' 
 AND TRIM(order_delivered_customer_date) != ''
  AND order_delivered_customer_date IS NOT NULL
  AND TRIM(order_estimated_delivery_date) != ''
  AND order_estimated_delivery_date IS NOT NULL 
  and date_format(order_delivered_customer_date,'%Y-%m-%d') > date_format(order_estimated_delivery_date,'%Y-%m-%d'); 
 -- Metrics:
-- Late delivered orders: 1,328
-- Average delay among late orders: 10.02 days
 
-- Delivery Performance: April 2018 Late Orders 
 Select count(order_id), round( avg(datediff(order_delivered_customer_date,order_estimated_delivery_date)),2) As Avg_Delay from orders where order_status='delivered' 
 and date_format(order_purchase_timestamp , '%Y-%m')='2018-04' 
 AND TRIM(order_delivered_customer_date) != ''
  AND order_delivered_customer_date IS NOT NULL
  AND TRIM(order_estimated_delivery_date) != ''
  AND order_estimated_delivery_date IS NOT NULL 
  and date_format(order_delivered_customer_date,'%Y-%m-%d') > date_format(order_estimated_delivery_date,'%Y-%m-%d'); 







