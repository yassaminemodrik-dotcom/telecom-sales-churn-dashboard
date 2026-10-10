# 🧮 DAX Measures Reference — Orange Morocco Dashboard

This document details all DAX calculations created for the **Orange Morocco Sales Performance & Churn Intelligence** Power BI report.

---

## 📊 Core Revenue & Commercial KPIs

### 1. Total Net Revenue
Calculates the aggregate net sales revenue across all commercial channels.
```dax
Total Revenue MAD = SUM('Orange_Morocco_Sales_Master'[Net_Revenue_MAD])
```

### 2. Average Revenue Per User / Transaction (ARPU)
Calculates the mean revenue generated per transaction across B2B and B2C segments.
```dax
ARPU MAD = AVERAGE('Orange_Morocco_Sales_Master'[Net_Revenue_MAD])
```

### 3. Total Gross Margin
Sums the total gross margin in MAD across all product lines.
```dax
Total Gross Margin MAD = SUM('Orange_Morocco_Sales_Master'[Gross_Margin_MAD])
```

### 4. Gross Margin Percentage
Calculates the gross profit margin percentage relative to total net revenue.
```dax
Gross Margin % = 
DIVIDE(
    [Total Gross Margin MAD], 
    [Total Revenue MAD], 
    0
)
```

---

## 🎯 Target Realization & Performance Metrics

### 5. Regional Annual Target
Pulls the target revenue allocation per region from the targets dimension table.
```dax
Total Target MAD = SUM('Orange_Regional_Targets'[Annual_Target_MAD])
```

### 6. Target Attainment Percentage
Measures commercial target realization rate against regional target allocations.
```dax
Target Attainment % = 
DIVIDE(
    [Total Revenue MAD], 
    [Total Target MAD], 
    0
)
```

---

## ⚠️ Churn & Attrition Intelligence Metrics

### 7. Revenue at Risk (High Churn Risk)
Calculates net revenue exposed to high customer attrition risk.
```dax
Revenue At Risk MAD = 
CALCULATE(
    [Total Revenue MAD], 
    'Orange_Morocco_Sales_Master'[Churn_Risk_Level] = "High"
)
```

### 8. High Churn Risk Percentage (by Net Revenue)
Calculates the proportion of total company revenue classified under high churn exposure.
```dax
High Churn Risk % (by Revenue) = 
DIVIDE(
    [Revenue At Risk MAD],
    [Total Revenue MAD],
    0
)
```

### 9.  Average NPS Score
Calculates the average Net Promoter Score across all surveyed customer accounts.
```dax
Average NPS Score = AVERAGE('Orange_Morocco_Sales_Master'[NPS_Score])
```
