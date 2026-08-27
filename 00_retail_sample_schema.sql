-- Retail SQL Learning | Shared Sample Schema
-- Run this first if you want a local SQL Server practice environment.
-- The learning files intentionally focus on query patterns rather than
-- providing a full production-ready database deployment.

CREATE TABLE dbo.Customers (
    CustomerID int PRIMARY KEY,
    FirstName varchar(100) NOT NULL,
    LastName varchar(100) NOT NULL,
    Email varchar(255) NULL,
    City varchar(100) NULL,
    StateCode varchar(10) NULL,
    Country varchar(100) NULL
);

CREATE TABLE dbo.Products (
    ProductID int PRIMARY KEY,
    ProductName varchar(200) NOT NULL,
    CategoryName varchar(100) NOT NULL,
    SKU varchar(50) NULL,
    UnitPrice decimal(18,2) NOT NULL,
    CostPrice decimal(18,2) NOT NULL,
    DiscountPercent decimal(5,2) NULL,
    StockQuantity int NOT NULL DEFAULT 0,
    ReorderLevel int NOT NULL DEFAULT 10,
    IsActive bit NOT NULL DEFAULT 1,
    LastModifiedDate datetime2 NULL
);

CREATE TABLE dbo.Orders (
    OrderID bigint PRIMARY KEY,
    CustomerID int NOT NULL,
    OrderDate datetime2 NOT NULL,
    DeliveryDate datetime2 NULL,
    TotalAmount decimal(18,2) NOT NULL,
    PaymentMethod varchar(30) NULL,
    SalesChannel varchar(30) NULL,
    PromotionID int NULL,
    SourceSystem varchar(50) NULL,
    LastModifiedDate datetime2 NULL
);

CREATE TABLE dbo.OrderLines (
    OrderID bigint NOT NULL,
    ProductID int NOT NULL,
    Quantity int NOT NULL,
    LineAmount decimal(18,2) NOT NULL,
    PRIMARY KEY (OrderID, ProductID)
);

CREATE TABLE dbo.Employees (
    EmployeeID int PRIMARY KEY,
    EmployeeName varchar(200) NOT NULL,
    ManagerID int NULL
);

CREATE TABLE dbo.LoyaltyMembers (
    CustomerID int PRIMARY KEY
);

CREATE TABLE dbo.StoreProducts (
    ProductID int PRIMARY KEY
);

CREATE TABLE dbo.OnlineProducts (
    ProductID int PRIMARY KEY
);

CREATE TABLE dbo.MonthlySalesTargets (
    OrderYear int NOT NULL,
    OrderMonth int NOT NULL,
    RevenueTarget decimal(18,2) NOT NULL,
    PRIMARY KEY (OrderYear, OrderMonth)
);

-- Warehousing / ETL practice tables
CREATE TABLE dbo.FactSales (
    OrderID bigint PRIMARY KEY,
    CustomerID int,
    OrderDate date,
    SalesAmount decimal(18,2),
    LoadDate datetime2 NOT NULL DEFAULT GETDATE()
);

CREATE TABLE dbo.DimCustomer (
    CustomerSK bigint IDENTITY PRIMARY KEY,
    CustomerBusinessKey int NOT NULL,
    FirstName varchar(100),
    LastName varchar(100),
    Email varchar(255),
    City varchar(100),
    ValidFrom datetime2 NOT NULL,
    ValidTo datetime2 NOT NULL,
    IsCurrent bit NOT NULL
);

-- Suggested sample data themes:
-- Customers: 10-20 customers across Bangalore, Mumbai, Delhi, Hyderabad.
-- Products: Electronics, Grocery, Fashion, Home, Beauty.
-- Orders: store, online and mobile orders across multiple months.
-- OrderLines: multiple products per order.
