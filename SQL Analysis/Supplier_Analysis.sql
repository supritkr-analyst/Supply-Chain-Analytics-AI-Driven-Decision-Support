USE supply_chain;

---- ============================================
-- SUPPLIER ANALYSIS
-- ============================================

-- 1. Orders by supplier
SELECT
    Supplier_ID,
    Supplier_Name,
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM SupplyChain_Cleaned
GROUP BY
    Supplier_ID,
    Supplier_Name
ORDER BY Total_Orders DESC;


-- 2. Quantity supplied by supplier
SELECT
    Supplier_ID,
    Supplier_Name,
    SUM(Order_Quantity) AS Total_Quantity_Supplied
FROM SupplyChain_Cleaned
GROUP BY
    Supplier_ID,
    Supplier_Name
ORDER BY Total_Quantity_Supplied DESC;


-- 3. Procurement cost by supplier
SELECT
    Supplier_ID,
    Supplier_Name,
    ROUND(SUM(Total_Cost), 2) AS Total_Procurement_Cost
FROM SupplyChain_Cleaned
GROUP BY
    Supplier_ID,
    Supplier_Name
ORDER BY Total_Procurement_Cost DESC;


-- 4. Profit by supplier
SELECT
    Supplier_ID,
    Supplier_Name,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM SupplyChain_Cleaned
GROUP BY
    Supplier_ID,
    Supplier_Name
ORDER BY Total_Profit DESC;


-- 5. Supplier delivery performance
SELECT
    Supplier_ID,
    Supplier_Name,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    SUM(CASE 
        WHEN Order_Status = 'Delivered' THEN 1 
        ELSE 0 
    END) AS Delivered_Orders,
    ROUND(
        SUM(CASE 
            WHEN Order_Status = 'Delivered' THEN 1 
            ELSE 0 
        END) * 100.0 / COUNT(DISTINCT Order_ID),
        2
    ) AS Delivery_Performance_Percent,
    ROUND(AVG(Delivery_Time_Days), 2) AS Average_Delivery_Time
FROM SupplyChain_Cleaned
GROUP BY
    Supplier_ID,
    Supplier_Name
ORDER BY Delivery_Performance_Percent DESC;


-- 6. Complete supplier performance summary
SELECT
    Supplier_ID,
    Supplier_Name,
    Supplier_Region,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    SUM(Order_Quantity) AS Quantity_Supplied,
    ROUND(SUM(Total_Cost), 2) AS Procurement_Cost,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(AVG(Delivery_Time_Days), 2) AS Avg_Delivery_Days,
    ROUND(AVG(Shipping_Cost), 2) AS Avg_Shipping_Cost
FROM SupplyChain_Cleaned
GROUP BY
    Supplier_ID,
    Supplier_Name,
    Supplier_Region
ORDER BY Total_Profit DESC;