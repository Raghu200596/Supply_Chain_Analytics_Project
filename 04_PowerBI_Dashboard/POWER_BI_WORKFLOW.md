# Supply Chain Analytics – Power BI Workflow

## 1. Overview
**Project:** Supply Chain Performance, Inventory & Logistics Analytics  
**Tool:** Microsoft Power BI Desktop  
**Dataset:** Cleaned supply chain dataset  
**Records:** 120,000 order-line records; 34 columns

**Objective:** Build an interactive dashboard for sales, profitability, delivery, inventory and returns.

## 2. Data loading and validation
Imported the cleaned CSV and checked row counts, key fields, data types, duplicates and totals.
- Total records: 120,000
- Distinct Order_Line_ID: 120,000
- Duplicate Order_Line_ID: 0
- Revenue: approximately ₹21.93 Cr
- Profit: approximately ₹5.43 Cr
- Missing On_Time_Flag: 4,204

Missing On_Time_Flag values were excluded from on-time and late-delivery calculations.

## 3. Data model
Used a single-table model with the main table named `Supply_Chain`.

## 4. Measures and calculated fields
Created measures for total revenue, total profit, profit margin, total orders, average order value, total customers, quantity sold, average delivery days, on-time rate, late deliveries, average shipping cost, same-day on-time rate, adequate stock, low stock, low-stock rate, returned records and return rate.

### Selected DAX definitions
```dax
Product Profit Margin =
DIVIDE([Total Profit], [Total Revenue], 0)
```
```dax
Average Delivery Days =
AVERAGE(Supply_Chain[Delivery_Days])
```
```dax
Average Shipping Cost =
AVERAGE(Supply_Chain[Shipping_Cost])
```
```dax
Late Deliveries =
CALCULATE(
    COUNTROWS(Supply_Chain),
    Supply_Chain[On_Time_Flag] = 0,
    NOT(ISBLANK(Supply_Chain[On_Time_Flag]))
)
```
```dax
Adequate Stock Records =
CALCULATE(
    COUNTROWS(Supply_Chain),
    Supply_Chain[Inventory_Status] = "Adequate Stock"
)
```
```dax
Total Returned Records =
CALCULATE(
    COUNTROWS(Supply_Chain),
    Supply_Chain[Return_Flag] = "Yes"
)
```
```dax
Low Stock Rate =
DIVIDE(
    CALCULATE(COUNTROWS(Supply_Chain), Supply_Chain[Inventory_Status] = "Low Stock"),
    CALCULATE(
        COUNTROWS(Supply_Chain),
        Supply_Chain[Inventory_Status] IN {"Low Stock", "Adequate Stock"}
    ),
    0
)
```
```dax
Return Rate =
DIVIDE(
    CALCULATE(COUNTROWS(Supply_Chain), Supply_Chain[Return_Flag] = "Yes"),
    CALCULATE(COUNTROWS(Supply_Chain), Supply_Chain[Return_Flag] IN {"Yes", "No"}),
    0
)
```

### Display columns
```dax
Payment Method Display =
VAR PaymentValue = TRIM(COALESCE(Supply_Chain[Payment_Method], ""))
RETURN IF(PaymentValue = "", "Unknown", PaymentValue)
```
```dax
Inventory Status Display =
VAR StatusValue = TRIM(COALESCE(Supply_Chain[Inventory_Status], ""))
RETURN IF(StatusValue = "", "Unknown / Blank", StatusValue)
```

## 5. Dashboard pages

### Executive Overview
KPIs: Revenue, Profit, Profit Margin, Orders, On-Time Rate, Return Rate.  
Visuals: Monthly Revenue and Profit Trend; Revenue by Region; Revenue Contribution by Payment Method.

### Sales & Profit Analysis
KPIs: Revenue, Profit, Profit Margin, Average Order Value, Customers, Quantity Sold.  
Visuals: Top 10 Customers by Profit; Top 10 Products by Revenue; Revenue Contribution by Product Category; Profit Margin by Product Category; Revenue & Profit by Product Category; Revenue vs Profit by Product.

### Delivery & Logistics Analysis
KPIs: Average Delivery Days, On-Time Rate, Late Deliveries, Average Shipping Cost, Same-Day On-Time Rate.  
Visuals: Monthly On-Time Delivery Trend; On-Time Delivery Rate by Shipping Type; Delivery Performance by Region; Average Delivery Days by Shipping Type; Shipping Cost Contribution by Shipping Type.

### Inventory & Returns Analysis
KPIs: Adequate Stock, Low Stock Records, Low Stock Rate, Returned Records, Overall Return Rate.  
Visuals: Return Rate by Region; Return Rate by Product Category; Low Stock Records by Product Category; Low Stock Rate by Warehouse; Inventory Status Distribution.

## 6. Interactivity
Added Year, Region, Product Category and Shipping Type slicers; page navigation buttons; Home buttons; Reset Filters bookmarks; and cross-filtering between visuals. Tested slicer interactions and reset behavior.

## 7. Theme and formatting
| Colour | Hex | Usage |
|---|---|---|
| Dark Navy | #0A3A44 | Titles and text |
| Primary Teal | #0F7C8C | Main chart series |
| Turquoise | #17BEBB | Secondary series and accents |
| Mint | #A9E8DC | KPI backgrounds |
| Cream | #FFF9F0 | Report canvas |
| Gridline Grey-Green | #E6EFEC | Gridlines |
| White | #FFFFFF | Text on dark backgrounds |

## 8. Overall KPIs
| KPI | Result |
|---|---:|
| Total Revenue | ₹21.93 Cr |
| Total Profit | ₹5.43 Cr |
| Overall Profit Margin | 24.76% |
| Total Orders | 63,860 |
| Average Delivery Days | 5.86 |
| On-Time Delivery Rate | 27.93% |
| Overall Return Rate | 5.87% |
| Low Stock Rate | 17.09% |

## 9. Key insights
1. Electronics generated the highest category revenue.
2. South recorded the highest regional revenue.
3. Apparel had the highest category profit margin (24.90%).
4. UPI generated the highest revenue among payment methods.
5. Economy shipping had the highest on-time rate (28.28%).
6. Same Day shipping had the shortest average delivery time (3.15 days).
7. Home & Kitchen had the highest category return rate (6.04%).
8. West had the highest regional return rate (6.00%).
9. Warehouse 14 had the highest low-stock rate (18.43%).
10. Overall low-stock rate was 17.09%.

## 10. Outcome
Developed a four-page interactive Power BI report covering executive performance, sales and profit, delivery and logistics, and inventory and returns.

**PBIX file:** `Supply_Chain_Analytics_Dashboard.pbix`

**Reconciliation note:** The CSV used in Power BI showed no missing values in some financial and delivery fields, while the Python notebook's final validation reported missing values. Confirm the exact export and missing-value treatment before claiming row-level parity.
