SELECT [SubTotal]
	  , [TaxAmt]
      , [Freight]
	  , [TotalDue]
	  , dbo.ufnAddThreeNumbers(SubTotal, TaxAmt, Freight) as Total
FROM SalesLT.SalesOrderHeader