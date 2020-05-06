Create Procedure [Store].[CreateNewLogEntry]
	@RequestMethod Varchar(25),
	@Requester Varchar(55),
	@RequestHeader Varchar(Max),
	@RequestQuery Varchar(Max)
As
	
	Begin Try
		Insert Into [Store].[SecretClientRequestLog]
			(
				[RequestDate],
				[RequestTime],
				[Requester],
				[RequestMethod],
				[RequestHeader],
				[RequestQuery]
			)
		Values
			(
				GetDate(),
				Convert(Time(6),Current_Timestamp),
				@Requester,
				@RequestMethod,
				@RequestHeader,
				@RequestQuery
			)
	End Try

	Begin Catch 
		Execute [Store].[ReturnErrorInformation];
	End Catch

Return 0
