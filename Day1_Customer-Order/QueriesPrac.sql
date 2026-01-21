SELECT *
FROM dbo.Customers;

SELECT CustomerId, FullName, City
FROM dbo.Customers;

SELECT DISTINCT City
FROM dbo.Customers;

SELECT FullName AS CustomerName, City AS CustomerCity
FROM dbo.Customers;

SELECT *
FROM dbo.Customers
WHERE City = 'Chennai';

SELECT *
FROM dbo.Orders
WHERE Status = 'Delivered' AND PaymentMode = 'UPI';

SELECT *
FROM dbo.Customers
WHERE City IN ('Chennai', 'Coimbatore');

SELECT *
FROM dbo.Orders
WHERE Amount BETWEEN 800 AND 3000;

SELECT *
FROM dbo.Customers
WHERE FullName LIKE 'S%';

SELECT *
FROM dbo.Orders
ORDER BY Amount DESC;

SELECT TOP 3 *
FROM dbo.Orders
ORDER BY Amount DESC;



SELECT *
FROM dbo.Customers
WHERE FullName LIKE 'S%a' or FullName like '%Varshith%';

 SELECT top 1 * from 

(SELECT TOP 2 *
FROM dbo.Orders
ORDER BY Amount  desc ) 

TT 

order by tt.Amount