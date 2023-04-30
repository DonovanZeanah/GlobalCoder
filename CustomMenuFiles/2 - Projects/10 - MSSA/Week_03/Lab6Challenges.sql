IF (NOT EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_SCHEMA = 'SalesLT' 
                 AND  TABLE_NAME = 'CallLog'))
BEGIN
    CREATE TABLE SalesLT.CallLog
	(
		CallID int IDENTITY PRIMARY KEY NOT NULL,
		CallTime datetime NOT NULL DEFAULT GETDATE(),
		SalesPerson nvarchar(256) NOT NULL,
		CustomerID int NOT NULL REFERENCES SalesLT.Customer(CustomerID),
		PhoneNumber nvarchar(25) NOT NULL,
		Notes nvarchar(max) NULL
	);
END

SELECT * FROM SalesLT.CallLog;

INSERT INTO SalesLT.CallLog
VALUES
('2015-01-01T12:30:00', 'adventure-works\pamela0', 1, '245-555-0173', 'Returning call re: enquiry about delivery');

SELECT * FROM SalesLT.CallLog;

INSERT INTO SalesLT.CallLog
VALUES
(DEFAULT, 'adventure-works\david8', 2, '170-555-0127', NULL);
SELECT * FROM SalesLT.CallLog;

INSERT INTO SalesLT.CallLog (SalesPerson, CustomerID, PhoneNumber)
VALUES
('adventure-works\jillian0', 3, '279-555-0130');
SELECT * FROM SalesLT.CallLog;

INSERT INTO SalesLT.CallLog
VALUES
(DATEADD(mi,-2, GETDATE()), 'adventure-works\jillian0', 4, '710-555-0173', NULL),
(DEFAULT, 'adventure-works\shu0', 5, '828-555-0186', 'Called to arrange deliver of order 10987');
SELECT * FROM SalesLT.CallLog;

INSERT INTO SalesLT.CallLog (SalesPerson, CustomerID, PhoneNumber, Notes)
SELECT SalesPerson, CustomerID, Phone, 'Sales promotion call'
FROM SalesLT.Customer
WHERE CompanyName = 'Big-Time Bike Store';
SELECT * FROM SalesLT.CallLog;

INSERT INTO SalesLT.CallLog (SalesPerson, CustomerID, PhoneNumber)
VALUES
('adventure-works\josé1', 10, '150-555-0127');

SELECT SCOPE_IDENTITY() AS LatestIdentityInDB,
       IDENT_CURRENT('SalesLT.CallLog') AS LatestCallID;

SELECT * FROM SalesLT.CallLog;

SET IDENTITY_INSERT SalesLT.CallLog ON;

INSERT INTO SalesLT.CallLog (CallID, SalesPerson, CustomerID, PhoneNumber)
VALUES
(20, 'adventure-works\josé1', 11, '926-555-0159');

SET IDENTITY_INSERT SalesLT.CallLog OFF;

SELECT * FROM SalesLT.CallLog;

UPDATE SalesLT.CallLog
SET Notes = 'No notes'
WHERE Notes IS NULL;

SELECT * FROM SalesLT.CallLog;

UPDATE SalesLT.CallLog
SET SalesPerson = '', PhoneNumber = ''

SELECT * FROM SalesLT.CallLog;

UPDATE SalesLT.CallLog
SET SalesPerson = c.SalesPerson, PhoneNumber = c.Phone
FROM SalesLT.Customer AS c
WHERE c.CustomerID = SalesLT.CallLog.CustomerID;
SELECT * FROM SalesLT.CallLog;

DELETE FROM SalesLT.CallLog
WHERE CallTime < DATEADD(dd, -7, GETDATE());
SELECT * FROM SalesLT.CallLog;

TRUNCATE TABLE SalesLT.CallLog;
SELECT * FROM SalesLT.CallLog;
SELECT IDENT_CURRENT('SalesLT.CallLog')

--Challenges
--Challenge 1
--1.1
--Insert a product
INSERT INTO SalesLT.Product (Name, ProductNumber, StandardCost, ListPrice, ProductCategoryID, SellStartDate)
VALUES
('LED Lights', 'LT-L123', 2.56, 12.99, 37, GETDATE());

SELECT SCOPE_IDENTITY();

SELECT * FROM SalesLT.Product
WHERE ProductID = SCOPE_IDENTITY();

--1.2
--Insert a new category with two products:
INSERT INTO SalesLT.ProductCategory (ParentProductCategoryID, Name)
VALUES
(4, 'Bells and Horns');

INSERT INTO SalesLT.Product (Name, ProductNumber, StandardCost, ListPrice, ProductCategoryID, SellStartDate)
VALUES
('Bicycle Bell', 'BB-RING', 2.47, 4.99, IDENT_CURRENT('SalesLT.ProductCategory'), GETDATE()),
('Bicycle Horn', 'BH-PARP', 1.29, 3.75, IDENT_CURRENT('SalesLT.ProductCategory'), GETDATE());

SELECT c.Name As Category, p.Name AS Product
FROM SalesLT.Product AS p
JOIN SalesLT.ProductCategory as c
    ON p.ProductCategoryID = c.ProductCategoryID
WHERE p.ProductCategoryID = IDENT_CURRENT('SalesLT.ProductCategory');

--Challenge 2
--2.1 Update Product Prices
UPDATE SalesLT.Product
SET ListPrice = ListPrice * 1.1
WHERE ProductCategoryID =
    (SELECT ProductCategoryID
     FROM SalesLT.ProductCategory
     WHERE Name = 'Bells and Horns');


--2.2 Discontinue Products
UPDATE SalesLT.Product
SET DiscontinuedDate = GETDATE()
WHERE ProductCategoryID = 37
AND ProductNumber <> 'LT-L123';

--Challenge 3
--3.1 Delete Products
DELETE FROM SalesLT.Product
WHERE ProductCategoryID =
    (SELECT ProductCategoryID
     FROM SalesLT.ProductCategory
     WHERE Name = 'Bells and Horns');

DELETE FROM SalesLT.ProductCategory
WHERE ProductCategoryID =
    (SELECT ProductCategoryID
     FROM SalesLT.ProductCategory
     WHERE Name = 'Bells and Horns');

