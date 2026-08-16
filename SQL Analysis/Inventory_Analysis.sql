USE supply_chain;

-- ============================================
-- INVENTORY ANALYSIS
-- ============================================

-- 1. Total inventory level
SELECT
    SUM(Inventory_Level) AS Total_Inventory
FROM SupplyChain_Cleaned;


-- 2. Average inventory level
SELECT
    ROUND(AVG(Inventory_Level), 2) AS Average_Inventory_Level
FROM SupplyChain_Cleaned;


-- 3. Inventory by product
SELECT
    Product_ID,
    Product_Name,
    Product_Category,
    ROUND(AVG(Inventory_Level), 2) AS Average_Inventory_Level
FROM SupplyChain_Cleaned
GROUP BY
    Product_ID,
    Product_Name,
    Product_Category
ORDER BY Average_Inventory_Level DESC;


-- 4. Inventory by category
SELECT
    Product_Category,
    SUM(Inventory_Level) AS Total_Inventory,
    ROUND(AVG(Inventory_Level), 2) AS Average_Inventory
FROM SupplyChain_Cleaned
GROUP BY Product_Category
ORDER BY Total_Inventory DESC;


-- 5. Low-stock products
-- Low stock threshold = 500 units
SELECT
    Product_ID,
    Product_Name,
    Product_Category,
    Inventory_Level
FROM SupplyChain_Cleaned
WHERE Inventory_Level < 500
ORDER BY Inventory_Level ASC;


-- 6. Number of low-stock products
SELECT
    COUNT(DISTINCT Product_ID) AS Low_Stock_Products
FROM SupplyChain_Cleaned
WHERE Inventory_Level < 500;


-- 7. Products with highest inventory
SELECT
    Product_ID,
    Product_Name,
    Product_Category,
    Inventory_Level
FROM SupplyChain_Cleaned
ORDER BY Inventory_Level DESC
LIMIT 10;


-- 8. Inventory by warehouse
SELECT
    Warehouse_ID,
    Warehouse_Location,
    SUM(Inventory_Level) AS Total_Inventory,
    ROUND(AVG(Inventory_Level), 2) AS Average_Inventory
FROM SupplyChain_Cleaned
GROUP BY
    Warehouse_ID,
    Warehouse_Location
ORDER BY Total_Inventory DESC;