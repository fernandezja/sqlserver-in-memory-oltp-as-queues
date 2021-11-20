CREATE PROCEDURE [queues].[JediQueue_Enqueue]
	@Data VARCHAR(1000)
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @IsSuccessful BIT = 0

	BEGIN TRY
		
		BEGIN TRANSACTION

			INSERT INTO queues.JediQueue
			SELECT 
				[Data] = @Data, 
				LastModifiedDate = SYSDATETIME()

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

EXEC queues.JediQueue_Enqueue
	@Data = 'Demo'


-------------------------------------------------------------------------------------
*/

