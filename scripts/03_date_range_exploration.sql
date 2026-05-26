-- =============================================================================
-- Script   : 03_date_range_exploration.sql
-- Author   : Uzair Akhtar
-- GitHub   : https://github.com/HafizUzairAkhtar
-- =============================================================================
-- Purpose:
--     This script explores the date boundaries of our data.
--     Before doing any time-based analysis, we need to know the
--     full time range we are working with — how far back the data
--     goes and how recent it is.
--
--     It also checks the age range of customers, which is useful
--     for demographic segmentation later in the project.
--
-- SQL Functions Used:
--     MIN()      → Returns the earliest (smallest) value
--     MAX()      → Returns the latest (largest) value
--     DATEDIFF() → Calculates the difference between two dates
--     GETDATE()  → Returns today's current date and time
--
-- Tables Used:
--     gold.fact_sales     → To check the sales date range
--     gold.dim_customers  → To check the customer age range
--
-- Execution Order:
--     Run this script after: 02_dimensions_exploration.sql
--     Next step: 04_measures_exploration.sql
-- =============================================================================


-- Step 1: Find the full date range of sales data
--         This tells us when the first order was placed and when the last one was.
--         The total duration in months gives us a sense of how much history we have
--         to work with for trend and time-series analysis.
SELECT
    MIN(order_date)                                    AS first_order_date,
    MAX(order_date)                                    AS last_order_date,
    DATEDIFF(MONTH, MIN(order_date), MAX(order_date))  AS order_range_months
FROM gold.fact_sales;


-- Step 2: Find the shipping date range
--         Comparing the shipping date range with the order date range helps us
--         spot any data gaps or delays in fulfillment records.
SELECT
    MIN(shipping_date)                                         AS first_shipping_date,
    MAX(shipping_date)                                         AS last_shipping_date,
    DATEDIFF(MONTH, MIN(shipping_date), MAX(shipping_date))    AS shipping_range_months
FROM gold.fact_sales;


-- Step 3: Find the age range of customers
--         MIN(birthdate) = oldest customer (born earliest)
--         MAX(birthdate) = youngest customer (born most recently)
--         This is useful for age-group segmentation in later analysis.
SELECT
    MIN(birthdate)                             AS oldest_birthdate,
    DATEDIFF(YEAR, MIN(birthdate), GETDATE())  AS oldest_age,
    MAX(birthdate)                             AS youngest_birthdate,
    DATEDIFF(YEAR, MAX(birthdate), GETDATE())  AS youngest_age
FROM gold.dim_customers;


-- Step 4: Find the date range of when customers were created
--         This tells us how long the business has been acquiring customers
--         and whether customer acquisition is recent or spread over many years.
SELECT
    MIN(create_date)                                       AS first_customer_created,
    MAX(create_date)                                       AS last_customer_created,
    DATEDIFF(MONTH, MIN(create_date), MAX(create_date))    AS customer_creation_range_months
FROM gold.dim_customers;


-- =============================================================================
-- Exploration complete.
-- You now know the full time boundaries of sales data and customer demographics.
-- Next step: Run 04_measures_exploration.sql
-- =============================================================================