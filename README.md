# sqlserver-in-memory-oltp-as-queues
SQL Server In-Memory OLTP as Queues

It's a simple proof-of-concept to use queues with in-memory OLTP, to queue one or many item and get it with pop (FIFO method). 

### Store Procedures
 - queues.JediQueue_Enqueue
 - queues.JediQueue_EnqueueItems
 - queues.JediQueue_Count
 - queues.JediQueue_Pop
 - queues.JediQueue_Clean



#### Enqueue 1 item
```
EXEC queues.JediQueue_Enqueue
	@Data = 'Demo item A'
```

#### Enqueue 1000 items with in-memory table type
```
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
```