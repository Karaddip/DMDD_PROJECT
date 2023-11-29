IF EXISTS (SELECT name FROM sys.databases WHERE name = N'DAMGPROJ_G12')
DROP DATABASE DAMGPROJ_G12
GO

CREATE DATABASE [DAMGPROJ_G12]
GO

USE [DAMGPROJ_G12]
GO

-- Creating Category table
CREATE TABLE Category (
    CategoryID INT NOT NULL,
    CategoryName VARCHAR(20) NOT NULL CONSTRAINT category_chk CHECK ((CategoryName) IN ('Fruits', 'Snacks', 'Dairy', 'Seafood', 'Grains', 'Beverages', 'Vegetables', 'Desserts', 'Bakery', 'Canned Goods')),
    CONSTRAINT CategoryID_PK PRIMARY KEY (CategoryID)
);
GO

-- Stored Procedure to find all the Products in each category
CREATE PROCEDURE GetProductsByCategory
    @CategoryName VARCHAR(20)
AS
BEGIN
    SELECT
        p.ProductID,
        p.ProductName,
        p.ProductDescription,
        p.Price,
        s.SupplierName
    FROM
        Product p
    JOIN
        Category c ON p.CategoryID = c.CategoryID
    JOIN
        Supplier s ON p.SupplierID = s.SupplierID
    WHERE
        c.CategoryName = @CategoryName;
END
GO
--create a column computed based user defined function to concatenate product name and product description
CREATE FUNCTION dbo.ConcatenateProductNameAndDescription(
    @ProductName NVARCHAR(30),
    @ProductDescription NVARCHAR(100)
)
RETURNS NVARCHAR(130)
AS
BEGIN
    RETURN ISNULL(@ProductName, '') + ' - ' + ISNULL(@ProductDescription, '');
END;
GO

-- Add a computed column to the Product table using the function
ALTER TABLE Product
ADD ComputedProductNameAndDescription AS dbo.ConcatenateProductNameAndDescription(ProductName, ProductDescription);

select * from Product
-- Example of executing the stored procedure with a specific CategoryName
EXEC GetProductsByCategory @CategoryName = 'Fruits';


-- Creating Supplier table
CREATE TABLE Supplier (
    SupplierID INT NOT NULL,
    SupplierName VARCHAR(20) NOT NULL,
    Address VARCHAR(100) NOT NULL,
    Phone_No BIGINT NOT NULL,
    CONSTRAINT SupplierId_PK PRIMARY KEY (SupplierID)
);

-- Creating Product table
CREATE TABLE Product (
    ProductID INT NOT NULL,
    ProductName VARCHAR(30) NOT NULL,
    ProductDescription VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    SupplierID INT NOT NULL,
    CategoryID INT NOT NULL,
    CONSTRAINT ProductID_PK PRIMARY KEY (ProductID),
    CONSTRAINT CategoryID_FK1 FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID),
    CONSTRAINT SupplierID_FK2 FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID)
);
GO
--create a non-clustered index for CategoryID on Product
CREATE NONCLUSTERED INDEX IDX_Product_CategoryID ON [dbo].[Product](CategoryID);
GO

-- Create a PL/SQL function to get the total quantity available for a product
CREATE FUNCTION dbo.GetTotalQuantityAvailable(@p_productID INT)
RETURNS INT
AS
BEGIN
    DECLARE @total_quantity INT;

    -- Sum the total quantity available for the given product
    SELECT @total_quantity = SUM(QuantityAvailable)
    FROM Inventory
    WHERE ProductID = @p_productID;

    RETURN ISNULL(@total_quantity, 0);
END;
GO
---- Example of executing the user defined function to get available quantity for a specific Product ID
DECLARE @result INT, @productID INT;
SET @productID = 2003;
SET @result = dbo.GetTotalQuantityAvailable(@productID);
PRINT 'Total Quantity Available for Product ' + CAST(@productID AS VARCHAR) + ' is: ' + CAST(@result AS VARCHAR);
GO

--This view combines information about products and their current inventory status.
CREATE VIEW ProductInventoryView AS
SELECT
    p.ProductID,
    p.ProductName,
    p.Price,
    c.CategoryName,
    s.SupplierName,
    i.QuantityAvailable,
    b.BatchID,
    b.ProductionDate
FROM
    Product p
    INNER JOIN Inventory i ON p.ProductID = i.ProductID
    INNER JOIN Batches b ON i.BatchID = b.BatchID
    INNER JOIN Category c ON p.CategoryID = c.CategoryID
    INNER JOIN Supplier s ON p.SupplierID = s.SupplierID;
GO

-- Creating Batches table
CREATE TABLE [dbo].[Batches] (
    [BatchID] INT NOT NULL,
    [ProductID] INT NOT NULL,
    [ProductionDate] DATE NOT NULL,
    [Quantity] INT NOT NULL,
    CONSTRAINT [PK_Batches] PRIMARY KEY CLUSTERED ([BatchID] ASC),
    CONSTRAINT [FK_Batches_Product] FOREIGN KEY ([ProductID]) REFERENCES [dbo].[Product] ([ProductID])
);

-- Creating Inventory table
CREATE TABLE [dbo].[Inventory] (
    [InventoryID] INT NOT NULL,
    [ProductID] INT NOT NULL,
    [BatchID] INT NOT NULL,
    [QuantityAvailable] INT NOT NULL,
    CONSTRAINT [PK_Inventory] PRIMARY KEY CLUSTERED ([InventoryID] ASC),
    CONSTRAINT [FK_Inventory_Product] FOREIGN KEY ([ProductID]) REFERENCES [dbo].[Product] ([ProductID]),
    CONSTRAINT [FK_Inventory_Batches] FOREIGN KEY ([BatchID]) REFERENCES [dbo].[Batches] ([BatchID])
);

-- Creating Retailer table
CREATE TABLE Retailer (
    RetailerID INT NOT NULL,
    RetailerName VARCHAR(200) NOT NULL,
    MobileNo BIGINT NOT NULL,
    CONSTRAINT RetailerID_PK PRIMARY KEY (RetailerID)
);

-- Creating BillingInfo table
CREATE TABLE BillingInfo (
    BillingID INT NOT NULL,
    BillingAddress VARCHAR(50) NOT NULL,
    Payment VARCHAR(20) NOT NULL CHECK (Payment IN ('Credit Card', 'Debit Card', 'Cash')),
    RetailerID INT NOT NULL,
    CONSTRAINT BillingID_PK PRIMARY KEY (BillingID),
    CONSTRAINT RetailerID_FK FOREIGN KEY (RetailerID) REFERENCES Retailer(RetailerID)
);

--Creating employee table
CREATE TABLE Employee (
    EmployeeID INT NOT NULL,
    EmployeeName VARCHAR(20) NOT NULL,
    JobRole VARCHAR(20) NOT NULL,
    Contactinfo BIGINT NOT NULL,
	SSN VARCHAR(25) NOT NULL DEFAULT '000-00-0000',
    CONSTRAINT JobRole_chk CHECK (JobRole IN ('Employee', 'Manager')),
    CONSTRAINT EmployeeID_pk PRIMARY KEY (EmployeeID)
);
GO
-- Stored Procedure to find all Orders handled by a specific Employee
CREATE PROCEDURE GetEmployeeOrdersWithEmployeeName
    @EmployeeID INT
AS
BEGIN
    SELECT
        o.OrderID,
        o.OrderDate,
        o.TotalAmount,
        o.Status,
        e.EmployeeName
    FROM
        [Order] o
    JOIN
        Employee e ON o.EmployeeID = e.EmployeeID
    WHERE
        o.EmployeeID = @EmployeeID;
END
GO
-- Example of executing the stored procedure with a specific EmployeeID
EXEC GetEmployeeOrdersWithEmployeeName @EmployeeID = 23456;

-- Creating Order table
CREATE TABLE [Order] (
    OrderID INT NOT NULL,
    OrderDate DATE NOT NULL, 
    TotalAmount DECIMAL(6,2) NOT NULL,
    RetailerID INT,
    EmployeeID INT,
    [Status] VARCHAR(20) NOT NULL CONSTRAINT [StatusCheck] CHECK ([Status] IN ('Pending', 'Placed', 'In Progress', 'Delivered', 'Dispatched', 'Cancelled', 'On Hold', 'Completed', 'Failed')),
    PRIMARY KEY (OrderID),
    FOREIGN KEY (RetailerID) REFERENCES Retailer(RetailerID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

--create a non-clustered index for RetailerID on Order
CREATE NONCLUSTERED INDEX IDX_Order_RetailerID ON [Order](RetailerID);

-- Creating OrderDetails table
CREATE TABLE OrderDetails (
    QuantityOrdered INT CHECK (QuantityOrdered > 0),
    ProductID INT UNIQUE NOT NULL,
    OrderID INT UNIQUE NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES [Order] (OrderID),
    FOREIGN KEY (ProductID) REFERENCES Product (ProductID)
);

--create a non-clustered index for Order ID
create nonclustered index NIX_FTE_OrderID on OrderDetails (OrderID asc)
GO

--Orderdetail View
CREATE VIEW OrderDetailsView AS
SELECT
    o.OrderID,
    o.OrderDate,
    r.RetailerName,
    e.EmployeeName,
    od.QuantityOrdered,
    p.ProductName,
    p.Price
FROM
    [Order] o
    INNER JOIN Retailer r ON o.RetailerID = r.RetailerID
    INNER JOIN Employee e ON o.EmployeeID = e.EmployeeID
    INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
    INNER JOIN Product p ON od.ProductID = p.ProductID;
GO

-- Creating Shipment table
CREATE TABLE Shipment (
    ShipmentID INT NOT NULL,
    ShipmentDate CHAR(11) NOT NULL,
    ShipmentAddress VARCHAR(100) NOT NULL,
    TrackingInfo VARCHAR(20) NOT NULL,
    OrderID INT NOT NULL,
    SupplierID INT NOT NULL,
    CONSTRAINT ShipmentID_PK PRIMARY KEY (ShipmentID),
    CONSTRAINT OrderID_FK FOREIGN KEY (OrderID) REFERENCES [Order](OrderID),
    CONSTRAINT SupplierID_FK FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID)
);
GO

--ShipmentDetail View
CREATE VIEW ShipmentDetailsView AS
SELECT
    s.ShipmentID,
    s.ShipmentDate,
    s.ShipmentAddress,
    s.TrackingInfo,
    o.OrderID,
    r.RetailerName,
    p.ProductName,
    b.BatchID
FROM
    Shipment s
    INNER JOIN [Order] o ON s.OrderID = o.OrderID
    INNER JOIN Retailer r ON o.RetailerID = r.RetailerID
    INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
    INNER JOIN Product p ON od.ProductID = p.ProductID
    INNER JOIN Batches b ON p.ProductID = b.ProductID;
GO

--Trigger for order status on shipment
CREATE TRIGGER trgAfterInsertShipment ON Shipment
AFTER INSERT
AS
BEGIN
  UPDATE [Order]
  SET Status = 'Dispatched'
  WHERE OrderID IN (SELECT OrderID FROM inserted)
END;
GO

-- Creating a Notification table
CREATE TABLE NotificationLog (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT,
    NotificationMessage NVARCHAR(MAX),
    LogDate DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_NotificationLog_Order FOREIGN KEY (OrderID) REFERENCES [Order](OrderID)
);
GO

--Trigger to notify manager on higher value orders
CREATE TRIGGER NotifyManagerOnHighValueOrders
ON [Order]
AFTER INSERT
AS
BEGIN
    -- Insert log entries into NotificationLog when a high-value order is placed
    INSERT INTO NotificationLog (OrderID, NotificationMessage)
    SELECT i.OrderID, 'High-value order placed! Notify the manager.'
    FROM inserted i
    WHERE i.TotalAmount > 500.00;
END;
GO

--INSERT INTO [Order] (OrderID, OrderDate, TotalAmount, RetailerID, EmployeeID, [Status])
--VALUES (303, '2023-12-12', 510.00, 1001, 12345, 'Pending');

--SELECT * FROM NotificationLog

--Stored View to generate invoice for specific Retailer
alter PROCEDURE GenerateRetailerInvoice
@RetailerID INT
AS
BEGIN
    DECLARE @RetailerName VARCHAR(200);
    DECLARE @BillingAddress VARCHAR(50);
    DECLARE @PaymentMethod VARCHAR(20);
    DECLARE @InvoiceTotal DECIMAL(10, 2);

    -- Get Retailer information and Billing details
    SELECT 
        @RetailerName = r.RetailerName,
        @BillingAddress = bi.BillingAddress,
        @PaymentMethod = bi.Payment
    FROM Retailer r
    JOIN BillingInfo bi ON r.RetailerID = bi.RetailerID
    WHERE r.RetailerID = @RetailerID;

    -- Get Invoice Total
    SELECT @InvoiceTotal = SUM(o.TotalAmount)
    FROM [Order] o
    WHERE o.RetailerID = @RetailerID;

    -- Display Invoice
    PRINT '----------------------------- INVOICE -----------------------------';
    PRINT 'Retailer: ' + @RetailerName;
    PRINT 'Billing Address: ' + @BillingAddress;
    PRINT 'Payment Method: ' + @PaymentMethod;
    
    -- Add Order Details to Invoice Text
    SELECT 
        @InvoiceTotal = ISNULL(SUM(o.TotalAmount), 0)
    FROM [Order] o
    WHERE o.RetailerID = @RetailerID;

    -- Add Invoice Total to Invoice Text
    PRINT '---------------------------------------------------------------------';
    PRINT 'Invoice Total: $' + CONVERT(NVARCHAR(20), @InvoiceTotal);
    PRINT '---------------------------------------------------------------------';
END

EXEC GenerateRetailerInvoice @RetailerID = 1001;

-- Column Data Encryption
-- Check if a Master Key already exists, if not, create one
IF NOT EXISTS (SELECT * FROM sys.symmetric_keys WHERE symmetric_key_id = 101)
BEGIN
    CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'yourStrongPasswordHere';
END

-- Create a certificate to encrypt the symmetric key, if it does not already exist
IF NOT EXISTS (SELECT * FROM sys.certificates WHERE name = 'EmployeeCertificate')
BEGIN
    CREATE CERTIFICATE EmployeeCertificate WITH SUBJECT = 'Employee Data Encryption';
END

-- Create a symmetric key encrypted with the certificate, if it does not already exist
IF NOT EXISTS (SELECT 1 FROM sys.symmetric_keys WHERE name = 'EmployeeSSNKey')
BEGIN
    CREATE SYMMETRIC KEY EmployeeSSNKey WITH ALGORITHM = AES_256 
    ENCRYPTION BY CERTIFICATE EmployeeCertificate;
END

-- Add an encrypted column to the Employee table for the SSN
ALTER TABLE Employee ADD EncryptedSSN VARBINARY(MAX);

-- Open the symmetric key
OPEN SYMMETRIC KEY EmployeeSSNKey DECRYPTION BY CERTIFICATE EmployeeCertificate;

-- Encrypt the SSN data and store it in the new column
UPDATE Employee
SET EncryptedSSN = EncryptByKey(Key_GUID('EmployeeSSNKey'), SSN);

-- Close the symmetric key
CLOSE SYMMETRIC KEY EmployeeSSNKey;

-- Optionally, drop the plaintext SSN column if you're sure the encryption worked
ALTER TABLE Employee DROP COLUMN SSN;

select * from Employee;


--Decryption 
-- Open the symmetric key
OPEN SYMMETRIC KEY EmployeeSSNKey
DECRYPTION BY CERTIFICATE EmployeeCertificate;

-- Select and decrypt the EncryptedSSN column
SELECT
    EmployeeID,
    EmployeeName,
    JobRole,
    Contactinfo,
    CONVERT(VARCHAR, DecryptByKey(EncryptedSSN)) AS DecryptedSSN
FROM Employee;

-- Close the symmetric key
CLOSE SYMMETRIC KEY EmployeeSSNKey;

--For Dropping the encrypytedSSN column
ALTER TABLE Employee
DROP COLUMN EncryptedSSN;
GO

CREATE VIEW EmployeeView as 
SELECT
    EmployeeID,
    EmployeeName,
    JobRole,
    ContactInfo,
    EncryptByKey(Key_GUID('EmpSSN'), CONVERT(VARBINARY, SSN)) AS EncryptedSSN
FROM
    Employee;
GO

SELECT * FROM EmployeeView

