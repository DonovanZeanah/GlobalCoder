SELECT Name, ListPrice
FROM SalesLT.Product;

SELECT Name, ListPrice
FROM SalesLT.Product
ORDER BY Name;

SELECT Name, ListPrice
FROM SalesLT.Product
ORDER BY ListPrice;

SELECT Name, ListPrice
FROM SalesLT.Product
ORDER BY ListPrice DESC;

SELECT Name, ListPrice
FROM SalesLT.Product
ORDER BY ListPrice DESC, Name ASC;

SELECT Name, ListPrice
FROM SalesLT.Product
ORDER BY ListPrice DESC, Name ASC;

SELECT TOP (20) WITH TIES Name, ListPrice
FROM SalesLT.Product
ORDER BY ListPrice DESC;

SELECT TOP (20) WITH TIES Name, ListPrice
FROM SalesLT.Product
ORDER BY ListPrice DESC;

SELECT Name, ListPrice
FROM SalesLT.Product
ORDER BY Name OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

SELECT Name, ListPrice
FROM SalesLT.Product
ORDER BY Name OFFSET 10 ROWS FETCH NEXT 10 ROWS ONLY;

SELECT Color
FROM SalesLT.Product;

SELECT ALL Color
FROM SalesLT.Product;

SELECT DISTINCT Color
FROM SalesLT.Product;

SELECT DISTINCT Color, Size
FROM SalesLT.Product;

SELECT Name, Color, Size
FROM SalesLT.Product
WHERE ProductModelID = 6
ORDER BY Name;

SELECT Name, Color, Size
FROM SalesLT.Product
WHERE ProductModelID <> 6
ORDER BY Name;

SELECT Name, ListPrice
FROM SalesLT.Product
WHERE ListPrice > 1000.00
ORDER BY ListPrice;

SELECT Name, ListPrice
FROM SalesLT.Product
WHERE Name LIKE 'HL Road Frame %';

SELECT Name, ListPrice
FROM SalesLT.Product
WHERE ProductNumber LIKE 'FR-_[0-9][0-9]_-[0-9][0-9]';

SELECT Name, ListPrice
FROM SalesLT.Product
WHERE SellEndDate IS NOT NULL;

SELECT Name
FROM SalesLT.Product
WHERE SellEndDate BETWEEN '2006/1/1' AND '2006/12/31';

SELECT ProductCategoryID, Name, ListPrice
FROM SalesLT.Product
WHERE ProductCategoryID IN (5,6,7);

SELECT ProductCategoryID, Name, ListPrice, SellEndDate
FROM SalesLT.Product
WHERE ProductCategoryID IN (5,6,7) AND SellEndDate IS NULL;

SELECT Name, ProductCategoryID, ProductNumber
FROM SalesLT.Product
WHERE ProductNumber LIKE 'FR%' OR ProductCategoryID IN (5,6,7);

--## Challenge 1:

--1.1
--List of all customer locations
SELECT * FROM SalesLT.Address
SELECT City, StateProvince, CountryRegion 
FROM SalesLT.Address
GROUP BY City, StateProvince, CountryRegion
ORDER BY City

--1.2
--Top 10% of weight products
SELECT TOP (10) PERCENT WITH TIES [Name], WEIGHT
FROM SalesLT.Product
WHERE WEIGHT IS NOT NULL
ORDER BY WEIGHT DESC

--## Challenge 2:

--2.1
--name, color, size of products with prod model id = 1
SELECT [Name], Color, Size 
FROM SalesLT.Product
WHERE ProductModelID = 1

--2.2
--Product Number and Name where color is black, red or white and size is small or med
SELECT ProductID, ProductNumber, [Name] ProductName, Color, Size, ListPrice, StandardCost
FROM SalesLT.Product
WHERE COLOR IN ('Black', 'Red', 'White') AND Size IN ('S', 'M')

--2.3
--Product Number, Name, and List Price where number starts with BK-
SELECT ProductID, ProductNumber, [Name] ProductName, Color, Size, ListPrice, StandardCost
FROM SalesLT.Product
WHERE ProductNumber LIKE 'BK-%'

--2.4
--Product Number, Name, and List Price where number starts with BK-
-- does not have BK-R
-- ends with a - followed by any two numbers
SELECT ProductID, ProductNumber, [Name] ProductName, Color, Size, ListPrice, StandardCost
FROM SalesLT.Product
WHERE ProductNumber LIKE 'BK-%'
AND ProductNumber NOT LIKE 'BK-R%'
AND ProductNumber LIKE '%-[0-9][0-9]'

SELECT ProductID, ProductNumber, [Name] ProductName, Color, Size, ListPrice, StandardCost
FROM SalesLT.Product
WHERE ProductNumber LIKE 'BK-[^R]%-[0-9][0-9]'



