-- =============================================================================
-- Script   : 01_database_exploration.sql
-- Author   : Uzair Akhtar
-- GitHub   : https://github.com/HafizUzairAkhtar
-- =============================================================================
-- Purpose:
--     This script explores the structure of the DataWarehouseAnalytics database.
--     It helps us understand what tables exist, which schema they belong to,
--     and what columns and data types each table contains.
--
--     This is always the first step before doing any analysis you need to
--     know what data you have before you can work with it.
--
-- System Tables Used:
--     INFORMATION_SCHEMA.TABLES   → Lists all tables in the database
--     INFORMATION_SCHEMA.COLUMNS  → Lists all columns for a given table
--
-- Execution Order:
--     Run this script after: 00_init_database.sql
--     Next step: 02_dimensions_exploration.sql
-- =============================================================================


-- Step 1: List all tables in the database
--         This shows us every table along with its schema and type (BASE TABLE or VIEW).
--         Useful for getting a quick overview of the database structure.
SELECT
    TABLE_CATALOG,
    TABLE_SCHEMA,
    TABLE_NAME,
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES;


-- Step 2: Inspect columns of the dim_customers table
--         This shows each column's name, data type, whether it allows NULLs,
--         and the max character length (for text columns).
--         Repeat this query for dim_products and fact_sales to explore those tables too.
SELECT
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';


-- Step 3: Inspect columns of the dim_products table
SELECT
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_products';


-- Step 4: Inspect columns of the fact_sales table
SELECT
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'fact_sales';


-- =============================================================================
-- Exploration complete.
-- You now have a clear picture of all tables and their column structures.
-- Next step: Run 02_dimensions_exploration.sql
-- =============================================================================
