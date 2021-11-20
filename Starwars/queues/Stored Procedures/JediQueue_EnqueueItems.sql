CREATE PROCEDURE [queues].[JediQueue_EnqueueItems]
	@Items queues.JediQueueItemTableType READONLY
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @IsSuccessful BIT = 0

	BEGIN TRY
		
		BEGIN TRANSACTION

			INSERT INTO queues.JediQueue
			SELECT 
				[Data] = TEMP.[Data], 
				LastModifiedDate = SYSDATETIME()
			FROM @Items TEMP

			SET @IsSuccessful = 1

		COMMIT TRANSACTION

	END TRY

	BEGIN CATCH
		
		IF (XACT_STATE()) <> 0
		BEGIN
			ROLLBACK TRANSACTION
		END				
		
	END CATCH

	SELECT 
		IsSuccessful = @IsSuccessful

END
GO

/*
--------------------------------------------------------------------------------------
-- TEST
-------------------------------------------------------------------------------------

DECLARE @ItemsTable queues.JediQueueItemTableType

;WITH RandomItemsCTE AS (
  SELECT TOP 1000
	[Data] = C1.name,
	[Index] = ROW_NUMBER() OVER (ORDER BY (SELECT 1))
	FROM sys.all_columns C1
		CROSS JOIN sys.all_columns C2
)

INSERT INTO @ItemsTable([Data])
SELECT TOP 1000
	[Data] = CONCAT('Demo item ', CTE.[Index], ' ', CTE.[Data])
FROM RandomItemsCTE CTE


EXEC queues.JediQueue_EnqueueItems
	@Items = @ItemsTable
GO


-------------------------------------------------------------------------------------
*/

