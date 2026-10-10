--This query analyse cities performance based on net revenue in MAD (Moroccan Dirham). It calculates the total net revenue for each city and ranks them accordingly.
select 
city,
sum(net_revenue_mad) as total_net_revenue,
row_number() over(  ORDER BY sum(net_revenue_mad) desc) as rank
from orange_morocco_sales_master
group by city
order by total_net_revenue desc;


-- This query analyses which regions contribute most, and who is furthest from target?
  SELECT
    s.region,
    SUM(s.net_revenue_mad)                                                  AS revenue_mad,
    SUM(t.annual_target_mad)                                                       AS target_mad,
    ROUND(100.0 * SUM(s.net_revenue_mad) / SUM(t.annual_target_mad), 1)              AS attainment_pct,
    SUM(t.annual_target_mad) - SUM(s.net_revenue_mad)                                AS gap_to_target_mad,
    ROUND(100.0 * SUM(s.net_revenue_mad) / SUM(SUM(s.net_revenue_mad)) OVER (), 1) AS share_of_revenue_pct
FROM orange_morocco_sales_master as  s left join orange_regional_targets as t
    ON s.region = t.region
GROUP BY s.region
ORDER BY gap_to_target_mad DESC;

-- this query identifies which cities drive revenue inside each region?
SELECT region, city, SUM(net_revenue_mad) AS revenue_mad,
       RANK() OVER (PARTITION BY region ORDER BY SUM(net_revenue_mad) DESC) AS rank_in_region
FROM Orange_Morocco_Sales_Master
GROUP BY region, city
ORDER BY region, rank_in_region;