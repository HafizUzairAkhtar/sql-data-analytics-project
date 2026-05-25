-- =============================================================================
-- Script   : 11_part_to_whole_analysis.sql
-- Author   : Uzair Akhtar
-- GitHub   : https://github.com/HafizUzairAkhtar
-- =============================================================================
-- Purpose:
--     This script calculates what percentage each dimension contributes
--     to the overall total — answering the question:
--     "What share of the whole does each part represent?"
--
--     Part-to-whole analysis is essential for understanding where revenue
--     is really coming from. For example, one category might look big in
--     isolation but represent only 5% of total revenue once you see the
--     full picture.
--
-- SQL Functions Used:
--     CTE (WITH)          → Pre-aggregates sales per category before calculating shares
--     SUM() OVER ()       → Calculates the grand total across ALL rows (no partition)
--     CAST( AS FLOAT)     → Converts integer to decimal for accurate division
--     ROUND()             → Rounds the percentage to 2 decimal places
--     LEFT JOIN           → Joins sales facts with product dimension
--
-- Tables Used:
--     gold.fact_sales    → Sales transactions
--     gold.dim_products  → Product category details
--
-- Execution Order:
--     Run this script after: 10_data_segmentation.sql
--     Next step: 12_report_customers.sql
-- =============================================================================


-- Step 1: Aggregate total sales per product category
--         The CTE calculates total revenue for each category first.
--         Separating this step keeps the percentage logic in Step 2 clean.
WITH category_sales AS (
    SELECT
        p.category,
        SUM(f.sales_amount) AS total_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON p.product_key = f.product_key
    GROUP BY p.category
)

-- Step 2: Calculate each category's share of total revenue
--
--         SUM(total_sales) OVER ():
--             → No PARTITION BY and no ORDER BY inside OVER().
--               This means the window covers ALL rows at once,
--               giving us the grand total of all categories combined.
--
--         CAST(total_sales AS FLOAT) / SUM(total_sales) OVER ():
--             → We cast to FLOAT before dividing because both columns
--               are integers. Integer division in SQL truncates decimals,
--               so 3 / 5 = 0 instead of 0.6. FLOAT prevents this.
--
--         ROUND(..., 2):
--             → Rounds to 2 decimal places so the percentage reads cleanly,
--               e.g., 96.25 instead of 96.24789123...
SELECT
    category,
    total_sales,
    SUM(total_sales) OVER ()                                               AS overall_sales,
    ROUND((CAST(total_sales AS FLOAT) / SUM(total_sales) OVER ()) * 100, 2) AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC;


-- Step 3: Category contribution by number of orders (not just revenue)
--         Revenue share alone can be misleading — a category with high revenue
--         but few orders may rely on a small number of expensive transactions.
--         Comparing order share vs revenue share reveals this imbalance.
WITH category_orders AS (
    SELECT
        p.category,
        COUNT(DISTINCT f.order_number) AS total_orders
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON p.product_key = f.product_key
    GROUP BY p.category
)
SELECT
    category,
    total_orders,
    SUM(total_orders) OVER ()                                                AS overall_orders,
    ROUND((CAST(total_orders AS FLOAT) / SUM(total_orders) OVER ()) * 100, 2) AS percentage_of_total
FROM category_orders
ORDER BY total_orders DESC;


-- =============================================================================
-- Analysis complete.
-- Each category now has its revenue share and order share of the total business.
-- Compare percentage_of_total across both queries to spot categories that punch
-- above or below their weight in terms of revenue vs order volume.
-- Next step: Run 12_report_customers.sql
-- =============================================================================