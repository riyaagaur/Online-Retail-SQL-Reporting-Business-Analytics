DROP TABLE IF EXISTS online_retail;

CREATE TABLE online_retail (
  invoiceno TEXT,
  stockcode TEXT,
  description TEXT,
  quantity INTEGER,
  invoicedate TIMESTAMP,
  unitprice NUMERIC,
  customerid NUMERIC,
  country TEXT
);

DROP TABLE IF EXISTS fact_sales_clean;

CREATE TABLE fact_sales_clean AS
SELECT
    invoiceno,
    stockcode,
    description,
    quantity,
    invoicedate,
    unitprice,
    customerid,
    country,
    (quantity * unitprice) AS revenue
FROM online_retail
WHERE quantity > 0
  AND unitprice > 0
  AND customerid IS NOT NULL;


DROP TABLE IF EXISTS rpt_monthly_revenue;

CREATE TABLE rpt_monthly_revenue AS
SELECT
    DATE_TRUNC('month', invoicedate) AS month,
    ROUND(SUM(revenue), 2) AS monthly_revenue,
    COUNT(DISTINCT invoiceno) AS monthly_orders,
    COUNT(DISTINCT customerid) AS active_customers
FROM fact_sales_clean
GROUP BY 1
ORDER BY 1;

SELECT * FROM rpt_monthly_revenue 
ORDER BY month LIMIT 5;

SELECT COUNT(*) FROM rpt_monthly_revenue;

CREATE TABLE rpt_kpi_summary AS
SELECT
    COUNT(DISTINCT invoiceno) AS total_orders,
    COUNT(DISTINCT customerid) AS total_customers,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(revenue) / COUNT(DISTINCT invoiceno), 2) AS avg_order_value
FROM fact_sales_clean;


SELECT * FROM rpt_kpi_summary;
