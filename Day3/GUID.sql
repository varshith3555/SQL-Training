

-- 1. Create table with NEWID() – Random GUID
-- Generates a random unique identifier (GUID) for each row
CREATE TABLE Product2 (
    ID UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    ProductName VARCHAR(255)
);

-- 2. Insert sample records
-- ID is auto-generated; no need to specify
INSERT INTO Product2 (ProductName) VALUES ('CAP');
INSERT INTO Product2 (ProductName) VALUES ('IT');

-- 3. View all data
SELECT * FROM Product2;

-- 4. Cleanup: Drop table if needed
DROP TABLE Product2;



-- 5. Create table with NEWSEQUENTIALID()
-- Generates a sequential GUID (higher than previous one)
CREATE TABLE Product2_Sequential (
    ID UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWSEQUENTIALID(),
    ProductName VARCHAR(255)
);

-- 6. Insert sample records
-- IDs will be in sequential order
INSERT INTO Product2_Sequential (ProductName) VALUES ('CAP');
INSERT INTO Product2_Sequential (ProductName) VALUES ('IT');

-- 7. View results – notice the sequential GUIDs
SELECT * FROM Product2_Sequential;

-- 8. Cleanup
DROP TABLE Product2_Sequential;
