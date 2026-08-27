-- Retail SQL Learning | 04 Joins

-- INNER JOIN: orders with customers
SELECT o.OrderID, o.OrderDate,
       c.CustomerID, c.FirstName, c.LastName
FROM dbo.Orders o
INNER JOIN dbo.Customers c
    ON o.CustomerID = c.CustomerID;

-- Join three tables
SELECT o.OrderID,
       p.ProductName,
       ol.Quantity,
       ol.LineAmount
FROM dbo.Orders o
JOIN dbo.OrderLines ol ON o.OrderID = ol.OrderID
JOIN dbo.Products p ON ol.ProductID = p.ProductID;

-- LEFT JOIN: customers with or without orders
SELECT c.CustomerID,
       c.FirstName,
       c.LastName,
       o.OrderID
FROM dbo.Customers c
LEFT JOIN dbo.Orders o
    ON c.CustomerID = o.CustomerID;

-- Find customers with no orders
SELECT c.CustomerID, c.FirstName, c.LastName
FROM dbo.Customers c
LEFT JOIN dbo.Orders o
    ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;

-- Self join: employees and managers
SELECT e.EmployeeName,
       m.EmployeeName AS ManagerName
FROM dbo.Employees e
LEFT JOIN dbo.Employees m
    ON e.ManagerID = m.EmployeeID;

-- FULL OUTER JOIN example
SELECT a.ProductID AS ProductA,
       b.ProductID AS ProductB
FROM dbo.StoreProducts a
FULL OUTER JOIN dbo.OnlineProducts b
    ON a.ProductID = b.ProductID;
