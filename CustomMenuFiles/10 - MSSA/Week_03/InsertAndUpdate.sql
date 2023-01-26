USE [AdventureWorksLT2019]
GO

select max(productid) from saleslt.product
999

11 -. prodcat id
127 - prodmodelid

INSERT INTO [SalesLT].[Product]
(
	[Name],[ProductNumber],[Color],[StandardCost]
    ,[ListPrice],[Size],[Weight]
    ,[ProductCategoryID] --in the ProductCategory Table
    ,[ProductModelID] -- in the ProductModel Table
	,[SellStartDate]
)
VALUES
(
	'Brian''s Product3', '1A2B3Ca2', 'Yellow', 125.52
	, 275.50, 64, 452.35
	, 11
	, 127
	, DateAdd(YYYY, -5, GETDATE())
)
GO

SELECT @@IDENTITY
SELECT SCOPE_IDENTITY()
SELECT IDENT_CURRENT('SalesLT.Address')

--if this exists...
DROP TABLE SalesLT.ProductBackup20221019

SELECT * 
INTO SalesLT.ProductBackup20221019
FROM SalesLT.Product

DELETE FROM SalesLT.ProductBackup20221019
TRUNCATE TABLE SalesLT.ProductBackup20221019

INSERT INTO SalesLT.ProductBackup20221019
(
	[Name],[ProductNumber],[Color],[StandardCost]
    ,[ListPrice],[Size],[Weight]
    ,[ProductCategoryID] --in the ProductCategory Table
    ,[ProductModelID] -- in the ProductModel Table
	,[SellStartDate]
	,[rowguid]
	,[ModifiedDate]
)
VALUES
(
	'Brian''s Product3', '1A2B3Ca2', 'Yellow', 125.52
	, 275.50, 64, 452.35
	, 11
	, 127
	, DateAdd(YYYY, -5, GETDATE())
	, newid()
	, GetDate()
)
GO
SELECT @@Identity

select * from SalesLT.ProductBackup20221019
order by productid desc

TRUNCATE TABLE SalesLT.Product

DROP TABLE SalesLT.ProductBackup20221019a
SELECT * 
INTO SalesLT.ProductBackup20221019a
FROM SalesLT.Product
WHERE ProductModelId = 11


SELECT * FROM SalesLT.Product
WHERE ProductModelID = 11

SELECT * 
FROM SalesLT.ProductBackup20221019a