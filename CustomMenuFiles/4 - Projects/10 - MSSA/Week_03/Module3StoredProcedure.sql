
CREATE OR ALTER PROCEDURE SalesLT.GetProductsForGrid
	@offset INT,
	@numRows INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT ProductId, [Name], ListPrice
	FROM SalesLT.Product
	ORDER BY [ProductId] OFFSET @offset*@numRows ROWS FETCH NEXT @numRows ROWS ONLY;
END
GO
