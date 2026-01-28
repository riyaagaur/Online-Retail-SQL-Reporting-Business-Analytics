SELECT COUNT(*) 
FROM online_retail;

SELECT * FROM online_retail 
LIMIT 10;

WITH base AS (
    SELECT *
    FROM online_retail
    WHERE quantity > 0
      AND unitprice > 0
      AND customerid IS NOT NULL
)
SELECT
    COUNT(DISTINCT invoiceno) AS total_orders,
    COUNT(DISTINCT customerid) AS total_customers,
    ROUND(SUM(quantity * unitprice), 2) AS total_revenue,
    ROUND(SUM(quantity * unitprice) / COUNT(DISTINCT invoiceno), 2) AS avg_order_value
FROM base;

WITH base AS (
    SELECT
      DATE_TRUNC('month', invoicedate) AS month,
      quantity * unitprice AS revenue
    FROM online_retail
    WHERE quantity > 0
      AND unitprice > 0
      AND customerid IS NOT NULL
)
SELECT
  month,
  ROUND(SUM(revenue), 2) AS monthly_revenue
FROM base
GROUP BY month
ORDER BY month;

WITH base AS (
    SELECT
      customerid,
      quantity * unitprice AS revenue
    FROM online_retail
    WHERE quantity > 0
      AND unitprice > 0
      AND customerid IS NOT NULL
)
SELECT
  customerid,
  ROUND(SUM(revenue), 2) AS total_revenue
FROM base
GROUP BY customerid
ORDER BY total_revenue DESC
LIMIT 10;

