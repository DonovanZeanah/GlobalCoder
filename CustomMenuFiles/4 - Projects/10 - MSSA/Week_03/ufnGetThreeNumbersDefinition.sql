
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER FUNCTION ufnAddThreeNumbers
(
	@number1 DECIMAL(18,2),
	@number2 DECIMAL(18,2),
	@number3 DECIMAL(18,2)
)
RETURNS DECIMAL(18,2)
AS
BEGIN
	DECLARE @value DECIMAL(18,2)

	-- Add the T-SQL statements to compute the return value here
	SET @value = ISNULL(@number1, 0) + COALESCE(@number2, 0) + ISNULL(@number3, 0)

	-- Return the result of the function
	RETURN @value

END
GO

