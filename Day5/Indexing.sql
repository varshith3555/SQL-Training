-- Enables display of I/O statistics for each query, Shows logical reads, physical reads
SET STATISTICS IO ON;

-- Enables display of execution time statistics, Shows CPU time
SET STATISTICS TIME ON;

-- Creates a new table 'perf_issue' and copies all data
-- from Person.Person into it (one-time operation)
-- This is useful for testing performance without affecting original data
SELECT *
INTO perf_issue
FROM Person.Person;

-- Inserts all records from Person.Person into perf_issue again
-- This increases the data size and helps test performance
-- Note: This duplicates data if run after SELECT INTO
INSERT INTO perf_issue
SELECT *
FROM Person.Person;

-- Retrieves all rows from perf_issue table
-- Used to observe execution time and I/O cost
SELECT * FROM perf_issue;

-- Creates a view on top of perf_issue table
-- A view does NOT store data; it only stores the query definition and views do NOT improve performance by default
CREATE VIEW perf_issue_vw
AS
SELECT *
FROM perf_issue;

-- Reads data using the view
SELECT * FROM perf_issue_vw;

-- Adds a ROW_NUMBER column to each row
-- ROW_NUMBER() is a window function
-- ORDER BY BusinessEntityID determines row numbering sequence
-- This operation requires sorting and may increase CPU usage
SELECT 
    ROW_NUMBER() OVER (ORDER BY BusinessEntityID) AS RowNum,
    *
 FROM perf_issue;




-- Retrieves table-level page usage information and used_page_count shows how many pages are used by each table
SELECT
    so.name,
    ps.used_page_count
FROM
    sys.dm_db_partition_stats ps

-- Joins system objects to get table names, object_id links partition stats with table metadata
INNER JOIN
    sysobjects so
ON
    ps.object_id = so.id

WHERE             -- Filters only user-defined tables, xtype = 'U' represents user tables
    so.xtype = 'U'
ORDER BY          -- Sorts results by page usage, Useful for finding tables with highest or lowest space usage
    ps.used_page_count;




USE AdventureWorks2025;
GO

DROP TABLE IF EXISTS dbo.SOH_Practice;
SELECT TOP (300000)
  SalesOrderID, CustomerID, OrderDate, SubTotal, TaxAmt, Freight, TotalDue
INTO dbo.SOH_Practice
FROM Sales.SalesOrderHeader
ORDER BY SalesOrderID;

-- Create a clustered index on SalesOrderID (common pattern)
-- This leaves our search columns (CustomerID, OrderDate) without a supporting index.
CREATE CLUSTERED INDEX CX_SOH_Practice_SalesOrderID
ON dbo.SOH_Practice(SalesOrderID);

DROP INDEX IF EXISTS CX_SOH_Practice_SalesOrderID ON dbo.SOH_Practice;