-- Retail SQL Learning | 07 Window Functions

-- ROW_NUMBER: latest order per customer
WITH RankedOrders AS (
    SELECT o.*,
           ROW_NUMBER() OVER (
               PARTITION BY CustomerID
               ORDER BY OrderDate DESC, OrderID DESC
           ) AS rn
    FROM dbo.Orders o
)
SELECT *
FROM RankedOrders
WHERE rn = 1;

-- RANK products by revenue
WITH ProductSales AS (
    SELECT ProductID, SUM(LineAmount) AS Revenue
    FROM dbo.OrderLines
    GROUP BY ProductID
)
SELECT ProductID,
       Revenue,
       RANK() OVER (ORDER BY Revenue DESC) AS RevenueRank
FROM ProductSales;

-- Running revenue
SELECT OrderDate,
       TotalAmount,
       SUM(TotalAmount) OVER (
           ORDER BY OrderDate, OrderID
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS RunningRevenue
FROM dbo.Orders;

-- LAG / LEAD
SELECT CustomerID,
       OrderID,
       OrderDate,
       TotalAmount,
       LAG(TotalAmount) OVER (
           PARTITION BY CustomerID ORDER BY OrderDate
       ) AS PreviousOrderAmount,
       LEAD(TotalAmount) OVER (
           PARTITION BY CustomerID ORDER BY OrderDate
       ) AS NextOrderAmount
FROM dbo.Orders;

-- Percent of category revenue
SELECT p.CategoryName,
       p.ProductID,
       SUM(ol.LineAmount) AS ProductRevenue,
       100.0 * SUM(ol.LineAmount)
       / SUM(SUM(ol.LineAmount)) OVER (PARTITION BY p.CategoryName)
       AS CategoryRevenuePct
FROM dbo.Products p
JOIN dbo.OrderLines ol
  ON p.ProductID = ol.ProductID
GROUP BY p.CategoryName, p.ProductID;
