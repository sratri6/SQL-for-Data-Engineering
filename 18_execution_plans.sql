-- Retail SQL Learning | 18 Execution Plans

-- In SSMS, enable Actual Execution Plan with Ctrl+M before running.

SELECT c.CustomerID,
       c.FirstName,
       c.LastName,
       SUM(o.TotalAmount) AS Revenue
FROM dbo.Customers c
JOIN dbo.Orders o
  ON c.CustomerID = o.CustomerID
WHERE o.OrderDate >= '2026-01-01'
GROUP BY c.CustomerID, c.FirstName, c.LastName
ORDER BY Revenue DESC;

-- Compare two filtering approaches.
-- Query A: potentially non-SARGable
SELECT COUNT(*)
FROM dbo.Orders
WHERE YEAR(OrderDate) = 2026;

-- Query B: SARGable
SELECT COUNT(*)
FROM dbo.Orders
WHERE OrderDate >= '2026-01-01'
  AND OrderDate < '2027-01-01';

-- Useful plan-reading concepts:
-- 1. Index Seek: targeted access, usually preferable for selective predicates.
-- 2. Index Scan/Table Scan: reads many/all rows.
-- 3. Key Lookup: fetches missing columns from clustered index.
-- 4. Hash Match: often used for larger joins/aggregations.
-- 5. Sort: can be expensive for large datasets.
-- 6. Estimated vs Actual Rows: large differences may indicate stale statistics
--    or cardinality estimation problems.

-- Statistics
UPDATE STATISTICS dbo.Orders WITH FULLSCAN;

-- Query Store example
SELECT TOP (20)
       qt.query_sql_text,
       rs.avg_duration,
       rs.avg_cpu_time,
       rs.count_executions
FROM sys.query_store_query_text qt
JOIN sys.query_store_query q
  ON qt.query_text_id = q.query_text_id
JOIN sys.query_store_plan p
  ON q.query_id = p.query_id
JOIN sys.query_store_runtime_stats rs
  ON p.plan_id = rs.plan_id
ORDER BY rs.avg_duration DESC;
