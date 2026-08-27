-- Retail SQL Learning | 12 MERGE & UPSERT
-- Production note: validate MERGE behavior for your SQL Server workload;
-- explicit UPDATE + INSERT patterns are often preferred for critical pipelines.

-- Source staging table assumed:
-- dbo.StgProducts(ProductID, ProductName, CategoryName, UnitPrice, CostPrice, LastModifiedDate)

MERGE dbo.Products AS target
USING dbo.StgProducts AS source
   ON target.ProductID = source.ProductID

WHEN MATCHED THEN
    UPDATE SET
        target.ProductName = source.ProductName,
        target.CategoryName = source.CategoryName,
        target.UnitPrice = source.UnitPrice,
        target.CostPrice = source.CostPrice,
        target.LastModifiedDate = source.LastModifiedDate

WHEN NOT MATCHED BY TARGET THEN
    INSERT (
        ProductID, ProductName, CategoryName,
        UnitPrice, CostPrice, LastModifiedDate
    )
    VALUES (
        source.ProductID, source.ProductName, source.CategoryName,
        source.UnitPrice, source.CostPrice, source.LastModifiedDate
    );

-- Recommended explicit UPSERT pattern
BEGIN TRANSACTION;

UPDATE p
SET p.ProductName = s.ProductName,
    p.CategoryName = s.CategoryName,
    p.UnitPrice = s.UnitPrice,
    p.CostPrice = s.CostPrice
FROM dbo.Products p
JOIN dbo.StgProducts s
  ON p.ProductID = s.ProductID;

INSERT INTO dbo.Products (
    ProductID, ProductName, CategoryName, UnitPrice, CostPrice
)
SELECT s.ProductID, s.ProductName, s.CategoryName, s.UnitPrice, s.CostPrice
FROM dbo.StgProducts s
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.Products p
    WHERE p.ProductID = s.ProductID
);

COMMIT TRANSACTION;
