USE supply_chain;

-- ============================================
-- OPERATIONS ANALYSIS
-- ============================================

-- 1. Total orders
SELECT
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM SupplyChain_Cleaned;


-- 2. Orders by status
SELECT
    Order_Status,
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM SupplyChain_Cleaned
GROUP BY Order_Status
ORDER BY Total_Orders DESC;


-- 3. Delivered vs cancelled orders
SELECT
    SUM(CASE 
        WHEN Order_Status = 'Delivered' THEN 1 
        ELSE 0 
    END) AS Delivered_Orders,

    SUM(CASE 
        WHEN Order_Status = 'Cancelled' THEN 1 
        ELSE 0 
    END) AS Cancelled_Orders
FROM SupplyChain_Cleaned;


-- 4. Delivery performance percentage
SELECT
    ROUND(
        SUM(CASE 
            WHEN Order_Status = 'Delivered' THEN 1 
            ELSE 0 
        END) * 100.0 / COUNT(DISTINCT Order_ID),
        2
    ) AS Delivery_Performance_Percent
FROM SupplyChain_Cleaned;


-- 5. Average delivery time
SELECT
    ROUND(AVG(Delivery_Time_Days), 2) AS Average_Delivery_Time_Days
FROM SupplyChain_Cleaned;


-- 6. Shipping costs
SELECT
    ROUND(SUM(Shipping_Cost), 2) AS Total_Shipping_Cost,
    ROUND(AVG(Shipping_Cost), 2) AS Average_Shipping_Cost
FROM SupplyChain_Cleaned;


-- 7. Transportation mode analysis
SELECT
    Transportation_Mode,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    ROUND(AVG(Delivery_Time_Days), 2) AS Average_Delivery_Time,
    ROUND(SUM(Shipping_Cost), 2) AS Total_Shipping_Cost
FROM SupplyChain_Cleaned
GROUP BY Transportation_Mode
ORDER BY Total_Orders DESC;