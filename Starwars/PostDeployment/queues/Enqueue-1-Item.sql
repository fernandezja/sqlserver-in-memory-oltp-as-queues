
PRINT ' |_ Enqueue 1 item'
GO


EXEC queues.JediQueue_Enqueue
	@Data = 'Demo item A'
