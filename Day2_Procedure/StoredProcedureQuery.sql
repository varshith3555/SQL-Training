
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--CREATE PROCEDURE CRUDLpuDB
ALTER PROCEDURE CRUDLpuDB
	-- Add the parameters for the stored procedure here
	@Action varchar(50),
	@Id int = NULL,
	@Name varchar(50) = NULL
AS
BEGIN
--select Id, deptName from tbl_dept
	if @Action = 'Insert' 
	BEGIN

	INSERT into tbl_dept(Id, deptName) values(@Id, @Name)
	end

	else if @Action = 'SELECT'
	BEGIN
	SELECT * FROM tbl_dept
	end

	else if @Action = 'Update'
	BEGIN
	UPDATE tbl_dept set deptName = @Name where Id=@Id
	end

	else if @Action = 'DELETE'
	BEGIN
	DELETE tbl_dept where Id =@Id
	end

	else
	BEGIN
	PRINT 'INVALID'
	end

END
GO

EXEC CRUDLpuDB 'SELECT'
