
-- =====================================================
-- Project: E-commerce Operations & Customer Insights
-- Database: MySQL
-- Purpose: Initialize the project database
-- =====================================================

CREATE DATABASE IF NOT EXISTS ecommerce_operations;

USE ecommerce_operations;

-- Verify the selected database
SELECT DATABASE();


-- Table: customers
CREATE TABLE IF NOT EXISTS customers (
    customer_id TEXT,
    customer_unique_id TEXT,
    customer_zip_code_prefix TEXT,
    customer_city TEXT,
    customer_state TEXT
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci;


-- Table: products

CREATE TABLE `products` (
   `product_id` text,
   `product_category_name` text,
   `product_name_lenght` text,
   `product_description_lenght` text,
   `product_photos_qty` text,
   `product_weight_g` text,
   `product_length_cm` text,
   `product_height_cm` text,
   `product_width_cm` text
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Table: sellers

CREATE TABLE `sellers` (
   `seller_id` text,
   `seller_zip_code_prefix` text,
   `seller_city` text,
   `seller_state` text
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci


-- Table: orders
CREATE TABLE `orders` (
   `order_id` varchar(32) DEFAULT NULL,
   `customer_id` varchar(32) DEFAULT NULL,
   `order_status` varchar(30) DEFAULT NULL,
   `order_purchase_timestamp` text,
   `order_approved_at` text,
   `order_delivered_carrier_date` text,
   `order_delivered_customer_date` text,
   `order_estimated_delivery_date` text
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Table: order_items
CREATE TABLE `order_items` (
   `order_id` text,
   `order_item_id` text,
   `product_id` text,
   `seller_id` text,
   `shipping_limit_date` text,
   `price` text,
   `freight_value` text
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


