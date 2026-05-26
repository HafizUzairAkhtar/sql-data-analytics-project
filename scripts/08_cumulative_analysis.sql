-- =============================================================================
-- Script   : 08_cumulative_analysis.sql
-- Author   : Uzair Akhtar
-- GitHub   : https://github.com/HafizUzairAkhtar
-- =============================================================================
-- Purpose:
--     This script calculates running totals and moving averages to track
--     how key metrics accumulate and evolve over time.
--
--     Cumulative analysis is different from period-by-period analysis.
--     Instead of asking "how much did we sell this year?", it asks
--     "how much have we sold in total up to this point in time?"
--     This is essential for growth tracking and long-term trend analysis.
--
-- SQL Functions Used:
--     SUM() OVER (ORDER BY ...)  → Calculates a running total across rows
--     AVG() OVER (ORDER BY ...)  → Calculates a moving average across rows
--     DATETRUNC()                → Groups dates to the start of a year or month
--     Subquery                   → Pre-aggregates data before applying window functions
--
-- Tables Used:
--     gold.fact_sales → Sales transactions with order dates, amounts, and prices
--
-- Execution Order:
--     Run this script after: 07_change_over_time_analysis.sql
--     Next step: 09_performance_analysis.sql
-- =============================================================================


-- Step 1: Running total of sales and moving average price — by year
--         The inner subquery first aggregates sales and average price per year.
--         The outer query then applies window functions on top of that result.
--
--         SUM(total_sales) OVER (ORDER BY order_date):
--             → Adds each year's sales to all previous years' totals.
--               The result keeps growing — that is the running total.
--
--         AVG(avg_price) OVER (ORDER BY order_date):
--             → Averages the price across all years up to the current row.
--               This smooths out price fluctuations to show the overall trend.
SELECT
    order_date,
    total_sales,
    SUM(total_sales) OVER (ORDER BY order_date)  AS running_total_sales,
    AVG(avg_price)   OVER (ORDER BY order_date)  AS moving_average_price
FROM (
    SELECT
        DATETRUNC(year, order_date)  AS order_date,
        SUM(sales_amount)            AS total_sales,
        AVG(price)                   AS avg_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(year, order_date)
) AS yearly_sales;


-- Step 2: Running total of sales and moving average price — by month
--         Same logic as Step 1 but at monthly granularity.
--         Monthly cumulative totals are more useful when the data spans
--         only a few years, as yearly steps may be too few to see a trend.
SELECT
    order_date,
    total_sales,
    SUM(total_sales) OVER (ORDER BY order_date)  AS running_total_sales,
    AVG(avg_price)   OVER (ORDER BY order_date)  AS moving_average_price
FROM (
    SELECT
        DATETRUNC(month, order_date)  AS order_date,
        SUM(sales_amount)             AS total_sales,
        AVG(price)                    AS avg_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(month, order_date)
) AS monthly_sales;


-- Step 3: Running total of quantity sold — by year
--         Tracks the cumulative number of items sold over time.
--         Useful for inventory and supply chain planning — knowing the
--         total units moved helps estimate future demand patterns.
SELECT
    order_date,
    total_quantity,
    SUM(total_quantity) OVER (ORDER BY order_date) AS running_total_quantity
FROM (
    SELECT
        DATETRUNC(year, order_date)  AS order_date,
        SUM(quantity)                AS total_quantity
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(year, order_date)
) AS yearly_quantity;


-- =============================================================================
-- Analysis complete.
-- Running totals show how sales and quantity accumulate over time.
-- Moving averages smooth out fluctuations to reveal the underlying price trend.
-- Use yearly view for long-term growth, monthly view for finer detail.
-- Next step: Run 09_performance_analysis.sql
-- =============================================================================