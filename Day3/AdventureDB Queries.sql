-- INSERT INTO PARENT TABLE
INSERT INTO [Person].[BusinessEntity] (rowguid, ModifiedDate)
VALUES (NEWID(), GETDATE());
SELECT SCOPE_IDENTITY();

-- INSERT INTO CHILD TABLE (Person.Person)
INSERT INTO [Person].[Person]
(BusinessEntityID, PersonType, NameStyle, Title, FirstName, LastName)
VALUES (20778, 'EM', 0, 'Mr.', 'Varshith', 'Reddy');

-- VERIFY INSERT
SELECT TOP 15 *
FROM [Person].[Person]
ORDER BY BusinessEntityID DESC;

-- UNION ALL (Duplicates allowed)
SELECT TOP 15 BusinessEntityID, LastName 
FROM [Person].[Person]
UNION ALL
SELECT TOP 15 BusinessEntityID, LastName 
FROM [Person].[Person] 
ORDER BY BusinessEntityID DESC;

-- UNION (Duplicates removed)
SELECT BusinessEntityID, LastName
FROM (
    SELECT TOP 15 BusinessEntityID, LastName 
    FROM [Person].[Person]
    ORDER BY BusinessEntityID ASC
) A
UNION
SELECT BusinessEntityID, LastName
FROM (
    SELECT TOP 15 BusinessEntityID, LastName 
    FROM [Person].[Person]
    ORDER BY BusinessEntityID DESC
) B
ORDER BY BusinessEntityID DESC;