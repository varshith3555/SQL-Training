
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE SecondProc
	-- Add the parameters for the stored procedure here
	@OrderId int,
	@OrderDate date
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- Insert statements for procedure here
	SELECT * FROM Orders WHERE OrderId=@OrderId AND OrderDate=@OrderDate
END
GO

EXEC SecondProc 5001, '2026-01-10';