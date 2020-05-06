Create Table [Store].[SecretClientRequestLog]
(
	[RequestID] Bigint Not Null Identity(1000,1),
	[RequestDate] Date Not Null Default GetDate(),
	[RequestTime] Time(6) Not Null Default Convert(Time(6), Current_TimeStamp),
	[Requester] Varchar(55) Not Null,
	[RequestMethod] Varchar(25) Not Null,
	[RequestHeader] Varchar(Max) Not Null,
	[RequestQuery] Varchar(Max) Not Null,
	
	Constraint PrimaryKeyRequest Primary Key([RequestID], [RequestDate], [RequestTime], [Requester], [RequestMethod]),
	Constraint CheckRequestType Check([RequestMethod]='GET' Or [RequestMethod] = 'POST' Or [RequestMethod] = 'PUT' Or [RequestMethod] = 'DELETE')
	
)
