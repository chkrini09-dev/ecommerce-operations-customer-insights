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
  
  
-- Customer purchase behaviour
-- Identify customers who have placed more than one order.
Select c.customer_unique_id,count(o.order_id) as order_count from customers c inner join orders o on c.customer_id=o.customer_id group by 
c.customer_unique_id having order_count>1 order by c.customer_unique_id asc;

-- What percentage of actual customers have placed only one order versus multiple orders?
SELECT
    CASE
        WHEN order_count = 1 THEN 'One-time'
        WHEN order_count > 1 THEN 'Repeat'
    END AS customer_type,
    COUNT(*) AS total_customers,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(DISTINCT customer_unique_id) FROM customers), 2) AS percentage
FROM
(
    SELECT
        c.customer_unique_id,
        COUNT(o.order_id) AS order_count
    FROM customers c
    INNER JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
) AS customer_orders
GROUP BY customer_type
ORDER BY total_customers DESC;


-- How many customers placed exactly 1, 2, 3, 4, or 5+ orders?
SELECT
    CASE
        WHEN order_count >= 5 THEN '5+ orders'
        ELSE CONCAT(order_count, ' orders')
    END AS order_frequency,
    COUNT(*) AS total_customers
FROM
(
    SELECT
        c.customer_unique_id,
        COUNT(o.order_id) AS order_count
    FROM customers c
    INNER JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
) AS customer_orders
GROUP BY order_frequency
ORDER BY
    CASE
        WHEN order_frequency = '5+ orders' THEN 5
        ELSE CAST(SUBSTRING_INDEX(order_frequency, ' ', 1) AS UNSIGNED)
    END;


-- Product and Category Performance


-- Which product categories generate the highest sales?
select  COUNT(oi.order_item_id) as total_item_sold, round(SUM(oi.price),2) as total_sales , round(avg(oi.price),2) As avg_item_price ,
pc.product_category_name_english from order_items oi 
inner join products p on oi.product_id=p.product_id left join product_category_translation pc on p.product_category_name=pc.product_category_name  
group by pc.product_category_name_english order by total_sales desc limit 10;

-- What percentage of total product sales does each category contribute?
select round((sum(oi.price)/(Select sum(price) from order_items) *100.0),2 )AS Per_Prod_sold, pc.product_category_name_english from order_items oi 
inner join products p on oi.product_id=p.product_id left join product_category_translation pc on p.product_category_name=pc.product_category_name  
group by pc.product_category_name_english;

-- Which categories are the top 5 contributors to total sales?
select round((sum(oi.price)/(Select sum(CAST(price AS DECIMAL(12,2))) from order_items) *100.0),2 )AS Per_Prod_sold, pc.product_category_name_english from order_items oi 
inner join products p on oi.product_id=p.product_id left join product_category_translation pc on p.product_category_name=pc.product_category_name  
group by pc.product_category_name_english order by Per_Prod_sold desc limit 5;



-- Seller Performance
-- Which sellers generate the highest sales?
Select round(SUM(CAST(oi.price AS DECIMAL(12,2)) ), 2) as total_sales, COUNT(distinct(oi.order_id)) as total_orders,  COUNT(oi.order_item_id) as total_item_sold , 
round(avg(CAST(oi.price AS DECIMAL(12,2))),2) As avg_item_price , s.seller_id from order_items oi inner join sellers s on oi.seller_id=s.seller_id group by 
s.seller_id order by total_sales desc;


-- Seller order fulfilment analysis

Select round(SUM(CAST(oi.price AS DECIMAL(12,2)) ), 2) as total_sales, COUNT(distinct(oi.order_id)) as total_orders , 
count(distinct case when o.order_status ='delivered' then oi.order_id end) as Total_order_delivered ,
count( distinct case when o.order_status = 'canceled' then oi.order_id  end) as Total_order_cancelled,
count( distinct case when o.order_status !='delivered' and o.order_status !='canceled' then oi.order_id end)  as Total_order_not_delivered,
round(100.0 * count(distinct case when o.order_status='delivered' then oi.order_id end)  / NULLIF(COUNT(distinct(oi.order_id)), 0), 2) as Delivered_order_perc, s.seller_id
 from orders o inner join order_items oi on o.order_id=oi.order_id inner join sellers s on oi.seller_id=s.seller_id group by seller_id order by total_sales desc ;

-- Seller delivery timeliness analysis

Select  count( distinct case when date_format(o.order_delivered_customer_date,'%Y-%m-%d') < date_format(o.order_estimated_delivery_date,'%Y-%m-%d') then oi.order_id end) As Early,
count( distinct case when date_format(o.order_delivered_customer_date,'%Y-%m-%d') > date_format(o.order_estimated_delivery_date,'%Y-%m-%d') then  oi.order_id end) as Late,
count( distinct case when date_format(o.order_delivered_customer_date,'%Y-%m-%d') = date_format(o.order_estimated_delivery_date,'%Y-%m-%d') then  oi.order_id end) as ON_time
, avg(case when date_format(o.order_delivered_customer_date,'%Y-%m-%d') > date_format(o.order_estimated_delivery_date,'%Y-%m-%d') 
Then datediff(o.order_delivered_customer_date,o.order_estimated_delivery_date) end ) As AVGLat, s.seller_id from orders o inner join order_items oi 
 on o.order_id=oi.order_id inner join sellers s on oi.seller_id=s.seller_id where o.order_status='delivered' and trim(o.order_delivered_customer_date) !='' 
 and o.order_delivered_customer_date is not null and trim(o.order_estimated_delivery_date) !='' 
 and o.order_estimated_delivery_date is not null group by s.seller_id;  







