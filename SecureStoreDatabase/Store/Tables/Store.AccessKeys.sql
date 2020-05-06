Create Table [Store].[AccessKeys]
(
	[StoreAccessKey] Varbinary(900) Not Null, 
	[StoreUsername] Varchar(55) Not Null,
	[FirstName] Varchar(55) Null,
	[LastName] Varchar(55) Null,
	[MiddleName] Varchar(55) Null,
	[AccessStartDate] Date Not Null Default GetDate(),
	[AccessEndDate] Date Not Null Default DateAdd(yy,50,GetDate()),
	[CreationDate] Date Not Null Default GetDate(),
	[CreationTime] Time(6) Not Null Default Convert(Time(6),Current_TimeStamp),


	Constraint PrimaryKeyStoreUsername Primary Key(StoreUsername),
	Constraint UniqueAccessKeyConstraint Unique(StoreAccessKey)

)
