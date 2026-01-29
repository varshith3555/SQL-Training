Select * from Customers;

-- First Approach
Select MAX(CustomerId) from Customers
where CustomerId < (select MAX(CustomerId) from Customers);

-- Second Approach
SELECT TOP 1 * 
FROM Customers
WHERE CustomerId < (SELECT MAX(CustomerId) FROM Customers)
ORDER BY CustomerId DESC

-- third way
SELECT *
FROM Customers
ORDER BY CustomerId DESC
OFFSET 1 ROWS FETCH NEXT 1 ROW ONLY;