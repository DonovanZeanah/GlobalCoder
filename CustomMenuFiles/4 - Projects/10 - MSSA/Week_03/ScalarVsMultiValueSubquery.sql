/*
select c.CustomerID, c.FirstName, c.LastName, Count(oh.SalesOrderId), SUM(oh.TotalDue) from SalesLT.Customer c
INNER JOIN SalesLT.SalesOrderHeader oh on c.CustomerID = oh.CustomerID
INNER JOIN SalesLT.SalesOrderDetail od on od.SalesOrderID = oh.SalesOrderID
GROUP BY c.CustomerId, c.FirstName, c.LastName
order by c.LastName, c.FirstName
*/
/*
DECLARE @FirstName VARCHAR(50) = 'Guy'
DECLARE @LastName VARCHAR(50) = 'Gilbert'
*/
DECLARE @FirstName VARCHAR(50) = 'Christopher'
DECLARE @LastName VARCHAR(50) = 'Beck'
--DECLARE @CategoryName VARCHAR(50) = 'Socks'
DECLARE @CategoryName VARCHAR(50) = 'Road Bikes'
--DECLARE @CategoryName VARCHAR(50) = 'Jerseys'

--find the customer
DECLARE @CustomerID INT = (
	SELECT MAX(CustomerId) 
	FROM SalesLT.Customer
	WHERE FirstName = @FirstName AND LastName = @LastName
)
PRINT @CustomerID
/*
--find the customer order line item that was the most expensive
SELECT c.CustomerID, c.FirstName, c.LastName, oh.SalesOrderID, oh.RevisionNumber, oh.OrderDate, oh.[Status],
		oh.SalesOrderNumber, oh.SalesOrderID, p.ProductID, p.[Name], p.Color, od.UnitPrice, od.OrderQty, od.LineTotal
FROM SalesLt.Customer c
INNER JOIN SalesLT.SalesOrderHeader oh on c.CustomerID = oh.CustomerID
INNER JOIN SalesLT.SalesOrderDetail od on oh.SalesOrderID = od.SalesOrderID
INNER JOIN SalesLT.Product p on od.ProductID = p.ProductID
WHERE c.CustomerID = @CustomerID
and od.LineTotal =
(
	SELECT MAX(od.LineTotal)
	FROM SalesLt.Customer c
	INNER JOIN SalesLT.SalesOrderHeader oh on c.CustomerID = oh.CustomerID
	INNER JOIN SalesLT.SalesOrderDetail od on oh.SalesOrderID = od.SalesOrderID
	WHERE c.CustomerID = @CustomerID
)
ORDER BY p.[Name], p.Color
*/
---SAME:
SELECT TOP (1) od.* FROM SalesLT.SalesOrderDetail od
INNER JOIN SalesLT.SalesOrderHeader oh on od.SalesOrderID = oh.SalesOrderID
WHERE oh.CustomerID = @CustomerID
ORDER BY od.LineTotal DESC

--find the customer orders where the product is @CategoryName
SELECT c.CustomerID, c.FirstName, c.LastName, oh.SalesOrderID, oh.RevisionNumber, oh.OrderDate, oh.[Status],
		oh.SalesOrderNumber, oh.SalesOrderID, p.ProductID, p.[Name], p.Color, od.UnitPrice, od.OrderQty, od.LineTotal
FROM SalesLt.Customer c
INNER JOIN SalesLT.SalesOrderHeader oh on c.CustomerID = oh.CustomerID
INNER JOIN SalesLT.SalesOrderDetail od on oh.SalesOrderID = od.SalesOrderID
INNER JOIN SalesLT.Product p on od.ProductID = p.ProductID
WHERE c.CustomerID = @CustomerID
and p.ProductCategoryID IN
(
	SELECT pc.ProductCategoryId
	FROM SALESLT.ProductCategory pc
	WHERE pc.[Name] = @CategoryName
)
ORDER BY p.[Name], p.Color
