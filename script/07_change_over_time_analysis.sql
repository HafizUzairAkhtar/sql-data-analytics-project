-- =============================================================================
-- Script   : 07_change_over_time_analysis.sql
-- Author   : Uzair Akhtar
-- GitHub   : https://github.com/HafizUzairAkhtar
-- =============================================================================
-- Purpose:
--     This script analyzes how key sales metrics change over time.
--     Time-based analysis helps us identify trends, spot seasonal patterns,
--     and measure whether the business is growing or declining period by period.
--
--     Three different date grouping approaches are demonstrated so you can
--     choose the one that fits your reporting needs best.
--
-- SQL Functions Used:
--     YEAR()         → Extracts the year part from a date
--     MONTH()        → Extracts the month number from a date
--     DATETRUNC()    → Truncates a date to the start of a given period (e.g., month)
--     FORMAT()       → Formats a date as a readable string (e.g., '2022-Jan')
--     SUM()          → Totals sales and quantity per time period
--     COUNT(DISTINCT)→ Counts unique customers active in each period
--     WHERE          → Filters out NULL order dates to avoid bad data
--
-- Tables Used:
--     gold.fact_sales → Sales transactions with order dates
--
-- Execution Order:
--     Run this script after: 06_ranking_analysis.sql
--     Next step: 08_cumulative_analysis.sql
-- =============================================================================


-- Step 1: Monthly sales trend using YEAR() and MONTH()
--         This is the simplest approach — extract year and month separately.
--         The result has two date columns (year and month) which makes it
--         easy to filter by a specific year or month independently.
--         Always filter out NULL order dates to keep the results clean.
SELECT
    YEAR(order_date)              AS order_year,
    MONTH(order_date)             AS order_month,
    SUM(sales_amount)             AS total_sales,
    COUNT(DISTINCT customer_key)  AS total_customers,
    SUM(quantity)                 AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date);


-- Step 2: Monthly sales trend using DATETRUNC()
--         DATETRUNC(month, order_date) rounds every date down to the 1st of
--         its month (e.g., 2022-03-15 becomes 2022-03-01).
--         This keeps the result as a proper DATE column, which is better
--         for connecting to BI tools like Power BI that expect date types.
SELECT
    DATETRUNC(month, order_date)  AS order_month_start,
    SUM(sales_amount)             AS total_sales,
    COUNT(DISTINCT customer_key)  AS total_customers,
    SUM(quantity)                 AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
ORDER BY DATETRUNC(month, order_date);


-- Step 3: Monthly sales trend using FORMAT()
--         FORMAT() converts the date into a readable string like '2022-Jan'.
--         This is the most human-friendly format for reports and presentations.
--         Downside: the result is a string, not a date, so it cannot be used
--         directly in date calculations or BI tools that need date columns.
SELECT
    FORMAT(order_date, 'yyyy-MMM') AS order_month_label,
    SUM(sales_amount)              AS total_sales,
    COUNT(DISTINCT customer_key)   AS total_customers,
    SUM(quantity)                  AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date, 'yyyy-MMM')
ORDER BY FORMAT(order_date, 'yyyy-MMM');


-- Step 4: Yearly sales trend
--         Sometimes a monthly view has too much noise and a yearly rollup
--         is clearer for spotting long-term growth or decline.
--         Use this when presenting to stakeholders who want a big-picture view.
SELECT
    YEAR(order_date)              AS order_year,
    SUM(sales_amount)             AS total_sales,
    COUNT(DISTINCT customer_key)  AS total_customers,
    SUM(quantity)                 AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date);


-- =============================================================================
-- Analysis complete.
-- You now have monthly and yearly views of sales trends using three approaches.
-- Use DATETRUNC() when connecting to BI tools, FORMAT() for readable reports,
-- and YEAR()/MONTH() when you need to filter by year or month independently.
-- Next step: Run 08_cumulative_analysis.sql
-- =============================================================================