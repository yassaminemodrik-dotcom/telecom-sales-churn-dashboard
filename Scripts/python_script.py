import pandas as pd
import numpy as np

# Set seed for reproducibility
np.random.seed(42)
n_rows = 500

# Regions & Product Mappings
regions = ["Casablanca-Settat", "Rabat-Salé-Kénitra", "Marrakech-Safi", "Tanger-Tétouan-Al Hoceïma", "Fès-Meknès", "Souss-Massa"]
products = ["Enterprise Cloud & 5G Solutions", "Fibre Optique High-Speed", "Postpaid Mobile (Offre Yo / Mobile)", "Smart Router & Hardware Add-ons", "Prepaid Recharge & Pass"]
segments = ["B2B Enterprise", "B2B SME", "B2C Premium", "B2C Families", "B2C Youth"]

# Data Generation
data = {
    "Contract_ID": [f"OR-MAR-{2025000 + i}" for i in range(n_rows)],
    "Region": np.random.choice(regions, n_rows, p=[0.30, 0.28, 0.15, 0.12, 0.10, 0.05]),
    "Product_Line": np.random.choice(products, n_rows, p=[0.15, 0.25, 0.30, 0.10, 0.20]),
    "Customer_Segment": np.random.choice(segments, n_rows),
    "Gross_Revenue_MAD": np.round(np.random.uniform(200, 8000, n_rows), 2),
    "NPS_Score": np.random.randint(1, 11, n_rows)
}

df = pd.DataFrame(data)

# Calculate Margin & Net Revenue
df["Discount_MAD"] = np.round(df["Gross_Revenue_MAD"] * np.random.uniform(0.02, 0.15, n_rows), 2)
df["Net_Revenue_MAD"] = df["Gross_Revenue_MAD"] - df["Discount_MAD"]
df["Gross_Margin_MAD"] = np.round(df["Net_Revenue_MAD"] * np.random.uniform(0.40, 0.65, n_rows), 2)

# Churn Logic: Low NPS + High Discount = Higher Risk
df["Churn_Risk_Level"] = np.where(df["NPS_Score"] <= 4, "High", np.where(df["NPS_Score"] <= 7, "Medium", "Low"))

# Export
df.to_csv("Orange_Morocco_Sales_Master.csv", index=False)
print("CSV generated successfully!")