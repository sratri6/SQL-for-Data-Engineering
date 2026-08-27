-- Retail SQL Learning | 08 Advanced SQL

-- Conditional aggregation
SELECT
    SUM(CASE WHEN PaymentMethod = 'Card' THEN TotalAmount ELSE 0 END) AS CardSales,
    SUM(CASE WHEN PaymentMethod = 'UPI' THEN TotalAmount ELSE 0 END) AS UPISales,
    SUM(CASE WHEN PaymentMethod = 'Cash' THEN TotalAmount ELSE 0 END) AS CashSales
FROM dbo.Orders;

-- NULL-safe business logic
SELECT ProductID,
       ProductName,
       COALESCE(DiscountPercent, 0) AS DiscountPercent,
       UnitPrice * (1 - COALESCE(DiscountPercent, 0) / 100.0) AS NetPrice
FROM dbo.Products;

-- APPLY: top product per customer
SELECT c.CustomerID,
       c.FirstName,
       top_product.ProductID,
       top_product.ProductRevenue
FROM dbo.Customers c
OUTER APPLY (
    SELECT TOP (1)
           ol.ProductID,
           SUM(ol.LineAmount) AS ProductRevenue
    FROM dbo.Orders o
    JOIN dbo.OrderLines ol ON o.OrderID = ol.OrderID
    WHERE o.CustomerID = c.CustomerID
    GROUP BY ol.ProductID
    ORDER BY SUM(ol.LineAmount) DESC
) top_product;

-- Set operators
SELECT CustomerID FROM dbo.Orders
INTERSECT
SELECT CustomerID FROM dbo.LoyaltyMembers;

SELECT CustomerID FROM dbo.Orders
EXCEPT
SELECT CustomerID FROM dbo.LoyaltyMembers;
