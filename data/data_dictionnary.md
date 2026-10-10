# Data Dictionary

> ⚠️ **Synthetic dataset** created for demonstration purposes. Not actual Orange Morocco data.
> Independent portfolio project, not affiliated with Orange.

This document describes the two source files behind the Power BI report: what each column means, how the tables relate, how the KPIs are calculated, and what the data can and cannot support.

---

## 1. Dataset overview

| File | Table | Grain (one row =) | Rows | Columns |
|---|---|---|---|---|
| `data\Orange_Morocco_Sales_Master.csv` | `orange_morocco_sales_master` | One sales transaction | 500 | 17 |
| `data\Orange_Regional_Targets.csv` | `orange_regional_targets` | One region | 6 | 3 |

| Item | Value |
|---|---|
| Period covered | 2025-01-02 to 2026-09-30 (21 months, 300 distinct transaction dates) |
| Currency | MAD (Moroccan dirham) |
| Encoding | UTF-8, comma-separated, header row |
| Geography | 6 regions, 13 cities |
| Total units sold | 642 |
| Total net revenue | 746,308.90 MAD |

> **Transactions vs units.** The report shows two different counts. *Transactions* (500) are rows in the sales table. *Units* (642) is the sum of `Units_Sold`. 
---

## 2. Table relationships

```
regional_targets (1) ────────< (many) sales
   Region (PK)                         Region (FK)

Calendar (1) ────────────────< (many) sales
   Date (PK)                           Date (FK)
```

- `sales.Region` joins to `regional_targets.Region` (many-to-one). All 6 regions match exactly, with no orphan rows on either side.
- `Calendar` is a DAX-generated date table (not a CSV) joined on `Date`.
- `City` belongs to exactly one `Region` (see section 5).

---

## 3. Table: `orange_morocco_sales_master` (Orange_Morocco_Sales_Master.csv)

| # | Column | Type (PostgreSQL / Power BI) | Description | Values / range |
|---|---|---|---|---|
| 1 | `Transaction_ID` | `TEXT` / Text | Unique transaction identifier (primary key). Format `OR-MAR-2026-NNNNN`. | `OR-MAR-2026-10000` to `OR-MAR-2026-10499` |
| 2 | `Date` | `DATE` / Date | Date of the sale. | 2025-01-02 to 2026-09-30 |
| 3 | `Region` | `TEXT` / Text | Administrative region of the sale. Foreign key to `regional_targets`. | 6 values (section 5) |
| 4 | `City` | `TEXT` / Text | City of the sale. | 13 values (section 5) |
| 5 | `Customer_Segment` | `TEXT` / Text | Customer category, B2B or B2C. | 5 values (section 6) |
| 6 | `Product_Line` | `TEXT` / Text | Product or service sold. | 5 values (section 6) |
| 7 | `Sales_Channel` | `TEXT` / Text | Channel through which the sale was made. | 5 values (section 6) |
| 8 | `Units_Sold` | `INTEGER` / Whole number | Number of units in the transaction. | 1 to 10 |
| 9 | `Unit_Price_MAD` | `NUMERIC(12,2)` / Decimal | List price per unit before discount. | 20.44 to 8,482.65 |
| 10 | `Gross_Revenue_MAD` | `NUMERIC(12,2)` / Decimal | `Units_Sold × Unit_Price_MAD`, before discount. | 20.44 to 43,093.50 |
| 11 | `Discount_MAD` | `NUMERIC(12,2)` / Decimal | Discount granted in MAD. Applied at 5%, 10%, 15% or 20% of gross revenue on 272 of the 500 transactions; 0 otherwise. | 0.00 to 1,790.35 |
| 12 | `Net_Revenue_MAD` | `NUMERIC(12,2)` / Decimal | `Gross_Revenue_MAD − Discount_MAD`. This is the revenue measure used in the report. | 20.44 to 43,093.50 |
| 13 | `Gross_Margin_MAD` | `NUMERIC(12,2)` / Decimal | Net revenue minus direct cost, in MAD. | 8.18 to 23,701.43 |
| 14 | `Payment_Method` | `TEXT` / Text | How the customer paid. | 4 values (section 6) |
| 15 | `NPS_Score` | `SMALLINT` / Whole number | Customer satisfaction score on a 1 to 10 scale. See the note below. | 1 to 10 (mean 5.55) |
| 16 | `Churn_Risk_Score` | `NUMERIC(3,2)` / Decimal | Modelled probability-style churn score between 0 and 1. Higher means more likely to leave. | 0.05 to 0.85 |
| 17 | `Churn_Risk_Level` | `TEXT` / Text | Category derived from `Churn_Risk_Score` (thresholds below). | `Low`, `Medium`, `High` |

**Churn level thresholds** (observed in the data):

| Level | Score range | Transactions |
|---|---|---|
| Low | 0.05 to 0.30 | 172 |
| Medium | 0.31 to 0.60 | 194 |
| High | 0.61 to 0.85 | 134 |

**About `NPS_Score`.** A true Net Promoter Score ranges from −100 to +100 and is calculated as % promoters minus % detractors. This column holds an individual 1 to 10 rating, so its average (5.55) is a satisfaction score, not an NPS. In the report it is labelled "Average NPS Score" for brevity; "Average Satisfaction Score (1–10)" is the accurate name.

---

## 4. Table: `orange_regional_targets` (Orange_Regional_Targets.csv)

| # | Column | Type (PostgreSQL / Power BI) | Description |
|---|---|---|---|
| 1 | `Region` | `TEXT` / Text | Region name. Primary key, joins to `sales.Region`. |
| 2 | `Annual_Target_MAD` | `INTEGER` / Whole number | Revenue target for the region, in MAD. |
| 3 | `Strategic_Priority` | `TEXT` / Text | Commercial role assigned to the region. |

| Region | Annual_Target_MAD | Strategic_Priority |
|---|---|---|
| Casablanca-Settat | 450,000 | High Growth Zone |
| Rabat-Salé-Kénitra | 320,000 | Core Government & Premium |
| Marrakech-Safi | 210,000 | Tourism & Hospitality Focus |
| Tanger-Tétouan-Al Hoceïma | 180,000 | Industrial & Logistics Hub |
| Fès-Meknès | 120,000 | Regional Expansion |
| Souss-Massa | 90,000 | Retail Growth Zone |
| **Total** | **1,370,000** | |

---

## 5. Geography: region → city

| Region | Cities (transactions) |
|---|---|
| Casablanca-Settat | Casablanca (53), El Jadida (51), Mohammedia (54) |
| Rabat-Salé-Kénitra | Rabat (53), Salé (58), Kénitra (40) |
| Marrakech-Safi | Marrakech (31), Safi (41) |
| Tanger-Tétouan-Al Hoceïma | Tangier (33), Tétouan (35) |
| Fès-Meknès | Fès (19), Meknès (13) |
| Souss-Massa | Agadir (19) |

---

## 6. Category values

**Customer_Segment**: B2B - SME (116), B2C - Premium (102), B2B - Enterprise (98), B2C - Families (93), B2C - Youth (91)

**Product_Line** (transactions · units · net revenue · gross margin %):

| Product_Line | Transactions | Units | Net revenue (MAD) | Margin % |
|---|---|---|---|---|
| Enterprise Cloud & 5G Solutions | 79 | 148 | 590,857 | 55% |
| Fibre Optique High-Speed | 122 | 145 | 62,609 | 75% |
| Postpaid Mobile (Offre Yo / Mobile) | 149 | 179 | 42,417 | 65% |
| Smart Router & Hardware Add-ons | 51 | 56 | 41,771 | 25% |
| Prepaid Recharge & Pass | 99 | 114 | 8,654 | 40% |

**Sales_Channel**: Tele-sales / Call Center (111), Orange Store / Boutique (105), Authorized Retailers (100), B2B Field Sales (93), Online Portal (Orange.ma) (91)

**Payment_Method**: Orange Money (132), Cash in Store (131), Direct Debit (Prélèvement) (119), Credit Card / CMI (118)

---

## 7. Derived objects (not in the CSV files)

| Object | Where | Definition |
|---|---|---|
| `Calendar` | Power BI (DAX) | Date table with Year, Month Number, Month and Year-Month. Marked as the date table and related to `sales[Date]`. |
| `sales_monthly` | PostgreSQL view | `sales` plus a `month` column, `DATE_TRUNC('month', "Date")`. |

---

## 8. KPI definitions

| KPI | Definition | Value in report |
|---|---|---|
| Total Revenue MAD | Sum of `Net_Revenue_MAD` | 746.31K |
| Total Gross Margin MAD | Sum of `Gross_Margin_MAD` | 413.40K |
| Gross Margin % | Total gross margin ÷ total net revenue | 55.4% |
| Target Attainment % | Total net revenue ÷ sum of `Annual_Target_MAD` | 54.48% |
| ARPU MAD | Total net revenue ÷ number of transactions (500) | 1.49K |
| Revenue At Risk MAD | Sum of `Net_Revenue_MAD` where `Churn_Risk_Level = 'High'` | 155.09K |
| Revenue at Risk % | Revenue at risk ÷ total net revenue | 20.78% |
| High Churn Risk % | High-risk transactions ÷ all transactions (134 ÷ 500) | 26.80% |
| Average Discount MAD | Mean of `Discount_MAD` across all transactions | 81.71 |
| Average NPS Score | Mean of `NPS_Score` | 5.55 |
| Top Region by Margin | Region with the highest total `Gross_Margin_MAD` | Rabat-Salé-Kénitra |

**Two churn metrics, two denominators.** *Revenue at Risk %* (20.78%) is a share of **revenue**. *High Churn Risk %* (26.80%) is a share of **transactions**. They differ because high-risk transactions are smaller than average, so they hold a smaller share of revenue than of count.

---

## 9. Reconciliation: report vs source files

Every headline figure was recomputed directly from the CSVs.

| Metric | Report | Recomputed from CSV |
|---|---|---|
| Total net revenue | 746.31K | 746,308.90 |
| Total gross margin | 413.40K | 413,404.04 |
| Gross margin % | 55.4% | 55.39% |
| Target attainment | 54.48% | 54.475% (746,308.90 ÷ 1,370,000) |
| ARPU | 1.49K | 1,492.62 |
| Revenue at risk | 155.09K | 155,091.11 |
| Revenue at risk % | 20.78% | 20.78% |
| High churn risk % | 26.80% | 26.80% (134 ÷ 500) |
| Average discount | 81.71 | 81.71 |
| Average NPS score | 5.55 | 5.546 |
| Total units | 642 | 642 |

---

## 10. Data quality checks

| Check | Result |
|---|---|
| Missing values (all 20 columns across both files) | None |
| Duplicate rows | None |
| Duplicate `Transaction_ID` | None (500 unique) |
| `Gross_Revenue_MAD − Discount_MAD = Net_Revenue_MAD` | Holds for all rows |
| `Units_Sold × Unit_Price_MAD = Gross_Revenue_MAD` | Holds for all rows |
| `Gross_Margin_MAD ≤ Net_Revenue_MAD` | Holds for all rows |
| Every `Region` in `sales` exists in `regional_targets` | Yes, and vice versa |
| Every city maps to exactly one region | Yes |

---

## 11. Known limitations

- **Synthetic data.** Seasonality, regional shares, margins and churn patterns reflect the assumptions of the generator, not real market behaviour. Findings illustrate the analytical method, not facts about the real company.
- **Target period mismatch.** `Annual_Target_MAD` is a yearly figure, but sales cover 21 months. Target Attainment (54.48%) therefore compares 21 months of revenue with one year of target. In this project the target is treated as a fixed benchmark for the whole period; a production version would use period-matched targets.
- **No customer identifier.** The sales table has no customer ID, so ARPU is approximated as average net revenue per transaction, and customer-level churn cannot be tracked over time.
- **Churn is a score, not an outcome.** `Churn_Risk_Level` is a modelled label; there is no record of customers who actually left.
- **`Transaction_ID` carries a constant year.** The "2026" in every ID is a fixed prefix, not the sale year (292 of 500 rows have a `Date` in 2025). Use `Date` for any time analysis.
- **Small samples at city level.** Several cities have fewer than 20 transactions (Fès 19, Agadir 19, Meknès 13), so city-level rankings are indicative only.
