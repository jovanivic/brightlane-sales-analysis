Brightlane Sales Analysis: SQL Star Schema and Power BI Dashboard

Note: Brightlane Software is a fictional company. The data is synthetic practice data, created to demonstrate data cleaning, modeling and dashboard skills. It does not describe a real business.

Question:
1. Where does Brightlane's revenue come from, and where is revenue at risk?
2. Which products and regions drive the most revenue?
3. Which sales reps rank highest?
4. How much revenue is unpaid (Pending or Overdue)?

Data:
A synthetic sales file, stg_sales_raw: 1,252 rows, all stored as text, with deliberately messy data (four date formats, inconsistent spellings, placeholders such as 9999 and "TBD", duplicate rows).
A clean four-table set used for the star schema: 30 customers, 5 products, 100 orders, 195 order lines.
Source: synthetic data created for this project. The cleaned tables are the four CSV files in this repo (dim_customer.csv, dim_product.csv, dim_rep.csv, fact_sales.csv). The raw table is in brightlane_workspace_1.db.

Method:
Profiled each column with SQL (GROUP BY, COUNT, LIKE / GLOB) and logged what was wrong.
Cleaned the raw table through layered SQL views, leaving the original untouched. Used TRIM, CASE, NULLIF, REPLACE, CAST and date conversion to ISO format. Removed exact duplicates only after cleaning.
Validated against the formula revenue = seats × unit price × (1 − discount). Found 23 rows that don't reconcile and flagged them instead of guessing.
Answered the questions above in SQL with six queries using JOINs, a CTE and a window function (RANK() OVER). See queries.sql.
Modeled the data as a star schema (below) and built it as SQL views.
Built a Power BI dashboard with five DAX measures: Total Revenue, Order Count, Avg Order Value, Company Avg Order Value (CALCULATE with ALL) and Variance vs Company.
Checked every total against the SQL results (195 lines, $4,349,298.00).
Data model

Grain: 
each row in fact_sales is one product line on one order, and it records seats and revenue.

Star schema: 
fact_sales holds one row per product line on an order. It connects to three dimension tables: dim_customer, dim_product and dim_rep.

Dashboard: 
The dashboard uses five DAX measures: Total Revenue, Order Count, Avg Order Value, Company Avg Order Value and Variance vs Company. Every total reconciles to the SQL results ($4,349,298.00 across 195 lines).

Finding:
North America generates $2.65M, 61% of Brightlane's $4.35M revenue, from 71 of its 100 orders. However, its average order is about $37K, well below Europe ($60K) and Asia Pacific ($57K). That suggests North America's revenue may come mainly from volume, so raising order size there, or growing the larger-order regions, is a lever worth testing.
Also: 
$844K (19%) of revenue is Pending or Overdue.

Limitations:
The data is synthetic and small (100 orders), so the finding shows a method, not a market truth.
The data has revenue only, with no costs, so nothing here says anything about profit.
23 raw rows don't match the revenue formula and are flagged, not corrected.
Customer names in the raw file were not cleaned (348 spellings for 30 customers).
The "so what" in the finding is a hypothesis. Testing it would need more data, such as order size over time.
How to reproduce
Open brightlane_workspace_1.db in any SQLite tool and run queries.sql.
Open brightlane_dashboard.pbix in Power BI Desktop (free, Windows). The screenshots above show the result if you don't have it.

Files:
queries.sql ---	Six business-question queries, commented
brightlane_workspace_1.db ---	SQLite database with the raw table, cleaning views and star schema
dim_customer.csv, dim_product.csv, dim_rep.csv, fact_sales.csv	Cleaned star-schema tables
star_schema.png	Data model diagram
brightlane_dashboard.pbix ---	Power BI file
dashboard.png ---	Dashboard screenshot
README.md ---	This file

Tools:
SQLite, SQL (JOINs, CTEs, window functions), Power BI, DAX.
