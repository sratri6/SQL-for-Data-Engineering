-- Retail SQL Learning | 02 Filtering & Sorting

-- WHERE
SELECT *
FROM dbo.Products
WHERE UnitPrice > 500;

-- Multiple predicates
SELECT *
FROM dbo.Products
WHERE CategoryName = 'Electronics'
  AND UnitPrice BETWEEN 500 AND 2000;

-- IN
SELECT *
FROM dbo.Customers
WHERE StateCode IN ('KA', 'MH', 'DL');

-- LIKE
SELECT *
FROM dbo.Products
WHERE ProductName LIKE '%Laptop%';

-- NULL handling
SELECT *
FROM dbo.Customers
WHERE Email IS NULL;

-- ORDER BY
SELECT ProductName, UnitPrice
FROM dbo.Products
ORDER BY UnitPrice DESC, ProductName ASC;

-- Pagination
SELECT ProductID, ProductName, UnitPrice
FROM dbo.Products
ORDER BY ProductID
OFFSET 20 ROWS FETCH NEXT 10 ROWS ONLY;
