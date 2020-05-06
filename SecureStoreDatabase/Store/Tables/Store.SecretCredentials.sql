Create Table [Store].[SecretCredentials]
(
	[StoreUsername] Varchar(55) Not Null,
	[EntryKey] Varchar(255) Not Null Default [Store].[StoreKey](),
	[EntryName] Varchar(255) Not Null,
	[EntryUse] Varchar(255) Not Null,
	[Username] Varbinary(8000) Not Null,
	[Password] Varbinary(8000) Not Null,
	[EntryStartDate] Date Not Null Default GetDate(),
	[EntryEndDate] Date Not Null Default DateAdd(yy,50,GetDate()),
	[CreationDate] Date Not Null Default GetDate(),
	[CreationTime] Time(6) Not Null Default Convert(Time(6),Current_TimeStamp),

	Constraint PrimaryKeyCredentialsKey Primary Key(EntryKey),
	Constraint UniqueUserCredentialsName Unique(StoreUsername, EntryName),
	Constraint ForeignKeyUsernameAA Foreign Key(StoreUsername) References [Store].[AccessKeys](StoreUsername) On Update Cascade On Delete Cascade
)
