-- Retail SQL Learning | 01 SQL Fundamentals
-- Dialect: SQL Server / T-SQL
-- Scenario: Contoso Retail

-- Basic SELECT
SELECT CustomerID, FirstName, LastName, City, Country
FROM dbo.Customers;

-- Calculated columns
SELECT ProductID, ProductName, UnitPrice,
       UnitPrice * 1.18 AS PriceIncludingTax
FROM dbo.Products;

-- Aliases
SELECT ProductName AS Product,
       UnitPrice AS Price
FROM dbo.Products;

-- DISTINCT
SELECT DISTINCT CategoryName
FROM dbo.Products;

-- TOP
SELECT TOP (10) ProductID, ProductName, UnitPrice
FROM dbo.Products;

-- CASE expression
SELECT ProductName, UnitPrice,
       CASE
           WHEN UnitPrice >= 1000 THEN 'Premium'
           WHEN UnitPrice >= 500 THEN 'Mid-range'
           ELSE 'Budget'
       END AS PriceBand
FROM dbo.Products;
