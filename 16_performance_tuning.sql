-- Retail SQL Learning | 16 Performance Tuning

-- Avoid SELECT *
SELECT OrderID, CustomerID, OrderDate, TotalAmount
FROM dbo.Orders
WHERE CustomerID = @CustomerID;

-- SARGable predicate: preferred
SELECT *
FROM dbo.Orders
WHERE OrderDate >= '2026-01-01'
  AND OrderDate <  '2027-01-01';

-- Avoid functions on indexed columns when possible
-- Less efficient:
-- WHERE YEAR(OrderDate) = 2026

-- Better:
SELECT *
FROM dbo.Orders
WHERE OrderDate >= '2026-01-01'
  AND OrderDate < '2027-01-01';

-- Reduce rows before joining
WITH RecentOrders AS (
    SELECT OrderID, CustomerID, OrderDate, TotalAmount
    FROM dbo.Orders
    WHERE OrderDate >= DATEADD(DAY, -90, GETDATE())
)
SELECT ro.OrderID, c.CustomerID, c.FirstName, ro.TotalAmount
FROM RecentOrders ro
JOIN dbo.Customers c
  ON ro.CustomerID = c.CustomerID;

-- Temp table can help when a large intermediate result is reused
SELECT CustomerID, SUM(TotalAmount) AS Revenue
INTO #CustomerRevenue
FROM dbo.Orders
GROUP BY CustomerID;

CREATE INDEX IX_CustomerRevenue_CustomerID
ON #CustomerRevenue(CustomerID);

SELECT *
FROM #CustomerRevenue
WHERE Revenue > 100000;

-- Inspect logical IO/time
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT CustomerID, SUM(TotalAmount)
FROM dbo.Orders
GROUP BY CustomerID;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
