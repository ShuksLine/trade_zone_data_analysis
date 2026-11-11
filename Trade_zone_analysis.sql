-- TRADEZONE DATA CLEANING
-- 7 TABLES AVAILABLE IN DATA
-- EXPLORATORY DATA ANALYSIS

SELECT * FROM trade_zone.customers;
SELECT * FROM trade_zone.reviews;
SELECT * FROM trade_zone.payments;
SELECT * FROM trade_zone.orders;
SELECT * FROM trade_zone.order_items;
SELECT * FROM trade_zone.products;
SELECT * FROM trade_zone.sellers;

SHOW DATABASES;
 
-- REMOVING DUPLICATES FROM TABLES

SELECT *,
ROW_NUMBER() OVER(PARTITION BY customer_id, first_name) AS row_num
FROM trade_zone.customers;

SELECT *
FROM reviews;

WITH Dupli AS 
(
	SELECT *,
    row_number() OVER(PARTITION BY review_id, product_id, customer_id, order_id) 
    AS row_numb
    FROM trade_zone.reviews
)
SELECT *
FROM Dupli
WHERE row_numb > 1;

SELECT city, seller_name
FROM sellers
ORDER BY city, seller_name asc
;

SELECT * FROM sellers
WHERE account_status = 'suspended'; 

			-- Standardizing data for spell correction
SELECT *
FROM trade_zone.customers;

SELECT DISTINCT city, TRIM(city)
FROM trade_zone.customers;

UPDATE trade_zone.customers
SET city = TRIM(city);

SELECT DISTINCT city
FROM trade_zone.customers;

		-- Trade Analysis: Customer Acquisition
SELECT state, COUNT(state) AS total_customer
FROM trade_zone.customers
GROUP BY state
ORDER BY 2 DESC
;

SELECT customer_id, total_amount
FROM trade_zone.orders
WHERE order_status = "Delivered" or order_status = "Shipped"
;

SELECT DISTINCT order_status
FROM trade_zone.orders
;

		-- Product Performance
SELECT MAX(amount)
FROM trade_zone.payments;

SELECT *
FROM trade_zone.payments
WHERE amount > 10000
ORDER BY amount DESC
;

SELECT product_name, category, SUM(unit_price) AS total_revenue
FROM trade_zone.products
WHERE unit_price > 100000
GROUP BY product_name, category
ORDER BY total_revenue DESC 
;

        -- total revenue
SELECT SUM(amount) AS Revenue
FROM trade_zone.payments;

		-- seller fulfilment efficiency
SELECT seller_id, order_status, delivery_date
FROM trade_zone.orders
WHERE order_date -  delivery_date
;
	
		-- Customer Spend Segmentation
SELECT customer_id AS high_spenders, COUNT(customer_id) AS total_no_of_order, avg(total_amount) as avg_spend_per_customer, 
SUM(total_amount) as total_revenue_contribution
FROM orders
WHERE total_amount >= 100000
GROUP BY customer_id
;

SELECT customer_id AS medium_spenders, COUNT(customer_id) AS total_no_of_order, avg(total_amount) as avg_spend_per_customer, 
SUM(total_amount) as total_revenue_contribution
FROM orders
WHERE total_amount = 50000 or total_amount < 99999
GROUP BY customer_id
;
		
SELECT customer_id AS low_spenders, COUNT(customer_id) AS total_no_of_order, avg(total_amount) as avg_spend_per_customer, 
SUM(total_amount) as total_revenue_contribution
FROM orders
WHERE total_amount < 50000
GROUP BY customer_id
;

		-- payment method preferences
SELECT payment_method, SUM(amount) AS total_amount, COUNT(payment_method) AS number_of_transactions
FROM trade_zone.payments
GROUP BY payment_method
;

SELECT DISTINCT state; -- merge another column with another column

		-- review ratings
SELECT product_id, rating AS high_rated
FROM trade_zone.reviews
WHERE rating >= 4
;

SELECT product_id, rating AS mid_rated
FROM trade_zone.reviews
WHERE rating = 3 or rating < 3.99
;

SELECT product_id, rating AS low_rated
FROM trade_zone.reviews
WHERE rating < 3
;

		-- sales performance
SELECT category, COUNT(product_name) as total_product, SUM(unit_price) as total_revenue, avg(unit_price) as price
FROM trade_zone.products
GROUP BY category
ORDER BY total_product DESC
;

		-- Top seller bonus qualification
SELECT seller_id, order_status, COUNT(order_status) as completed_orders, sum(total_amount) AS total_revenue
FROM trade_zone.orders
WHERE order_status = "Delivered" or order_status = "Shipped" and order_status >= 10 
GROUP BY seller_id, order_status
ORDER BY total_revenue DESC
;

SELECT *
FROM trade_zone.orders
JOIN order_items
