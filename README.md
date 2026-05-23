# 📊 SQL Data Analytics Project

A hands-on SQL analytics project built on a retail data warehouse. This project covers the full analytics workflow from database setup and exploration to segmentation, trend analysis, and final reporting views using **Microsoft SQL Server (T-SQL)**.

---

## 🎯 Project Objective

The goal of this project is to practice and demonstrate core SQL skills used by data engineers and analysts in real business environments. Each script targets a specific type of analysis, building progressively from exploration to insight.

---

## 🗄️ Database Structure

The project uses a `gold` schema with three core tables:

| Table | Description |
|---|---|
| `gold.dim_customers` | Customer details: name, country, gender, birthdate |
| `gold.dim_products` | Product details: name, category, subcategory, cost |
| `gold.fact_sales` | Sales transactions: orders, quantities, prices, dates |

---

## 📁 Project Structure

> 🔧 *Full folder structure will be added once the project is complete.*

---

## 🔍 Analysis Breakdown

### 🔹 Phase 1 — Exploration (Scripts 01–03)
Understanding the shape, range, and content of the data before any analysis begins.

- List all tables and inspect column types
- Find unique countries, categories, and products
- Determine the date range of sales data and customer age range

### 🔹 Phase 2 — Core Metrics (Scripts 04–06)
Answering the first business questions: *How big is the business? Who are the top performers?*

- Total sales, quantity, orders, average price
- Revenue and customer count broken down by country, gender, and category
- Top 5 products by revenue; Top 10 customers by spending; Bottom 3 by orders

### 🔹 Phase 3 — Trend Analysis (Scripts 07–09)
Understanding how performance changes over time.

- Monthly and yearly sales trend using `DATETRUNC()`, `FORMAT()`, and `DATEPART()`
- Running total of sales and moving average price using `SUM() OVER()`
- Year-over-Year product performance using `LAG()` and `AVG() OVER(PARTITION BY)`

### 🔹 Phase 4 — Segmentation (Scripts 10–11)
Grouping data into meaningful categories for deeper insight.

- Products segmented into cost ranges: Below 100 / 100–500 / 500–1000 / Above 1000
- Customers segmented into: **VIP**, **Regular**, and **New** based on lifespan and spending
- Category contribution to total revenue using window-based percentage calculation

### 🔹 Phase 5 — Reporting Views (Scripts 12–13)
Building reusable SQL views that consolidate all metrics into one place.

**Customer Report (`gold.report_customers`)** includes:
- Age and age group, customer segment (VIP / Regular / New)
- Recency, total orders, total sales, total quantity, lifespan
- Average order value and average monthly spend

**Product Report (`gold.report_products`)** includes:
- Category, subcategory, cost, product segment (High-Performer / Mid-Range / Low-Performer)
- Recency, total orders, total sales, total quantity, total customers, lifespan
- Average order revenue and average monthly revenue

---

## 🛠️ SQL Concepts Used

| Concept | Scripts |
|---|---|
| Aggregation (`SUM`, `COUNT`, `AVG`) | 04, 05, 06 |
| `GROUP BY`, `ORDER BY` | 04, 05, 06 |
| `JOIN` (LEFT JOIN) | 05, 06, 07, 09, 10, 12, 13 |
| Date functions (`DATETRUNC`, `FORMAT`, `DATEPART`, `DATEDIFF`) | 03, 07, 08, 12, 13 |
| Window functions (`SUM OVER`, `AVG OVER`, `LAG`, `RANK`, `DENSE_RANK`) | 06, 08, 09, 11 |
| `CASE` statements | 09, 10, 12, 13 |
| CTEs (Common Table Expressions) | 09, 10, 11, 12, 13 |
| Views (`CREATE VIEW`) | 12, 13 |
| `TOP N` queries | 06 |
| `BULK INSERT` | 00 |

---

## ⚙️ How to Run

1. Open **SQL Server Management Studio (SSMS)**
2. Run `00_init_database.sql` first to create the database, schema, and load the data
3. Run scripts in order from `01` to `13` each builds on the previous understanding
4. Scripts `12` and `13` create views you can query anytime with `SELECT * FROM gold.report_customers`

> **Note:** The `BULK INSERT` in `00_init_database.sql` points to a local file path. Update the path to match where your CSV files are stored on your machine.

---

## 📌 Key Takeaways

- Practiced writing clean, readable T-SQL with consistent formatting and comments
- Learned how window functions like `LAG()` and `SUM() OVER()` enable time-based comparisons without self-joins
- Built reusable reporting views combining multiple CTEs and conditional logic
- Understood how to segment customers and products to answer real business questions

---

## 🧰 Tools Used

- Microsoft SQL Server (T-SQL)
- SQL Server Management Studio (SSMS)
- Git & GitHub

---

## 📚 Learning Resource

This project was built while following the **SQL Data Analytics** course by [Data With Baraa](https://www.datawithbaraa.com).

---

## 👤 Author

**Hafiz Uzair Akhtar**  
Data Engineering Enthusiast | SQL · Python · ETL Pipelines · PySpark  
📧 uzair.akhtar501@gmail.com  
[GitHub](https://github.com/HafizUzairAkhtar) · [LinkedIn](https://linkedin.com/in/uzair08)
