-- =============================================================================
-- Script   : 09_performance_analysis.sql
-- Author   : Uzair Akhtar
-- GitHub   : https://github.com/HafizUzairAkhtar
-- =============================================================================
-- Purpose:
--     This script measures how products perform year over year by comparing
--     each year's sales against two benchmarks:
--
--     1. The product's own historical average
--        → "Is this year better or worse than this product normally performs?"
--
--     2. The previous year's sales (Year-over-Year comparison)
--        → "Is this year better or worse than last year specifically?"
--
--     This dual comparison gives a much richer picture of performance than
--     looking at raw sales numbers alone.
--
-- SQL Functions Used:
--     CTE (WITH)                          → Pre-aggregates yearly sales per product
--     AVG() OVER (PARTITION BY)           → Computes each product's average across all years
--     LAG() OVER (PARTITION BY ORDER BY)  → Looks back one row to get previous year's sales
--     CASE                                → Labels performance as Above/Below Avg or Increase/Decrease
--     LEFT JOIN                           → Joins sales facts with product dimension
--
-- Tables Used:
--     gold.fact_sales    → Sales transactions
--     gold.dim_products  → Product details
--
-- Execution Order:
--     Run this script after: 08_cumulative_analysis.sql
--     Next step: 10_data_segmentation.sql
-- =============================================================================


-- Step 1: Build a CTE with yearly sales per product
--         We first aggregate total sales per product per year.
--         This becomes the base for all window function calculations below.
--         Using a CTE keeps the main query clean and readable.
WITH yearly_product_sales AS (
    SELECT
        YEAR(f.order_date)   AS order_year,
        p.product_name,
        SUM(f.sales_amount)  AS current_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
    GROUP BY
        YEAR(f.order_date),
        p.product_name
)

-- Step 2: Compare each year's sales against the product average and previous year
--
--         AVG() OVER (PARTITION BY product_name):
--             → Calculates the average sales for that product across ALL years.
--               PARTITION BY ensures each product gets its own average,
--               not a global average across all products.
--
--         diff_avg:
--             → Positive means this year beat the product's historical average.
--               Negative means this year underperformed the historical average.
--
--         avg_change:
--             → Labels each row as 'Above Avg', 'Below Avg', or 'Avg'
--               based on diff_avg. Easier to read than raw numbers.
--
--         LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year):
--             → Pulls the previous year's sales for the same product.
--               PARTITION BY keeps each product's history separate.
--               ORDER BY order_year ensures we always look back exactly one year.
--               Returns NULL for the first year (no previous year exists).
--
--         diff_py:
--             → Difference between this year and last year for the same product.
--               Positive = growth, Negative = decline.
--
--         py_change:
--             → Labels each row as 'Increase', 'Decrease', or 'No Change'
--               based on diff_py.
SELECT
    order_year,
    product_name,
    current_sales,

    -- Benchmark 1: Compare to the product's own historical average
    AVG(current_sales) OVER (PARTITION BY product_name)                                            AS avg_sales,
    current_sales - AVG(current_sales) OVER (PARTITION BY product_name)                            AS diff_avg,
    CASE
        WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg'
        WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg'
        ELSE 'Avg'
    END AS avg_change,

    -- Benchmark 2: Compare to the previous year's sales (Year-over-Year)
    LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year)                        AS py_sales,
    current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year)        AS diff_py,
    CASE
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
        ELSE 'No Change'
    END AS py_change

FROM yearly_product_sales
ORDER BY product_name, order_year;


-- =============================================================================
-- Analysis complete.
-- Each product now has a dual performance label for every year:
--   avg_change → how this year compares to the product's own historical average
--   py_change  → how this year compares to the previous year specifically
-- Next step: Run 10_data_segmentation.sql
-- =============================================================================
