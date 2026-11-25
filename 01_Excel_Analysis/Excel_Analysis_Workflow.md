# Supply Chain Analytics – Excel Analysis Workflow

## 1. Project Overview

**Project Name:** Supply Chain Performance, Inventory & Logistics Analytics  
**Tool:** Microsoft Excel  
**Dataset:** Supply Chain dataset  
**Records:** 120,000 order-line records  
**Project Stage:** Data preparation, data-quality analysis and initial business analysis

### Objective

Use Excel to inspect and clean the supply chain dataset, prepare analysis-ready data, summarize key operational and financial metrics, and build charts that support business decisions.

---

## 2. Workbook Preparation

Imported the supply chain dataset into Excel and organized the workbook for analysis.

The analysis focused on fields such as:

- Order_Line_ID
- Order_ID
- Order_Date
- Product_Category
- Product_ID
- Customer_ID
- Customer_City
- Region
- Supplier_ID
- Warehouse_ID
- Quantity_Ordered
- Unit_Price
- Unit_Cost
- Discount_Pct
- Shipping_Type
- Shipping_Cost
- Expected_Delivery_Date
- Actual_Delivery_Date
- Order_Status
- Stock_Available
- Inventory_Status
- Return_Flag

The exact columns available for a particular analysis depend on the source worksheet.

---

## 3. Data Inspection and Quality Checks

Reviewed the dataset before performing transformations.

Checks included:

- Confirming the number of records and columns
- Reviewing column names and data types
- Identifying blank and null values
- Checking duplicate records and identifiers
- Looking for inconsistent text values
- Checking numeric fields for invalid or negative values
- Reviewing date columns for missing or inconsistent dates

`Order_Line_ID` was used as the unique order-line identifier. `Order_ID` can repeat because a single order may contain multiple product lines.

---

## 4. Data Cleaning with Power Query

Used Excel Power Query to prepare the data.

### Text cleaning

- Applied Trim to remove unwanted leading and trailing spaces.
- Applied Clean where needed to remove non-printing characters.
- Standardized text capitalization for consistent category and location labels.

### Data-type checks

Reviewed and assigned suitable data types to text, whole-number, decimal, date and percentage fields.

### Missing and invalid values

Inspected missing values in important fields, including:

- Supplier_ID
- Quantity_Ordered
- Unit_Price
- Unit_Cost
- Shipping_Cost
- Stock_Available
- Payment_Method
- Delivery_Days
- On_Time_Flag
- Profit_Margin

Applied field-specific cleaning rules rather than replacing every missing value with zero. Negative or invalid values were reviewed according to the meaning of each field.

### Product and warehouse fields

Reviewed and standardized Product_ID and Warehouse_ID values. A Product_ID mapping query was used as part of the preparation workflow.

### Shipping and delivery fields

Reviewed shipping-related columns and prepared delivery-related fields using the available date information. Order status logic was used to classify records into meaningful delivery-status groups, including:

- Cancelled
- Pending
- Unknown
- Delivered Late
- Delivered On Time

The classification depends on the expected and actual delivery dates and the status information available in the record.

### Return and inventory fields

Created or reviewed the Return Rate and inventory-related fields used in the analysis, including:

- Delivery_Days
- On_Time_Flag
- Inventory_Status
- Return_Rate
- Profit_Margin

Loaded the cleaned output for further analysis.

---

## 5. Data Model Preparation

Used Excel's Data Model / Power Pivot workflow to add the required tables to the model.

The workbook preparation included:

- Loading the relevant tables into the Data Model
- Reviewing the table structure
- Connecting related tables where applicable
- Preparing the model for PivotTable-based analysis

The final relationships should be checked in the workbook's Diagram View before publishing.

---

## 6. Calculated Business Fields

Prepared business fields required for financial and operational analysis.

### Revenue

Revenue is calculated using quantity, unit price and discount:

```excel
=Quantity_Ordered*Unit_Price*(1-Discount_Pct)
```

### Total Cost

```excel
=Quantity_Ordered*Unit_Cost
```

### Profit

```excel
=Revenue-Total_Cost
```

### Profit Margin

```excel
=IFERROR(Profit/Revenue,0)
```

### Delivery Days

Delivery duration is based on the difference between actual delivery date and ship date. Invalid date sequences should be treated as data-quality issues rather than valid delivery durations.

> Note: Use the corresponding structured table references or cell references in the workbook. These formulas describe the business logic; adapt the column names to the actual Excel table.

---

## 7. PivotTable Analysis

Created PivotTables to summarize key supply chain performance measures.

The analysis included:

1. Average Delivery Days by Shipping Type
2. On-Time Delivery Rate by Region
3. Inventory Status Distribution
4. Stock Availability by Product Category
5. Profit Margin by Product Category

PivotTables were used to group, aggregate and compare the data across relevant business dimensions.

---

## 8. Excel Charts and Initial Dashboard Analysis

Created charts from the PivotTable summaries to make the findings easier to understand.

The Excel analysis included charts for:

- Average Delivery Days by Shipping Type
- On-Time Delivery Rate by Region
- Inventory Status Distribution
- Stock Availability by Product Category
- Profit Margin by Product Category

Applied consistent chart formatting, clear titles, readable labels and suitable number formats.

---

## 9. Key Findings from the Overall Project Analysis

The Excel stage supported the wider project analysis. The following findings were confirmed during the combined SQL, Python and Power BI analysis:

- Electronics generated the highest product-category revenue.
- South recorded the highest regional revenue.
- Apparel had the highest category profit margin at 24.90%.
- Economy shipping had the highest on-time delivery rate at 28.28%.
- Same Day shipping had the shortest average delivery time at 3.15 days.
- Home & Kitchen had the highest category return rate at 6.04%.
- Warehouse 14 had the highest low-stock rate at 18.43%.

These are project-level findings from the completed analysis stages; they should not all be attributed to Excel PivotTables unless the corresponding result is present in the Excel workbook.

---

## 10. Quality and Validation Considerations

Before using the workbook results:

- Confirm that the cleaned data row count is as expected.
- Check that `Order_Line_ID` remains unique.
- Verify formulas against sample records.
- Check that PivotTable totals agree with their source data.
- Refresh PivotTables after updating the source.
- Confirm that percentage and currency fields use appropriate number formats.
- Review blanks and invalid values rather than silently treating them as zero.

---

## 11. Final Outcome

Completed the Excel data preparation and initial analysis stage of the end-to-end Supply Chain Analytics project.

Excel was used to inspect and clean the dataset with Power Query, prepare data for analysis, create calculated business fields, summarize performance with PivotTables, and build charts for delivery, inventory and profitability analysis.

The prepared data and findings were then used as inputs to the SQL, Python EDA and Power BI stages.

**Suggested workbook filename:** `Supply_Chain_Excel_Analysis.xlsx`
