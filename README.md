# 📊 SQL Data Analytics Project

![SQL](https://img.shields.io/badge/SQL-T--SQL-blue)
![SQL Server](https://img.shields.io/badge/Database-Microsoft%20SQL%20Server-red)
![Analytics](https://img.shields.io/badge/Focus-Data%20Analytics-green)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen)

A complete hands-on **SQL Data Analytics project** built on a retail data warehouse using **Microsoft SQL Server** and **T-SQL**.

This project demonstrates how raw business data can be explored, analyzed, segmented, and converted into reusable reporting views. It covers the full analytics workflow from database setup and basic exploration to advanced reporting using joins, aggregations, window functions, CTEs, segmentation logic, and SQL views.

---

## 📌 Project Overview

The project uses a retail-style data warehouse and focuses on answering real business questions such as:

- How much revenue was generated?
- Which products and customers perform best?
- How does sales performance change over time?
- Which customer groups are most valuable?
- Which product categories contribute most to total revenue?
- How can analysis be converted into reusable reporting views?

The final output includes two reporting views:

- `gold.report_customers`
- `gold.report_products`

These views summarize customer and product performance in a clean business-ready format.

---

## 🎯 Project Objectives

- Practice real-world SQL analytics using Microsoft SQL Server.
- Explore data warehouse tables and understand business entities.
- Perform sales, customer, and product analysis.
- Use advanced SQL concepts such as CTEs and window functions.
- Build reusable reporting views for analytics and dashboarding.
- Strengthen data analyst and data engineering SQL skills.

---

## 🗄️ Database Structure

The main analysis is performed on the `gold` schema, which contains three core tables:

| Table | Description |
|---|---|
| `gold.dim_customers` | Customer information such as name, gender, country, and birthdate. |
| `gold.dim_products` | Product information such as product name, category, subcategory, and cost. |
| `gold.fact_sales` | Sales transaction details including order dates, quantities, prices, and sales amount. |

The project also includes CSV files for `bronze`, `silver`, and `gold` layers, showing a data warehouse-style structure.

---

## 📁 Project Structure

```text
sql-data-analytics-project/
│
├── datasets/
│   ├── DataWarehouseAnalytics.bak
│   └── csv-files/
│       ├── bronze.crm_cust_info.csv
│       ├── bronze.crm_prd_info.csv
│       ├── bronze.crm_sales_details.csv
│       ├── bronze.erp_cust_az12.csv
│       ├── bronze.erp_loc_a101.csv
│       ├── bronze.erp_px_cat_g1v2.csv
│       ├── silver.crm_cust_info.csv
│       ├── silver.crm_prd_info.csv
│       ├── silver.crm_sales_details.csv
│       ├── silver.erp_cust_az12.csv
│       ├── silver.erp_loc_a101.csv
│       ├── silver.erp_px_cat_g1v2.csv
│       ├── gold.dim_customers.csv
│       ├── gold.dim_products.csv
│       ├── gold.fact_sales.csv
│       ├── gold.report_customers.csv
│       └── gold.report_products.csv
│
├── docs/
│   ├── Dimension or Measure.png
│   └── Project Roadmap.png
│
├── scripts/
│   ├── 00_init_database.sql
│   ├── 01_database_exploration.sql
│   ├── 02_dimensions_exploration.sql
│   ├── 03_date_range_exploration.sql
│   ├── 04_measures_exploration.sql
│   ├── 05_magnitude_analysis.sql
│   ├── 06_ranking_analysis.sql
│   ├── 07_change_over_time_analysis.sql
│   ├── 08_cumulative_analysis.sql
│   ├── 09_performance_analysis.sql
│   ├── 10_data_segmentation.sql
│   ├── 11_part_to_whole_analysis.sql
│   ├── 12_report_customers.sql
│   └── 13_report_products.sql
│
└── README.md
```

---

## 🧭 Project Roadmap

The project is divided into five main phases:

| Phase | Scripts | Focus Area |
|---|---:|---|
| Phase 1 | `01`–`03` | Database, dimension, and date range exploration |
| Phase 2 | `04`–`06` | Measures, magnitude, and ranking analysis |
| Phase 3 | `07`–`09` | Time trends, cumulative analysis, and performance analysis |
| Phase 4 | `10`–`11` | Data segmentation and part-to-whole analysis |
| Phase 5 | `12`–`13` | Customer and product reporting views |

---

## 🔍 Analysis Breakdown

### 1. Database Exploration

Scripts used:

- `01_database_exploration.sql`
- `02_dimensions_exploration.sql`
- `03_date_range_exploration.sql`

Key tasks:

- Explore available tables and columns.
- Identify unique countries, categories, and subcategories.
- Check customer birthdate range.
- Check first and last order dates.
- Understand the overall shape of the dataset.

---

### 2. Measures and Business Metrics

Scripts used:

- `04_measures_exploration.sql`
- `05_magnitude_analysis.sql`
- `06_ranking_analysis.sql`

Key tasks:

- Calculate total sales.
- Calculate total quantity sold.
- Count total orders, products, and customers.
- Analyze revenue by country, gender, category, and customer.
- Find top-performing products.
- Find high-value customers.
- Identify low-performing products or customers.

---

### 3. Time-Based Analysis

Scripts used:

- `07_change_over_time_analysis.sql`
- `08_cumulative_analysis.sql`
- `09_performance_analysis.sql`

Key tasks:

- Analyze monthly and yearly sales trends.
- Calculate running total sales.
- Calculate moving average price.
- Compare yearly product performance.
- Use previous year sales for performance comparison.
- Identify whether product sales are above or below average.

---

### 4. Segmentation Analysis

Scripts used:

- `10_data_segmentation.sql`
- `11_part_to_whole_analysis.sql`

Key tasks:

- Segment products by cost range.
- Segment customers into business groups such as VIP, Regular, and New.
- Analyze category contribution to total sales.
- Calculate percentage share of each category.

---

### 5. Reporting Views

Scripts used:

- `12_report_customers.sql`
- `13_report_products.sql`

These scripts create final reporting views that can be used for dashboards, business reports, or further analytics.

#### Customer Report: `gold.report_customers`

Includes:

- Customer name
- Age and age group
- Customer segment
- Total orders
- Total sales
- Total quantity purchased
- Customer lifespan
- Recency
- Average order value
- Average monthly spend

#### Product Report: `gold.report_products`

Includes:

- Product name
- Category and subcategory
- Product cost
- Product segment
- Total orders
- Total sales
- Total quantity sold
- Total customers
- Product lifespan
- Recency
- Average order revenue
- Average monthly revenue

---

## 🛠️ SQL Concepts Used

| SQL Concept | Used For |
|---|---|
| `SELECT` | Retrieving data from tables |
| `WHERE` | Filtering records |
| `GROUP BY` | Aggregating data by business dimensions |
| `ORDER BY` | Sorting analysis results |
| `SUM()` | Calculating total sales and quantities |
| `COUNT()` | Counting orders, customers, and products |
| `AVG()` | Calculating average price and revenue |
| `MIN()` / `MAX()` | Finding date ranges and value ranges |
| `JOIN` | Combining fact and dimension tables |
| `CASE` | Creating segments and business labels |
| CTEs | Breaking complex queries into readable steps |
| Window Functions | Running totals, moving averages, ranking, and comparisons |
| `LAG()` | Comparing current performance with previous periods |
| `RANK()` / `DENSE_RANK()` | Ranking products and customers |
| `CREATE VIEW` | Creating reusable reporting layers |
| `BULK INSERT` | Loading CSV files into SQL Server |

---

## ⚙️ How to Run This Project

### Option 1: Restore the Backup File

1. Open **SQL Server Management Studio (SSMS)**.
2. Restore the database using:
   - `datasets/DataWarehouseAnalytics.bak`
3. Open the `scripts/` folder.
4. Run the analysis scripts in order from `01` to `13`.

### Option 2: Load CSV Files Manually

1. Open **SQL Server Management Studio (SSMS)**.
2. Run:

```sql
scripts/00_init_database.sql
```

3. Update the file paths inside the `BULK INSERT` statements according to your local machine.
4. Run the remaining scripts in order:

```text
01_database_exploration.sql
02_dimensions_exploration.sql
03_date_range_exploration.sql
04_measures_exploration.sql
05_magnitude_analysis.sql
06_ranking_analysis.sql
07_change_over_time_analysis.sql
08_cumulative_analysis.sql
09_performance_analysis.sql
10_data_segmentation.sql
11_part_to_whole_analysis.sql
12_report_customers.sql
13_report_products.sql
```

5. Query the final views:

```sql
SELECT * FROM gold.report_customers;
SELECT * FROM gold.report_products;
```

---

## 📊 Example Business Questions Answered

- What is the total revenue of the business?
- Which country generates the highest sales?
- Which product category contributes the most revenue?
- Who are the top customers by total spending?
- Which products are high performers?
- How are sales changing over time?
- What is the monthly running total of sales?
- Which customers are VIP, Regular, or New?
- What percentage of total sales comes from each category?

---

## ✅ Key Takeaways

- Built a complete SQL analytics workflow from exploration to reporting.
- Practiced real-world business analysis using a data warehouse model.
- Used joins to combine customer, product, and sales data.
- Used window functions for ranking, running totals, and performance comparison.
- Created customer and product segmentation logic.
- Built reusable SQL views for reporting and dashboard use cases.

---

## 🧰 Tools and Technologies

- Microsoft SQL Server
- SQL Server Management Studio (SSMS)
- T-SQL
- Git
- GitHub

---

## 📚 Learning Resource

This project was built while following the **SQL Data Analytics** course by [Data With Baraa](https://www.datawithbaraa.com/).

---

## 👤 Author

**Hafiz Uzair Akhtar**  
Data Engineering Enthusiast | SQL · Python · ETL Pipelines · PySpark  
📧 uzair.akhtar501@gmail.com  
[GitHub](https://github.com/HafizUzairAkhtar) · [LinkedIn](https://linkedin.com/in/uzair08)

---

## ⭐ Repository

If this project helps you learn SQL analytics, feel free to star the repository and connect with me on LinkedIn.
