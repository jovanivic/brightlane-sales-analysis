Brightlane Sales Analysis: SQL Star Schema and Power BI Dashboard

Note: 
Brightlane Software is a fictional company. The data is synthetic practice data, created to demonstrate data cleaning, modeling and dashboard skills. It does not describe a real business.

Question:
1. Where does Brightlane's revenue come from, and where is revenue at risk?
2. Which products and regions drive the most revenue?
3. Which sales reps rank highest?
4. How much revenue is unpaid (Pending or Overdue)?
Data

The project has two parts that use two separate datasets in the same SQLite database.

Part 1, cleaning (raw file): 
a synthetic sales file, stg_sales_raw: 1,252 rows, all stored as text, with deliberately messy data (four date formats, inconsistent spellings, placeholders such as 9999 and "TBD", duplicate rows, a repeated header row and a TOTAL row). It has about 1,200 distinct orders.
Part 2, modeling and dashboard (clean set): 
a separate, already-clean sales dataset loaded into the same database: 30 customers, 5 products, 4 sales reps, 100 orders, 195 order lines. The star schema, queries and dashboard use this set.
Source: synthetic data created for this project. The cleaned tables are the four CSV files in this repo (dim_customer.csv, dim_product.csv, dim_rep.csv, fact_sales.csv). The raw table is in brightlane_workspace_1.db.
Method

Part 1: clean the raw file
Profiled each column with SQL (GROUP BY, COUNT, LIKE / GLOB) and logged what was wrong.
Cleaned the raw table through layered SQL views (stg_sales_clean, sales_clean, sales_final), leaving the original untouched. Used TRIM, CASE, NULLIF, REPLACE, CAST and date conversion to ISO format. Dropped the stray header and TOTAL rows (1,252 to 1,250), then removed exact duplicates only after cleaning (1,250 to 1,200).
Validated against the formula revenue = seats × unit price × (1 − discount). Of the 1,200 cleaned rows, 1,013 reconcile, 23 don't and are flagged instead of guessed, and 164 can't be tested because a value is missing. Six order IDs are reused and flagged.

Part 2: model and analyze the clean 100-order set
Modeled it as a star schema (below) and built it as SQL views.
Answered the questions above in SQL with six queries using JOINs, a CTE and a window function (RANK() OVER). See queries.sql.
Built a Power BI dashboard with five DAX measures: Total Revenue, Order Count, Avg Order Value, Company Avg Order Value (CALCULATE with ALL) and Variance vs Company.
Checked every total against the SQL results (195 lines, $4,349,298.00).

Grain: 
each row in fact_sales is one product line on one order, and it records seats and revenue.

Star schema: 
fact_sales holds one row per product line on an order. It connects to three dimension tables: dim_customer, dim_product and dim_rep.

Dashboard: 
The dashboard uses five DAX measures: Total Revenue, Order Count, Avg Order Value, Company Avg Order Value and Variance vs Company. Every total reconciles to the SQL results ($4,349,298.00 across 195 lines).

Finding:
North America generates $2.65M, 61% of Brightlane's $4.35M revenue, from 71 of its 100 orders. However, its average order is about $37K, well below Europe ($60K) and Asia Pacific ($57K). That suggests North America's revenue may come mainly from volume, so raising order size there, or growing the larger-order regions, is a lever worth testing.

Also: $844K (19%) of revenue is Pending or Overdue. Sales rep Devon Clarke holds the most unpaid revenue ($356K, about 42%), and Keystone Retail is the customer with the most ($217K, about 26%).

Limitations:
The data is synthetic and small (100 orders in the star schema), so the finding shows a method, not a market truth.
The star schema and dashboard use a separate clean 100-order dataset. The cleaned raw file (1,200 rows) is not loaded into them.
The data has revenue only, with no costs, so nothing here says anything about profit.
23 cleaned raw rows don't match the revenue formula and are flagged, not corrected. This check applies to the raw file, and the 100-order set has no mismatches.
Customer names in the raw file were not cleaned (348 spellings for 30 customers).
The "so what" in the finding is a hypothesis. Testing it would need more data, such as order size over time.

How to reproduce:
Open brightlane_workspace_1.db in any SQLite tool and run queries.sql.
Open brightlane_dashboard.pbix in Power BI Desktop (free, Windows). The screenshots above show the result if you don't have it.

Files:
queries.sql ---	Six business-question queries, commented
brightlane_workspace_1.db ---	SQLite database with the raw table, cleaning views and star schema
dim_customer.csv, dim_product.csv, dim_rep.csv, fact_sales.csv --- Cleaned star-schema tables
star_schema.png	Data model diagram
brightlane_dashboard.pbix ---	Power BI file
dashboard.png ---	Dashboard screenshot
README.md ---	This file

Tools:
SQLite, SQL (JOINs, CTEs, window functions), Power BI, DAX.
