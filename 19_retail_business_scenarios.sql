-- Retail SQL Learning | 19 Real-World Retail Business Scenarios

-- 1. Top 10 customers by revenue
SELECT TOP (10)
       o.CustomerID,
       SUM(o.TotalAmount) AS Revenue
FROM dbo.Orders o
GROUP BY o.CustomerID
ORDER BY Revenue DESC;

-- 2. Best-selling products
SELECT TOP (20)
       p.ProductID,
       p.ProductName,
       SUM(ol.Quantity) AS UnitsSold,
       SUM(ol.LineAmount) AS Revenue
FROM dbo.OrderLines ol
JOIN dbo.Products p ON ol.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY UnitsSold DESC;

-- 3. Basket size
SELECT AVG(OrderItemCount * 1.0) AS AverageItemsPerOrder
FROM (
    SELECT OrderID, SUM(Quantity) AS OrderItemCount
    FROM dbo.OrderLines
    GROUP BY OrderID
) x;

-- 4. Repeat customers
SELECT CustomerID,
       COUNT(DISTINCT OrderID) AS OrderCount
FROM dbo.Orders
GROUP BY CustomerID
HAVING COUNT(DISTINCT OrderID) >= 2;

-- 5. Customer RFM-style metrics
SELECT CustomerID,
       DATEDIFF(DAY, MAX(OrderDate), CAST(GETDATE() AS date)) AS RecencyDays,
       COUNT(DISTINCT OrderID) AS Frequency,
       SUM(TotalAmount) AS MonetaryValue
FROM dbo.Orders
GROUP BY CustomerID;

-- 6. Store vs online sales
SELECT SalesChannel,
       SUM(TotalAmount) AS Revenue,
       COUNT(DISTINCT OrderID) AS Orders
FROM dbo.Orders
GROUP BY SalesChannel;

-- 7. Product margin
SELECT p.ProductID,
       p.ProductName,
       SUM(ol.Quantity * (p.UnitPrice - p.CostPrice)) AS GrossMargin
FROM dbo.OrderLines ol
JOIN dbo.Products p ON ol.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY GrossMargin DESC;

-- 8. Stockout candidates
SELECT ProductID, ProductName, StockQuantity
FROM dbo.Products
WHERE StockQuantity <= ReorderLevel
ORDER BY StockQuantity;

-- 9. Promotion effectiveness
SELECT PromotionID,
       COUNT(DISTINCT OrderID) AS Orders,
       SUM(TotalAmount) AS Revenue
FROM dbo.Orders
WHERE PromotionID IS NOT NULL
GROUP BY PromotionID;

-- 10. Customer churn proxy
SELECT CustomerID,
       MAX(OrderDate) AS LastPurchase,
       DATEDIFF(DAY, MAX(OrderDate), CAST(GETDATE() AS date)) AS InactiveDays
FROM dbo.Orders
GROUP BY CustomerID
HAVING DATEDIFF(DAY, MAX(OrderDate), CAST(GETDATE() AS date)) > 180;
