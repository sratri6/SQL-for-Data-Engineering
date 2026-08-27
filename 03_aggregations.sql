-- Retail SQL Learning | 03 Aggregations

-- COUNT
SELECT COUNT(*) AS TotalCustomers
FROM dbo.Customers;

-- SUM / AVG / MIN / MAX
SELECT
    SUM(LineAmount) AS Revenue,
    AVG(LineAmount) AS AverageOrderLine,
    MIN(LineAmount) AS MinimumLineValue,
    MAX(LineAmount) AS MaximumLineValue
FROM dbo.OrderLines;

-- GROUP BY
SELECT ProductID,
       SUM(Quantity) AS UnitsSold,
       SUM(LineAmount) AS Revenue
FROM dbo.OrderLines
GROUP BY ProductID;

-- HAVING
SELECT CustomerID,
       COUNT(DISTINCT OrderID) AS Orders,
       SUM(LineAmount) AS Revenue
FROM dbo.OrderLines
GROUP BY CustomerID
HAVING SUM(LineAmount) > 100000;

-- Monthly revenue
SELECT YEAR(OrderDate) AS OrderYear,
       MONTH(OrderDate) AS OrderMonth,
       SUM(TotalAmount) AS Revenue
FROM dbo.Orders
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY OrderYear, OrderMonth;
