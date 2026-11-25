CREATE DATABASE supply_chain_analysis;

USE supply_chain_analysis;

SELECT COUNT(*) AS imported_rows FROM supply_chain_raw;

DESCRIBE supply_chain_raw;

ALTER TABLE supply_chain_raw RENAME COLUMN `ï»¿Order_Line_ID` TO Order_Line_ID;

USE supply_chain_analysis;

SELECT COUNT(*) AS imported_rows
FROM supply_chain_raw;

DESCRIBE supply_chain_raw;

ALTER TABLE supply_chain_raw RENAME COLUMN `Delivary Days` TO Delivery_Days;
ALTER TABLE supply_chain_raw RENAME COLUMN `Inventary_Status` TO Inventory_Status;

SELECT
    Order_Date,
    Ship_Date,
    Expected_Delivery_Date,
    Actual_Delivery_Date
FROM supply_chain_raw
WHERE
    (Order_Date IS NOT NULL AND TRIM(Order_Date) <> ''
        AND STR_TO_DATE(Order_Date, '%d-%m-%Y') IS NULL)
    OR
    (Ship_Date IS NOT NULL AND TRIM(Ship_Date) <> ''
        AND STR_TO_DATE(Ship_Date, '%d-%m-%Y') IS NULL)
    OR
    (Expected_Delivery_Date IS NOT NULL AND TRIM(Expected_Delivery_Date) <> ''
        AND STR_TO_DATE(Expected_Delivery_Date, '%d-%m-%Y') IS NULL)
    OR
    (Actual_Delivery_Date IS NOT NULL AND TRIM(Actual_Delivery_Date) <> ''
        AND STR_TO_DATE(Actual_Delivery_Date, '%d-%m-%Y') IS NULL)
LIMIT 20;

CREATE TABLE supply_chain AS
SELECT
    CAST(NULLIF(TRIM(Order_Line_ID), '') AS UNSIGNED) AS Order_Line_ID,
    CAST(NULLIF(TRIM(Order_ID), '') AS UNSIGNED) AS Order_ID,

    STR_TO_DATE(NULLIF(TRIM(Order_Date), ''), '%d-%m-%Y') AS Order_Date,

    CAST(NULLIF(TRIM(Customer_ID), '') AS UNSIGNED) AS Customer_ID,
    Customer_City,
    Region,
    CAST(NULLIF(TRIM(Product_ID), '') AS UNSIGNED) AS Product_ID,
    CAST(NULLIF(TRIM(Supplier_ID), '') AS UNSIGNED) AS Supplier_ID,
    CAST(NULLIF(TRIM(Warehouse_ID), '') AS UNSIGNED) AS Warehouse_ID,
    CAST(NULLIF(TRIM(Reorder_Level), '') AS UNSIGNED) AS Reorder_Level,

    Shipping_Type,

    STR_TO_DATE(NULLIF(TRIM(Ship_Date), ''), '%d-%m-%Y') AS Ship_Date,
    STR_TO_DATE(NULLIF(TRIM(Expected_Delivery_Date), ''), '%d-%m-%Y') AS Expected_Delivery_Date,
    STR_TO_DATE(NULLIF(TRIM(Actual_Delivery_Date), ''), '%d-%m-%Y') AS Actual_Delivery_Date,

    Payment_Method,
    Return_Flag,
    Product_Name,
    Product_Category,

    CAST(NULLIF(TRIM(Quantity_Ordered), '') AS UNSIGNED) AS Quantity_Ordered,
    CAST(NULLIF(TRIM(Unit_Price), '') AS DECIMAL(12,2)) AS Unit_Price,
    CAST(NULLIF(TRIM(Unit_Cost), '') AS DECIMAL(12,2)) AS Unit_Cost,
    CAST(NULLIF(TRIM(Discount_Pct), '') AS DECIMAL(5,4)) AS Discount_Pct,
    CAST(NULLIF(TRIM(Tax_Pct), '') AS DECIMAL(5,4)) AS Tax_Pct,
    CAST(NULLIF(TRIM(Stock_Available), '') AS UNSIGNED) AS Stock_Available,

    Order_Status,

    CAST(NULLIF(TRIM(Shipping_Cost), '') AS DECIMAL(12,2)) AS Shipping_Cost,
    CAST(NULLIF(TRIM(Return_Rate), '') AS DECIMAL(5,4)) AS Return_Rate,
    CAST(NULLIF(TRIM(Delivery_Days), '') AS SIGNED) AS Delivery_Days,

    On_Time_Flag,
    Inventory_Status,

    CAST(NULLIF(TRIM(Total_Cost), '') AS DECIMAL(14,2)) AS Total_Cost,
    CAST(NULLIF(TRIM(Profit), '') AS DECIMAL(14,2)) AS Profit,
    CAST(NULLIF(TRIM(Profit_Margin), '') AS DECIMAL(8,4)) AS Profit_Margin,
    CAST(NULLIF(TRIM(Revenue), '') AS DECIMAL(14,2)) AS Revenue

FROM supply_chain_raw;

SELECT COUNT(*) AS total_rows FROM supply_chain;

DESCRIBE supply_chain;

SELECT
    (SELECT COUNT(*) FROM supply_chain_raw) AS raw_rows,
    (SELECT COUNT(*) FROM supply_chain) AS cleaned_rows;
    
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT Order_Line_ID) AS unique_order_line_ids
FROM supply_chain;

SELECT
    COUNT(*) AS total_rows,
    SUM(Order_Line_ID IS NULL) AS missing_Order_Line_ID,
    SUM(Order_ID IS NULL) AS missing_Order_ID,
    SUM(Order_Date IS NULL) AS missing_Order_Date,
    SUM(Customer_ID IS NULL) AS missing_Customer_ID,
    SUM(Customer_City IS NULL OR TRIM(Customer_City) = '') AS missing_Customer_City,
    SUM(Region IS NULL OR TRIM(Region) = '') AS missing_Region,
    SUM(Product_ID IS NULL) AS missing_Product_ID,
    SUM(Supplier_ID IS NULL) AS missing_Supplier_ID,
    SUM(Warehouse_ID IS NULL) AS missing_Warehouse_ID,
    SUM(Reorder_Level IS NULL) AS missing_Reorder_Level,
    SUM(Shipping_Type IS NULL OR TRIM(Shipping_Type) = '') AS missing_Shipping_Type,
    SUM(Ship_Date IS NULL) AS missing_Ship_Date,
    SUM(Expected_Delivery_Date IS NULL) AS missing_Expected_Delivery_Date,
    SUM(Actual_Delivery_Date IS NULL) AS missing_Actual_Delivery_Date,
    SUM(Payment_Method IS NULL OR TRIM(Payment_Method) = '') AS missing_Payment_Method,
    SUM(Return_Flag IS NULL OR TRIM(Return_Flag) = '') AS missing_Return_Flag,
    SUM(Product_Name IS NULL OR TRIM(Product_Name) = '') AS missing_Product_Name,
    SUM(Product_Category IS NULL OR TRIM(Product_Category) = '') AS missing_Product_Category,
    SUM(Quantity_Ordered IS NULL) AS missing_Quantity_Ordered,
    SUM(Unit_Price IS NULL) AS missing_Unit_Price,
    SUM(Unit_Cost IS NULL) AS missing_Unit_Cost,
    SUM(Discount_Pct IS NULL) AS missing_Discount_Pct,
    SUM(Tax_Pct IS NULL) AS missing_Tax_Pct,
    SUM(Stock_Available IS NULL) AS missing_Stock_Available,
    SUM(Order_Status IS NULL OR TRIM(Order_Status) = '') AS missing_Order_Status,
    SUM(Shipping_Cost IS NULL) AS missing_Shipping_Cost,
    SUM(Return_Rate IS NULL) AS missing_Return_Rate,
    SUM(Delivery_Days IS NULL) AS missing_Delivery_Days,
    SUM(On_Time_Flag IS NULL OR TRIM(On_Time_Flag) = '') AS missing_On_Time_Flag,
    SUM(Inventory_Status IS NULL OR TRIM(Inventory_Status) = '') AS missing_Inventory_Status,
    SUM(Total_Cost IS NULL) AS missing_Total_Cost,
    SUM(Profit IS NULL) AS missing_Profit,
    SUM(Profit_Margin IS NULL) AS missing_Profit_Margin,
    SUM(Revenue IS NULL) AS missing_Revenue
FROM supply_chain;

SELECT
    SUM(TRIM(Order_Line_ID) = '') AS blank_Order_Line_ID,
    SUM(TRIM(Order_ID) = '') AS blank_Order_ID,
    SUM(TRIM(Order_Date) = '') AS blank_Order_Date,
    SUM(TRIM(Customer_ID) = '') AS blank_Customer_ID,
    SUM(TRIM(Supplier_ID) = '') AS blank_Supplier_ID,
    SUM(TRIM(Payment_Method) = '') AS blank_Payment_Method,
    SUM(TRIM(Quantity_Ordered) = '') AS blank_Quantity_Ordered,
    SUM(TRIM(Unit_Price) = '') AS blank_Unit_Price,
    SUM(TRIM(Unit_Cost) = '') AS blank_Unit_Cost,
    SUM(TRIM(Shipping_Cost) = '') AS blank_Shipping_Cost
FROM supply_chain_raw;

SELECT
    SUM(Quantity_Ordered <= 0) AS invalid_quantity,
    SUM(Unit_Price < 0) AS negative_unit_price,
    SUM(Unit_Cost < 0) AS negative_unit_cost,
    SUM(Discount_Pct < 0 OR Discount_Pct > 1) AS invalid_discount_pct,
    SUM(Tax_Pct < 0 OR Tax_Pct > 1) AS invalid_tax_pct,
    SUM(Stock_Available < 0) AS negative_stock,
    SUM(Shipping_Cost < 0) AS negative_shipping_cost,
    SUM(Revenue < 0) AS negative_revenue
FROM supply_chain;

SELECT
    'Payment_Method' AS column_name,
    COUNT(*) AS missing_count
FROM supply_chain_raw
WHERE Payment_Method IS NULL OR TRIM(Payment_Method) = ''

UNION ALL

SELECT
    'Quantity_Ordered',
    COUNT(*)
FROM supply_chain_raw
WHERE Quantity_Ordered IS NULL OR TRIM(Quantity_Ordered) = ''

UNION ALL

SELECT
    'Unit_Price',
    COUNT(*)
FROM supply_chain_raw
WHERE Unit_Price IS NULL OR TRIM(Unit_Price) = ''

UNION ALL

SELECT
    'Unit_Cost',
    COUNT(*)
FROM supply_chain_raw
WHERE Unit_Cost IS NULL OR TRIM(Unit_Cost) = ''

UNION ALL

SELECT
    'Shipping_Cost',
    COUNT(*)
FROM supply_chain_raw
WHERE Shipping_Cost IS NULL OR TRIM(Shipping_Cost) = '';

SELECT
    Order_Line_ID,
    Order_ID,
    Product_Name,
    Product_Category,
    Quantity_Ordered,
    Unit_Price,
    Unit_Cost,
    Shipping_Cost,
    Revenue,
    Profit
FROM supply_chain_raw
WHERE Quantity_Ordered IS NULL OR TRIM(Quantity_Ordered) = ''
   OR Unit_Price IS NULL OR TRIM(Unit_Price) = ''
   OR Unit_Cost IS NULL OR TRIM(Unit_Cost) = ''
   OR Shipping_Cost IS NULL OR TRIM(Shipping_Cost) = ''
LIMIT 20;

SELECT
    Order_Line_ID,
    Order_ID,
    Quantity_Ordered,
    Unit_Price,
    Discount_Pct,
    Revenue,
    Unit_Cost,
    Profit
FROM supply_chain_raw
WHERE CAST(Revenue AS DECIMAL(14,2)) = 0
LIMIT 20;

SELECT
    COUNT(*) AS zero_revenue_rows,
    SUM(
        Quantity_Ordered IS NULL
        OR TRIM(Quantity_Ordered) = ''
    ) AS zero_revenue_with_missing_quantity,
    SUM(
        Unit_Price IS NULL
        OR TRIM(Unit_Price) = ''
    ) AS zero_revenue_with_missing_unit_price,
    SUM(
        Quantity_Ordered IS NOT NULL
        AND TRIM(Quantity_Ordered) <> ''
        AND Unit_Price IS NOT NULL
        AND TRIM(Unit_Price) <> ''
    ) AS zero_revenue_with_quantity_and_price
FROM supply_chain_raw
WHERE CAST(Revenue AS DECIMAL(14,2)) = 0;

SELECT
    COUNT(*) AS missing_unit_cost_rows,
    SUM(
        Quantity_Ordered IS NOT NULL
        AND TRIM(Quantity_Ordered) <> ''
        AND Unit_Price IS NOT NULL
        AND TRIM(Unit_Price) <> ''
    ) AS rows_with_quantity_and_price,
    SUM(
        Revenue IS NOT NULL
        AND CAST(Revenue AS DECIMAL(14,2)) <> 0
    ) AS rows_with_nonzero_revenue
FROM supply_chain_raw
WHERE Unit_Cost IS NULL OR TRIM(Unit_Cost) = '';

SELECT
    COUNT(*) AS missing_shipping_cost_rows,
    SUM(
        Order_Status = 'Delivered On Time'
    ) AS delivered_on_time,
    SUM(
        Order_Status = 'Delivered Late'
    ) AS delivered_late,
    SUM(
        Order_Status NOT IN ('Delivered On Time', 'Delivered Late')
    ) AS other_order_statuses
FROM supply_chain_raw
WHERE Shipping_Cost IS NULL
   OR TRIM(Shipping_Cost) = '';
   
DESCRIBE supply_chain;

SELECT
    COUNT(*) AS total_rows,
    SUM(Payment_Method IS NULL) AS missing_payment_method,
    SUM(Quantity_Ordered IS NULL) AS missing_quantity,
    SUM(Unit_Price IS NULL) AS missing_unit_price,
    SUM(Unit_Cost IS NULL) AS missing_unit_cost,
    SUM(Shipping_Cost IS NULL) AS missing_shipping_cost,
    SUM(Ship_Date IS NULL) AS missing_ship_date,
    SUM(Expected_Delivery_Date IS NULL) AS missing_expected_delivery_date,
    SUM(Actual_Delivery_Date IS NULL) AS missing_actual_delivery_date
FROM supply_chain;

SELECT
    Order_Line_ID,
    Order_ID,
    Product_Name,
    Product_Category,
    Quantity_Ordered,
    Unit_Price,
    Unit_Cost,
    Revenue,
    Profit
FROM supply_chain
WHERE Quantity_Ordered IS NULL
LIMIT 20;

SELECT
    Order_Line_ID,
    Order_ID,
    Product_Name,
    Product_Category,
    Quantity_Ordered,
    Unit_Price,
    Unit_Cost,
    Revenue,
    Profit
FROM supply_chain
WHERE Unit_Price IS NULL
LIMIT 20;

SELECT
    Order_Line_ID,
    Order_ID,
    Product_Name,
    Product_Category,
    Quantity_Ordered,
    Unit_Price,
    Unit_Cost,
    Shipping_Cost,
    Revenue,
    Total_Cost,
    Profit
FROM supply_chain
WHERE Unit_Cost IS NULL
LIMIT 20;

SELECT
    Order_Line_ID,
    Order_ID,
    Product_Name,
    Product_Category,
    Shipping_Type,
    Order_Status,
    Shipping_Cost,
    Revenue,
    Profit
FROM supply_chain
WHERE Shipping_Cost IS NULL
LIMIT 20;

SELECT
    Order_Line_ID,
    Order_ID,
    Order_Date,
    Ship_Date,
    Expected_Delivery_Date,
    Actual_Delivery_Date,
    Shipping_Type,
    Order_Status,
    Delivery_Days,
    On_Time_Flag
FROM supply_chain
WHERE Ship_Date IS NULL
LIMIT 20;

SELECT
    Order_Line_ID,
    Order_ID,
    Order_Date,
    Ship_Date,
    Expected_Delivery_Date,
    Actual_Delivery_Date,
    Shipping_Type,
    Order_Status,
    Delivery_Days,
    On_Time_Flag
FROM supply_chain
WHERE Ship_Date IS NULL
LIMIT 20;

SELECT
    COUNT(*) AS missing_ship_date_rows,
    SUM(Order_Status = 'Delivered On Time') AS delivered_on_time,
    SUM(Order_Status = 'Delivered Late') AS delivered_late,
    SUM(Order_Status = 'Cancelled') AS cancelled,
    SUM(Order_Status = 'Shipped') AS shipped
FROM supply_chain
WHERE Ship_Date IS NULL;

SELECT
    SUM(Ship_Date IS NULL) AS missing_ship_date,
    SUM(Actual_Delivery_Date < Ship_Date) AS actual_delivery_before_ship,
    SUM(
        Ship_Date IS NULL
        AND Actual_Delivery_Date IS NOT NULL
    ) AS missing_ship_but_actual_delivery_exists
FROM supply_chain;

SELECT
    Order_Line_ID,
    Order_Status,
    Order_Date,
    Ship_Date,
    Expected_Delivery_Date,
    Actual_Delivery_Date
FROM supply_chain
WHERE Ship_Date IS NULL
   OR Actual_Delivery_Date < Ship_Date
ORDER BY Order_Line_ID;

SELECT
    SUM(Ship_Date IS NULL) AS missing_ship_date,
    SUM(
        Ship_Date IS NOT NULL
        AND Actual_Delivery_Date < Ship_Date
    ) AS actual_before_ship_with_ship_date,
    SUM(
        Ship_Date IS NULL
        AND Actual_Delivery_Date IS NOT NULL
    ) AS missing_ship_but_actual_exists,
    SUM(Actual_Delivery_Date IS NULL) AS missing_actual_delivery
FROM supply_chain;

SELECT
    Order_Status,
    COUNT(*) AS missing_actual_delivery_rows
FROM supply_chain
WHERE Actual_Delivery_Date IS NULL
GROUP BY Order_Status
ORDER BY missing_actual_delivery_rows DESC;

SELECT
    Order_Status,
    COUNT(*) AS missing_actual_delivery_rows,
    ROUND(SUM(Revenue), 2) AS associated_revenue
FROM supply_chain
WHERE Actual_Delivery_Date IS NULL
GROUP BY Order_Status
ORDER BY associated_revenue DESC;

SELECT
    Region,
    COUNT(*) AS missing_actual_delivery_rows,
    ROUND(SUM(Revenue), 2) AS associated_revenue
FROM supply_chain
WHERE Actual_Delivery_Date IS NULL
GROUP BY Region
ORDER BY missing_actual_delivery_rows DESC;

SELECT
    Shipping_Type,
    COUNT(*) AS missing_actual_delivery_rows,
    ROUND(SUM(Revenue), 2) AS associated_revenue
FROM supply_chain
WHERE Actual_Delivery_Date IS NULL
GROUP BY Shipping_Type
ORDER BY missing_actual_delivery_rows DESC;

SELECT
    Order_Line_ID,
    Order_Status,
    Order_Date,
    Ship_Date,
    Actual_Delivery_Date,
    DATEDIFF(Actual_Delivery_Date, Ship_Date) AS date_difference_days
FROM supply_chain
WHERE Ship_Date IS NOT NULL
  AND Actual_Delivery_Date IS NOT NULL
  AND Actual_Delivery_Date < Ship_Date
ORDER BY date_difference_days;

SELECT
    COUNT(*) AS total_negative_delivery_days,
    SUM(DATEDIFF(Actual_Delivery_Date, Ship_Date) = -1) AS delivered_1_day_early,
    SUM(DATEDIFF(Actual_Delivery_Date, Ship_Date) = -2) AS delivered_2_days_early,
    SUM(DATEDIFF(Actual_Delivery_Date, Ship_Date) = -3) AS delivered_3_days_early
FROM supply_chain
WHERE Ship_Date IS NOT NULL
  AND Actual_Delivery_Date IS NOT NULL
  AND DATEDIFF(Actual_Delivery_Date, Ship_Date) < 0;
  
SELECT
    Order_Status,
    COUNT(*) AS negative_delivery_day_rows
FROM supply_chain
WHERE Ship_Date IS NOT NULL
  AND Actual_Delivery_Date IS NOT NULL
  AND DATEDIFF(Actual_Delivery_Date, Ship_Date) < 0
GROUP BY Order_Status
ORDER BY negative_delivery_day_rows DESC;

SELECT
    COUNT(*) AS delivered_on_time_rows,
    SUM(Actual_Delivery_Date <= Expected_Delivery_Date) AS actual_date_matches_on_time_status,
    SUM(Actual_Delivery_Date > Expected_Delivery_Date) AS actual_date_conflicts_with_on_time_status
FROM supply_chain
WHERE Order_Status = 'Delivered On Time'
AND Actual_Delivery_Date IS NOT NULL
AND Expected_Delivery_Date IS NOT NULL;
  
SELECT
    COUNT(*) AS delivered_late_rows,
    SUM(Actual_Delivery_Date > Expected_Delivery_Date)
        AS actual_date_matches_late_status,
    SUM(Actual_Delivery_Date <= Expected_Delivery_Date)
        AS actual_date_conflicts_with_late_status
FROM supply_chain
WHERE Order_Status = 'Delivered Late'
  AND Actual_Delivery_Date IS NOT NULL
  AND Expected_Delivery_Date IS NOT NULL;
  
SELECT
    Order_Status,
    COUNT(*) AS status_count
FROM supply_chain
GROUP BY Order_Status
ORDER BY status_count DESC;

SELECT
    Order_Line_ID,
    Order_ID,
    Order_Date,
    Ship_Date,
    Expected_Delivery_Date,
    Actual_Delivery_Date,
    Order_Status,
    Revenue
FROM supply_chain
WHERE Order_Status = 'Unknown'
LIMIT 20;

SELECT
    COUNT(*) AS unknown_status_rows,
    SUM(Expected_Delivery_Date IS NULL) AS missing_expected_date,
    SUM(Actual_Delivery_Date IS NULL) AS missing_actual_date,
    SUM(Ship_Date IS NULL) AS missing_ship_date,
    ROUND(SUM(Revenue), 2) AS associated_revenue
FROM supply_chain
WHERE Order_Status = 'Unknown';

SELECT
    Order_Line_ID,
    Order_Status,
    Expected_Delivery_Date,
    Actual_Delivery_Date,
    Ship_Date,
    Revenue
FROM supply_chain
WHERE Order_Status = 'Unknown'
ORDER BY Order_Line_ID
LIMIT 20;

SELECT
    Order_Status,
    COUNT(*) AS total_rows,
    SUM(
        Order_Status = 'Shipped'
        AND Actual_Delivery_Date IS NOT NULL
    ) AS shipped_with_actual_delivery,
    SUM(
        Order_Status = 'Cancelled'
        AND Actual_Delivery_Date IS NOT NULL
    ) AS cancelled_with_actual_delivery,
    SUM(
        Order_Status IN ('Processing', 'Pending', 'In Transit')
        AND Actual_Delivery_Date IS NOT NULL
    ) AS in_progress_with_actual_delivery,
    SUM(
        Order_Status = 'Unknown'
        AND Expected_Delivery_Date IS NULL
    ) AS unknown_missing_expected_date
FROM supply_chain
GROUP BY Order_Status
ORDER BY total_rows DESC;

SELECT
    Order_Line_ID,
    COUNT(*) AS duplicate_count
FROM supply_chain
GROUP BY Order_Line_ID
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

SELECT
    SUM(Quantity_Ordered <= 0) AS invalid_quantity,
    SUM(Unit_Price < 0) AS negative_unit_price,
    SUM(Unit_Cost < 0) AS negative_unit_cost,
    SUM(Discount_Pct < 0 OR Discount_Pct > 1) AS invalid_discount_pct,
    SUM(Tax_Pct < 0 OR Tax_Pct > 1) AS invalid_tax_pct,
    SUM(Stock_Available < 0) AS negative_stock,
    SUM(Shipping_Cost < 0) AS negative_shipping_cost,
    SUM(Revenue < 0) AS negative_revenue,
    SUM(Total_Cost < 0) AS negative_total_cost
FROM supply_chain;

SELECT
    MIN(Order_Date) AS earliest_order_date,
    MAX(Order_Date) AS latest_order_date,
    MIN(Ship_Date) AS earliest_ship_date,
    MAX(Ship_Date) AS latest_ship_date,
    MIN(Expected_Delivery_Date) AS earliest_expected_delivery,
    MAX(Expected_Delivery_Date) AS latest_expected_delivery,
    MIN(Actual_Delivery_Date) AS earliest_actual_delivery,
    MAX(Actual_Delivery_Date) AS latest_actual_delivery
FROM supply_chain;

SELECT
    SUM(Ship_Date < Order_Date) AS ship_before_order,
    SUM(Expected_Delivery_Date < Order_Date) AS expected_delivery_before_order,
    SUM(Actual_Delivery_Date < Order_Date) AS actual_delivery_before_order,
    SUM(
        Actual_Delivery_Date IS NOT NULL
        AND Expected_Delivery_Date IS NOT NULL
        AND Actual_Delivery_Date < Ship_Date
    ) AS actual_delivery_before_ship
FROM supply_chain;

SELECT
    Order_Line_ID,
    Order_Status,
    Order_Date,
    Ship_Date,
    Expected_Delivery_Date,
    Actual_Delivery_Date,
    DATEDIFF(Actual_Delivery_Date, Order_Date) AS actual_vs_order_days,
    Revenue
FROM supply_chain
WHERE Actual_Delivery_Date < Order_Date
ORDER BY actual_vs_order_days;

SELECT
    Order_Status,
    DATEDIFF(Actual_Delivery_Date, Ship_Date) AS delivery_day_difference,
    COUNT(*) AS affected_rows,
    ROUND(SUM(Revenue), 2) AS associated_revenue
FROM supply_chain
WHERE Actual_Delivery_Date IS NOT NULL
  AND Ship_Date IS NOT NULL
  AND Actual_Delivery_Date < Ship_Date
GROUP BY
    Order_Status,
    DATEDIFF(Actual_Delivery_Date, Ship_Date)
ORDER BY
    Order_Status,
    delivery_day_difference;
    
SELECT
    SUM(
        ABS(
            Revenue -
            (Quantity_Ordered * Unit_Price * (1 - Discount_Pct))
        ) > 0.01
    ) AS revenue_formula_mismatch,

    SUM(
        ABS(
            Total_Cost -
            (Quantity_Ordered * Unit_Cost)
        ) > 0.01
    ) AS total_cost_formula_mismatch,

    SUM(
        ABS(
            Profit -
            (Revenue - Total_Cost)
        ) > 0.01
    ) AS profit_formula_mismatch,

    SUM(
        ABS(
            Profit_Margin -
            (Profit / NULLIF(Revenue, 0))
        ) > 0.0001
    ) AS profit_margin_formula_mismatch

FROM supply_chain
WHERE Quantity_Ordered IS NOT NULL
  AND Unit_Price IS NOT NULL
  AND Unit_Cost IS NOT NULL
  AND Discount_Pct IS NOT NULL
  AND Revenue IS NOT NULL
  AND Total_Cost IS NOT NULL
  AND Profit IS NOT NULL
  AND Profit_Margin IS NOT NULL
  AND Revenue <> 0;
  
SELECT
    Order_Line_ID,
    Revenue,
    Total_Cost,
    Profit,
    Profit_Margin,
    Profit / NULLIF(Revenue, 0) AS recalculated_profit_margin,
    Profit_Margin -
        (Profit / NULLIF(Revenue, 0)) AS margin_difference
FROM supply_chain
WHERE Revenue <> 0
  AND Profit_Margin IS NOT NULL
  AND ABS(
        Profit_Margin -
        (Profit / NULLIF(Revenue, 0))
      ) > 0.0001
ORDER BY ABS(margin_difference) DESC
LIMIT 20;

SELECT
    COUNT(*) AS total_mismatch_rows,
    SUM(ABS(Profit_Margin - (Profit / NULLIF(Revenue, 0))) > 0.0005)
        AS mismatch_above_tolerance
FROM supply_chain
WHERE Profit_Margin IS NOT NULL
  AND Revenue <> 0;
  
SELECT
    COUNT(*) AS total_rows,
    SUM(ABS(Profit_Margin - ROUND(Profit / NULLIF(Revenue, 0), 4)) > 0) 
        AS mismatch_after_4_decimal_rounding,
    SUM(ABS(Profit_Margin - ROUND(Profit / NULLIF(Revenue, 0), 4)) = 0) 
        AS matched_after_4_decimal_rounding
FROM supply_chain
WHERE Profit_Margin IS NOT NULL
  AND Revenue <> 0;
  
SELECT
    Order_Line_ID,
    Revenue,
    Profit,
    Profit_Margin,
    ROUND(Profit / NULLIF(Revenue, 0), 4) AS recalculated_margin,
    Profit_Margin - ROUND(Profit / NULLIF(Revenue, 0), 4) AS difference
FROM supply_chain
WHERE Profit_Margin IS NOT NULL
  AND Revenue <> 0
  AND ABS(Profit_Margin - ROUND(Profit / NULLIF(Revenue, 0), 4)) > 0
ORDER BY ABS(Profit_Margin - ROUND(Profit / NULLIF(Revenue, 0), 4)) DESC
LIMIT 20;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT Order_Line_ID) AS distinct_order_line_ids,
    COUNT(*) - COUNT(DISTINCT Order_Line_ID) AS duplicate_order_line_id_rows
FROM supply_chain;

SELECT
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(
        DISTINCT
        Order_ID,
        Product_Name,
        Product_Category,
        Quantity_Ordered,
        Unit_Price,
        Unit_Cost,
        Revenue,
        Order_Date,
        Ship_Date,
        Expected_Delivery_Date,
        Actual_Delivery_Date
    ) AS possible_duplicate_business_rows
FROM supply_chain;

SELECT
    Order_ID,
    Product_Name,
    Product_Category,
    Quantity_Ordered,
    Unit_Price,
    Unit_Cost,
    Revenue,
    COUNT(*) AS repeated_rows,
    GROUP_CONCAT(Order_Line_ID ORDER BY Order_Line_ID) AS order_line_ids
FROM supply_chain
GROUP BY
    Order_ID,
    Product_Name,
    Product_Category,
    Quantity_Ordered,
    Unit_Price,
    Unit_Cost,
    Revenue
HAVING COUNT(*) > 1
ORDER BY repeated_rows DESC
LIMIT 20;

SELECT
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(DISTINCT CONCAT_WS(
        '|',
        Order_ID,
        Product_Name,
        Product_Category,
        Quantity_Ordered,
        Unit_Price,
        Unit_Cost,
        Revenue,
        Order_Date,
        Ship_Date,
        Expected_Delivery_Date,
        Actual_Delivery_Date
    )) AS possible_duplicate_business_rows
FROM supply_chain;

SELECT
    COUNT(*) AS total_rows,
    SUM(Product_Name IS NULL OR TRIM(Product_Name) = '') AS missing_product_name,
    SUM(Product_Category IS NULL OR TRIM(Product_Category) = '') AS missing_product_category,
    SUM(Quantity_Ordered IS NULL) AS missing_quantity,
    SUM(Unit_Price IS NULL) AS missing_unit_price,
    SUM(Unit_Cost IS NULL) AS missing_unit_cost,
    SUM(Shipping_Cost IS NULL) AS missing_shipping_cost,
    SUM(Order_Date IS NULL) AS missing_order_date,
    SUM(Ship_Date IS NULL) AS missing_ship_date,
    SUM(Expected_Delivery_Date IS NULL) AS missing_expected_delivery_date,
    SUM(Actual_Delivery_Date IS NULL) AS missing_actual_delivery_date
FROM supply_chain;

SELECT
    Order_Status,
    COUNT(*) AS rows_with_missing_numeric_values,
    SUM(Quantity_Ordered IS NULL) AS missing_quantity,
    SUM(Unit_Price IS NULL) AS missing_unit_price,
    SUM(Unit_Cost IS NULL) AS missing_unit_cost,
    ROUND(SUM(Revenue), 2) AS associated_revenue
FROM supply_chain
WHERE Quantity_Ordered IS NULL
   OR Unit_Price IS NULL
   OR Unit_Cost IS NULL
GROUP BY Order_Status
ORDER BY rows_with_missing_numeric_values DESC;

SELECT
    Order_Line_ID,
    Order_Status,
    Order_Date,
    Ship_Date,
    Expected_Delivery_Date,
    Actual_Delivery_Date,
    DATEDIFF(Actual_Delivery_Date, Ship_Date) AS delivery_days,
    Revenue
FROM supply_chain
WHERE Ship_Date IS NOT NULL
  AND Actual_Delivery_Date IS NOT NULL
  AND Actual_Delivery_Date < Ship_Date
ORDER BY delivery_days;

SELECT
    COUNT(*) AS invalid_delivery_date_rows,
    ROUND(SUM(Revenue), 2) AS associated_revenue
FROM supply_chain
WHERE Ship_Date IS NOT NULL
  AND Actual_Delivery_Date IS NOT NULL
  AND Actual_Delivery_Date < Ship_Date;

SHOW COLUMNS FROM supply_chain;

SELECT
    MIN(Discount_Pct) AS min_discount_pct,
    MAX(Discount_Pct) AS max_discount_pct,
    MIN(Tax_Pct) AS min_tax_pct,
    MAX(Tax_Pct) AS max_tax_pct,
    MIN(Return_Rate) AS min_return_rate,
    MAX(Return_Rate) AS max_return_rate
FROM supply_chain;

SELECT
    MIN(Quantity_Ordered) AS min_quantity,
    MAX(Quantity_Ordered) AS max_quantity,
    MIN(Unit_Price) AS min_unit_price,
    MAX(Unit_Price) AS max_unit_price,
    MIN(Unit_Cost) AS min_unit_cost,
    MAX(Unit_Cost) AS max_unit_cost,
    MIN(Stock_Available) AS min_stock,
    MAX(Stock_Available) AS max_stock,
    MIN(Reorder_Level) AS min_reorder_level,
    MAX(Reorder_Level) AS max_reorder_level,
    MIN(Shipping_Cost) AS min_shipping_cost,
    MAX(Shipping_Cost) AS max_shipping_cost
FROM supply_chain;

SELECT
    SUM(Order_Line_ID < 0) AS negative_order_line_id,
    SUM(Order_ID < 0) AS negative_order_id,
    SUM(Customer_ID < 0) AS negative_customer_id,
    SUM(Product_ID < 0) AS negative_product_id,
    SUM(Supplier_ID < 0) AS negative_supplier_id,
    SUM(Warehouse_ID < 0) AS negative_warehouse_id
FROM supply_chain;

SELECT
    SUM(Order_Line_ID IS NULL) AS missing_order_line_id,
    SUM(Order_ID IS NULL) AS missing_order_id,
    SUM(Customer_ID IS NULL) AS missing_customer_id,
    SUM(Product_ID IS NULL) AS missing_product_id,
    SUM(Supplier_ID IS NULL) AS missing_supplier_id,
    SUM(Warehouse_ID IS NULL) AS missing_warehouse_id
FROM supply_chain;

SELECT
    COUNT(*) AS missing_supplier_rows,
    COUNT(DISTINCT Order_ID) AS affected_orders,
    ROUND(SUM(Revenue), 2) AS associated_revenue
FROM supply_chain
WHERE Supplier_ID IS NULL;

SELECT
    SUM(Customer_City IS NULL OR TRIM(Customer_City) = '') AS missing_customer_city,
    SUM(Region IS NULL OR TRIM(Region) = '') AS missing_region,
    SUM(Shipping_Type IS NULL OR TRIM(Shipping_Type) = '') AS missing_shipping_type,
    SUM(Payment_Method IS NULL OR TRIM(Payment_Method) = '') AS missing_payment_method,
    SUM(Return_Flag IS NULL OR TRIM(Return_Flag) = '') AS missing_return_flag,
    SUM(Product_Name IS NULL OR TRIM(Product_Name) = '') AS missing_product_name,
    SUM(Product_Category IS NULL OR TRIM(Product_Category) = '') AS missing_product_category,
    SUM(Order_Status IS NULL OR TRIM(Order_Status) = '') AS missing_order_status
FROM supply_chain;

SELECT
    SUM(Region IS NULL OR TRIM(Region) = '') AS missing_region,
    SUM(Product_Name IS NULL OR TRIM(Product_Name) = '') AS missing_product_name,
    SUM(Product_Category IS NULL OR TRIM(Product_Category) = '') AS missing_product_category,
    SUM(Shipping_Type IS NULL OR TRIM(Shipping_Type) = '') AS missing_shipping_type,
    SUM(Payment_Method IS NULL OR TRIM(Payment_Method) = '') AS missing_payment_method,
    SUM(Return_Flag IS NULL OR TRIM(Return_Flag) = '') AS missing_return_flag,
    SUM(Order_Status IS NULL OR TRIM(Order_Status) = '') AS missing_order_status,
    SUM(Inventory_Status IS NULL OR TRIM(Inventory_Status) = '') AS missing_inventory_status,
    SUM(On_Time_Flag IS NULL OR TRIM(On_Time_Flag) = '') AS missing_on_time_flag
FROM supply_chain;

SELECT
    SUM(
        Inventory_Status IS NULL
        AND (Stock_Available IS NULL OR Reorder_Level IS NULL)
    ) AS inventory_nulls_expected,

    SUM(
        Inventory_Status IS NULL
        AND Stock_Available IS NOT NULL
        AND Reorder_Level IS NOT NULL
    ) AS inventory_nulls_unexpected,

    SUM(
        On_Time_Flag IS NULL
        AND (Actual_Delivery_Date IS NULL OR Order_Status NOT IN ('Delivered On Time', 'Delivered Late'))
    ) AS on_time_flag_nulls_expected,

    SUM(
        On_Time_Flag IS NULL
        AND Actual_Delivery_Date IS NOT NULL
        AND Order_Status IN ('Delivered On Time', 'Delivered Late')
    ) AS on_time_flag_nulls_unexpected
FROM supply_chain;

SELECT
    COUNT(*) AS total_rows,

    SUM(Inventory_Status IS NULL) AS inventory_status_nulls,
    SUM(Stock_Available IS NULL) AS stock_available_nulls,
    SUM(Reorder_Level IS NULL) AS reorder_level_nulls,

    SUM(On_Time_Flag IS NULL) AS on_time_flag_nulls,
    SUM(Actual_Delivery_Date IS NULL) AS actual_delivery_date_nulls,

    SUM(Order_Status = 'Delivered On Time') AS delivered_on_time_rows,
    SUM(Order_Status = 'Delivered Late') AS delivered_late_rows
FROM supply_chain;

SELECT
    COUNT(*) AS total_rows,

    SUM(Stock_Available IS NULL) AS missing_stock_rows,

    SUM(
        Stock_Available IS NULL
        AND Inventory_Status IS NOT NULL
    ) AS missing_stock_with_status,

    SUM(
        Stock_Available IS NOT NULL
        AND Reorder_Level IS NOT NULL
        AND Inventory_Status <>
            CASE
                WHEN Stock_Available <= Reorder_Level THEN 'Low Stock'
                ELSE 'Adequate Stock'
            END
    ) AS inventory_status_logic_mismatches
FROM supply_chain;

SELECT
    COUNT(*) AS total_rows,

    SUM(On_Time_Flag IS NULL) AS missing_on_time_flag,

    SUM(
        Actual_Delivery_Date IS NULL
        AND On_Time_Flag IS NOT NULL
    ) AS flag_present_without_actual_delivery,

    SUM(
        Actual_Delivery_Date IS NOT NULL
        AND Order_Status = 'Delivered On Time'
        AND On_Time_Flag <> 1
    ) AS on_time_flag_mismatches,

    SUM(
        Actual_Delivery_Date IS NOT NULL
        AND Order_Status = 'Delivered Late'
        AND On_Time_Flag <> 0
    ) AS late_flag_mismatches
FROM supply_chain;

SELECT
    COUNT(*) AS total_rows,

    SUM(Return_Flag IS NULL) AS missing_return_flag,
    SUM(Return_Rate IS NULL) AS missing_return_rate,

    SUM(
        Return_Flag = 'Yes'
        AND Return_Rate <> 1
    ) AS yes_flag_rate_mismatches,

    SUM(
        Return_Flag = 'No'
        AND Return_Rate <> 0
    ) AS no_flag_rate_mismatches,

    SUM(
        Return_Flag NOT IN ('Yes', 'No')
    ) AS unexpected_return_flag_values
FROM supply_chain;

SELECT
    COUNT(*) AS total_rows,

    SUM(Delivery_Days IS NULL) AS missing_delivery_days,

    SUM(
        Actual_Delivery_Date IS NOT NULL
        AND Ship_Date IS NOT NULL
        AND Delivery_Days <>
            DATEDIFF(Actual_Delivery_Date, Ship_Date)
    ) AS delivery_days_mismatches,

    SUM(
        Actual_Delivery_Date IS NOT NULL
        AND Ship_Date IS NOT NULL
        AND Delivery_Days < 0
    ) AS negative_delivery_days
FROM supply_chain;

SELECT
    COUNT(*) AS missing_delivery_days,

    SUM(Ship_Date IS NULL) AS missing_ship_date,

    SUM(Actual_Delivery_Date IS NULL) AS missing_actual_delivery_date,

    SUM(
        Ship_Date IS NOT NULL
        AND Actual_Delivery_Date IS NOT NULL
    ) AS both_dates_present_but_delivery_days_missing
FROM supply_chain
WHERE Delivery_Days IS NULL;

SELECT
    Order_Status,
    COUNT(*) AS total_rows,

    SUM(
        Order_Status IN ('Delivered On Time', 'Delivered Late')
        AND Actual_Delivery_Date IS NULL
    ) AS delivered_status_missing_actual_date,

    SUM(
        Order_Status IN ('Processing', 'Shipped', 'In Transit', 'Pending', 'Cancelled')
        AND Actual_Delivery_Date IS NOT NULL
    ) AS non_delivered_status_with_actual_date
FROM supply_chain
GROUP BY Order_Status
ORDER BY total_rows DESC;

SELECT
    Order_Line_ID,
    Order_Status,
    Order_Date,
    Ship_Date,
    Expected_Delivery_Date,
    Actual_Delivery_Date,
    Delivery_Days,
    Revenue
FROM supply_chain
WHERE
    (
        Order_Status IN ('Processing', 'In Transit')
        AND Actual_Delivery_Date IS NOT NULL
    )
ORDER BY
    Order_Status,
    Actual_Delivery_Date;
    
SELECT
    'Order_Status' AS column_name,
    Order_Status AS value,
    COUNT(*) AS row_count
FROM supply_chain
GROUP BY Order_Status

UNION ALL

SELECT
    'Return_Flag',
    Return_Flag,
    COUNT(*)
FROM supply_chain
GROUP BY Return_Flag

UNION ALL

SELECT
    'Shipping_Type',
    Shipping_Type,
    COUNT(*)
FROM supply_chain
GROUP BY Shipping_Type

UNION ALL

SELECT
    'Payment_Method',
    Payment_Method,
    COUNT(*)
FROM supply_chain
GROUP BY Payment_Method

ORDER BY column_name, value;

SELECT
    SUM(Customer_City IS NOT NULL AND Customer_City <> TRIM(Customer_City))
        AS city_extra_spaces,

    SUM(Region IS NOT NULL AND Region <> TRIM(Region))
        AS region_extra_spaces,

    SUM(Shipping_Type IS NOT NULL AND Shipping_Type <> TRIM(Shipping_Type))
        AS shipping_type_extra_spaces,

    SUM(Payment_Method IS NOT NULL AND Payment_Method <> TRIM(Payment_Method))
        AS payment_method_extra_spaces,

    SUM(Return_Flag IS NOT NULL AND Return_Flag <> TRIM(Return_Flag))
        AS return_flag_extra_spaces,

    SUM(Product_Name IS NOT NULL AND Product_Name <> TRIM(Product_Name))
        AS product_name_extra_spaces,

    SUM(Product_Category IS NOT NULL AND Product_Category <> TRIM(Product_Category))
        AS product_category_extra_spaces,

    SUM(Order_Status IS NOT NULL AND Order_Status <> TRIM(Order_Status))
        AS order_status_extra_spaces,

    SUM(Inventory_Status IS NOT NULL AND Inventory_Status <> TRIM(Inventory_Status))
        AS inventory_status_extra_spaces,

    SUM(On_Time_Flag IS NOT NULL AND On_Time_Flag <> TRIM(On_Time_Flag))
        AS on_time_flag_extra_spaces
FROM supply_chain;

SELECT
    COUNT(*) AS total_rows,

    SUM(
        Order_Date IS NOT NULL
        AND Ship_Date IS NOT NULL
        AND Ship_Date < Order_Date
    ) AS ship_before_order,

    SUM(
        Order_Date IS NOT NULL
        AND Expected_Delivery_Date IS NOT NULL
        AND Expected_Delivery_Date < Order_Date
    ) AS expected_delivery_before_order,

    SUM(
        Ship_Date IS NOT NULL
        AND Expected_Delivery_Date IS NOT NULL
        AND Expected_Delivery_Date < Ship_Date
    ) AS expected_delivery_before_ship,

    SUM(
        Ship_Date IS NOT NULL
        AND Actual_Delivery_Date IS NOT NULL
        AND Actual_Delivery_Date < Ship_Date
    ) AS actual_delivery_before_ship,

    SUM(
        Order_Date IS NOT NULL
        AND Actual_Delivery_Date IS NOT NULL
        AND Actual_Delivery_Date < Order_Date
    ) AS actual_delivery_before_order
FROM supply_chain;

SELECT
    COUNT(*) AS total_rows,

    SUM(Revenue < 0) AS negative_revenue,
    SUM(Total_Cost < 0) AS negative_total_cost,

    SUM(Profit < 0) AS negative_profit,
    SUM(Profit_Margin < 0) AS negative_profit_margin,

    SUM(Return_Rate NOT IN (0, 1)) AS unexpected_return_rate,

    SUM(Delivery_Days < 0) AS negative_delivery_days,

    SUM(On_Time_Flag NOT IN (0, 1)) AS unexpected_on_time_flag
FROM supply_chain;

SELECT
    Order_Line_ID,
    Quantity_Ordered,
    Unit_Price,
    Discount_Pct,
    Unit_Cost,
    Revenue,
    Total_Cost,
    Profit,
    Revenue - Total_Cost AS recalculated_profit
FROM supply_chain
WHERE Profit < 0
ORDER BY Profit ASC
LIMIT 20;

CREATE TABLE supply_chain_clean AS
SELECT *
FROM supply_chain;

SELECT COUNT(*) AS total_records
FROM supply_chain_clean;

SELECT
    COUNT(*) AS Total_Rows,

    SUM(Supplier_ID IS NULL) AS Missing_Supplier_ID,
    SUM(Quantity_Ordered IS NULL) AS Missing_Quantity,
    SUM(Unit_Price IS NULL) AS Missing_Unit_Price,
    SUM(Unit_Cost IS NULL) AS Missing_Unit_Cost,
    SUM(Shipping_Cost IS NULL) AS Missing_Shipping_Cost,
    SUM(Stock_Available IS NULL) AS Missing_Stock,
    SUM(Ship_Date IS NULL) AS Missing_Ship_Date,
    SUM(Expected_Delivery_Date IS NULL) AS Missing_Expected_Date,
    SUM(Actual_Delivery_Date IS NULL) AS Missing_Actual_Date,
    SUM(Payment_Method IS NULL) AS Missing_Payment_Method

FROM supply_chain_clean;

SELECT
    missing.Order_Line_ID,
    missing.Order_ID,
    missing.Product_ID,
    COUNT(DISTINCT other.Supplier_ID) AS Available_Suppliers,
    GROUP_CONCAT(DISTINCT other.Supplier_ID) AS Supplier_List
FROM supply_chain_clean AS missing
LEFT JOIN supply_chain_clean AS other
    ON missing.Order_ID = other.Order_ID
    AND other.Supplier_ID IS NOT NULL
WHERE missing.Supplier_ID IS NULL
GROUP BY
    missing.Order_Line_ID,
    missing.Order_ID,
    missing.Product_ID
ORDER BY Available_Suppliers DESC;

SELECT
    COUNT(*) AS Total_Orders,
    SUM(Distinct_Suppliers = 1) AS Single_Supplier_Orders,
    SUM(Distinct_Suppliers > 1) AS Multiple_Supplier_Orders
FROM (
    SELECT
        Order_ID,
        COUNT(DISTINCT Supplier_ID) AS Distinct_Suppliers
    FROM supply_chain_clean
    WHERE Supplier_ID IS NOT NULL
    GROUP BY Order_ID
) AS Supplier_Check;

SELECT
    Order_Line_ID,
    Order_ID,
    Product_ID,
    Warehouse_ID,
    Quantity_Ordered,
    Unit_Price,
    Discount_Pct,
    Revenue
FROM supply_chain_clean
WHERE Quantity_Ordered IS NULL;

UPDATE supply_chain_clean
SET Revenue = NULL
WHERE Quantity_Ordered IS NULL
  AND Revenue = 0;
  
SELECT
    COUNT(*) AS Updated_Records,
    SUM(Revenue IS NULL) AS Revenue_Null_Records
FROM supply_chain_clean
WHERE Quantity_Ordered IS NULL;

SELECT
    Order_Line_ID,
    Quantity_Ordered,
    Unit_Price,
    Discount_Pct,
    Revenue,
    CASE
        WHEN Quantity_Ordered > 0
             AND Discount_Pct < 1
             AND Revenue IS NOT NULL
        THEN ROUND(
            Revenue / (Quantity_Ordered * (1 - Discount_Pct)), 2
        )
        ELSE NULL
    END AS Estimated_Unit_Price
FROM supply_chain_clean
WHERE Unit_Price IS NULL;

UPDATE supply_chain_clean
SET Revenue = NULL
WHERE Unit_Price IS NULL
  AND Revenue = 0;
  
SELECT
    COUNT(*) AS Unit_Price_Null_Records,
    SUM(Revenue IS NULL) AS Revenue_Null_Records
FROM supply_chain_clean
WHERE Unit_Price IS NULL;

SELECT
    Order_Line_ID,
    Product_ID,
    Supplier_ID,
    Quantity_Ordered,
    Unit_Price,
    Unit_Cost,
    Total_Cost,
    Revenue,
    Profit
FROM supply_chain_clean
WHERE Unit_Cost IS NULL
LIMIT 50;

SELECT
    m.Product_ID,
    m.Supplier_ID,
    COUNT(*) AS Missing_Cost_Records,
    COUNT(c.Unit_Cost) AS Available_Cost_Records,
    COUNT(DISTINCT c.Unit_Cost) AS Distinct_Cost_Values,
    MIN(c.Unit_Cost) AS Minimum_Cost,
    MAX(c.Unit_Cost) AS Maximum_Cost,
    AVG(c.Unit_Cost) AS Average_Cost
FROM supply_chain_clean AS m
LEFT JOIN supply_chain_clean AS c
    ON m.Product_ID = c.Product_ID
    AND m.Supplier_ID = c.Supplier_ID
    AND c.Unit_Cost IS NOT NULL
WHERE m.Unit_Cost IS NULL
GROUP BY
    m.Product_ID,
    m.Supplier_ID
ORDER BY Available_Cost_Records DESC;

SELECT
    m.Product_ID,
    m.Supplier_ID,

    COUNT(DISTINCT m.Order_Line_ID)
        AS Missing_Cost_Records,

    COUNT(DISTINCT c.Unit_Cost)
        AS Distinct_Cost_Values,

    MIN(c.Unit_Cost) AS Minimum_Cost,
    MAX(c.Unit_Cost) AS Maximum_Cost,
    AVG(c.Unit_Cost) AS Average_Cost

FROM supply_chain_clean AS m

LEFT JOIN supply_chain_clean AS c
    ON m.Product_ID = c.Product_ID
    AND m.Supplier_ID = c.Supplier_ID
    AND c.Unit_Cost IS NOT NULL

WHERE m.Unit_Cost IS NULL

GROUP BY
    m.Product_ID,
    m.Supplier_ID

ORDER BY Missing_Cost_Records DESC;

UPDATE supply_chain_clean AS m
JOIN (
    SELECT
        Product_ID,
        Supplier_ID,
        MIN(Unit_Cost) AS Recovered_Unit_Cost
    FROM supply_chain_clean
    WHERE Unit_Cost IS NOT NULL
    GROUP BY Product_ID, Supplier_ID
    HAVING COUNT(DISTINCT Unit_Cost) = 1
) AS c
    ON m.Product_ID = c.Product_ID
    AND m.Supplier_ID = c.Supplier_ID
SET m.Unit_Cost = c.Recovered_Unit_Cost
WHERE m.Unit_Cost IS NULL;

SELECT
    COUNT(*) AS Remaining_Null_Unit_Cost,
    SUM(Unit_Cost IS NOT NULL) AS Available_Unit_Cost
FROM supply_chain_clean;

SELECT
    SUM(Unit_Cost IS NULL) AS Remaining_Null_Unit_Cost,
    SUM(Unit_Cost IS NOT NULL) AS Available_Unit_Cost
FROM supply_chain_clean;

UPDATE supply_chain_clean
SET
    Total_Cost = ROUND(Quantity_Ordered * Unit_Cost, 2),
    Profit = ROUND(
        Revenue - (Quantity_Ordered * Unit_Cost), 2
    )
WHERE Unit_Cost IS NOT NULL
  AND Quantity_Ordered IS NOT NULL
  AND Revenue IS NOT NULL
  AND Total_Cost IS NULL;
  
SELECT
    COUNT(*) AS Eligible_Records,
    SUM(Total_Cost IS NOT NULL) AS Available_Total_Cost,
    SUM(Profit IS NOT NULL) AS Available_Profit,
    SUM(Total_Cost IS NULL) AS Missing_Total_Cost
FROM supply_chain_clean
WHERE Unit_Cost IS NOT NULL
  AND Quantity_Ordered IS NOT NULL
  AND Revenue IS NOT NULL;
  
UPDATE supply_chain_clean
SET Profit = ROUND(
    Revenue - Total_Cost, 2
)
WHERE Profit IS NULL
  AND Revenue IS NOT NULL
  AND Total_Cost IS NOT NULL;
  
SELECT
    m.Shipping_Type,
    m.Warehouse_ID,
    COUNT(*) AS Missing_Records,
    COUNT(DISTINCT c.Shipping_Cost) AS Distinct_Cost_Values,
    MIN(c.Shipping_Cost) AS Minimum_Cost,
    MAX(c.Shipping_Cost) AS Maximum_Cost,
    ROUND(AVG(c.Shipping_Cost), 2) AS Average_Cost
FROM supply_chain_clean AS m
LEFT JOIN supply_chain_clean AS c
    ON m.Shipping_Type = c.Shipping_Type
    AND m.Warehouse_ID = c.Warehouse_ID
    AND c.Shipping_Cost IS NOT NULL
WHERE m.Shipping_Cost IS NULL
GROUP BY
    m.Shipping_Type,
    m.Warehouse_ID
ORDER BY Missing_Records DESC;

WITH Missing_Groups AS (
    SELECT
        Shipping_Type,
        Warehouse_ID,
        COUNT(*) AS Missing_Records
    FROM supply_chain_clean
    WHERE Shipping_Cost IS NULL
    GROUP BY Shipping_Type, Warehouse_ID
),

Cost_Statistics AS (
    SELECT
        Shipping_Type,
        Warehouse_ID,
        COUNT(DISTINCT Shipping_Cost) AS Distinct_Cost_Values,
        MIN(Shipping_Cost) AS Minimum_Cost,
        MAX(Shipping_Cost) AS Maximum_Cost,
        ROUND(AVG(Shipping_Cost), 2) AS Average_Cost
    FROM supply_chain_clean
    WHERE Shipping_Cost IS NOT NULL
    GROUP BY Shipping_Type, Warehouse_ID
)

SELECT
    m.Shipping_Type,
    m.Warehouse_ID,
    m.Missing_Records,
    COALESCE(c.Distinct_Cost_Values, 0) AS Distinct_Cost_Values,
    c.Minimum_Cost,
    c.Maximum_Cost,
    c.Average_Cost
FROM Missing_Groups AS m
LEFT JOIN Cost_Statistics AS c
    ON m.Shipping_Type = c.Shipping_Type
    AND m.Warehouse_ID = c.Warehouse_ID
ORDER BY m.Missing_Records DESC;

SELECT
    Order_Line_ID,
    Product_ID,
    Warehouse_ID,
    Quantity_Ordered,
    Stock_Available,
    Reorder_Level,
    Inventory_Status
FROM supply_chain_clean
WHERE Stock_Available IS NULL
LIMIT 50;

WITH Missing_Stock AS (
    SELECT
        Product_ID,
        Warehouse_ID,
        COUNT(*) AS Missing_Records
    FROM supply_chain_clean
    WHERE Stock_Available IS NULL
    GROUP BY Product_ID, Warehouse_ID
),

Available_Stock AS (
    SELECT
        Product_ID,
        Warehouse_ID,
        COUNT(DISTINCT Stock_Available) AS Distinct_Stock_Values,
        MIN(Stock_Available) AS Minimum_Stock,
        MAX(Stock_Available) AS Maximum_Stock,
        AVG(Stock_Available) AS Average_Stock
    FROM supply_chain_clean
    WHERE Stock_Available IS NOT NULL
    GROUP BY Product_ID, Warehouse_ID
)

SELECT
    m.Product_ID,
    m.Warehouse_ID,
    m.Missing_Records,
    COALESCE(a.Distinct_Stock_Values, 0) AS Distinct_Stock_Values,
    a.Minimum_Stock,
    a.Maximum_Stock,
    a.Average_Stock
FROM Missing_Stock AS m
LEFT JOIN Available_Stock AS a
    ON m.Product_ID = a.Product_ID
    AND m.Warehouse_ID = a.Warehouse_ID
ORDER BY m.Missing_Records DESC;

SELECT
    Order_Line_ID,
    Order_Date,
    Ship_Date,
    Expected_Delivery_Date,
    Actual_Delivery_Date,
    Order_Status
FROM supply_chain_clean
WHERE Ship_Date IS NULL;

SELECT
    Order_Line_ID,
    Order_Date,
    Ship_Date,
    Expected_Delivery_Date,
    Actual_Delivery_Date,
    Order_Status
FROM supply_chain_clean
WHERE Expected_Delivery_Date IS NULL;

SELECT
    Order_Line_ID,
    Order_Date,
    Ship_Date,
    Expected_Delivery_Date,
    Actual_Delivery_Date,
    Order_Status,
    Delivery_Days
FROM supply_chain_clean
WHERE Actual_Delivery_Date IS NULL
  AND Order_Status IN (
      'Delivered Late',
      'Delivered On Time'
  );
  
SELECT
    Order_Status,
    COUNT(*) AS Total_Records
FROM supply_chain_clean
GROUP BY Order_Status
ORDER BY Total_Records DESC;

SELECT
    Shipping_Type,
    COUNT(*) AS Total_Records
FROM supply_chain_clean
GROUP BY Shipping_Type
ORDER BY Total_Records DESC;

SELECT
    Payment_Method,
    COUNT(*) AS Total_Records
FROM supply_chain_clean
GROUP BY Payment_Method
ORDER BY Total_Records DESC;

SELECT
    m.Order_Line_ID,
    m.Order_ID,
    COUNT(DISTINCT o.Payment_Method) AS Available_Methods,
    GROUP_CONCAT(DISTINCT o.Payment_Method) AS Payment_Method_List
FROM supply_chain_clean AS m
LEFT JOIN supply_chain_clean AS o
    ON m.Order_ID = o.Order_ID
    AND o.Payment_Method IS NOT NULL
WHERE m.Payment_Method IS NULL
GROUP BY
    m.Order_Line_ID,
    m.Order_ID
ORDER BY Available_Methods DESC;

SELECT
    COUNT(*) AS Empty_Payment_Method_Records
FROM supply_chain_clean
WHERE TRIM(Payment_Method) = '';

UPDATE supply_chain_clean
SET Payment_Method = NULL
WHERE TRIM(Payment_Method) = '';

SELECT
    SUM(Payment_Method IS NULL) AS Null_Payment_Method,
    SUM(TRIM(Payment_Method) = '') AS Empty_Payment_Method
FROM supply_chain_clean;

SELECT
    m.Order_Line_ID,
    m.Order_ID,
    COUNT(DISTINCT o.Payment_Method) AS Available_Methods,
    GROUP_CONCAT(DISTINCT o.Payment_Method) AS Payment_Method_List
FROM supply_chain_clean AS m
LEFT JOIN supply_chain_clean AS o
    ON m.Order_ID = o.Order_ID
    AND o.Payment_Method IS NOT NULL
WHERE m.Payment_Method IS NULL
GROUP BY
    m.Order_Line_ID,
    m.Order_ID
ORDER BY Available_Methods DESC;

SELECT
    COUNT(*) AS Orders_With_One_Method,
    SUM(Total_Lines = 1) AS Single_Line_Orders,
    SUM(Total_Lines > 1) AS Multiple_Line_Orders
FROM (
    SELECT
        Order_ID,
        COUNT(*) AS Total_Lines,
        COUNT(DISTINCT Payment_Method) AS Distinct_Methods
    FROM supply_chain_clean
    GROUP BY Order_ID
    HAVING COUNT(DISTINCT Payment_Method) = 1
) AS Payment_Check;

UPDATE supply_chain_clean AS m
JOIN (
    SELECT
        Order_ID,
        MIN(Payment_Method) AS Recovered_Payment_Method
    FROM supply_chain_clean
    WHERE Payment_Method IS NOT NULL
    GROUP BY Order_ID
    HAVING COUNT(DISTINCT Payment_Method) = 1
) AS p
    ON m.Order_ID = p.Order_ID
SET m.Payment_Method = p.Recovered_Payment_Method
WHERE m.Payment_Method IS NULL;

SELECT
    COUNT(*) AS Total_Records,
    SUM(Payment_Method IS NULL) AS Remaining_Null,
    SUM(Payment_Method IS NOT NULL) AS Available_Payment_Method
FROM supply_chain_clean;

SELECT
    COUNT(*) AS Eligible_Records
FROM supply_chain_clean AS m
JOIN (
    SELECT
        Order_ID,
        MIN(Payment_Method) AS Recovered_Method
    FROM supply_chain_clean
    WHERE Payment_Method IS NOT NULL
    GROUP BY Order_ID
    HAVING COUNT(DISTINCT Payment_Method) = 1
) AS p
    ON m.Order_ID = p.Order_ID
WHERE m.Payment_Method IS NULL;

UPDATE supply_chain_clean AS m
JOIN (
    SELECT
        Order_ID,
        MIN(Payment_Method) AS Recovered_Method
    FROM supply_chain_clean
    WHERE Payment_Method IS NOT NULL
    GROUP BY Order_ID
    HAVING COUNT(DISTINCT Payment_Method) = 1
) AS p
    ON m.Order_ID = p.Order_ID
SET m.Payment_Method = p.Recovered_Method
WHERE m.Payment_Method IS NULL;

SELECT
    COUNT(*) AS Total_Records,
    SUM(Payment_Method IS NULL) AS Remaining_NULL,
    SUM(Payment_Method IS NOT NULL) AS Available_Payment_Method
FROM supply_chain_clean;

SELECT
    Return_Flag,
    COUNT(*) AS Total_Records
FROM supply_chain_clean
GROUP BY Return_Flag
ORDER BY Total_Records DESC;

SELECT
    COUNT(*) AS Total_Records,
    SUM(Return_Rate IS NULL) AS Missing_Return_Rate,
    SUM(Return_Rate < 0 OR Return_Rate > 1) AS Invalid_Return_Rate,
    MIN(Return_Rate) AS Minimum_Return_Rate,
    MAX(Return_Rate) AS Maximum_Return_Rate
FROM supply_chain_clean;

SELECT
    SUM(Order_Status <> TRIM(Order_Status)) AS Order_Status_Spaces,
    SUM(Shipping_Type <> TRIM(Shipping_Type)) AS Shipping_Type_Spaces,
    SUM(Payment_Method <> TRIM(Payment_Method)) AS Payment_Method_Spaces,
    SUM(Return_Flag <> TRIM(Return_Flag)) AS Return_Flag_Spaces
FROM supply_chain_clean;

SELECT
    'Customer_City' AS Column_Name,
    COUNT(DISTINCT Customer_City) AS Distinct_Values
FROM supply_chain_clean

UNION ALL

SELECT
    'Region',
    COUNT(DISTINCT Region)
FROM supply_chain_clean

UNION ALL

SELECT
    'Product_Category',
    COUNT(DISTINCT Product_Category)
FROM supply_chain_clean;

SELECT 'Customer_City' AS Column_Name,
       Customer_City AS Category_Value,
       COUNT(*) AS Total_Records
FROM supply_chain_clean
GROUP BY Customer_City

UNION ALL

SELECT 'Region',
       Region,
       COUNT(*)
FROM supply_chain_clean
GROUP BY Region

UNION ALL

SELECT 'Product_Category',
       Product_Category,
       COUNT(*)
FROM supply_chain_clean
GROUP BY Product_Category

ORDER BY Column_Name, Category_Value;

SELECT
    COUNT(*) AS Unknown_City_Records,
    SUM(Customer_City IS NULL) AS Null_City_Records,
    SUM(TRIM(Customer_City) = '') AS Empty_City_Records
FROM supply_chain_clean
WHERE Customer_City = 'Unknown';

SELECT
    SUM(Customer_City IS NULL) AS Null_Customer_City,
    SUM(Region IS NULL) AS Null_Region,
    SUM(Product_Category IS NULL) AS Null_Product_Category,
    SUM(Shipping_Type IS NULL) AS Null_Shipping_Type,
    SUM(Order_Status IS NULL) AS Null_Order_Status,
    SUM(Return_Flag IS NULL) AS Null_Return_Flag,

    SUM(TRIM(Customer_City) = '') AS Empty_Customer_City,
    SUM(TRIM(Region) = '') AS Empty_Region,
    SUM(TRIM(Product_Category) = '') AS Empty_Product_Category
FROM supply_chain_clean;

SELECT
    COUNT(*) AS Total_Records,
    SUM(Delivery_Days < 0) AS Negative_Delivery_Days,
    SUM(Delivery_Days IS NULL) AS Missing_Delivery_Days,
    SUM(On_Time_Flag IS NULL) AS Missing_On_Time_Flag,
    SUM(On_Time_Flag NOT IN (0, 1)) AS Invalid_On_Time_Flag
FROM supply_chain_clean;

SELECT
    Order_Line_ID,
    Order_Date,
    Ship_Date,
    Actual_Delivery_Date,
    Delivery_Days,
    Order_Status,
    On_Time_Flag
FROM supply_chain_clean
WHERE Delivery_Days < 0
ORDER BY Delivery_Days;

UPDATE supply_chain_clean
SET Delivery_Days = NULL
WHERE Delivery_Days < 0;

SELECT
    COUNT(*) AS Total_Records,
    SUM(Delivery_Days < 0) AS Remaining_Negative_Days,
    SUM(Delivery_Days IS NULL) AS Missing_Delivery_Days,
    SUM(Delivery_Days >= 0) AS Valid_Delivery_Days
FROM supply_chain_clean;

SELECT
    COUNT(*) AS Total_Records,
    SUM(Profit_Margin IS NULL) AS Missing_Profit_Margin,
    SUM(Profit_Margin < 0) AS Negative_Profit_Margin,
    SUM(Profit_Margin > 1) AS Above_100_Percent,
    MIN(Profit_Margin) AS Minimum_Profit_Margin,
    MAX(Profit_Margin) AS Maximum_Profit_Margin
FROM supply_chain_clean;

SELECT
    COUNT(*) AS Missing_Margin_Records,

    SUM(Revenue IS NULL) AS Missing_Revenue,

    SUM(Profit IS NULL) AS Missing_Profit,

    SUM(Revenue = 0) AS Zero_Revenue,

    SUM(
        Revenue IS NOT NULL
        AND Revenue <> 0
        AND Profit IS NOT NULL
    ) AS Inputs_Available

FROM supply_chain_clean
WHERE Profit_Margin IS NULL;

UPDATE supply_chain_clean
SET Profit_Margin = ROUND(Profit / Revenue, 4)
WHERE Profit_Margin IS NULL
  AND Revenue IS NOT NULL
  AND Revenue <> 0
  AND Profit IS NOT NULL;
  
SELECT
    COUNT(*) AS Total_Records,
    SUM(Profit_Margin IS NULL) AS Remaining_Null,
    SUM(Profit_Margin IS NOT NULL) AS Available_Profit_Margin,
    SUM(Profit_Margin < 0) AS Negative_Profit_Margin
FROM supply_chain_clean;

SELECT
    Inventory_Status,
    COUNT(*) AS Total_Records
FROM supply_chain_clean
GROUP BY Inventory_Status
ORDER BY Total_Records DESC;

SELECT
    SUM(Inventory_Status IS NULL) AS Null_Inventory_Status,
    SUM(TRIM(Inventory_Status) = '') AS Empty_Inventory_Status,
    SUM(Stock_Available IS NULL) AS Missing_Stock
FROM supply_chain_clean;

UPDATE supply_chain_clean
SET Inventory_Status = NULL
WHERE TRIM(Inventory_Status) = '';

SELECT
    SUM(Inventory_Status IS NULL) AS Null_Inventory_Status,
    SUM(TRIM(Inventory_Status) = '') AS Empty_Inventory_Status
FROM supply_chain_clean;

SELECT
    COUNT(*) AS Total_Records,

    SUM(
        Stock_Available IS NOT NULL
        AND Reorder_Level IS NOT NULL
        AND Inventory_Status = 'Adequate Stock'
        AND Stock_Available >= Reorder_Level
    ) AS Adequate_Stock_Records,

    SUM(
        Stock_Available IS NOT NULL
        AND Reorder_Level IS NOT NULL
        AND Inventory_Status = 'Low Stock'
        AND Stock_Available < Reorder_Level
    ) AS Low_Stock_Records,

    SUM(
        Stock_Available IS NULL
        OR Reorder_Level IS NULL
    ) AS Missing_Input_Records

FROM supply_chain_clean;

SELECT
    Order_Line_ID,
    Product_ID,
    Warehouse_ID,
    Stock_Available,
    Reorder_Level,
    Inventory_Status,
    CASE
        WHEN Stock_Available >= Reorder_Level
            THEN 'Adequate Stock'
        WHEN Stock_Available < Reorder_Level
            THEN 'Low Stock'
    END AS Expected_Status
FROM supply_chain_clean
WHERE Stock_Available IS NOT NULL
  AND Reorder_Level IS NOT NULL
  AND (
      (Stock_Available >= Reorder_Level
       AND Inventory_Status <> 'Adequate Stock')
      OR
      (Stock_Available < Reorder_Level
       AND Inventory_Status <> 'Low Stock')
  );
  
SELECT
    SUM(
        Stock_Available > Reorder_Level
        AND Inventory_Status = 'Adequate Stock'
    ) AS Adequate_Stock_Records,

    SUM(
        Stock_Available <= Reorder_Level
        AND Inventory_Status = 'Low Stock'
    ) AS Low_Stock_Records,

    SUM(Stock_Available IS NULL) AS Missing_Stock_Records

FROM supply_chain_clean;

SELECT
    SUM(
        Revenue IS NOT NULL
        AND Quantity_Ordered IS NOT NULL
        AND Unit_Price IS NOT NULL
        AND ABS(
            Revenue -
            (Quantity_Ordered * Unit_Price * (1 - Discount_Pct))
        ) > 0.01
    ) AS Revenue_Mismatches,

    SUM(
        Total_Cost IS NOT NULL
        AND Quantity_Ordered IS NOT NULL
        AND Unit_Cost IS NOT NULL
        AND ABS(
            Total_Cost -
            (Quantity_Ordered * Unit_Cost)
        ) > 0.01
    ) AS Total_Cost_Mismatches,

    SUM(
        Profit IS NOT NULL
        AND Revenue IS NOT NULL
        AND Total_Cost IS NOT NULL
        AND ABS(Profit - (Revenue - Total_Cost)) > 0.01
    ) AS Profit_Mismatches

FROM supply_chain_clean;

SELECT
    COUNT(*) AS Eligible_Records,
    SUM(
        ABS(Profit_Margin - (Profit / Revenue)) > 0.0005
    ) AS Profit_Margin_Mismatches
FROM supply_chain_clean
WHERE Profit_Margin IS NOT NULL
  AND Profit IS NOT NULL
  AND Revenue IS NOT NULL
  AND Revenue <> 0;
  
SELECT
    COUNT(*) AS Eligible_Records,
    SUM(
        Delivery_Days <> DATEDIFF(
            Actual_Delivery_Date,
            Ship_Date
        )
    ) AS Delivery_Days_Mismatches
FROM supply_chain_clean
WHERE Delivery_Days IS NOT NULL
  AND Actual_Delivery_Date IS NOT NULL
  AND Ship_Date IS NOT NULL;
  
SELECT
    COUNT(*) AS Eligible_Records,

    SUM(
        (On_Time_Flag = 1
         AND Actual_Delivery_Date > Expected_Delivery_Date)
        OR
        (On_Time_Flag = 0
         AND Actual_Delivery_Date <= Expected_Delivery_Date)
    ) AS On_Time_Flag_Mismatches

FROM supply_chain_clean
WHERE Actual_Delivery_Date IS NOT NULL
  AND Expected_Delivery_Date IS NOT NULL
  AND On_Time_Flag IS NOT NULL;
  
SELECT
    Order_Line_ID,
    Order_Date,
    Ship_Date,
    Expected_Delivery_Date,
    Actual_Delivery_Date,
    Order_Status,
    Delivery_Days,
    On_Time_Flag,
    CASE
        WHEN Actual_Delivery_Date <= Expected_Delivery_Date
            THEN 1
        ELSE 0
    END AS Expected_On_Time_Flag
FROM supply_chain_clean
WHERE Actual_Delivery_Date IS NOT NULL
  AND Expected_Delivery_Date IS NOT NULL
  AND On_Time_Flag IS NOT NULL
  AND (
      (On_Time_Flag = 1
       AND Actual_Delivery_Date > Expected_Delivery_Date)
      OR
      (On_Time_Flag = 0
       AND Actual_Delivery_Date <= Expected_Delivery_Date)
  );
  
SELECT
    COUNT(*) AS Eligible_Records,
    SUM(
        On_Time_Flag <>
        CASE
            WHEN Actual_Delivery_Date <= Expected_Delivery_Date
            THEN 1
            ELSE 0
        END
    ) AS Actual_Flag_Mismatches
FROM supply_chain_clean
WHERE Actual_Delivery_Date IS NOT NULL
  AND Expected_Delivery_Date IS NOT NULL
  AND On_Time_Flag IS NOT NULL;
  
SELECT
    Order_Line_ID,
    Actual_Delivery_Date,
    Expected_Delivery_Date,
    On_Time_Flag,
    CAST(On_Time_Flag AS UNSIGNED) AS Numeric_Flag,
    CASE
        WHEN Actual_Delivery_Date <= Expected_Delivery_Date
        THEN 1
        ELSE 0
    END AS Expected_Flag,
    On_Time_Flag = 1 AS Flag_Comparison,
    DATEDIFF(
        Actual_Delivery_Date,
        Expected_Delivery_Date
    ) AS Date_Difference
FROM supply_chain_clean
WHERE Actual_Delivery_Date IS NOT NULL
  AND Expected_Delivery_Date IS NOT NULL
  AND On_Time_Flag IS NOT NULL
  AND On_Time_Flag <>
      CASE
          WHEN Actual_Delivery_Date <= Expected_Delivery_Date
          THEN 1
          ELSE 0
      END;

SELECT
    COUNT(*) AS Empty_On_Time_Flag,
    SUM(On_Time_Flag IS NULL) AS Null_On_Time_Flag
FROM supply_chain_clean
WHERE TRIM(On_Time_Flag) = '';

SELECT
    COUNT(*) AS Empty_Flag_Records,

    SUM(
        Actual_Delivery_Date IS NOT NULL
        AND Expected_Delivery_Date IS NOT NULL
    ) AS Both_Dates_Available,

    SUM(
        Actual_Delivery_Date IS NULL
        OR Expected_Delivery_Date IS NULL
    ) AS One_Or_Both_Dates_Missing

FROM supply_chain_clean
WHERE TRIM(On_Time_Flag) = '';

UPDATE supply_chain_clean
SET On_Time_Flag =
    CASE
        WHEN Actual_Delivery_Date IS NOT NULL
             AND Expected_Delivery_Date IS NOT NULL
        THEN
            CASE
                WHEN Actual_Delivery_Date <= Expected_Delivery_Date
                THEN 1
                ELSE 0
            END
        ELSE NULL
    END
WHERE TRIM(On_Time_Flag) = '';

SELECT
    COUNT(*) AS Total_Records,
    SUM(TRIM(On_Time_Flag) = '') AS Empty_Flag_Records,
    SUM(On_Time_Flag IS NULL) AS Null_Flag_Records,
    SUM(On_Time_Flag = '1') AS On_Time_Records,
    SUM(On_Time_Flag = '0') AS Late_Records
FROM supply_chain_clean;

SELECT
    COUNT(*) AS Eligible_Records,
    SUM(
        On_Time_Flag <>
        CASE
            WHEN Actual_Delivery_Date <= Expected_Delivery_Date
            THEN 1
            ELSE 0
        END
    ) AS On_Time_Flag_Mismatches
FROM supply_chain_clean
WHERE Actual_Delivery_Date IS NOT NULL
  AND Expected_Delivery_Date IS NOT NULL
  AND On_Time_Flag IS NOT NULL;
  
SELECT
    COUNT(*) AS Total_Records,

    SUM(
        Return_Flag = 'Yes'
        AND Return_Rate = 0
    ) AS Yes_With_Zero_Rate,

    SUM(
        Return_Flag = 'No'
        AND Return_Rate > 0
    ) AS No_With_Positive_Rate,

    SUM(Return_Flag IS NULL) AS Missing_Return_Flag,
    SUM(Return_Rate IS NULL) AS Missing_Return_Rate

FROM supply_chain_clean;

SELECT
    SUM(TRIM(Supplier_ID) = '') AS Empty_Supplier_ID,
    SUM(TRIM(Payment_Method) = '') AS Empty_Payment_Method,
    SUM(TRIM(Inventory_Status) = '') AS Empty_Inventory_Status,
    SUM(TRIM(On_Time_Flag) = '') AS Empty_On_Time_Flag,
    SUM(TRIM(Customer_City) = '') AS Empty_Customer_City,
    SUM(TRIM(Region) = '') AS Empty_Region,
    SUM(TRIM(Product_Category) = '') AS Empty_Product_Category,
    SUM(TRIM(Shipping_Type) = '') AS Empty_Shipping_Type,
    SUM(TRIM(Order_Status) = '') AS Empty_Order_Status,
    SUM(TRIM(Return_Flag) = '') AS Empty_Return_Flag
FROM supply_chain_clean;

SELECT
    COUNT(*) AS Total_Records,
    COUNT(DISTINCT Order_Line_ID) AS Unique_Order_Line_IDs,
    SUM(Order_Line_ID IS NULL) AS Missing_Order_Line_ID,
    SUM(Supplier_ID IS NULL) AS Missing_Supplier_ID,
    SUM(Quantity_Ordered IS NULL) AS Missing_Quantity,
    SUM(Unit_Price IS NULL) AS Missing_Unit_Price,
    SUM(Unit_Cost IS NULL) AS Missing_Unit_Cost,
    SUM(Shipping_Cost IS NULL) AS Missing_Shipping_Cost,
    SUM(Stock_Available IS NULL) AS Missing_Stock,
    SUM(Payment_Method IS NULL) AS Missing_Payment_Method,
    SUM(Delivery_Days IS NULL) AS Missing_Delivery_Days,
    SUM(On_Time_Flag IS NULL) AS Missing_On_Time_Flag,
    SUM(Profit_Margin IS NULL) AS Missing_Profit_Margin
FROM supply_chain_clean;

SELECT
    COUNT(*) AS Total_Records,
    COUNT(DISTINCT Order_Line_ID) AS Unique_IDs,
    COUNT(*) - COUNT(DISTINCT Order_Line_ID) AS Duplicate_IDs
FROM supply_chain_clean;

SELECT
    Product_Category,
    COUNT(*) AS Total_Order_Lines,
    SUM(Revenue) AS Total_Revenue,
    SUM(Profit) AS Total_Profit
FROM supply_chain_clean
GROUP BY Product_Category
ORDER BY Total_Revenue DESC;

SELECT
    YEAR(Order_Date) AS Order_Year,
    MONTHNAME(Order_Date) AS Order_Month,
    MONTH(Order_Date) AS Month_Number,
    SUM(Revenue) AS Total_Revenue,
    SUM(Profit) AS Total_Profit
FROM supply_chain_clean
GROUP BY
    YEAR(Order_Date),
    MONTH(Order_Date),
    MONTHNAME(Order_Date)
ORDER BY
    Order_Year,
    Month_Number;
    
SELECT
    Product_ID,
    COUNT(*) AS Total_Order_Lines,
    SUM(Quantity_Ordered) AS Total_Quantity_Sold,
    SUM(Revenue) AS Total_Revenue,
    SUM(Profit) AS Total_Profit
FROM supply_chain_clean
GROUP BY Product_ID
ORDER BY Total_Revenue DESC
LIMIT 10;

SELECT
    Region,
    COUNT(*) AS Total_Order_Lines,
    SUM(Revenue) AS Total_Revenue,
    SUM(Profit) AS Total_Profit
FROM supply_chain_clean
GROUP BY Region
ORDER BY Total_Revenue DESC;

SELECT
    Payment_Method,
    COUNT(*) AS Total_Order_Lines,
    SUM(Revenue) AS Total_Revenue,
    SUM(Profit) AS Total_Profit
FROM supply_chain_clean
GROUP BY Payment_Method
ORDER BY Total_Revenue DESC;

SELECT
    Customer_ID,
    COUNT(*) AS Total_Order_Lines,
    SUM(Quantity_Ordered) AS Total_Quantity_Purchased,
    SUM(Revenue) AS Total_Revenue,
    SUM(Profit) AS Total_Profit
FROM supply_chain_clean
GROUP BY Customer_ID
ORDER BY Total_Revenue DESC
LIMIT 10;

SELECT
    Product_Category,
    SUM(Revenue) AS Total_Revenue,
    SUM(Profit) AS Total_Profit,
    ROUND(
        (SUM(Profit) / NULLIF(SUM(Revenue), 0)) * 100,
        2
    ) AS Profit_Margin_Pct
FROM supply_chain_clean
GROUP BY Product_Category
ORDER BY Profit_Margin_Pct DESC;

SELECT
    YEAR(Order_Date) AS Order_Year,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    SUM(Revenue) AS Total_Revenue,
    SUM(Profit) AS Total_Profit,
    ROUND(
        (SUM(Profit) / NULLIF(SUM(Revenue), 0)) * 100,
        2
    ) AS Profit_Margin_Pct
FROM supply_chain_clean
GROUP BY YEAR(Order_Date)
ORDER BY Order_Year;

SELECT
    Product_ID,
    COUNT(*) AS Total_Order_Lines,
    SUM(Revenue) AS Total_Revenue,
    SUM(Profit) AS Total_Profit
FROM supply_chain_clean
GROUP BY Product_ID
HAVING SUM(Profit) < 0
ORDER BY Total_Profit ASC
LIMIT 10;

SELECT
    Product_ID,
    COUNT(*) AS Total_Order_Lines,
    SUM(Revenue) AS Total_Revenue,
    SUM(Profit) AS Total_Profit,
    ROUND(
        (SUM(Profit) / NULLIF(SUM(Revenue), 0)) * 100,
        2
    ) AS Profit_Margin_Pct
FROM supply_chain_clean
GROUP BY Product_ID
HAVING SUM(Revenue) > 0
ORDER BY Profit_Margin_Pct ASC
LIMIT 10;

SELECT
    Customer_ID,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    SUM(Revenue) AS Total_Revenue,
    SUM(Profit) AS Total_Profit
FROM supply_chain_clean
GROUP BY Customer_ID
ORDER BY Total_Profit DESC
LIMIT 10;

SELECT
    Customer_City,
    COUNT(DISTINCT Customer_ID) AS Total_Customers,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    SUM(Revenue) AS Total_Revenue,
    SUM(Profit) AS Total_Profit
FROM supply_chain_clean
WHERE Customer_City IS NOT NULL
GROUP BY Customer_City
ORDER BY Total_Revenue DESC
LIMIT 10;

SELECT
    Product_ID,
    COUNT(*) AS Total_Records,
    AVG(Stock_Available) AS Avg_Stock,
    AVG(Reorder_Level) AS Avg_Reorder_Level,
    SUM(
        CASE
            WHEN Stock_Available <= Reorder_Level THEN 1
            ELSE 0
        END
    ) AS Low_Stock_Records
FROM supply_chain_clean
WHERE Stock_Available IS NOT NULL
GROUP BY Product_ID
HAVING SUM(
    CASE
        WHEN Stock_Available <= Reorder_Level THEN 1
        ELSE 0
    END
) > 0
ORDER BY Low_Stock_Records DESC
LIMIT 10;

SELECT
    Product_Category,
    COUNT(*) AS Total_Records,
    SUM(
        CASE
            WHEN Stock_Available <= Reorder_Level THEN 1
            ELSE 0
        END
    ) AS Low_Stock_Records,
    ROUND(
        SUM(
            CASE
                WHEN Stock_Available <= Reorder_Level THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS Low_Stock_Percentage
FROM supply_chain_clean
WHERE Stock_Available IS NOT NULL
GROUP BY Product_Category
ORDER BY Low_Stock_Records DESC;

SELECT
    Warehouse_ID,
    COUNT(*) AS Total_Records,
    SUM(
        CASE
            WHEN Stock_Available <= Reorder_Level THEN 1
            ELSE 0
        END
    ) AS Low_Stock_Records,
    ROUND(
        SUM(
            CASE
                WHEN Stock_Available <= Reorder_Level THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS Low_Stock_Percentage
FROM supply_chain_clean
WHERE Stock_Available IS NOT NULL
GROUP BY Warehouse_ID
ORDER BY Low_Stock_Records DESC;

SELECT
    Product_Category,
    Inventory_Status,
    COUNT(*) AS Total_Records,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (
            PARTITION BY Product_Category
        ),
        2
    ) AS Status_Percentage
FROM supply_chain_clean
WHERE Inventory_Status IS NOT NULL
GROUP BY
    Product_Category,
    Inventory_Status
ORDER BY
    Product_Category,
    Total_Records DESC;
    
SELECT
    Shipping_Type,
    COUNT(*) AS Total_Valid_Deliveries,
    SUM(
        CASE
            WHEN On_Time_Flag = 1 THEN 1
            ELSE 0
        END
    ) AS On_Time_Deliveries,
    SUM(
        CASE
            WHEN On_Time_Flag = 0 THEN 1
            ELSE 0
        END
    ) AS Late_Deliveries,
    ROUND(
        SUM(
            CASE
                WHEN On_Time_Flag = 1 THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS On_Time_Delivery_Rate
FROM supply_chain_clean
WHERE On_Time_Flag IS NOT NULL
GROUP BY Shipping_Type
ORDER BY On_Time_Delivery_Rate DESC;

SELECT
    Shipping_Type,
    COUNT(Delivery_Days) AS Valid_Deliveries,
    ROUND(AVG(Delivery_Days), 2) AS Avg_Delivery_Days,
    MIN(Delivery_Days) AS Min_Delivery_Days,
    MAX(Delivery_Days) AS Max_Delivery_Days
FROM supply_chain_clean
WHERE Delivery_Days IS NOT NULL
GROUP BY Shipping_Type
ORDER BY Avg_Delivery_Days ASC;

SELECT
    Product_Category,
    COUNT(*) AS Total_Order_Lines,
    SUM(
        CASE
            WHEN Return_Flag = 'Yes' THEN 1
            ELSE 0
        END
    ) AS Returned_Order_Lines,
    ROUND(
        SUM(
            CASE
                WHEN Return_Flag = 'Yes' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS Return_Rate_Pct
FROM supply_chain_clean
WHERE Return_Flag IS NOT NULL
GROUP BY Product_Category
ORDER BY Return_Rate_Pct DESC;

SELECT
    Region,
    COUNT(*) AS Total_Order_Lines,
    SUM(
        CASE
            WHEN Return_Flag = 'Yes' THEN 1
            ELSE 0
        END
    ) AS Returned_Order_Lines,
    ROUND(
        SUM(
            CASE
                WHEN Return_Flag = 'Yes' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS Return_Rate_Pct
FROM supply_chain_clean
WHERE Return_Flag IS NOT NULL
GROUP BY Region
ORDER BY Return_Rate_Pct DESC;
