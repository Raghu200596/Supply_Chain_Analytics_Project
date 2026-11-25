# Supply Chain Analytics – Python EDA Workflow

## Objective
Explore the 120,000-row, 34-column supply chain dataset, identify data-quality issues, understand operational patterns and produce insights for Power BI.

## Tools
- Python and Jupyter Notebook
- pandas (`pd`) for loading, cleaning and grouping data
- NumPy (`np`) for numerical operations and missing-value handling
- Matplotlib (`plt`) for visualizations

```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
%matplotlib inline

df = pd.read_csv("supply_chain_cleaned.csv")
```

## Initial inspection
```python
df.shape
df.head()
df.columns
df.info()
df.isnull().sum()
df.duplicated().sum()
df.describe()
```
These inspect dimensions, sample records, columns, data types, nulls, duplicates and numeric summaries.

## Date and delivery validation
Converted date columns to datetime and checked date consistency. Sixty records had Actual_Delivery_Date earlier than Ship_Date by 1–3 days; Delivery_Days was set to missing for these invalid intervals.

The analysis found 4,520 zero-day delivery values. Of these, 318 were confirmed valid same-day deliveries; unverified zero values were treated as missing. Final Delivery_Days missing count: 4,262; valid values: 115,738.

```python
df["Order_Date"] = pd.to_datetime(df["Order_Date"], errors="coerce")
```
Apply the same conversion pattern to the other date fields used in the notebook.

## Exploratory analysis
Analyzed order status, region, product category, shipping type, payment method, return flag and inventory status using counts, percentages and grouped summaries.

## Delivery performance
| Shipping type | Average days | On-time rate |
|---|---:|---:|
| Same Day | 3.15 | 26.87% |
| Express | 4.09 | 28.01% |
| Standard | 6.10 | 27.90% |
| Economy | 8.09 | 28.28% |

## Inventory
- Adequate Stock: 98,623
- Low Stock: 20,330
- Missing inventory status: 1,047
- Low-stock rate among known inventory statuses: 17.09%
- Electronics category low-stock rate: 17.26%
- Warehouse 14 low-stock rate: 18.43%

## Sales and profitability
- Revenue: ₹21.93 Cr
- Profit: ₹5.43 Cr
- Overall profit margin: 24.76%
- Electronics had the highest category revenue (₹37,054,192.67) and profit (₹9,155,075.99).
- Apparel had the highest category margin (24.90%).

## Customer and product analysis
- Customer 9486 had the highest reported customer revenue (₹66,424.32) and profit (₹23,648.07).
- Product 607 ranked first by revenue (₹386,644.40).
- Product 744 ranked second by revenue and had the highest profit among the top 10 revenue products in the reported analysis.

## Returns
- Returned records: 7,041
- Overall return rate: 5.87%
- Home & Kitchen had the highest category return rate (6.04%).
- West had the highest regional return rate (6.00%).
- Express had the highest return rate by shipping type (approximately 6.12%).

## Visualizations
Created charts for delivery-days distribution, order status, category and regional performance, inventory status, low-stock rates, monthly revenue/profit, customer and product performance, and return rates.

## Final notebook validation
- Shape: 120,000 rows × 34 columns
- Duplicate Order_Line_ID: 0
- Date range: 2024-01-01 to 2025-12-30
- Revenue total: ₹219,281,611.92
- Profit total: ₹54,291,805.83
- Delivery_Days missing: 4,262
- On_Time_Flag missing: 4,204
- Return_Flag missing: 0

**Reconciliation note:** The CSV later used in Power BI showed no missing values in Revenue, Profit, Profit_Margin and Delivery_Days, while the notebook validation reported missing values in those fields. Confirm the exact export and missing-value treatment before claiming row-level parity between Python and Power BI.

## Outcome
Python EDA identified sales, delivery, inventory and return patterns, validated key fields and generated findings used to support the Power BI dashboard.
