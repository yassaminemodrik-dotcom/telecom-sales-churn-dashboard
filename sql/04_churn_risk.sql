-- Q: How much revenue is at high churn risk, by share of revenue AND by share of contracts?
SELECT
    ROUND(SUM(net_revenue_mad) FILTER (WHERE churn_risk_level = 'High'), 2)                 AS revenue_at_risk_mad,
    ROUND(100.0 * SUM(net_revenue_mad) FILTER (WHERE churn_risk_level = 'High')
          / SUM(net_revenue_mad), 2)                                                  AS revenue_at_risk_pct,
    COUNT(*) FILTER (WHERE churn_risk_level = 'High')                                       AS high_risk_contracts,
    ROUND(100.0 * COUNT(*) FILTER (WHERE churn_risk_level = 'High') / COUNT(*), 2)          AS high_risk_contracts_pct
FROM orange_morocco_sales_master;

-- Q: Where is the exposure concentrated (segment x region)?
SELECT customer_segment, region,
       COUNT(*) FILTER (WHERE churn_risk_level = 'High')              AS high_risk_contracts,
       SUM(net_revenue_mad) FILTER (WHERE churn_risk_level = 'High')  AS revenue_at_risk_mad
FROM orange_morocco_sales_master
GROUP BY customer_segment, region
ORDER BY revenue_at_risk_mad DESC NULLS LAST;