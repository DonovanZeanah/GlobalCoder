SELECT TOP(25) ProductModelID, [Name] AS ProductModel 
FROM AdventureWorksLT2019.SalesLT.ProductModel
ORDER BY ProductModelID

SELECT TOP(25) ProductModelID, [Name] 
FROM SalesLT.ProductModel
ORDER BY ProductModelID

SELECT TOP(25) [Name] AS ProductName, ProductModelID
FROM AdventureWorksLT2019.SalesLT.Product
ORDER BY ProductModelID

--this is the valid join
SELECT SalesLT.Product.[Name] as ProductName
		, SalesLT.ProductModel.[Name] as ProductModel
		, SalesLT.ProductModel.ProductModelID
		, SalesLT.Product.ProductModelID
FROM SalesLT.Product
INNER JOIN SalesLT.ProductModel 
	on SalesLT.Product.ProductModelID = SalesLT.ProductModel.ProductModelID
Order By ProductModel, ProductName

--using aliasing
SELECT p.[Name] as ProductName
		, pm.[Name] as ProductModel
		, p.ProductModelID
		, pm.ProductModelID
FROM SalesLT.Product p
INNER JOIN SalesLT.ProductModel pm on p.ProductModelID = pm.ProductModelID
Order By ProductModel, ProductName
