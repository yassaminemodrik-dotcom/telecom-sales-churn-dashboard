-- 1. Table for Orange_Morocco_Sales_Master.csv
CREATE TABLE orange_morocco_sales_master (
    transaction_id VARCHAR(50) PRIMARY KEY,
    date DATE NOT NULL,
    region VARCHAR(100) NOT NULL,
    city VARCHAR(50),
    customer_segment VARCHAR(50),
    product_line VARCHAR(100),
    sales_channel VARCHAR(50),
    units_sold INT,
    unit_price_mad DECIMAL(10, 2),
    gross_revenue_mad DECIMAL(10, 2),
    discount_mad DECIMAL(10, 2),
    net_revenue_mad DECIMAL(10, 2),
    gross_margin_mad DECIMAL(10, 2),
    payment_method VARCHAR(50),
    nps_score INT,
    churn_risk_score DECIMAL(4, 2),
    churn_risk_level VARCHAR(20)
);

-- 2. Table for Orange_Regional_Targets.csv
CREATE TABLE orange_regional_targets (
    region VARCHAR(100) PRIMARY KEY,
    annual_target_mad DECIMAL(12, 2) NOT NULL,
    strategic_priority VARCHAR(100)
);
-- 1. Load Table 'Orange_Morocco_Sales_Master'
COPY orange_morocco_sales_master
FROM 'C:\Users\E L I T E B O O K\OneDrive\Desktop\orange_analysis\data\Orange_Morocco_Sales_Master.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
-- 2. Load Table 'Orange_Regional_Targets'
COPY orange_regional_targets
FROM 'C:\Users\E L I T E B O O K\OneDrive\Desktop\orange_analysis\data\Orange_Regional_Targets.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

