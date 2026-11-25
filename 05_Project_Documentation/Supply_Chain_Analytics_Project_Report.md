# Supply Chain Analytics -- Project Report

## 1. Project Overview

**Project title:** Supply Chain Performance, Inventory & Logistics
Analytics\
**Project type:** End-to-end Data Analyst portfolio project\
**Dataset size:** 120,000 order-line records\
**Date coverage:** 1 January 2024 -- 30 December 2025\
**Unique row identifier:** `Order_Line_ID`

This project analyzes supply chain operations to understand sales
performance, profitability, delivery efficiency, inventory availability,
and product returns. It follows an end-to-end analytics workflow using
Microsoft Excel, MySQL, Python, and Power BI.

## 2. Business Objectives

-   Measure revenue, profit, and profit margin.
-   Compare performance across categories, products, regions, customers,
    and payment methods.
-   Examine delivery duration and on-time delivery.
-   Review shipping costs and shipping-type performance.
-   Assess inventory availability and low-stock patterns.
-   Analyze returns by category, region, and shipping type.
-   Validate data quality and calculated metrics.

## 3. Dataset Overview

  Attribute           Description
  ------------------- --------------------------
  Domain              Supply Chain
  Records             120,000
  Original columns    34
  Data grain          Order-line level
  Date coverage       2024-01-01 to 2025-12-30
  Unique identifier   `Order_Line_ID`

The dataset includes order, customer, product, supplier, warehouse,
shipping, inventory, payment, delivery-date, revenue, and profit
information.

## 4. Tools and Technologies

  -----------------------------------------------------------------------
  Tool                                Project use
  ----------------------------------- -----------------------------------
  Microsoft Excel                     Data inspection, cleaning, Pivot
                                      Tables, and initial analysis

  MySQL Workbench                     Data import, SQL transformations,
                                      validation, and business queries

  Python                              Exploratory Data Analysis

  Pandas                              Data loading, preparation,
                                      grouping, and analysis

  NumPy                               Numerical operations

  Matplotlib                          Data visualization

  Power BI                            Data modeling, DAX, interactive
                                      dashboards, and reporting

  GitHub                              Project organization and portfolio
                                      publication
  -----------------------------------------------------------------------

## 5. Project Workflow

### 5.1 Excel -- Data Cleaning and Initial Analysis

The Excel stage was used to inspect and prepare the dataset and perform
initial analysis.

Work included: - Inspecting the dataset and checking data quality. -
Trimming and standardizing text values. - Reviewing missing, duplicate,
negative, and invalid values. - Preparing analytical fields such as
revenue, total cost, profit, and operational metrics. - Using Pivot
Tables and charts to explore delivery, inventory, category, and
profitability patterns.

Detailed steps are documented in
`01_Excel_Analysis/Excel_Analysis_Workflow.md`.

### 5.2 MySQL -- Data Preparation, Validation, and Business Analysis

The SQL workflow used three tables:

-   `supply_chain_raw` -- imported source table.
-   `supply_chain` -- typed working table.
-   `supply_chain_clean` -- cleaned output table.

Work included: - Importing the dataset into MySQL Workbench. - Applying
appropriate data types. - Checking missing values and duplicate
records. - Investigating date sequence and delivery-status
inconsistencies. - Reviewing missing numeric and categorical values. -
Validating revenue, total cost, profit, and profit margin. - Reviewing
inventory and return-flag consistency. - Writing SQL queries to answer
20 business questions.

#### Key SQL validation results

  Validation                                             Result
  --------------------------------------------------- ---------
  Total rows checked                                    120,000
  Distinct `Order_Line_ID` values                       120,000
  Duplicate `Order_Line_ID` rows                              0
  Exact duplicate business records in tested fields           0
  Negative revenue records                                    0
  Negative total-cost records                                 0
  Negative profit records                                10,131
  Negative delivery-day records identified                   60
  Inventory-status logic mismatches in tested check           0

Negative profit records were retained because they may represent genuine
business losses; they were not automatically treated as invalid data.

#### Data-quality observations

-   Missing values were investigated field by field. Where reliable
    replacement values were unavailable, NULL values were retained.
-   Sixty records had an actual delivery date earlier than the ship
    date. These records were investigated, and the corresponding
    delivery-day values were treated as invalid for delivery-duration
    analysis.
-   Eighty-four records had an actual delivery date while the order
    status was `Processing` or `In Transit` (46 `Processing`, 38
    `In Transit`). These inconsistencies were documented rather than
    silently rewritten.
-   There were 59 records with `Unknown` order status and a missing
    expected delivery date.
-   `Order_ID` can repeat because an order may contain multiple order
    lines. `Order_Line_ID` was used as the unique row identifier.

SQL scripts, business analysis, and selected validation evidence are
stored in `02_SQL_Analysis/`.

### 5.3 Python -- Exploratory Data Analysis

Python EDA was performed in Jupyter Notebook using Pandas, NumPy, and
Matplotlib.

The analysis included: - Loading and inspecting the dataset. - Checking
shape, column types, missing values, duplicates, and descriptive
statistics. - Converting and validating date fields. - Examining
delivery-day distributions. - Analyzing order status, regions, product
categories, shipping types, payment methods, inventory, and returns. -
Comparing revenue and profit across categories, regions, products,
customers, and shipping types. - Creating charts to communicate
patterns. - Reviewing key metrics and data-quality results.

#### Selected Python findings

-   The valid delivery-day analysis contained 115,738 records; mean
    delivery duration was 5.86 days.
-   The return rate was 5.87%.
-   Electronics had the highest category revenue in the analysis.
-   Apparel had the highest category profit margin at approximately
    24.90%.
-   Home & Kitchen had the highest category return rate at approximately
    6.04%.
-   West had the highest regional return rate at approximately 6.00%.
-   Economy shipping had the highest on-time delivery rate among
    shipping types at approximately 28.28%.

The detailed workflow and code explanations are documented in
`03_Python_EDA/PYTHON_EDA_WORKFLOW.md`.

### 5.4 Power BI -- Data Modeling and Dashboard Development

The Power BI report contains five pages with KPI cards, charts, slicers,
navigation buttons, and reset-filter functionality.

#### Page 1 -- Home

-   Project introduction.
-   Navigation to the four analytical dashboard pages.

#### Page 2 -- Executive Overview

KPIs: - Total Revenue - Total Profit - Overall Profit Margin - Total
Orders - On-Time Delivery Rate - Overall Return Rate

Visuals: - Monthly Revenue & Profit Trend - Revenue by Region - Revenue
Contribution by Payment Method

#### Page 3 -- Sales & Profit Analysis

KPIs: - Total Revenue - Total Profit - Overall Profit Margin - Average
Order Value - Total Customers - Total Quantity Sold

Visuals: - Revenue and Profit by Product Category - Top 10 Products by
Revenue - Revenue Contribution by Product Category - Profit Margin by
Product Category - Top 10 Customers by Profit - Revenue vs. Profit by
Product

#### Page 4 -- Delivery & Logistics Analysis

KPIs: - Average Delivery Days - On-Time Delivery Rate - Late
Deliveries - Average Shipping Cost - Same-Day On-Time Delivery Rate

Visuals: - Average Delivery Days by Shipping Type - On-Time Delivery
Rate by Shipping Type - Delivery Performance by Region - Monthly On-Time
Delivery Trend - Shipping Cost Contribution by Shipping Type

#### Page 5 -- Inventory & Returns Analysis

KPIs: - Adequate Stock - Low Stock - Low Stock Rate - Returned Orders -
Return Rate

Visuals: - Inventory Status Distribution - Low Stock Records by Product
Category - Low Stock Rate by Warehouse - Return Rate by Product
Category - Return Rate by Region

The report uses a consistent visual theme and includes Year, Region,
Product Category, and Shipping Type slicers. Reset-filter bookmarks and
page navigation were added to improve usability.

The Power BI file and detailed workflow are stored in
`04_PowerBI_Dashboard/`.

## 6. Overall Business Metrics

The following are the overall metrics reported in the project analysis:

  Metric                              Result
  ------------------------------ -----------
  Total Revenue                    ₹21.93 Cr
  Total Profit                      ₹5.43 Cr
  Overall Profit Margin               24.76%
  Average Delivery Days            5.86 days
  On-Time Delivery Rate               27.93%
  Overall Return Rate                  5.87%
  Total Orders (dashboard KPI)        63,860

Dashboard values can change when slicers and filters are applied. KPI
definitions and filter context should be considered when comparing
results across tools.

## 7. Key Business Findings

### Sales and Profitability

-   Electronics generated the highest revenue among product categories.
-   Apparel recorded the highest category profit margin, approximately
    24.90%.
-   UPI was the leading payment method by revenue.
-   Product 607 ranked first by revenue among the products examined in
    the top-product analysis.
-   The South region generated the highest revenue among regions.

### Delivery and Logistics

-   Average delivery duration was 5.86 days.
-   The overall on-time delivery rate was 27.93%.
-   Economy shipping recorded the highest on-time delivery rate at
    approximately 28.28%.
-   Same Day shipping had the shortest average delivery duration at
    approximately 3.15 days.
-   Same Day shipping had the highest average shipping cost among
    shipping types in the analysis.

### Inventory and Returns

-   There were 20,330 low-stock records and 98,623 adequate-stock
    records.
-   Electronics had the highest low-stock record count among product
    categories.
-   Warehouse 14 had the highest low-stock rate in the warehouse
    comparison, approximately 18.43%.
-   Home & Kitchen had the highest category return rate, approximately
    6.04%.
-   West had the highest regional return rate, approximately 6.00%.

## 8. Potential Business Actions

The findings suggest areas for further investigation:

1.  **Delivery performance:** Review causes of late deliveries and
    compare performance by region and shipping type.
2.  **Inventory planning:** Review low-stock patterns, particularly in
    categories and warehouses with higher low-stock rates.
3.  **Returns management:** Investigate reasons behind higher return
    rates in Home & Kitchen and the West region.
4.  **Profitability:** Review products and order lines with negative
    profit to understand pricing, discount, and cost drivers.
5.  **Data quality:** Improve operational capture of delivery dates and
    order statuses to reduce incomplete or inconsistent records.

These are investigation opportunities based on the observed analysis,
not proof of specific root causes.

## 9. Repository Structure

``` text
Supply-Chain-Analytics-Complete-Data-Analyst-Project/
│
├── README.md
│
├── 01_Excel_Analysis/
│   ├── Supply_Chain_Final_Dataset.csv
│   ├── Excel_Analysis_Workflow.md
│   └── Screenshots/
│
├── 02_SQL_Analysis/
│   ├── Supply_Chain_SQL_Project.sql
│   ├── SQL_Business_Analysis.pdf
│   ├── SQL_Validation_Outputs/
│   └── SQL_Screenshots/
│
├── 03_Python_EDA/
│   ├── PYTHON_EDA_WORKFLOW.md
│   ├── notebooks/
│   ├── visuals/
│   └── Screenshots/
│
├── 04_PowerBI_Dashboard/
│   ├── Supply_Chain_Analytics_Dashboard.pbix
│   ├── POWER_BI_WORKFLOW.md
│   └── Screenshots/
│
└── 05_Project_Documentation/
    └── Supply_Chain_Analytics_Project_Report.md
```

## 10. Project Outcome

This project demonstrates an end-to-end data analytics workflow across
Excel, MySQL, Python, and Power BI. It covers data preparation, quality
checks, SQL-based business analysis, exploratory analysis, dashboard
development, and communication of business findings.

The project demonstrates practical skills in data cleaning, data
validation, analytical querying, exploratory data analysis, DAX,
visualization, and business reporting.

------------------------------------------------------------------------

**Project:** Supply Chain Performance, Inventory & Logistics Analytics\
**Tools:** Microsoft Excel \| MySQL \| Python \| Power BI\
**Dataset:** 120,000 order-line records
