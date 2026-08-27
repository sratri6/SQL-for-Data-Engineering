-- Retail SQL Learning | 15 Data Quality & Validation

-- Null checks
SELECT COUNT(*) AS NullCustomerIDs
FROM dbo.Orders
WHERE CustomerID IS NULL;

-- Duplicate business keys
SELECT OrderID, COUNT(*) AS DuplicateCount
FROM dbo.Orders
GROUP BY OrderID
HAVING COUNT(*) > 1;

-- Referential integrity
SELECT o.OrderID
FROM dbo.Orders o
LEFT JOIN dbo.Customers c
  ON o.CustomerID = c.CustomerID
WHERE c.CustomerID IS NULL;

-- Domain validation
SELECT *
FROM dbo.OrderLines
WHERE Quantity <= 0
   OR LineAmount < 0;

-- Price validation
SELECT p.ProductID, p.ProductName
FROM dbo.Products p
WHERE p.UnitPrice < 0
   OR p.CostPrice < 0
   OR p.CostPrice > p.UnitPrice;

-- Date validation
SELECT *
FROM dbo.Orders
WHERE DeliveryDate < OrderDate;

-- Completeness check by source
SELECT SourceSystem,
       COUNT(*) AS RowCount,
       COUNT(DISTINCT OrderID) AS DistinctOrders
FROM dbo.Orders
GROUP BY SourceSystem;

-- Reconciliation: header vs line total
SELECT o.OrderID,
       o.TotalAmount,
       SUM(ol.LineAmount) AS CalculatedAmount,
       o.TotalAmount - SUM(ol.LineAmount) AS Difference
FROM dbo.Orders o
JOIN dbo.OrderLines ol ON o.OrderID = ol.OrderID
GROUP BY o.OrderID, o.TotalAmount
HAVING ABS(o.TotalAmount - SUM(ol.LineAmount)) > 0.01;
