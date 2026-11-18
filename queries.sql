-- Brightlane Software: Week 1 business questions (SQLite)
-- Tables: customers, products, orders, order_lines
-- Check: line revenue totals $4,349,298.00 across 195 order lines.

-- Q1. Which products drive the most revenue?
SELECT
    p.product_name,
    COUNT(*)                           AS order_lines,
    ROUND(SUM(ol.line_revenue_usd), 2) AS revenue
FROM order_lines ol
JOIN products p
  ON ol.product_id = p.product_id
GROUP BY p.product_name
ORDER BY revenue DESC;

-- Q2. Which customer regions drive the most revenue?
SELECT
    c.region,
    COUNT(*)                           AS order_lines,
    ROUND(SUM(ol.line_revenue_usd), 2) AS revenue
FROM order_lines ol
JOIN orders o
  ON ol.order_id = o.order_id
JOIN customers c
  ON o.customer_id = c.customer_id
GROUP BY c.region
ORDER BY revenue DESC;

-- Q3. How do sales reps rank by total revenue?
SELECT
    o.sales_rep,
    ROUND(SUM(ol.line_revenue_usd), 2) AS revenue,
    RANK() OVER (ORDER BY SUM(ol.line_revenue_usd) DESC) AS revenue_rank
FROM order_lines ol
JOIN orders o
  ON ol.order_id = o.order_id
GROUP BY o.sales_rep
ORDER BY revenue_rank;

-- Q4. How much revenue sits in each payment status, and what share of the total is it?
WITH status_rev AS (
    SELECT
        o.payment_status,
        ROUND(SUM(ol.line_revenue_usd), 2) AS revenue
    FROM order_lines ol
    JOIN orders o
      ON ol.order_id = o.order_id
    GROUP BY o.payment_status
)
SELECT
    payment_status,
    revenue,
    ROUND(100.0 * revenue / (SELECT SUM(revenue) FROM status_rev), 1) AS pct_of_total
FROM status_rev
ORDER BY revenue DESC;

-- Q5. Which reps have the most unpaid (Pending or Overdue) revenue?
SELECT
    o.sales_rep,
    ROUND(SUM(ol.line_revenue_usd), 2) AS revenue
FROM order_lines ol
JOIN orders o
  ON ol.order_id = o.order_id
WHERE o.payment_status IN ('Pending', 'Overdue')
GROUP BY o.sales_rep
ORDER BY revenue DESC;

-- Q6. Which five customers have the most unpaid (Pending or Overdue) revenue?
SELECT
    c.customer_name,
    ROUND(SUM(ol.line_revenue_usd), 2) AS revenue
FROM order_lines ol
JOIN orders o
  ON ol.order_id = o.order_id
JOIN customers c
  ON o.customer_id = c.customer_id
WHERE o.payment_status IN ('Pending', 'Overdue')
GROUP BY c.customer_name
ORDER BY revenue DESC
LIMIT 5;
