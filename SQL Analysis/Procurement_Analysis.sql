CREATE DATABASE supply_chain;
USE supply_chain;

-- ============================================
-- PROCUREMENT ANALYSIS
-- ============================================

-- 1. Total number of orders
SELECT 
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM SupplyChain_Cleaned;


-- 2. Total order quantity
SELECT 
    SUM(Order_Quantity) AS Total_Order_Quantity
FROM SupplyChain_Cleaned;


-- 3. Total procurement cost
SELECT 
    ROUND(SUM(Total_Cost), 2) AS Total_Procurement_Cost
FROM SupplyChain_Cleaned;


-- 4. Average unit price
SELECT 
    ROUND(AVG(Unit_Price), 2) AS Average_Unit_Price
FROM SupplyChain_Cleaned;


-- 5. Procurement cost by product
SELECT
    Product_ID,
    Product_Name,
    Product_Category,
    ROUND(SUM(Total_Cost), 2) AS Procurement_Cost
FROM SupplyChain_Cleaned
GROUP BY
    Product_ID,
    Product_Name,
    Product_Category
ORDER BY Procurement_Cost DESC;


-- 6. Product with the highest procurement cost
SELECT
    Product_ID,
    Product_Name,
    Product_Category,
    ROUND(SUM(Total_Cost), 2) AS Procurement_Cost
FROM SupplyChain_Cleaned
GROUP BY
    Product_ID,
    Product_Name,
    Product_Category
ORDER BY Procurement_Cost DESC
LIMIT 1;


-- 7. Procurement cost by category
SELECT
    Product_Category,
    SUM(Order_Quantity) AS Total_Quantity,
    ROUND(SUM(Total_Cost), 2) AS Procurement_Cost,
    ROUND(AVG(Unit_Price), 2) AS Average_Unit_Price
FROM SupplyChain_Cleaned
GROUP BY Product_Category
ORDER BY Procurement_Cost DESC;


-- 8. Procurement cost by month
SELECT
    YEAR(Order_Date) AS Order_Year,
    MONTH(Order_Date) AS Order_Month,
    ROUND(SUM(Total_Cost), 2) AS Procurement_Cost
FROM SupplyChain_Cleaned
GROUP BY
    YEAR(Order_Date),
    MONTH(Order_Date)
ORDER BY
    Order_Year,
    Order_Month;