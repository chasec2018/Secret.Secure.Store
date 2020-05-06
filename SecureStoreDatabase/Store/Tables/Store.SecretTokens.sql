Create Table [Store].[SecretTokens]
(
	[StoreUsername] Varchar(55) Not Null,
	[EntryKey] Varchar(255) Not Null Default [Store].[StoreKey](),
	[EntryName] Varchar(255) Not Null,
	[EntryUse] Varchar(255) Not Null,
	[Token] Varbinary(8000) Not Null,
	[EntryStartDate] Date Not Null Default GetDate(),
	[EntryEndDate] Date Not Null Default DateAdd(yy,50,GetDate()),
	[CreationDate] Date Not Null Default GetDate(),
	[CreationTime] Time(6) Not Null Default Convert(Time(6),GetDate()),

	Constraint PrimaryKeyTokenKey Primary Key(EntryKey),
	Constraint UniqueUserTokensName Unique(StoreUsername, EntryName),
	Constraint ForeignKeyUsernameA Foreign Key(StoreUsername) References [Store].[AccessKeys](StoreUsername) On Update Cascade On Delete Cascade
)
