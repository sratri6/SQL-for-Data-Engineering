-- Retail SQL Learning | 21 SQL Cheat Sheets
-- Quick-reference examples for data engineering interviews and projects.

-- SELECT
SELECT col1, col2 FROM table_name;

-- FILTER
SELECT * FROM table_name WHERE col1 = 'value';

-- SORT
SELECT * FROM table_name ORDER BY col1 DESC;

-- AGGREGATE
SELECT key_col, SUM(amount), COUNT(*)
FROM table_name
GROUP BY key_col;

-- HAVING
SELECT key_col, SUM(amount)
FROM table_name
GROUP BY key_col
HAVING SUM(amount) > 10000;

-- JOIN
SELECT *
FROM orders o
JOIN customers c ON o.CustomerID = c.CustomerID;

-- LEFT JOIN
SELECT *
FROM customers c
LEFT JOIN orders o ON c.CustomerID = o.CustomerID;

-- CTE
WITH x AS (
    SELECT CustomerID, SUM(TotalAmount) AS Revenue
    FROM dbo.Orders
    GROUP BY CustomerID
)
SELECT * FROM x;

-- WINDOW
SELECT *,
       ROW_NUMBER() OVER (
           PARTITION BY CustomerID
           ORDER BY OrderDate DESC
       ) AS rn
FROM dbo.Orders;

-- CASE
SELECT ProductName,
       CASE WHEN UnitPrice >= 1000 THEN 'High'
            ELSE 'Low'
       END AS PriceBand
FROM dbo.Products;

-- NULL
SELECT COALESCE(Email, 'No Email') FROM dbo.Customers;

-- DATE
SELECT DATEADD(DAY, 7, OrderDate),
       DATEDIFF(DAY, OrderDate, DeliveryDate)
FROM dbo.Orders;

-- STRING
SELECT UPPER(TRIM(ProductName)),
       CONCAT(FirstName, ' ', LastName)
FROM dbo.Customers;

-- TOP N
SELECT TOP (10) *
FROM dbo.Products
ORDER BY UnitPrice DESC;

-- EXISTS
SELECT *
FROM dbo.Customers c
WHERE EXISTS (
    SELECT 1 FROM dbo.Orders o
    WHERE o.CustomerID = c.CustomerID
);

-- DEDUPLICATION
WITH d AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY BusinessKey
               ORDER BY LastModifiedDate DESC
           ) AS rn
    FROM dbo.Staging
)
SELECT *
FROM d
WHERE rn = 1;

-- INCREMENTAL LOAD
SELECT *
FROM dbo.SourceTable
WHERE LastModifiedDate > @LastWatermark;

-- SCD2
-- Expire old record, then insert the new current version.

-- PERFORMANCE
-- Prefer SARGable predicates, select only required columns,
-- filter early, inspect actual execution plans, and index based on workload.

-- DATA ENGINEERING FLOW
-- Source -> Staging -> Validation -> Transformation -> Dimension/Fact
-- -> Data Quality -> Audit -> Reporting
