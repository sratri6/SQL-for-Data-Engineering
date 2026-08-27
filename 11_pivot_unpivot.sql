-- Retail SQL Learning | 11 Pivot & Unpivot

-- PIVOT: monthly sales by payment method
SELECT PaymentMethod,
       [1] AS January,
       [2] AS February,
       [3] AS March,
       [4] AS April
FROM (
    SELECT PaymentMethod,
           MONTH(OrderDate) AS OrderMonth,
           TotalAmount
    FROM dbo.Orders
) src
PIVOT (
    SUM(TotalAmount)
    FOR OrderMonth IN ([1],[2],[3],[4])
) p;

-- PIVOT: category sales by channel
SELECT CategoryName,
       [Store] AS StoreSales,
       [Online] AS OnlineSales,
       [Mobile] AS MobileSales
FROM (
    SELECT p.CategoryName,
           o.SalesChannel,
           ol.LineAmount
    FROM dbo.Orders o
    JOIN dbo.OrderLines ol ON o.OrderID = ol.OrderID
    JOIN dbo.Products p ON ol.ProductID = p.ProductID
) src
PIVOT (
    SUM(LineAmount)
    FOR SalesChannel IN ([Store],[Online],[Mobile])
) p;

-- UNPIVOT
SELECT ProductID, AttributeName, AttributeValue
FROM (
    SELECT ProductID,
           CAST(UnitPrice AS varchar(50)) AS UnitPrice,
           CAST(CostPrice AS varchar(50)) AS CostPrice,
           CAST(DiscountPercent AS varchar(50)) AS DiscountPercent
    FROM dbo.Products
) src
UNPIVOT (
    AttributeValue FOR AttributeName
    IN (UnitPrice, CostPrice, DiscountPercent)
) u;
