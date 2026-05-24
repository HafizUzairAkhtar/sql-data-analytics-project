-- =============================================================================
-- Script   : 02_dimensions_exploration.sql
-- Author   : Uzair Akhtar
-- GitHub   : https://github.com/HafizUzairAkhtar
-- =============================================================================
-- Purpose:
--     This script explores the dimension tables to understand the unique
--     values they contain. Dimension tables describe the "who" and "what"
--     of our data — who the customers are and what products exist.
--
--     Knowing the distinct values in dimension tables helps us understand
--     the scope of the data before jumping into any analysis.
--
-- SQL Functions Used:
--     DISTINCT  → Returns only unique values, removing duplicates
--     ORDER BY  → Sorts results for easier reading
--
-- Tables Explored:
--     gold.dim_customers  → Customer dimension
--     gold.dim_products   → Product dimension
--
-- Execution Order:
--     Run this script after: 01_database_exploration.sql
--     Next step: 03_date_range_exploration.sql
-- =============================================================================


-- Step 1: Find all unique countries where customers are located
--         This tells us the geographic spread of our customer base.
--         Useful for regional analysis and filtering later.
SELECT DISTINCT
    country
FROM gold.dim_customers
ORDER BY country;


-- Step 2: Find all unique genders in the customer table
--         Helps us understand the gender breakdown before doing
--         any customer segmentation or demographic analysis.
SELECT DISTINCT
    gender
FROM gold.dim_customers
ORDER BY gender;


-- Step 3: Find all unique marital statuses in the customer table
--         Good to know what values exist so we don't get surprised
--         by unexpected entries during analysis.
SELECT DISTINCT
    marital_status
FROM gold.dim_customers
ORDER BY marital_status;


-- Step 4: Find all unique categories, subcategories, and product names
--         This gives us the full product hierarchy in one view.
--         Ordered so we can read it like a tree: Category → Subcategory → Product.
SELECT DISTINCT
    category,
    subcategory,
    product_name
FROM gold.dim_products
ORDER BY category, subcategory, product_name;


-- Step 5: Find all unique product lines in the products table
--         Product line is a separate grouping that may not align with category.
--         Worth checking independently to understand how products are classified.
SELECT DISTINCT
    product_line
FROM gold.dim_products
ORDER BY product_line;


-- =============================================================================
-- Exploration complete.
-- You now know the unique values across all key dimension columns.
-- Next step: Run 03_date_range_exploration.sql
-- =============================================================================