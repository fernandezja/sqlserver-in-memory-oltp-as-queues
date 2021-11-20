CREATE PROCEDURE [queues].[JediQueue_Pop]
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @IsSuccessful BIT = 0

	BEGIN TRY
		
		BEGIN TRANSACTION
				
		;WITH DataCTE AS (
			SELECT TOP 1 [Data], LastModifiedDate
			FROM queues.JediQueue
			ORDER BY Id DESC
		)

		DELETE FROM DataCTE
		OUTPUT deleted.[Data], deleted.LastModifiedDate;


		COMMIT TRANSACTION

	END TRY

	BEGIN CATCH
		
		IF (XACT_STATE()) <> 0
		BEGIN
			ROLLBACK TRANSACTION
		END				
		
	END CATCH

	--SELECT 
	--	IsSuccessful = @IsSuccessful

END
GO

/*
--------------------------------------------------------------------------------------
-- TEST
-------------------------------------------------------------------------------------

EXEC queues.JediQueue_Pop


-------------------------------------------------------------------------------------
*/

