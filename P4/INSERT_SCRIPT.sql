-- Inserting data into Category
INSERT INTO Category (CategoryID, CategoryName)
VALUES
(1, 'Fruits'),
(2, 'Snacks'),
(3, 'Dairy'),
(4, 'Seafood'),
(5, 'Grains'),
(6, 'Beverages'),
(7, 'Vegetables'),
(8, 'Desserts'),
(9, 'Bakery'),
(10, 'Canned Goods');

-- Inserting data into Supplier
INSERT INTO Supplier (SupplierID, SupplierName, Address, Phone_No)
VALUES
(5001, 'Fresh Farms', '123 Farm Lane, Harvest City', 5551112233),
(5002, 'Ocean Seafoods', '456 Sea Street, Oceanville', 5552223344),
(5003, 'Bakery Delights', '789 Baker Avenue, Breadtown', 5553334455),
(5004, 'Green Grocers', '101 Veggie Road, Vegtown', 5554445566),
(5005, 'Dairy Dairies', '202 Milk Lane, Dairyville', 5555556677),
(5006, 'Meat Masters', '303 Carnivore Street, Meatropolis', 5556667788),
(5007, 'Snack Sensations', '404 Snack Avenue, Snack City', 5557778899),
(5008, 'Grain Gurus', '505 Grain Lane, Grainville', 5558889900),
(5009, 'Beverage Bliss', '606 Drink Street, Beveragetown', 5559990011),
(5010, 'Sweet Treats', '707 Sugar Avenue, Sweetville', 5550001122);


-- Inserting data into Product
INSERT INTO Product (ProductID, ProductName, ProductDescription, Price, SupplierID, CategoryID)
VALUES
(2001, 'Apple', 'Fresh and juicy apples', 2.99, 5001, 1),
(2002, 'Potato Chips', 'Crunchy potato chips', 1.49, 5002, 2),
(2003, 'Milk', 'Whole milk, 1 gallon', 3.49, 5003, 3),
(2004, 'Salmon', 'Fresh salmon fillet', 9.99, 5004, 4),
(2005, 'Rice', 'Long-grain white rice', 5.99, 5005, 5),
(2006, 'Cola', 'Carbonated cola drink', 1.79, 5006, 6),
(2007, 'Carrots', 'Organic carrots', 1.29, 5007, 7),
(2008, 'Chocolate Cake', 'Rich chocolate cake', 8.99, 5008, 8),
(2009, 'Baguette', 'French baguette', 2.49, 5009, 9),
(2010, 'Canned Soup', 'Tomato soup in a can', 2.29, 5010, 10);

-- Inserting data into Batches
INSERT INTO Batches (BatchID, ProductID, ProductionDate, Quantity) VALUES
(11, 2001, '2023-01-10', 100),
(12, 2002, '2023-01-15', 200),
(13, 2003, '2023-01-20', 150),
(14, 2004, '2023-01-25', 160),
(15, 2005, '2023-02-10', 300),
(16, 2006, '2023-02-15', 110),
(17, 2007, '2023-02-20', 120),
(18, 2008, '2023-03-01', 130),
(19, 2009, '2023-03-10', 140),
(20, 2010, '2023-03-15', 150);

-- Inserting data into Inventory
INSERT INTO Inventory (InventoryID, ProductID, BatchID, QuantityAvailable) VALUES
(101, 2001, 11, 100),
(102, 2002, 12, 80),
(103, 2003, 13, 150),
(104, 2004, 14, 200),
(105, 2005, 15, 300),
(106, 2006, 16, 90),
(107, 2007, 17, 110),
(108, 2008, 18, 120),
(109, 2009, 19, 130),
(110, 2010, 20, 140);


-- Inserting data into Retailer
INSERT INTO Retailer (RetailerID, RetailerName, MobileNo)
VALUES
(1001, 'Fresh Mart', 5551234567),
(1002, 'Snack Haven', 5552345678),
(1003, 'Dairy Delights', 5553456789),
(1004, 'Seafood Emporium', 5554567890),
(1005, 'Grain Palace', 5555678901),
(1006, 'Eggcellent Grocers', 5556789012),
(1007, 'Rice Paradise', 5557890123),
(1008, 'Nutty Corner', 5558901234),
(1009, 'Tea Boutique', 5559012345),
(1010, 'Quinoa Haven', 5550123456);

-- Inserting data into BillingInfo
INSERT INTO BillingInfo (BillingID, BillingAddress, Payment, RetailerID)
VALUES
(501, '123 Market Street, Cityville', 'Credit Card', 1001),
(502, '456 Snack Lane, Munch City', 'Debit Card', 1002),
(503, '789 Dairy Avenue, Creamery Town', 'Cash', 1003),
(504, '101 Seafood Road, Oceanview', 'Credit Card', 1004),
(505, '202 Grain Street, Harvest Plaza', 'Cash', 1005),
(506, '303 Egg Lane, Organic Valley', 'Debit Card', 1006),
(507, '404 Rice Avenue, Grain City', 'Credit Card', 1007),
(508, '505 Nut Street, Crunch Center', 'Cash', 1008),
(509, '606 Tea Lane, Brew City', 'Credit Card', 1009),
(5010, '707 Quinoa Street, Superfood Center', 'Debit Card', 1010);


-- Inserting data into Employee
INSERT INTO Employee (EmployeeID, EmployeeName, JobRole, Contactinfo, SSN)
VALUES
(12345, 'John Smith', 'Manager', 9876543210, '123-45-6789'),
(23456, 'Mary Johnson', 'Employee', 8765432109, '234-56-7890'),
(34567, 'Robert Davis', 'Employee', 7654321098, '345-67-8901'),
(45678, 'Emily Wilson', 'Manager', 6543210987, '456-78-9012'),
(56789, 'Daniel Brown', 'Employee', 5432109876, '567-89-0123'),
(67890, 'Jessica Lee', 'Employee', 4321098765, '678-90-1234'),
(78901, 'Christopher White', 'Manager', 3210987654, '789-01-2345'),
(89012, 'Amanda Taylor', 'Employee', 2109876543, '890-12-3456'),
(90123, 'Michael Turner', 'Manager', 1098765432, '901-23-4567'),
(98765, 'Sophia Garcia', 'Employee', 987654321, '987-65-4321');

-- Inserting data into Order
INSERT INTO [Order] (OrderID, OrderDate, TotalAmount, RetailerID, EmployeeID, [Status])
VALUES
(201, '2023-01-01', 100.50, 1001, 12345, 'Pending'),
(202, '2023-02-02', 150.75, 1002, 23456, 'Placed'),
(203, '2023-03-03', 200.25, 1003, 34567, 'In Progress'),
(204, '2023-04-04', 75.20, 1001, 12345, 'Delivered'),
(205, '2023-05-05', 120.00, 1002, 23456, 'Dispatched'),
(206, '2023-06-06', 50.80, 1003, 34567, 'Cancelled'),
(207, '2023-07-07', 180.90, 1001, 12345, 'On Hold'),
(208, '2023-08-08', 90.60, 1002, 23456, 'Completed'),
(209, '2023-09-09', 30.40, 1003, 34567, 'Failed'),
(210, '2023-10-10', 300.00, 1001, 12345, 'Dispatched');

-- Inserting data into OrderDetails
INSERT INTO OrderDetails (QuantityOrdered, ProductID, OrderID)
VALUES
(5, 2001, 201),
(10, 2002, 202),
(8, 2003, 203),
(15, 2004, 204),
(3, 2005, 205),
(7, 2006, 206),
(12, 2007, 207),
(6, 2008, 208),
(9, 2009, 209),
(4, 2010, 210);

-- Inserting data into Shipment
INSERT INTO Shipment (ShipmentID, ShipmentDate, ShipmentAddress, TrackingInfo, OrderID, SupplierID)
VALUES
(701, '2023-11-22', '123 Main Street, Cityville', 'ABC123', 201, 5001),
(702, '2023-11-23', '456 Ocean Avenue, Beach City', 'XYZ456', 202, 5002),
(703, '2023-11-24', '789 Forest Lane, Green Valley', 'LMN789', 203, 5003),
(704, '2023-11-25', '101 Mountain Road, Summit Town', 'PQR101', 204, 5004),
(705, '2023-11-26', '202 Desert Street, Sand City', 'DEF202', 205, 5005),
(706, '2023-11-27', '303 River Lane, Riverside', 'GHI303', 206, 5006),
(707, '2023-11-28', '404 Valley Avenue, Valleyville', 'JKL404', 207, 5007),
(708, '2023-11-29', '505 Sky Street, Skyline', 'UVW505', 208, 5008),
(709, '2023-11-30', '606 Meadow Lane, Meadowtown', 'STU606', 209, 5009),
(710, '2023-12-01', '707 Hill Road, Hilltop', 'XYZ707', 210, 5010);


UPDATE Employee SET SSN = '123-45-6789' WHERE EmployeeID = 12345;
UPDATE Employee SET SSN = '234-56-7890' WHERE EmployeeID = 23456;
UPDATE Employee SET SSN = '345-67-8901' WHERE EmployeeID = 34567;
UPDATE Employee SET SSN = '456-78-9012' WHERE EmployeeID = 45678;
UPDATE Employee SET SSN = '567-89-0123' WHERE EmployeeID = 56789;
UPDATE Employee SET SSN = '678-90-1234' WHERE EmployeeID = 67890;
UPDATE Employee SET SSN = '789-01-2345' WHERE EmployeeID = 78901;
UPDATE Employee SET SSN = '890-12-3456' WHERE EmployeeID = 89012;
UPDATE Employee SET SSN = '901-23-4567' WHERE EmployeeID = 90123;
UPDATE Employee SET SSN = '987-65-4321' WHERE EmployeeID = 98765;

Select * from Employee