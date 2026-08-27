-- Retail SQL Learning | 10 Date & Time Functions

-- Current date/time
SELECT GETDATE() AS ServerDateTime,
       CAST(GETDATE() AS date) AS Today;

-- Date parts
SELECT OrderID,
       OrderDate,
       YEAR(OrderDate) AS OrderYear,
       MONTH(OrderDate) AS OrderMonth,
       DATEPART(QUARTER, OrderDate) AS OrderQuarter,
       DATENAME(WEEKDAY, OrderDate) AS WeekdayName
FROM dbo.Orders;

-- Date arithmetic
SELECT OrderID,
       OrderDate,
       DATEADD(DAY, 7, OrderDate) AS ExpectedDeliveryDate,
       DATEDIFF(DAY, OrderDate, DeliveryDate) AS DeliveryDays
FROM dbo.Orders;

-- Month boundaries
SELECT DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) AS MonthStart,
       EOMONTH(OrderDate) AS MonthEnd
FROM dbo.Orders;

-- Rolling 30-day business window
SELECT CAST(OrderDate AS date) AS OrderDay,
       SUM(TotalAmount) AS DailyRevenue
FROM dbo.Orders
WHERE OrderDate >= DATEADD(DAY, -30, CAST(GETDATE() AS date))
GROUP BY CAST(OrderDate AS date)
ORDER BY OrderDay;

-- Customer recency
SELECT CustomerID,
       MAX(OrderDate) AS LastOrderDate,
       DATEDIFF(DAY, MAX(OrderDate), CAST(GETDATE() AS date)) AS DaysSinceLastOrder
FROM dbo.Orders
GROUP BY CustomerID;
