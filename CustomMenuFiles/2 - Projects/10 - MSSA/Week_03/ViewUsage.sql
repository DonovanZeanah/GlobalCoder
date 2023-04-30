select * from vCustomerCounts
where Expr1 > 1


SELECT a.CustomerID, b.FirstName, b.MiddleName, b.LastName
FROM SalesLT.Customer a
JOIN (
	Select FirstName, MiddleName, LastName 
		From vCustomerCounts
     where NumberOfRows > 1
	) 
b on a.FirstName = b.FirstName and a.MiddleName = b.MiddleName and a.LastName = b.LastName
