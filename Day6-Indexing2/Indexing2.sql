CREATE OR ALTER PROCEDURE dbo.usp_ShowPerformance_WithWithoutIndex
(
      @Rows            INT = 100000,      -- how many rows to copy into practice table
      @TestProductId   INT = 870,         -- ProductID to test
      @Loops           INT = 10,          -- run same query multiple times (more reliable)
      @ClearCache      BIT = 0            -- 1 = clear cache (ONLY in test DB)
)
AS
BEGIN
    SET NOCOUNT ON;

    ----------------------------------------------------------------------
    -- 0) Safety note for cache clearing
    ----------------------------------------------------------------------
    IF @ClearCache = 1
    BEGIN
        PRINT 'WARNING: Cache clearing is enabled. Do NOT use @ClearCache=1 in Production.';
    END

    ----------------------------------------------------------------------
    -- 1) Build a large practice table (so the difference is visible)
    ----------------------------------------------------------------------
    DROP TABLE IF EXISTS dbo.SalesOrderDetail_Practice;

    SELECT TOP (@Rows)
           SalesOrderID,
           SalesOrderDetailID,
           ProductID,
           OrderQty,
           UnitPrice,
           LineTotal,
           ModifiedDate
    INTO dbo.SalesOrderDetail_Practice
    FROM Sales.SalesOrderDetail
    ORDER BY SalesOrderDetailID;  -- stable order

    ----------------------------------------------------------------------
    -- 2) Create a test query (filter by ProductID)
    --    This is the kind of query that indexing should speed up.
    ----------------------------------------------------------------------
    DECLARE @i INT;

    ----------------------------------------------------------------------
    -- Helper variables for timing
    ----------------------------------------------------------------------
    DECLARE @t0 DATETIME2(7), @t1 DATETIME2(7);
    DECLARE @ElapsedWithoutMs BIGINT, @ElapsedWithMs BIGINT;

    ----------------------------------------------------------------------
    -- 3) Run WITHOUT INDEX
    ----------------------------------------------------------------------
    -- Ensure index does not exist
    IF EXISTS (
        SELECT 1
        FROM sys.indexes
        WHERE object_id = OBJECT_ID('dbo.SalesOrderDetail_Practice')
          AND name = 'CX_SOD_Practice_ProductID'
    )
    DROP INDEX CX_SOD_Practice_ProductID ON dbo.SalesOrderDetail_Practice;

    IF @ClearCache = 1
    BEGIN
        CHECKPOINT;
        DBCC DROPCLEANBUFFERS;
        DBCC FREEPROCCACHE;
    END

    PRINT '============================';
    PRINT 'TEST 1: WITHOUT INDEX';
    PRINT '============================';

    SET STATISTICS IO ON;
    SET STATISTICS TIME ON;

    SET @t0 = SYSDATETIME();
    SET @i = 1;

    WHILE @i <= @Loops
    BEGIN
        -- OPTION(RECOMPILE) avoids “reusing” an old plan across runs.
        SELECT SalesOrderID, SalesOrderDetailID, ProductID, OrderQty, UnitPrice
        FROM dbo.SalesOrderDetail_Practice
        WHERE ProductID = @TestProductId
        OPTION (RECOMPILE);

        SET @i += 1;
    END

    SET @t1 = SYSDATETIME();
    SET STATISTICS IO OFF;
    SET STATISTICS TIME OFF;

    SET @ElapsedWithoutMs = DATEDIFF_BIG(MILLISECOND, @t0, @t1);

    ----------------------------------------------------------------------
    -- 4) Create CLUSTERED INDEX and Run WITH INDEX
    ----------------------------------------------------------------------
    CREATE CLUSTERED INDEX CX_SOD_Practice_ProductID
    ON dbo.SalesOrderDetail_Practice(ProductID);

    IF @ClearCache = 1
    BEGIN
        CHECKPOINT;
        DBCC DROPCLEANBUFFERS;
        DBCC FREEPROCCACHE;
    END

    PRINT '============================';
    PRINT 'TEST 2: WITH CLUSTERED INDEX';
    PRINT '============================';

    SET STATISTICS IO ON;
    SET STATISTICS TIME ON;

    SET @t0 = SYSDATETIME();
    SET @i = 1;

    WHILE @i <= @Loops
    BEGIN
        SELECT SalesOrderID, SalesOrderDetailID, ProductID, OrderQty, UnitPrice
        FROM dbo.SalesOrderDetail_Practice
        WHERE ProductID = @TestProductId
        OPTION (RECOMPILE);

        SET @i += 1;
    END

    SET @t1 = SYSDATETIME();
    SET STATISTICS IO OFF;
    SET STATISTICS TIME OFF;

    SET @ElapsedWithMs = DATEDIFF_BIG(MILLISECOND, @t0, @t1);

    ----------------------------------------------------------------------
    -- 5) Final summary result set (easy to paste into report)
    ----------------------------------------------------------------------
    SELECT
        @Rows  AS RowsCopiedIntoPracticeTable,
        @Loops AS LoopsExecuted,
        @TestProductId AS TestedProductID,

        @ElapsedWithoutMs AS TotalElapsedMs_WithoutIndex,
        CAST(@ElapsedWithoutMs * 1.0 / NULLIF(@Loops,0) AS DECIMAL(18,2)) AS AvgElapsedMsPerLoop_WithoutIndex,

        @ElapsedWithMs AS TotalElapsedMs_WithIndex,
        CAST(@ElapsedWithMs * 1.0 / NULLIF(@Loops,0) AS DECIMAL(18,2)) AS AvgElapsedMsPerLoop_WithIndex,

        CASE 
            WHEN @ElapsedWithMs = 0 THEN NULL
            ELSE CAST(@ElapsedWithoutMs * 1.0 / @ElapsedWithMs AS DECIMAL(18,2))
        END AS ImprovementFactor_XTimes
    ;

END
GO


usp_ShowPerformance_WithWithoutIndex