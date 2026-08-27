-- Retail SQL Learning | 06 Common Table Expressions

-- Basic CTE
WITH CustomerRevenue AS (
    SELECT CustomerID,
           SUM(TotalAmount) AS Revenue
    FROM dbo.Orders
    GROUP BY CustomerID
)
SELECT c.CustomerID,
       c.FirstName,
       c.LastName,
       cr.Revenue
FROM dbo.Customers c
JOIN CustomerRevenue cr
  ON c.CustomerID = cr.CustomerID
ORDER BY cr.Revenue DESC;

-- Multiple CTEs
WITH MonthlyRevenue AS (
    SELECT YEAR(OrderDate) AS OrderYear,
           MONTH(OrderDate) AS OrderMonth,
           SUM(TotalAmount) AS Revenue
    FROM dbo.Orders
    GROUP BY YEAR(OrderDate), MONTH(OrderDate)
),
MonthlyTargets AS (
    SELECT OrderYear, OrderMonth, RevenueTarget
    FROM dbo.MonthlySalesTargets
)
SELECT mr.OrderYear,
       mr.OrderMonth,
       mr.Revenue,
       mt.RevenueTarget,
       mr.Revenue - mt.RevenueTarget AS Variance
FROM MonthlyRevenue mr
LEFT JOIN MonthlyTargets mt
  ON mr.OrderYear = mt.OrderYear
 AND mr.OrderMonth = mt.OrderMonth;

-- Recursive CTE: employee hierarchy
WITH EmployeeHierarchy AS (
    SELECT EmployeeID, EmployeeName, ManagerID, 0 AS HierarchyLevel
    FROM dbo.Employees
    WHERE ManagerID IS NULL

    UNION ALL

    SELECT e.EmployeeID, e.EmployeeName, e.ManagerID,
           eh.HierarchyLevel + 1
    FROM dbo.Employees e
    JOIN EmployeeHierarchy eh
      ON e.ManagerID = eh.EmployeeID
)
SELECT *
FROM EmployeeHierarchy
OPTION (MAXRECURSION 100);
