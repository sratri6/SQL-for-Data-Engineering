-- Retail SQL Learning | 14 Data Warehousing: SCD, CDC & CDF
-- Examples are SQL Server-oriented. CDF terminology is commonly associated
-- with Delta Lake; an example is included as a conceptual SQL pattern.

-- SCD Type 1: overwrite customer attributes
UPDATE d
SET d.Email = s.Email,
    d.City = s.City,
    d.LastUpdatedDate = GETDATE()
FROM dbo.DimCustomer d
JOIN dbo.StgCustomer s
  ON d.CustomerBusinessKey = s.CustomerBusinessKey;

-- SCD Type 2: expire changed dimension record
UPDATE d
SET d.IsCurrent = 0,
    d.ValidTo = DATEADD(SECOND, -1, s.ChangeDate)
FROM dbo.DimCustomer d
JOIN dbo.StgCustomer s
  ON d.CustomerBusinessKey = s.CustomerBusinessKey
WHERE d.IsCurrent = 1
  AND (
       ISNULL(d.Email, '') <> ISNULL(s.Email, '')
    OR ISNULL(d.City, '') <> ISNULL(s.City, '')
  );

-- SCD Type 2: insert new version
INSERT INTO dbo.DimCustomer (
    CustomerBusinessKey, FirstName, LastName, Email, City,
    ValidFrom, ValidTo, IsCurrent
)
SELECT s.CustomerBusinessKey,
       s.FirstName, s.LastName, s.Email, s.City,
       s.ChangeDate, '9999-12-31', 1
FROM dbo.StgCustomer s
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.DimCustomer d
    WHERE d.CustomerBusinessKey = s.CustomerBusinessKey
      AND d.IsCurrent = 1
      AND ISNULL(d.Email, '') = ISNULL(s.Email, '')
      AND ISNULL(d.City, '') = ISNULL(s.City, '')
);

-- CDC concept: identify inserts/updates/deletes from a CDC capture table
SELECT __$start_lsn,
       __$operation,
       OrderID,
       CustomerID,
       TotalAmount
FROM cdc.dbo_Orders_CT
WHERE __$start_lsn > @LastLSN
ORDER BY __$start_lsn;

-- Delta Change Data Feed concept:
-- SELECT * FROM table_changes('retail.orders', @startingVersion, @endingVersion);
-- This command is executed in a Delta/Lakehouse SQL environment.
