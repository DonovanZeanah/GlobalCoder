SELECT * 
FROM SalesLT.Product
ORDER BY [Name]

SELECT * 
FROM SalesLT.Product
ORDER BY Color, [Name]

SELECT TOP(10) * 
FROM SalesLT.Product
ORDER BY [Name]

SELECT CONCAT(Title, ' ', FirstName, ' ', ISNULL(MiddleName + ' ', ''), ' ', LastName), EmailAddress, Phone
FROM [SalesLT].[Customer]
GROUP BY FirstName, MiddleName, LastName, CONCAT(Title, ' ', FirstName, ' ', ISNULL(MiddleName + ' ', ''), ' ', LastName), EmailAddress, Phone
ORDER BY LastName, FirstName

SELECT DISTINCT CONCAT(Title, ' ', FirstName, ' ', ISNULL(MiddleName + ' ', ''), ' ', LastName), EmailAddress, Phone
FROM [SalesLT].[Customer]
--GROUP BY FirstName, MiddleName, LastName, CONCAT(Title, ' ', FirstName, ' ', ISNULL(MiddleName + ' ', ''), ' ', LastName), EmailAddress, Phone
ORDER BY CONCAT(Title, ' ', FirstName, ' ', ISNULL(MiddleName + ' ', ''), ' ', LastName)

SELECT ProductID, [Name], ListPrice
FROM SalesLT.Product
ORDER BY ProductID DESC
	OFFSET 20 ROWS
	FETCH NEXT 10 ROWS ONLY;

SELECT *
FROM SalesLT.Product
WHERE StandardCost > 250 
	AND [Weight] < 1000

SELECT *
FROM SalesLT.Product
WHERE StandardCost > 250 
	AND StandardCost < 1000

SELECT *
FROM SalesLT.Product
WHERE StandardCost BETWEEN 250 AND 1000
		OR Weight Between 250 AND 1000

SELECT *
FROM SalesLT.Product
WHERE [Name] LIKE 'Mountain%'

SELECT *
FROM SalesLT.Product
WHERE [Name] LIKE '%Mou'

SELECT *
FROM SalesLT.Product
WHERE [Name] LIKE '%mOuntain%'

SELECT * FROM SalesLT.ProductCategory
WHERE [Name] LIKE '%Bike%'

1
5
6
7
30
31

SELECT [Name]
FROM SalesLT.Product
WHERE ProductCategoryID IN (1, 5, 6, 7, 30, 31)

SELECT [Name]
FROM SalesLT.ProductCategory
WHERE ProductCategoryID IN (1, 5, 6, 7, 30, 31)

--join:
SELECT p.[Name], pc.[Name]
FROM SalesLT.Product p
INNER JOIN SalesLT.ProductCategory pc on p.ProductCategoryID = pc.ProductCategoryID
WHERE pc.ProductCategoryID IN (1, 5, 6, 7, 30, 31)

--subquery:
SELECT p.[Name], pc.[Name]
FROM SalesLT.Product p
JOIN (
	SELECT [Name], ProductCategoryID
	FROM SalesLT.ProductCategory
	WHERE [Name] LIKE '%Bike%'
) pc on p.ProductCategoryID = pc.ProductCategoryID
WHERE p.ProductCategoryID IN 
(
	SELECT ProductCategoryID
	FROM SalesLT.ProductCategory
	WHERE [Name] LIKE '%Bike%'
)


SELECT p.[Name], pc.[Name], CONCAT(p.[Name], CHAR(13)+CHAR(10), pc.[Name])
FROM SalesLT.Product p
INNER JOIN SalesLT.ProductCategory pc on p.ProductCategoryID = pc.ProductCategoryID
WHERE pc.[Name] LIKE '%Bikes%'

SELECT p.[Name]
FROM SalesLT.Product p
WHERE p.ProductCategoryID =
(
	SELECT ProductCategoryID
	FROM SalesLT.ProductCategory
	WHERE [Name] LIKE '%Bike%'
)
