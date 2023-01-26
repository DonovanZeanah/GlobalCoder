/****** Script for SelectTopNRows command from SSMS  ******/
--duplicated?
SELECT c.FirstName, c.MiddleName, c.LastName, COUNT(*)
  FROM SalesLT.Customer c
  GROUP BY c.FirstName, c.MiddleName, c.LastName
  HAVING COUNT(*) > 1

--not duplicated
SELECT c.FirstName, c.MiddleName, c.LastName, COUNT(*)
  FROM SalesLT.Customer c
  GROUP BY c.FirstName, c.MiddleName, c.LastName
  HAVING COUNT(*) = 1

SELECT a.CustomerID, b.FirstName, b.MiddleName, b.LastName
FROM SalesLT.Customer a
JOIN (
SELECT c.FirstName, c.MiddleName, c.LastName
  FROM SalesLT.Customer c
  GROUP BY c.FirstName, c.MiddleName, c.LastName
  HAVING COUNT(*) = 1
) b on a.FirstName = b.FirstName and a.MiddleName = b.MiddleName and a.LastName = b.LastName


SELECT a.CustomerID, b.FirstName, b.MiddleName, b.LastName
FROM SalesLT.Customer a
JOIN (
SELECT c.FirstName, c.MiddleName, c.LastName
  FROM SalesLT.Customer c
  GROUP BY c.FirstName, c.MiddleName, c.LastName
  HAVING COUNT(*) > 1
) b on a.FirstName = b.FirstName and a.MiddleName = b.MiddleName and a.LastName = b.LastName


