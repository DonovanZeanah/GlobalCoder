CREATE VIEW [dbo].[vProductSales]
AS
SELECT   p.Name,
         p.ListPrice,
         SUM(o.LineTotal) AS TotalRevenue
FROM     SalesLT.SalesOrderDetail AS o
         INNER JOIN
         SalesLT.Product AS p
         ON o.ProductID = p.ProductID
GROUP BY p.Name, p.ListPrice;

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [Name], ListPrice, Sum(TotalRevenue)
  FROM vProductSales 
WHERE ListPrice > 1000
GROUP BY Name, ListPrice
HAVING SUM(TotalRevenue) > 20000
ORDER BY SUM(TotalRevenue) DESC

SELECT Name, ListPrice, TotalRevenue
	, RANK() OVER(Order By TotalRevenue DESC) as TotalRevenueRank
  FROM vProductSales 
WHERE ListPrice > 1000
order by TotalRevenue DESC




SELECT p.Name, p.ListPrice, SUM(o.LineTotal) AS TotalRevenue
FROM SalesLT.SalesOrderDetail AS o
JOIN SalesLT.Product AS p
    ON o.ProductID = p.ProductID
WHERE p.ListPrice > 1000
GROUP BY p.Name, p.ListPrice
HAVING SUM(o.LineTotal) > 20000
ORDER BY TotalRevenue DESC;
