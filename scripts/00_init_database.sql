-- =============================================================================
-- Script   : 00_init_database.sql
-- Author   : Uzair Akhtar
-- GitHub   : https://github.com/HafizUzairAkhtar
-- =============================================================================
-- Purpose:
--     This is the first script to run when setting up this project.
--     It creates the 'DataWarehouseAnalytics' database from scratch,
--     sets up the 'gold' schema, creates the three core tables, and
--     bulk loads data from local CSV files.
--
-- Tables Created:
--     gold.dim_customers  → Customer dimension table
--     gold.dim_products   → Product dimension table
--     gold.fact_sales     → Sales fact table
--
-- Execution Order:
--     Run this script FIRST before any other script in the project.
--     After this, proceed to: 01_database_exploration.sql
--
-- ⚠ WARNING:
--     This script will DROP the 'DataWarehouseAnalytics' database if it already exists.
--     ALL existing data will be permanently deleted.
--     Do not run this on a database that contains data you want to keep.
-- =============================================================================


-- Step 1: Switch to the master database
USE master;
GO


-- Step 2: Drop existing database if it exists
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouseAnalytics')
BEGIN
    ALTER DATABASE DataWarehouseAnalytics SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouseAnalytics;
END;
GO


-- Step 3: Create a fresh DataWarehouseAnalytics database
CREATE DATABASE DataWarehouseAnalytics;
GO


-- Step 4: Switch into the new database
USE DataWarehouseAnalytics;
GO


-- Step 5: Create the gold schema
CREATE SCHEMA gold;
GO


-- Step 6: Create dimension and fact tables

-- Dimension: Customers
CREATE TABLE gold.dim_customers (
    customer_key     INT,
    customer_id      INT,
    customer_number  NVARCHAR(50),
    first_name       NVARCHAR(50),
    last_name        NVARCHAR(50),
    country          NVARCHAR(50),
    marital_status   NVARCHAR(50),
    gender           NVARCHAR(50),
    birthdate        DATE,
    create_date      DATE
);
GO

-- Dimension: Products
CREATE TABLE gold.dim_products (
    product_key     INT,
    product_id      INT,
    product_number  NVARCHAR(50),
    product_name    NVARCHAR(50),
    category_id     NVARCHAR(50),
    category        NVARCHAR(50),
    subcategory     NVARCHAR(50),
    maintenance     NVARCHAR(50),
    cost            INT,
    product_line    NVARCHAR(50),
    start_date      DATE
);
GO

-- Fact: Sales
CREATE TABLE gold.fact_sales (
    order_number   NVARCHAR(50),
    product_key    INT,
    customer_key   INT,
    order_date     DATE,
    shipping_date  DATE,
    due_date       DATE,
    sales_amount   INT,
    quantity       TINYINT,
    price          INT
);
GO


-- Step 7: Load data from CSV files using BULK INSERT
-- Update the file paths below if you move the project folder.

-- Load Customers
TRUNCATE TABLE gold.dim_customers;
GO

BULK INSERT gold.dim_customers
FROM 'E:\Learning 2026\Data Engineering\sql-data-analytics-project\datasets\csv-files\gold.dim_customers.csv'
WITH (
    FIRSTROW        = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);
GO

-- Load Products
TRUNCATE TABLE gold.dim_products;
GO

BULK INSERT gold.dim_products
FROM 'E:\Learning 2026\Data Engineering\sql-data-analytics-project\datasets\csv-files\gold.dim_products.csv'
WITH (
    FIRSTROW        = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);
GO

-- Load Sales
TRUNCATE TABLE gold.fact_sales;
GO

BULK INSERT gold.fact_sales
FROM 'E:\Learning 2026\Data Engineering\sql-data-analytics-project\datasets\csv-files\gold.fact_sales.csv'
WITH (
    FIRSTROW        = 2,
    FIELDTERMINATOR = ',',
    TABLOCK
);
GO


-- =============================================================================
-- Setup complete.
-- Database 'DataWarehouseAnalytics' is ready with schema: gold
-- Tables loaded: gold.dim_customers | gold.dim_products | gold.fact_sales
-- Next step: Run 01_database_exploration.sql
-- =============================================================================
