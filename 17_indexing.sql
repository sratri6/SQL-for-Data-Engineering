-- Retail SQL Learning | 17 Indexing
-- Always validate indexes against actual workload and write frequency.

-- Clustered primary key
CREATE CLUSTERED INDEX IX_Orders_OrderID
ON dbo.Orders(OrderID);

-- Nonclustered index for customer order lookup
CREATE NONCLUSTERED INDEX IX_Orders_CustomerID_OrderDate
ON dbo.Orders(CustomerID, OrderDate DESC)
INCLUDE (TotalAmount, PaymentMethod);

-- Product category lookup
CREATE NONCLUSTERED INDEX IX_Products_Category
ON dbo.Products(CategoryName)
INCLUDE (ProductName, UnitPrice);

-- Filtered index: active products only
CREATE NONCLUSTERED INDEX IX_Products_Active
ON dbo.Products(CategoryName, ProductName)
INCLUDE (UnitPrice)
WHERE IsActive = 1;

-- Unique index on customer email
CREATE UNIQUE NONCLUSTERED INDEX UX_Customers_Email
ON dbo.Customers(Email)
WHERE Email IS NOT NULL;

-- Inspect indexes
SELECT
    i.name AS IndexName,
    OBJECT_NAME(i.object_id) AS TableName,
    i.type_desc,
    i.is_unique,
    i.is_disabled
FROM sys.indexes i
WHERE OBJECT_NAME(i.object_id) IN ('Orders', 'Products', 'Customers');

-- Important:
-- Do not blindly create every index. Indexes improve reads but increase
-- storage and INSERT/UPDATE/DELETE overhead.
