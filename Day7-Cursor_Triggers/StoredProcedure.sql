CREATE PROCEDURE sp_UpdateFashionPrices
AS
BEGIN
    DECLARE @ProductId INT;
    DECLARE @OldPrice DECIMAL(10,2);
    DECLARE @NewPrice DECIMAL(10,2);

    DECLARE curFashion CURSOR FAST_FORWARD
    FOR
        SELECT ProductId, Price
        FROM dbo.Products
        WHERE Category = 'Fashion';

    BEGIN TRY
        BEGIN TRAN;

        OPEN curFashion;
        FETCH NEXT FROM curFashion INTO @ProductId, @OldPrice;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @NewPrice = ROUND(@OldPrice * 1.05, 2);

            UPDATE dbo.Products
            SET Price = @NewPrice
            WHERE ProductId = @ProductId;

            INSERT INTO dbo.PriceChangeLog(ProductId, OldPrice, NewPrice)
            VALUES (@ProductId, @OldPrice, @NewPrice);

            FETCH NEXT FROM curFashion INTO @ProductId, @OldPrice;
        END

        CLOSE curFashion;
        DEALLOCATE curFashion;

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
    IF CURSOR_STATUS('global','curFashion') >= -1
    BEGIN
        CLOSE curFashion;
        DEALLOCATE curFashion;
    END

    IF @@TRANCOUNT > 0 ROLLBACK TRAN;
    THROW;
END CATCH;
END