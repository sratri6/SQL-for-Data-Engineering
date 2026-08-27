-- Retail SQL Learning | 09 String Functions

SELECT
    CustomerID,
    CONCAT(FirstName, ' ', LastName) AS FullName,
    UPPER(City) AS CityUpper,
    LOWER(Email) AS EmailLower,
    LEN(FirstName) AS FirstNameLength
FROM dbo.Customers;

-- TRIM / REPLACE
SELECT ProductName,
       TRIM(ProductName) AS CleanProductName,
       REPLACE(ProductName, '-', ' ') AS NormalizedProductName
FROM dbo.Products;

-- LEFT / RIGHT / SUBSTRING
SELECT SKU,
       LEFT(SKU, 3) AS BrandCode,
       RIGHT(SKU, 4) AS ItemCode,
       SUBSTRING(SKU, 5, 3) AS CategoryCode
FROM dbo.Products;

-- CHARINDEX
SELECT Email,
       CHARINDEX('@', Email) AS AtPosition
FROM dbo.Customers
WHERE Email IS NOT NULL;

-- Data standardization
SELECT CustomerID,
       CONCAT(
           UPPER(LEFT(FirstName, 1)),
           LOWER(SUBSTRING(FirstName, 2, LEN(FirstName)))
       ) AS StandardizedFirstName
FROM dbo.Customers;
