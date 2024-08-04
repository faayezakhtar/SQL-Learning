-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Script to create tables for PracticeDB
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- =====================================================================
-- Create table Customers
-- =====================================================================

USE PracticeDB;



CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName NVARCHAR(100),
    ContactEmail NVARCHAR(100),
	ContactPhone NVARCHAR(20)
);

-- =======================================================================
-- Insert Data into Customers table 
-- =======================================================================
INSERT INTO Customers (CustomerID, CustomerName, ContactEmail, ContactPhone) VALUES
(1, 'John Doe', 'john.doe@example.com', '217-440111'),
(2, 'Jane Smith', 'jane.smith@example.com', '217-440112'),
(3, 'Michael Johnson', 'michael.johnson@example.com', null),
(4, 'Emily Davis', 'emily.davis@example.com', '217-440113');

-- =====================================================================
-- Create table Products
-- =====================================================================
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    Price DECIMAL(10, 2),
	ProductColor NVARCHAR(20)
);


-- =======================================================================
-- Insert Data into Products table 
-- =======================================================================
INSERT INTO Products (ProductID, ProductName, Price, ProductColor) VALUES
(1, 'Laptop', 1000.00, 'Black'),
(2, 'Smartphone', 500.00, 'Silver'),
(3, 'Tablet', 300.00, 'Silver'),
(4, 'Headphones', 100.00, null);

-- =====================================================================
-- Create table Sales
-- =====================================================================
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    CustomerID INT,
    ProductID INT,
    SaleDate DATE,
    Quantity INT,
    TotalAmount DECIMAL(10, 2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);


-- =======================================================================
-- Insert Data into Sales table 
-- =======================================================================
INSERT INTO Sales (SaleID, CustomerID, ProductID, SaleDate, Quantity, TotalAmount) VALUES
(1, 1, 1, '2023-01-01', 1, 1000.00),
(2, 2, 2, '2023-01-02', 2, 1000.00),
(3, 3, 3, '2023-06-03', 3, 900.00),
(4, 4, 4, '2023-02-04', 4, 400.00),
(5, 1, 2, '2023-03-05', 1, 500.00),
(6, 2, 1, '2023-01-06', 1, 1000.00),
(7, 3, 4, '2023-04-07', 2, 200.00),
(8, 4, 3, '2023-05-08', 1, 300.00),
(9, 1, 3, '2023-07-09', 1, 300.00),
(10, 2, 4, '2023-08-10', 3, 300.00),
(11, 1, 3, '2023-10-10', 2, 600.00),
(12, 3, 4, '2023-08-10', 8, 800.00),
(13, 4, 4, '2023-09-10', 2, 200.00),
(14, 2, 3, '2023-11-10', 2, 600.00),
(15, 1, 2, '2023-12-10', 1, 500.00);


-- =====================================================================
-- Create table Employees table
-- =====================================================================
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    DepartmentID INT,
    ManagerID INT NULL,
    EmployeeName NVARCHAR(100),
    HireDate DATE,
    Salary DECIMAL(10, 2)
);


-- =====================================================================
-- Insert Data into Employees table
-- =====================================================================
INSERT INTO Employees (EmployeeID, DepartmentID, ManagerID, EmployeeName, HireDate, Salary) VALUES
(1, 101, NULL, 'Alice', '2023-01-01', 60000),
(2, 101, 1, 'Bob', '2023-01-03', 70000),
(3, 102, NULL, 'Charlie', '2023-03-02', 80000),
(4, 102, 3, 'David', '2023-05-04', 90000),
(5, 101, 1, 'Eve', '2023-04-05', 75000),
(6, 103, NULL, 'Frank', '2023-10-01', 65000),
(7, 103, 6, 'Grace', '2023-11-06', 72000),
(8, 102, 3, 'Hannah', '2023-12-07', 85000),
(9, 101, 1, 'Ivy', '2023-02-08', 71000),
(10, 103, 6, 'Jack', '2023-06-09', 69000);
