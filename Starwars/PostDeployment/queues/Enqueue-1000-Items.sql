PRINT ' |_ Enqueue 1000 item'
GO

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