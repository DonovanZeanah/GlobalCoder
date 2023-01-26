--target all
SELECT *
  FROM SalesLT.Product

--target all but only get some of the fields
SELECT ProductID, [Name], Color, ListPrice
  FROM SalesLT.Product

--limit by id
SELECT * 
FROM SalesLT.Product
WHERE ProductId = 712

--limit by name?
SELECT * 
FROM SalesLT.Product
WHERE [Name] = 'LL Road Frame - Black, 62'

--limit by cost where cost > 250 < 1000
SELECT * 
FROM SalesLT.Product
WHERE StandardCost > 250 
	AND StandardCost < 1000
	--AND [Weight] < 1000

--limit by category where category = 
/*
Mountain Bikes
Road Bikes
Touring Bikes
*/
--get the productcategory id:
SELECT ProductCategoryID
FROM SalesLT.ProductCategory
WHERE [Name] = 'Mountain Bikes'
--5
SELECT ProductCategoryID
FROM SalesLT.ProductCategory
WHERE [Name] = 'Road Bikes'
--6
SELECT ProductCategoryID
FROM SalesLT.ProductCategory
WHERE [Name] = 'Touring Bikes'
--7

--use the product id to get all the bikes in that category
SELECT * 
FROM SalesLT.Product
WHERE ProductCategoryID = 5
SELECT * 
FROM SalesLT.Product
WHERE ProductCategoryID = 6
SELECT * 
FROM SalesLT.Product
WHERE ProductCategoryID = 7

SELECT Count(*) 
FROM SalesLT.Product
WHERE ProductCategoryID = 5
SELECT Count(*) 
FROM SalesLT.Product
WHERE ProductCategoryID = 6
SELECT Count(*) 
FROM SalesLT.Product
WHERE ProductCategoryID = 7

--grouping, ordering, having
SELECT ProductCategoryID, Count(ProductCategoryID) as Total
FROM SalesLT.Product
GROUP BY ProductCategoryID
HAVING COUNT(ProductCategoryID) <= 10
--HAVING Total <= 10
ORDER BY ProductCategoryID ASC

--use the relational properties to build a better query
SELECT a.[Name], b.[Name]
FROM SalesLT.Product a
INNER JOIN SalesLT.ProductCategory b ON a.ProductCategoryID = b.ProductCategoryID
--WHERE prod.ProductCategoryID = 5
WHERE b.[Name] = 'Touring Bikes'
ORDER BY a.[Name]


--Challenge 1.1:
SELECT * FROM SalesLT.Customer
--Challenge 1.2:
SELECT Title + ' ' + 
		FirstName + ' ' + 
		COALESCE(NULLIF(MiddleName, ''), '') + ' ' +         
		LastName + ' ' +         
		COALESCE(NULLIF(Suffix, ''), '')
FROM SalesLT.Customer
GROUP BY Title, Firstname, COALESCE(NULLIF(MiddleName, ''), ''), LastName, COALESCE(NULLIF(Suffix, ''), '')
ORDER BY LastName, FirstName

--Challenge 1.3:
SELECT SalesPerson, Title + ' ' +         
		FirstName + ' ' +         
		COALESCE(NULLIF(MiddleName, ''), '') + ' ' +         
		LastName + ' ' +         
		COALESCE(NULLIF(Suffix, ''), ''),        
		EmailAddress,        
		Phone
FROM SalesLT.Customer
GROUP BY SalesPerson, Title, Firstname, COALESCE(NULLIF(MiddleName, ''), ''), LastName, COALESCE(NULLIF(Suffix, ''), ''), EmailAddress, Phone
ORDER BY SalesPerson, LastName, FirstName
--Challenge 2.1
--You have been asked to provide a list of all customer companies in the format Customer ID : Company Name - for example, 78: Preferred Bikes.
SELECT CONCAT(CustomerId, ' : ', CompanyName) FROM SalesLT.Customer
--Challenge 2.2a--The sales order number and revision number in the format () – for example SO71774 (2).
SELECT CONCAT(SalesOrderNumber, ' (', RevisionNumber, ')') FROM SalesLT.SalesOrderHeader
--Challenge 2.2b
SELECT FORMAT(CONVERT(DATETIME, CAST(OrderDate as VARCHAR(30)), 102), 'yyyy.MM.dd') AS FormattedStartDate FROM SalesLT.SalesOrderHeader

--SELECT SalesOrderNumber + ' (' + STR(RevisionNumber, 1) + ')' AS OrderRevision,
--   CONVERT(nvarchar(30), OrderDate, 102) AS OrderDate
--FROM SalesLT.SalesOrderHeader;


SELECT CONCAT(SalesOrderNumber, ' (', RevisionNumber, ')') as SalesOrderInfo
		, FORMAT(CONVERT(DATETIME, CAST(OrderDate as VARCHAR(30)), 102), 'yyyy.MM.dd') AS FormattedStartDate
FROM SalesLT.SalesOrderHeader

--Challenge 3.1
/*
You have been asked to write a query that returns a list of customer names. 
The list must consist of a single column in the format first last (for example Keith Harris) 
if the middle name is unknown, or first middle last (for example Jane M. Gates) if a middle name is known.
*/
SELECT CONCAT(FirstName, ' ', ISNULL(CONCAT(MiddleName, ' '), ''), LastName) as CustomerName
FROM SalesLT.Customer

--3.2
SELECT CustomerID, EmailAddress, Phone, COALESCE(EmailAddress, Phone) AS PrimaryContact
FROM SalesLT.Customer;

--3.3
SELECT SalesOrderID, OrderDate,
    CASE
        WHEN ShipDate IS NULL THEN 'Awaiting Shipment'
        ELSE 'Shipped'
    END AS ShippingStatus
FROM SalesLT.SalesOrderHeader;