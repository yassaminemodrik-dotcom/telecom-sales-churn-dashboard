-- This query analyzes revenue concentration by product line (concentration risk)
SELECT product_line,
       COUNT(*)  AS contracts,
       SUM(net_revenue_mad)  AS revenue_mad,
       ROUND(100.0 * SUM(net_revenue_mad) / SUM(SUM(net_revenue_mad)) OVER (), 1) AS share_pct
FROM orange_morocco_sales_master
GROUP BY product_line
ORDER BY revenue_mad DESC;


-- This query shows the monthly revenue trend with month-over-month change
WITH monthly AS (
    SELECT
        DATE_TRUNC('month',date)::date AS month,
        SUM(net_revenue_mad)                 AS revenue_mad
    FROM orange_morocco_sales_master
    GROUP BY 1
)
SELECT
    TO_CHAR(month, 'YYYY-MM') AS year_month,
    revenue_mad,
    ROUND(100.0 * (revenue_mad - LAG(revenue_mad) OVER (ORDER BY month))
          / NULLIF(LAG(revenue_mad) OVER (ORDER BY month), 0), 1) AS mom_change_pct
FROM monthly
ORDER BY month;