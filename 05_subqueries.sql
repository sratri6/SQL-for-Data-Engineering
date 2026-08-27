-- Retail SQL Learning | 05 Subqueries

-- Products above average price
SELECT ProductID, ProductName, UnitPrice
FROM dbo.Products
WHERE UnitPrice > (
    SELECT AVG(UnitPrice)
    FROM dbo.Products
);

-- Customers with at least one order
SELECT CustomerID, FirstName, LastName
FROM dbo.Customers
WHERE CustomerID IN (
    SELECT CustomerID
    FROM dbo.Orders
);

-- Correlated subquery: products priced above their category average
SELECT p.ProductID, p.ProductName, p.CategoryName, p.UnitPrice
FROM dbo.Products p
WHERE p.UnitPrice > (
    SELECT AVG(p2.UnitPrice)
    FROM dbo.Products p2
    WHERE p2.CategoryName = p.CategoryName
);

-- EXISTS
SELECT c.CustomerID, c.FirstName, c.LastName
FROM dbo.Customers c
WHERE EXISTS (
    SELECT 1
    FROM dbo.Orders o
    WHERE o.CustomerID = c.CustomerID
);

-- Scalar subquery in SELECT
SELECT o.OrderID,
       o.TotalAmount,
       (SELECT COUNT(*)
        FROM dbo.OrderLines ol
        WHERE ol.OrderID = o.OrderID) AS LineCount
FROM dbo.Orders o;
