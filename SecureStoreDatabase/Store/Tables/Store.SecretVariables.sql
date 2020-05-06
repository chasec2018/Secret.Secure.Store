Create Table [Store].[SecretVariables]
(
	[StoreUsername] Varchar(55) Not Null,
	[EntryKey] Varchar(255) Not Null Default [Store].[StoreKey](),
	[EntryName] Varchar(255) Not Null,
	[EntryUse] Varchar(255) Not Null,
	[Variable] Varbinary(8000) Not Null,
	[EntryStartDate] Date Not Null Default GetDate(),
	[EntryEndDate] Date Not Null Default DateAdd(yy,50,GetDate()),
	[CreationDate] Date Not Null Default GetDate(),
	[CreationTime] Time(6) Not Null Default Convert(Time(6),GetDate()),

	Constraint PrimaryKeyVariableKey Primary Key(EntryKey),
	Constraint UniqueUserVariablesName Unique(StoreUsername,EntryName),
	Constraint ForeignKeyUsernameAD Foreign Key(StoreUsername) References [Store].[AccessKeys](StoreUsername) On Update Cascade On Delete Cascade

)
