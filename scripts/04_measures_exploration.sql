-- =============================================================================
-- Script   : 04_measures_exploration.sql
-- Author   : Uzair Akhtar
-- GitHub   : https://github.com/HafizUzairAkhtar
-- =============================================================================
-- Purpose:
--     This script calculates the core business metrics (measures) of the dataset.
--     Measures are the numeric facts we want to analyze things like total sales,
--     number of orders, and average price.
--
--     Exploring measures early gives us a high-level picture of the business
--     size and helps us spot anything unusual before going deeper.
--
-- SQL Functions Used:
--     SUM()           → Adds up all values in a column
--     COUNT()         → Counts rows or non-null values
--     COUNT(DISTINCT) → Counts only unique values
--     AVG()           → Calculates the average value
--
-- Tables Used:
--     gold.fact_sales    → Source of all sales transactions
--     gold.dim_products  → Source of product records
--     gold.dim_customers → Source of customer records
--
-- Execution Order:
--     Run this script after: 03_date_range_exploration.sql
--     Next step: 05_magnitude_analysis.sql
-- =============================================================================


-- Step 1: Find the total revenue generated
--         SUM(sales_amount) gives us the overall business revenue.
--         This is the single most important top-level metric.
SELECT
    SUM(sales_amount) AS total_sales
FROM gold.fact_sales;


-- Step 2: Find the total number of items sold
--         This counts quantity, not orders one order can have multiple items.
SELECT
    SUM(quantity) AS total_quantity
FROM gold.fact_sales;


-- Step 3: Find the average selling price
--         AVG(price) gives us the typical price per unit across all transactions.
SELECT
    AVG(price) AS avg_price
FROM gold.fact_sales;


-- Step 4: Find the total number of orders
--         COUNT(order_number) counts every row, including duplicates per order.
--         COUNT(DISTINCT order_number) counts each unique order only once.
--         Always use DISTINCT when counting orders to avoid inflated numbers.
SELECT
    COUNT(order_number)          AS total_order_lines,
    COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales;


-- Step 5: Find the total number of products in the catalog
--         This counts all products listed in the products dimension table.
SELECT
    COUNT(DISTINCT product_name) AS total_products
FROM gold.dim_products;


-- Step 6: Find the total number of customers in the database
--         COUNT(customer_key) counts all customer records in the dimension table.
SELECT
    COUNT(customer_key) AS total_customers
FROM gold.dim_customers;


-- Step 7: Find how many customers have actually placed at least one order
--         This is different from Step 6 not every customer in dim_customers
--         may have made a purchase. Comparing these two numbers reveals
--         how many registered customers are inactive.
SELECT
    COUNT(DISTINCT customer_key) AS customers_with_orders
FROM gold.fact_sales;


-- Step 8: Generate a single summary report of all key business metrics
--         Using UNION ALL to stack all metrics into one clean result set.
--         This is useful for a quick executive-level snapshot of the business.
SELECT 'Total Sales'       AS measure_name, SUM(sales_amount)          AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity',                    SUM(quantity)               FROM gold.fact_sales
UNION ALL
SELECT 'Average Price',                     AVG(price)                  FROM gold.fact_sales
UNION ALL
SELECT 'Total Orders',                      COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total Products',                    COUNT(DISTINCT product_name) FROM gold.dim_products
UNION ALL
SELECT 'Total Customers',                   COUNT(customer_key)          FROM gold.dim_customers
UNION ALL
SELECT 'Customers With Orders',             COUNT(DISTINCT customer_key) FROM gold.fact_sales;


-- =============================================================================
-- Exploration complete.
-- You now have a clear picture of the key business metrics at a high level.
-- Next step: Run 05_magnitude_analysis.sql
-- =============================================================================
