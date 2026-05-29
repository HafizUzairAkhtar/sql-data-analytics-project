-- =============================================================================
-- Script   : 10_data_segmentation.sql
-- Author   : Uzair Akhtar
-- GitHub   : https://github.com/HafizUzairAkhtar
-- =============================================================================
-- Purpose:
--     This script segments products and customers into meaningful groups
--     based on their characteristics and behavior.
--
--     Segmentation is one of the most valuable analytical techniques because
--     it lets the business treat different groups differently for example,
--     rewarding VIP customers or reviewing low-cost product pricing.
--
--     Two segmentations are built in this script:
--
--     1. Product Segmentation by Cost Range
--        → Groups products into price tiers to understand catalog distribution.
--
--     2. Customer Segmentation by Spending and Loyalty
--        → Groups customers into VIP, Regular, and New based on how long
--          they have been buying and how much they have spent in total.
--
-- SQL Functions Used:
--     CASE          → Defines the segmentation rules (the "if this then that" logic)
--     CTE (WITH)    → Builds the segmentation logic before aggregating
--     SUM()         → Totals spending per customer
--     MIN() / MAX() → Finds the first and last order date per customer
--     DATEDIFF()    → Calculates how many months a customer has been active
--     COUNT()       → Counts how many records fall into each segment
--     GROUP BY      → Groups results by segment label
--
-- Tables Used:
--     gold.dim_products  → Product cost data for product segmentation
--     gold.fact_sales    → Sales transactions for customer spending
--     gold.dim_customers → Customer keys for joining
--
-- Execution Order:
--     Run this script after: 09_performance_analysis.sql
--     Next step: 11_part_to_whole_analysis.sql
-- =============================================================================


-- =============================================================================
-- Part 1: Product Segmentation by Cost Range
-- =============================================================================

-- Step 1: Assign each product to a cost range segment
--         The CASE statement defines four tiers based on the product cost.
--         This is done inside a CTE so the segmentation logic stays separate
--         from the counting logic, making it easier to read and modify.
--
--         Cost Tiers:
--             Below 100   → Low-cost / entry-level products
--             100 - 500   → Mid-range products
--             500 - 1000  → Premium products
--             Above 1000  → High-end / luxury products
WITH product_segments AS (
    SELECT
        product_key,
        product_name,
        cost,
        CASE
            WHEN cost < 100                  THEN 'Below 100'
            WHEN cost BETWEEN 100 AND 500    THEN '100-500'
            WHEN cost BETWEEN 500 AND 1000   THEN '500-1000'
            ELSE                                  'Above 1000'
        END AS cost_range
    FROM gold.dim_products
)

-- Step 2: Count how many products fall into each cost range
--         Sorted by total_products DESC so the most populated segment appears first.
SELECT
    cost_range,
    COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC;


-- =============================================================================
-- Part 2: Customer Segmentation by Spending and Loyalty
-- =============================================================================

-- Step 3: Calculate total spending and lifespan per customer
--         lifespan = number of months between first and last order.
--         A customer with lifespan = 0 placed only one order (same month).
--         This CTE is the foundation for the segmentation rules in Step 4.
WITH customer_spending AS (
    SELECT
        c.customer_key,
        SUM(f.sales_amount)                              AS total_spending,
        MIN(f.order_date)                                AS first_order,
        MAX(f.order_date)                                AS last_order,
        DATEDIFF(month, MIN(f.order_date), MAX(f.order_date)) AS lifespan
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c
        ON f.customer_key = c.customer_key
    GROUP BY c.customer_key
)

-- Step 4: Assign each customer to a segment, then count customers per segment
--
--         Segmentation Rules:
--             VIP      → At least 12 months active AND spent more than 5,000
--                        These are the most valuable long-term customers.
--             Regular  → At least 12 months active BUT spent 5,000 or less
--                        Loyal but lower-value candidates for upselling.
--             New      → Active for less than 12 months
--                        Recently acquired too early to judge their value.
--
--         The inner SELECT applies the CASE logic per customer.
--         The outer SELECT counts customers in each resulting segment.
SELECT
    customer_segment,
    COUNT(customer_key) AS total_customers
FROM (
    SELECT
        customer_key,
        CASE
            WHEN lifespan >= 12 AND total_spending > 5000  THEN 'VIP'
            WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
            ELSE                                                'New'
        END AS customer_segment
    FROM customer_spending
) AS segmented_customers
GROUP BY customer_segment
ORDER BY total_customers DESC;


-- =============================================================================
-- Analysis complete.
-- Products are grouped into 4 cost tiers.
-- Customers are grouped into 3 loyalty and spending segments:
--   VIP → high spend, long history
--   Regular → long history, lower spend
--   New → less than 12 months active
-- Next step: Run 11_part_to_whole_analysis.sql
-- =============================================================================
