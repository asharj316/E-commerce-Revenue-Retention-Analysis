DROP TABLE IF EXISTS ecommerce_orders;
CREATE TABLE ecommerce_orders (
    item_id TEXT,
    status TEXT,
    created_at DATE,
    sku TEXT,
    price NUMERIC,
    qty_ordered INT,
    grand_total NUMERIC,
    increment_id TEXT,
    category_name_1 TEXT,
    sales_commission_code TEXT,
    discount_amount NUMERIC,
    payment_method TEXT,
    Working_Date TEXT,
    BI_Status TEXT,
    MV TEXT,
    Year INT,
    Month INT,
    Customer_Since TEXT,
    "M-Y" TEXT,
    FY TEXT,
    Customer_ID TEXT,
    -- These are the 5 "ghost" columns causing your error
    unnamed_21 TEXT,
    unnamed_22 TEXT,
    unnamed_23 TEXT,
    unnamed_24 TEXT,
    unnamed_25 TEXT
);

COPY ecommerce_orders
FROM 'D:\Work\SQL PROJECT ECOMMERCE DS\Pakistan Largest Ecommerce Dataset.csv'
DELIMITER ','
CSV HEADER;

ALTER TABLE ecommerce_orders 
DROP COLUMN unnamed_21, 
DROP COLUMN unnamed_22, 
DROP COLUMN unnamed_23, 
DROP COLUMN unnamed_24, 
DROP COLUMN unnamed_25;

SELECT * FROM ecommerce_orders
DELETE FROM ecommerce_orders WHERE item_id IS NULL;

/* ================================================================
   STRATEGIC BUSINESS QUESTIONS: E-COMMERCE DATA ANALYSIS
   Dataset: Pakistan Largest Ecommerce Dataset
   ================================================================
*/

-- 01. TOTAL REVENUE: Calculate the gross financial intake across the entire dataset.
SELECT CAST (SUM (grand_total) AS FLOAT) AS Total_revenue
FROM ecommerce_orders
WHERE status = 'complete';
-- 02. TOTAL ORDERS: Determine the total volume of transactions processed.
SELECT status , SUM (qty_ordered) AS Total_orders
FROM ecommerce_orders
GROUP BY status;
-- 03. TOP REVENUE CATEGORIES: Identify which product segments are the primary financial drivers.
SELECT category_name , CAST (MAX (grand_total) AS FLOAT) AS Top_selling_products
FROM ecommerce_orders
WHERE status = 'complete'
GROUP BY category_name
LIMIT 5;
-- 04. PAYMENT PREFERENCES: Analyze the most frequently used payment methods by the customer base.
SELECT payment_method , CAST (MAX (grand_total) AS FLOAT) AS Top_used_pm
FROM ecommerce_orders
WHERE status = 'complete'
GROUP BY payment_method
LIMIT 3; 
-- 05. MONTHLY SALES TRENDS: Track revenue fluctuations over time to identify seasonal patterns.
SELECT month , CAST (SUM (grand_total) AS FLOAT) AS Monthly_revenue
FROM ecommerce_orders
WHERE status = 'complete'
GROUP BY month; 
-- 06. TOP 10 VALUABLE CUSTOMERS: List the highest-spending individuals for targeted loyalty marketing.
SELECT customer_id , CAST (SUM (grand_total) AS FLOAT) AS Valuable_customers
FROM ecommerce_orders
WHERE status = 'complete'
GROUP BY customer_id
LIMIT 3; 
-- 07. AVERAGE ORDER VALUE (AOV): Measure the mean spending per transaction to gauge customer behavior.
SELECT SUM(grand_total) / SUM(qty_ordered) AS AOV
FROM ecommerce_orders
WHERE status = 'complete';
-- 08. PRODUCT POPULARITY: Identify the top 10 SKUs based on total units sold.
SELECT sku ,  SUM (qty_ordered) AS Top_SKUS
FROM ecommerce_orders
WHERE status = 'complete'
GROUP BY sku
ORDER BY Top_SKUS DESC
LIMIT 10;

-- 09. ORDER STATUS LOGISTICS: Examine the ratio of completed vs. canceled and returned orders.
SELECT 
    status,
    COUNT(*) AS total_orders,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM ecommerce_orders
WHERE status IN ('complete', 'canceled', 'order_refunded')
GROUP BY status;

-- 10. REVENUE BY PAYMENT CHANNEL: Compare the total monetary value processed through each payment gateway.
SELECT payment_method , SUM (grand_total) AS Revenue_by_payment
FROM ecommerce_orders
GROUP BY payment_method
ORDER BY Revenue_by_payment DESC;

-- 11. DAILY PERFORMANCE: Monitor day-to-day revenue to spot specific high-performing dates.
ALTER TABLE ecommerce_orders
ALTER COLUMN created_at TYPE DATE
USING TO_DATE(created_at, 'MM/DD/YYYY');
---
SELECT 
    EXTRACT(DAY FROM created_at) AS order_day,
    SUM(grand_total) AS Daily_report
FROM ecommerce_orders
WHERE status = 'complete'
GROUP BY order_day
ORDER BY Daily_report DESC;

-- 12. HIGH-VALUE TRANSACTION VOLUME: Count how many individual orders exceed the store's average spend.
SELECT customer_id
FROM ecommerce_orders
GROUP BY customer_id
HAVING SUM (grand_total) > (SELECT AVG (grand_total) FROM ecommerce_orders)

-- 13. CUSTOMER RETENTION: Identify "Power Users" who have placed more than a single order.
SELECT customer_id , COUNT (qty_ordered) AS Total_orders_per_customers
FROM ecommerce_orders
GROUP BY customer_id
HAVING COUNT (qty_ordered) > 1
ORDER BY Total_orders_per_customers DESC

-- 14. INVENTORY VELOCITY: Rank categories based on the total quantity of items moved.
SELECT category_name_1 , SUM (qty_ordered) AS Total_qauntity_moved,
RANK() OVER (ORDER BY SUM (qty_ordered) DESC ) AS velocity_rank
FROM ecommerce_orders
GROUP BY category_name_1;

-- 15. REVENUE SHARE ANALYSIS: Calculate the percentage contribution of each category to the total company revenue.
SELECT 
    category_name_1,
    CONCAT(
        ROUND(
            (SUM(grand_total) * 100.0 / SUM(SUM(grand_total)) OVER ()), 
            2
        ),
        '%'
    ) AS formatted_revenue_share
FROM ecommerce_orders
GROUP BY 1
ORDER BY 1;