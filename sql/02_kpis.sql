SELECT
    ROUND(SUM(net_revenue_mad), 2) AS total_revenue_mad,
    ROUND(AVG(net_revenue_mad), 2) AS arpu,
    ROUND(100.0 * SUM(net_revenue_mad) / SUM(annual_target_mad), 2)    AS target_attainment_pct,
    ROUND(100.0 * SUM(gross_margin_mad) / SUM(net_revenue_mad), 1) AS gross_margin_pct,
    ROUND(SUM(gross_margin_mad), 2) AS total_gross_margin_mad,
    ROUND(AVG(nps_score), 2) AS avg_nps_score,
    ROUND(AVG(discount_mad), 2) AS avg_discount_mad
FROM orange_morocco_sales_master as  s left join orange_regional_targets as t
    ON s.region = t.region
