-- =============================================================================
-- Script   : 13_report_products.sql
-- Author   : Uzair Akhtar
-- GitHub   : https://github.com/HafizUzairAkhtar
-- =============================================================================
-- Purpose:
--     This script creates a reusable VIEW that consolidates all key product
--     metrics and performance attributes into a single, query-ready object.
--
--     Once created, anyone can run SELECT * FROM gold.report_products
--     to instantly access the full product profile with all KPIs pre-calculated.
--
-- Report Highlights:
--     1. Pulls core transaction and product fields from fact_sales and dim_products
--     2. Segments products by revenue tier (High-Performer / Mid-Range / Low-Performer)
--     3. Aggregates product-level metrics:
--            - total orders, total sales, total quantity, total customers
--            - lifespan (months between first and last sale)
--     4. Calculates KPIs:
--            - recency           → months since the product last had a sale
--            - avg_selling_price → average revenue per unit sold
--            - avg_order_revenue → average revenue per order
--            - avg_monthly_revenue → average revenue per active month
--
-- View Created:
--     gold.report_products
--
-- Tables Used:
--     gold.fact_sales   → Sales transactions
--     gold.dim_products → Product details (name, category, subcategory, cost)
--
-- Execution Order:
--     Run this script after: 12_report_customers.sql
--     This is the final script in the project.
-- =============================================================================


-- Drop the view if it already exists so we can recreate it cleanly
IF OBJECT_ID('gold.report_products', 'V') IS NOT NULL
    DROP VIEW gold.report_products;
GO


CREATE VIEW gold.report_products AS

-- =============================================================================
-- CTE 1: base_query
-- Pulls the raw transaction rows joined with product details.
-- We filter out NULL order dates here so all downstream CTEs stay clean.
-- customer_key is included so we can count unique customers per product later.
-- =============================================================================
WITH base_query AS (
    SELECT
        f.order_number,
        f.order_date,
        f.customer_key,
        f.sales_amount,
        f.quantity,
        p.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
),

-- =============================================================================
-- CTE 2: product_aggregations
-- Rolls up all transaction rows to one row per product.
-- COUNT(DISTINCT order_number)  → unique orders (not line items)
-- COUNT(DISTINCT customer_key)  → unique customers who bought this product
-- MAX(order_date)               → most recent sale date (used for recency)
-- DATEDIFF(month, MIN, MAX)     → lifespan in months between first and last sale
-- avg_selling_price             → average revenue per unit using NULLIF to
--                                  guard against divide-by-zero on quantity
-- =============================================================================
product_aggregations AS (
    SELECT
        product_key,
        product_name,
        category,
        subcategory,
        cost,
        DATEDIFF(month, MIN(order_date), MAX(order_date))              AS lifespan,
        MAX(order_date)                                                AS last_sale_date,
        COUNT(DISTINCT order_number)                                   AS total_orders,
        COUNT(DISTINCT customer_key)                                   AS total_customers,
        SUM(sales_amount)                                              AS total_sales,
        SUM(quantity)                                                  AS total_quantity,
        ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)), 1) AS avg_selling_price
    FROM base_query
    GROUP BY
        product_key,
        product_name,
        category,
        subcategory,
        cost
)

-- =============================================================================
-- Final SELECT: Adds segments and KPIs on top of the aggregated product data
-- =============================================================================
SELECT
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    last_sale_date,

    -- Recency: how many months since this product last had a sale
    -- Lower recency = more recently sold = still an active product
    DATEDIFF(month, last_sale_date, GETDATE())      AS recency_in_months,

    -- Product performance segment based on total revenue generated
    -- High-Performer  → total sales above 50,000
    -- Mid-Range       → total sales between 10,000 and 50,000
    -- Low-Performer   → total sales below 10,000
    CASE
        WHEN total_sales > 50000  THEN 'High-Performer'
        WHEN total_sales >= 10000 THEN 'Mid-Range'
        ELSE                           'Low-Performer'
    END AS product_segment,

    lifespan,
    total_orders,
    total_sales,
    total_quantity,
    total_customers,
    avg_selling_price,

    -- Average Order Revenue (AOR)
    -- How much revenue does this product generate per order on average?
    -- Guard against divide-by-zero with a CASE check on total_orders
    CASE
        WHEN total_orders = 0 THEN 0
        ELSE total_sales / total_orders
    END AS avg_order_revenue,

    -- Average Monthly Revenue
    -- How much revenue does this product generate per active month?
    -- If lifespan = 0 the product sold only within a single month,
    -- so we return total_sales directly instead of dividing by zero
    CASE
        WHEN lifespan = 0 THEN total_sales
        ELSE total_sales / lifespan
    END AS avg_monthly_revenue

FROM product_aggregations;
GO
