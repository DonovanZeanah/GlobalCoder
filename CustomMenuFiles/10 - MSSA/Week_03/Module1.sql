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
SELECT prod.[Name], productcat.[Name]
FROM SalesLT.Product prod
INNER JOIN SalesLT.ProductCategory productcat ON prod.ProductCategoryID = productcat.ProductCategoryID
--WHERE prod.ProductCategoryID = 5
WHERE productcat.[Name] = 'Touring Bikes'
ORDER BY prod.[Name]