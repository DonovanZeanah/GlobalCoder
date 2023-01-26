USE [AdventureWorksLT2019]
GO

BEGIN TRAN

UPDATE [SalesLT].[Product]
   SET [ProductCategoryID] = 7
WHERE ProductCategoryID = 32
GO

select * from SalesLT.Product

--ROLLBACK TRAN
--COMMIT TRAN


