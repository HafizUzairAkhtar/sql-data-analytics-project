-- =============================================================================
-- Script   : 12_report_customers.sql
-- Author   : Uzair Akhtar
-- GitHub   : https://github.com/HafizUzairAkhtar
-- =============================================================================
-- Purpose:
--     This script creates a reusable VIEW that consolidates all key customer
--     metrics and behavioral attributes into a single, query-ready object.
--
--     Once created, anyone can run SELECT * FROM gold.report_customers
--     to instantly access the full customer profile with all KPIs pre-calculated.
--
-- Report Highlights:
--     1. Pulls core transaction and profile fields from fact_sales and dim_customers
--     2. Segments customers by age group and loyalty tier (VIP / Regular / New)
--     3. Aggregates customer-level metrics:
--            - total orders, total sales, total quantity, total products
--            - lifespan (months between first and last order)
--     4. Calculates KPIs:
--            - recency        → months since the customer last placed an order
--            - avg_order_value   → average revenue per order
--            - avg_monthly_spend → average revenue per active month
--
-- View Created:
--     gold.report_customers
--
-- Tables Used:
--     gold.fact_sales    → Sales transactions
--     gold.dim_customers → Customer profile details
--
-- Execution Order:
--     Run this script after: 11_part_to_whole_analysis.sql
--     Next step: 13_report_products.sql
-- =============================================================================


-- Drop the view if it already exists so we can recreate it cleanly
IF OBJECT_ID('gold.report_customers', 'V') IS NOT NULL
    DROP VIEW gold.report_customers;
GO


CREATE VIEW gold.report_customers AS

-- =============================================================================
-- CTE 1: base_query
-- Pulls the raw transaction rows we need, joined with customer details.
-- We filter out NULL order dates here so all downstream CTEs stay clean.
-- CONCAT builds a single full_name column instead of keeping first and last separate.
-- DATEDIFF(year, birthdate, GETDATE()) calculates current age from birthdate.
-- =============================================================================
WITH base_query AS (
    SELECT
        f.order_number,
        f.product_key,
        f.order_date,
        f.sales_amount,
        f.quantity,
        c.customer_key,
        c.customer_number,
        CONCAT(c.first_name, ' ', c.last_name)    AS customer_name,
        DATEDIFF(year, c.birthdate, GETDATE())     AS age
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c
        ON c.customer_key = f.customer_key
    WHERE f.order_date IS NOT NULL
),

-- =============================================================================
-- CTE 2: customer_aggregation
-- Rolls up all transaction rows to one row per customer.
-- COUNT(DISTINCT order_number) → unique orders (not line items)
-- COUNT(DISTINCT product_key)  → unique products purchased
-- MAX(order_date)              → most recent order date (used for recency)
-- DATEDIFF(month, MIN, MAX)    → lifespan in months between first and last order
-- =============================================================================
customer_aggregation AS (
    SELECT
        customer_key,
        customer_number,
        customer_name,
        age,
        COUNT(DISTINCT order_number)                          AS total_orders,
        SUM(sales_amount)                                     AS total_sales,
        SUM(quantity)                                         AS total_quantity,
        COUNT(DISTINCT product_key)                           AS total_products,
        MAX(order_date)                                       AS last_order_date,
        DATEDIFF(month, MIN(order_date), MAX(order_date))     AS lifespan
    FROM base_query
    GROUP BY
        customer_key,
        customer_number,
        customer_name,
        age
)

-- =============================================================================
-- Final SELECT: Adds segments and KPIs on top of the aggregated customer data
-- =============================================================================
SELECT
    customer_key,
    customer_number,
    customer_name,
    age,

    -- Age group segmentation
    -- Buckets customers into standard demographic bands for reporting
    CASE
        WHEN age < 20                  THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29     THEN '20-29'
        WHEN age BETWEEN 30 AND 39     THEN '30-39'
        WHEN age BETWEEN 40 AND 49     THEN '40-49'
        ELSE                                '50 and Above'
    END AS age_group,

    -- Customer loyalty segment
    -- VIP      → 12+ months active AND spent more than 5,000
    -- Regular  → 12+ months active AND spent 5,000 or less
    -- New      → active for less than 12 months
    CASE
        WHEN lifespan >= 12 AND total_sales > 5000  THEN 'VIP'
        WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
        ELSE                                             'New'
    END AS customer_segment,

    last_order_date,

    -- Recency: how many months since the customer last placed an order
    -- Lower recency = more recently active = more engaged customer
    DATEDIFF(month, last_order_date, GETDATE())     AS recency,

    total_orders,
    total_sales,
    total_quantity,
    total_products,
    lifespan,

    -- Average Order Value (AOV)
    -- How much revenue does this customer generate per order on average?
    -- Guard against divide-by-zero with a CASE check on total_orders
    CASE
        WHEN total_orders = 0 THEN 0
        ELSE total_sales / total_orders
    END AS avg_order_value,

    -- Average Monthly Spend
    -- How much does this customer spend per active month on average?
    -- If lifespan = 0 the customer bought only within a single month,
    -- so we return total_sales directly instead of dividing by zero
    CASE
        WHEN lifespan = 0 THEN total_sales
        ELSE total_sales / lifespan
    END AS avg_monthly_spend

FROM customer_aggregation;
GO