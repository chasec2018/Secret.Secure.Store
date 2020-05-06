Create Function [Store].[StoreKey]()
Returns Varchar(255)
As
Begin

	Declare @year Varchar(5);
	Declare @monthday Varchar(10);
	Declare @timestamp Varchar(10)

		Set @year = concat('y',format(getdate(), 'yy'))
		Set @monthday = concat('m',format(getdate(),'mm'),'d',Format(getdate(),'dd'))
		Set @timestamp = format(current_timestamp,'hhmmss')

	Return Upper(Concat(@year, '-',@monthday, '-',@timestamp))
End
