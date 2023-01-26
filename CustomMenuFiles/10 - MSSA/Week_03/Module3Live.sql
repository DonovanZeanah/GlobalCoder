
-- inner join --
-- product/productcategory
-- product/productmodel

-- left join
SELECT [FirstName], [MiddleName], [LastName]
FROM SalesLT.Customer 
GROUP BY [FirstName], [MiddleName], [LastName]
--440 customers

SELECT c.CustomerId, c.FirstName, c.MiddleName, c.LastName
		, a.AddressID, a.AddressLine2, a.City, a.StateProvince, a.CountryRegion
FROM SalesLT.Customer c
INNER JOIN SalesLT.CustomerAddress ca on c.CustomerId = ca.CustomerId
INNER JOIN SalesLT.Address a on ca.AddressID = a.AddressID
ORDER BY c.LastName,  c.MiddleName, c.FirstName
--417 addresses (not guaranteed to be one per customer)

--"Give me all the customers for which we do not have an address"
SELECT c.CustomerId, c.FirstName, c.MiddleName, c.LastName, c.EmailAddress
		, a.AddressID, a.AddressLine2, a.City, a.StateProvince, a.CountryRegion
FROM SalesLT.Customer c
LEFT JOIN SalesLT.CustomerAddress ca on c.CustomerId = ca.CustomerId
LEFT JOIN SalesLT.Address a on ca.AddressID = a.AddressID
WHERE a.AddressID is null
ORDER BY c.LastName,  c.MiddleName, c.FirstName

--"Give me all the customers for which we do not have an address"
SELECT c.CustomerId, c.FirstName, c.MiddleName, c.LastName, c.EmailAddress, ca.AddressID
FROM SalesLT.Customer c
LEFT JOIN SalesLT.CustomerAddress ca on c.CustomerId = ca.CustomerId
WHERE ca.AddressID is null
ORDER BY c.LastName,  c.MiddleName, c.FirstName

--"Give me all the addresses that are orphaned
--SELECT c.CustomerId, c.FirstName, c.MiddleName, c.LastName, c.EmailAddress, ca.AddressID
--FROM SalesLT.Customer c
--LEFT JOIN SalesLT.CustomerAddress ca on c.CustomerID = ca.CustomerId
--ORDER BY c.LastName,  c.MiddleName, c.FirstName

SELECT * FROM SalesLT.Customer WHERE CustomerID = 29489

/*
29489	0	Ms.	Frances	B.	Adams	NULL	Area Bike Accessories	adventure-works\shu0	frances0@adventure-works.com
*/

DELETE FROM SalesLT.CustomerAddress
WHERE CustomerID = 29489
DELETE FROM SalesLT.Customer
WHERE CustomerId = 29489

--all the addresses
SELECT a.AddressID, a.AddressLine1, a.AddressLine2, a.City, a.StateProvince, a.CountryRegion, ca.AddressID
FROM SalesLT.Address a
LEFT JOIN SalesLT.CustomerAddress ca on a.AddressID = ca.AddressID
--where ca.AddressID is null
ORDER BY a.AddressID, a.AddressLine2, a.City, a.StateProvince, a.CountryRegion

--all the addresses that ARE NOT associated
SELECT a.AddressID, a.AddressLine1, a.AddressLine2, a.City, a.StateProvince, a.CountryRegion, ca.AddressID
FROM SalesLT.Address a
LEFT JOIN SalesLT.CustomerAddress ca on a.AddressID = ca.AddressID
where ca.AddressID is null
ORDER BY a.AddressID, a.AddressLine2, a.City, a.StateProvince, a.CountryRegion

--all the addresses that ARE associated
SELECT a.AddressID, a.AddressLine1, a.AddressLine2, a.City, a.StateProvince, a.CountryRegion, ca.AddressID
FROM SalesLT.Address a
RIGHT JOIN SalesLT.CustomerAddress ca on a.AddressID = ca.AddressID
--where ca.AddressID is null
ORDER BY a.AddressID, a.AddressLine2, a.City, a.StateProvince, a.CountryRegion



select * from SalesLT.address where addressid = 1069


--417 addresses (not guaranteed to be one per customer)
-- right join

-- left/right outer join

"Give me all the orders that have been placed in the last 90 days"

--all the data for that quarter
Select * from SalesLT.Customer c
INNER JOIN SalesLT.SalesOrderHeader oh on c.CustomerID = oh.CustomerID
WHERE oh.OrderDate BETWEEN '2008.06.01' AND '2008.09.01'

--customers who didn't place an order last quarter (...)
Select * 
from SalesLT.Customer c
LEFT JOIN SalesLT.SalesOrderHeader oh on c.CustomerID = oh.CustomerID
WHERE oh.CustomerID is null

select * from SalesLT.SalesOrderHeader
order by customerid

-- cartesian / cross join

-- self join

--all the addresses with a customer

--all the customers without an address

--all the addresses not assigned to a customer


--subqueries
SELECT * FROM SalesLT.Product
Where ProductModelID IN
(1
,2
,18
,24
,32
,95
,96
,97
,98
,99
,100
,101
,107
,112
,113
,114
,115
,118
)

SELECT * FROM SalesLT.Product
Where ProductModelID IN
(
	select ProductModelId FROM SalesLt.ProductModel
	where [Name] LIKE '%c%'
)
order by ProductModelID

SELECT p.ProductModelID, p.[Name], a.[Name]
FROM SalesLT.Product p
INNER JOIN 
(
	select ProductModelId, [Name] FROM SalesLt.ProductModel
	where [Name] LIKE '%c%'
) a on p.ProductModelID = a.ProductModelId
ORDER BY p.ProductModelID


