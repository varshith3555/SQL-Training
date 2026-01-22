
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
  --CREATE PROCEDURE FirstProc
	ALTER Procedure FirstProc
	-- Add the parameters for the stored procedure here
	@city VARCHAR(50),
	@segmentname varchar(50)
AS
BEGIN

    -- Insert statements for procedure here
	SELECT * FROM Customers WHERE city=@city OR Segment=@segmentname
END
GO
EXEC FirstProc 'BENGULURU', 'Retail'