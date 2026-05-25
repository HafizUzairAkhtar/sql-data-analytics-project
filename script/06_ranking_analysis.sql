-- =============================================================================
-- Script   : 06_ranking_analysis.sql
-- Author   : Uzair Akhtar
-- GitHub   : https://github.com/HafizUzairAkhtar
-- =============================================================================
-- Purpose:
--     This script ranks products and customers based on their performance.
--     Ranking analysis helps us quickly identify who the top performers are
--     and who is underperforming — which is critical for business decisions
--     like promotions, discontinuing products, or targeting key customers.
--
--     Two ranking approaches are demonstrated:
--     1. Simple ranking using TOP N  → quick and easy
--     2. Flexible ranking using window functions → more powerful and reusable
--
-- SQL Functions Used:
--     TOP N          → Returns only the first N rows after sorting
--     RANK()         → Assigns a rank with gaps (e.g., 1, 2, 2, 4)
--     DENSE_RANK()   → Assigns a rank without gaps (e.g., 1, 2, 2, 3)
--     ROW_NUMBER()   → Assigns a unique sequential number to each row
--     SUM()          → Totals sales amount per group
--     COUNT(DISTINCT)→ Counts unique orders per customer
--     GROUP BY       → Groups rows before aggregation
--     ORDER BY       → Controls sort direction for ranking
--
-- Tables Used:
--     gold.fact_sales    → Sales transactions (facts)
--     gold.dim_products  → Product details (dimension)
--     gold.dim_customers → Customer details (dimension)
--
-- Execution Order:
--     Run this script after: 05_magnitude_analysis.sql
--     Next step: 07_change_over_time_analysis.sql
-- =============================================================================


-- Step 1: Top 5 products by revenue — simple approach using TOP
--         TOP 5 is quick and readable but not flexible.
--         If you need to filter by rank later or change the cutoff dynamically,
--         you will need the window function approach in Step 2.
SELECT TOP 5
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC;


-- Step 2: Top 5 products by revenue — flexible approach using RANK()
--         RANK() assigns a rank to each product based on total revenue.
--         Wrapping it in a subquery lets us filter by rank number,
--         which is more powerful than TOP when building reports or views.
--         Note: RANK() leaves gaps when there are ties (e.g., 1, 2, 2, 4).
--         Use DENSE_RANK() if you want no gaps (e.g., 1, 2, 2, 3).
SELECT *
FROM (
    SELECT
        p.product_name,
        SUM(f.sales_amount)                          AS total_revenue,
        RANK() OVER (ORDER BY SUM(f.sales_amount) DESC) AS rank_products
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON p.product_key = f.product_key
    GROUP BY p.product_name
) AS ranked_products
WHERE rank_products <= 5;


-- Step 3: Bottom 5 products by revenue
--         Same query as Step 1 but sorted ascending — lowest revenue first.
--         These are candidates for review: low demand, pricing issues,
--         or products that may need to be discontinued.
SELECT TOP 5
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue ASC;


-- Step 4: Top 10 customers by revenue
--         Identifies the highest-value customers in the business.
--         These are the customers most worth retaining — a small group
--         often drives a large portion of total revenue.
SELECT TOP 10
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_revenue DESC;


-- Step 5: Bottom 3 customers by number of orders placed
--         These are the least engaged customers in terms of purchase frequency.
--         Useful for re-engagement campaigns or churn analysis.
SELECT TOP 3
    c.customer_key,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_orders ASC;


-- Step 6: Rank all products using DENSE_RANK() for a full leaderboard
--         Unlike Step 2 which filters to top 5, this returns all products ranked.
--         DENSE_RANK() is used here so tied products share the same rank
--         without leaving gaps in the ranking sequence.
SELECT
    p.product_name,
    SUM(f.sales_amount)                               AS total_revenue,
    DENSE_RANK() OVER (ORDER BY SUM(f.sales_amount) DESC) AS revenue_rank
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY revenue_rank;


-- =============================================================================
-- Analysis complete.
-- You now know the top and bottom performers across products and customers.
-- Next step: Run 07_change_over_time_analysis.sql
-- =============================================================================