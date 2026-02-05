
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

USE BikeStores;
GO

CREATE TRIGGER INSERT_TRIGGER
ON dbo.customers
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.LogInfo (LogText)
    SELECT 
        'INSERT on dbo.customers | CustomerId = ' 
        + CAST(customer_id AS NVARCHAR(20))
    FROM inserted;
END;
GO


SELECT name
FROM sys.triggers
WHERE name = 'INSERT_TRIGGER';


INSERT INTO dbo.customers
(customer_id, first_name, last_name, phone, email, street, city, state, zip_code)
VALUES
(7, 'Varshith', 'reddy', '9848067312', 'varshith@gmail.com',
 'Ganapur', 'Hyd', 'TS', '50920');

 INSERT INTO dbo.customers
(customer_id, first_name, last_name, phone, email, street, city, state, zip_code)
VALUES
(8, 'Test', 'User', '9999999999', 'test@gmail.com',
 'Street', 'City', 'TS', '50920');



SELECT * FROM dbo.LogInfo ORDER BY Id DESC;
