-- Retail SQL Learning | 20 SQL Interview Questions
-- Practice each problem before viewing the solution.

-- Q1. Second highest product price
SELECT MAX(UnitPrice) AS SecondHighestPrice
FROM dbo.Products
WHERE UnitPrice < (SELECT MAX(UnitPrice) FROM dbo.Products);

-- Q2. Top 3 products in every category
WITH ProductRevenue AS (
    SELECT p.CategoryName,
           p.ProductID,
           p.ProductName,
           SUM(ol.LineAmount) AS Revenue
    FROM dbo.Products p
    JOIN dbo.OrderLines ol ON p.ProductID = ol.ProductID
    GROUP BY p.CategoryName, p.ProductID, p.ProductName
),
Ranked AS (
    SELECT *,
           DENSE_RANK() OVER (
               PARTITION BY CategoryName
               ORDER BY Revenue DESC
           ) AS rnk
    FROM ProductRevenue
)
SELECT *
FROM Ranked
WHERE rnk <= 3;

-- Q3. Customers who ordered in every quarter of 2026
SELECT CustomerID
FROM dbo.Orders
WHERE OrderDate >= '2026-01-01'
  AND OrderDate < '2027-01-01'
GROUP BY CustomerID
HAVING COUNT(DISTINCT DATEPART(QUARTER, OrderDate)) = 4;

-- Q4. Duplicate orders
SELECT OrderID, COUNT(*) AS Cnt
FROM dbo.Orders
GROUP BY OrderID
HAVING COUNT(*) > 1;

-- Q5. Latest order per customer
WITH x AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY CustomerID
               ORDER BY OrderDate DESC, OrderID DESC
           ) AS rn
    FROM dbo.Orders
)
SELECT *
FROM x
WHERE rn = 1;

-- Q6. Month-over-month revenue growth
WITH Monthly AS (
    SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS MonthStart,
           SUM(TotalAmount) AS Revenue
    FROM dbo.Orders
    GROUP BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
)
SELECT MonthStart,
       Revenue,
       LAG(Revenue) OVER (ORDER BY MonthStart) AS PreviousMonthRevenue,
       100.0 * (Revenue - LAG(Revenue) OVER (ORDER BY MonthStart))
       / NULLIF(LAG(Revenue) OVER (ORDER BY MonthStart), 0) AS MoMGrowthPct
FROM Monthly;

-- Q7. Customers above average customer revenue
WITH CustomerRevenue AS (
    SELECT CustomerID, SUM(TotalAmount) AS Revenue
    FROM dbo.Orders
    GROUP BY CustomerID
)
SELECT *
FROM CustomerRevenue
WHERE Revenue > (SELECT AVG(Revenue) FROM CustomerRevenue);

-- Q8. Products never sold
SELECT p.ProductID, p.ProductName
FROM dbo.Products p
LEFT JOIN dbo.OrderLines ol
  ON p.ProductID = ol.ProductID
WHERE ol.ProductID IS NULL;

-- Q9. Running total by sales channel
SELECT SalesChannel,
       OrderDate,
       TotalAmount,
       SUM(TotalAmount) OVER (
           PARTITION BY SalesChannel
           ORDER BY OrderDate, OrderID
       ) AS RunningRevenue
FROM dbo.Orders;

-- Q10. Find customers with increasing order values
WITH x AS (
    SELECT CustomerID,
           OrderID,
           OrderDate,
           TotalAmount,
           LAG(TotalAmount) OVER (
               PARTITION BY CustomerID ORDER BY OrderDate
           ) AS PreviousAmount
    FROM dbo.Orders
)
SELECT *
FROM x
WHERE PreviousAmount IS NOT NULL
  AND TotalAmount > PreviousAmount;
