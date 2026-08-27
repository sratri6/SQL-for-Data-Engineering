-- Retail SQL Learning | 13 ETL SQL Patterns

-- 1. Extract incremental records
SELECT *
FROM dbo.SourceOrders
WHERE LastModifiedDate > @LastWatermark;

-- 2. Stage data
SELECT
    OrderID,
    CustomerID,
    OrderDate,
    TotalAmount,
    LastModifiedDate
INTO #StageOrders
FROM dbo.SourceOrders
WHERE LastModifiedDate > @LastWatermark;

-- 3. Deduplicate staging data
WITH Deduped AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY OrderID
               ORDER BY LastModifiedDate DESC
           ) AS rn
    FROM #StageOrders
)
SELECT *
INTO #CleanOrders
FROM Deduped
WHERE rn = 1;

-- 4. Data transformation
SELECT OrderID,
       CustomerID,
       CAST(OrderDate AS date) AS OrderDate,
       ROUND(TotalAmount, 2) AS TotalAmount
FROM #CleanOrders;

-- 5. Reject invalid records
SELECT *
FROM #CleanOrders
WHERE CustomerID IS NULL
   OR TotalAmount < 0;

-- 6. Load target
INSERT INTO dbo.FactSales (
    OrderID, CustomerID, OrderDate, SalesAmount
)
SELECT OrderID, CustomerID, OrderDate, TotalAmount
FROM #CleanOrders c
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.FactSales f
    WHERE f.OrderID = c.OrderID
);

-- 7. Audit counts
SELECT
    (SELECT COUNT(*) FROM #StageOrders) AS StagedRows,
    (SELECT COUNT(*) FROM #CleanOrders) AS CleanRows,
    (SELECT COUNT(*) FROM dbo.FactSales
     WHERE LoadDate >= CAST(GETDATE() AS date)) AS LoadedRows;
