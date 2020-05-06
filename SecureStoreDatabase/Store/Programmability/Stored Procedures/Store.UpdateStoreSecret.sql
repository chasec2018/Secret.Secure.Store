Create Procedure Store.UpdateStoreSecret
	@StoreUsername Varchar(255),
	@EntryKey Varchar(255),
	@EntryType Int,
	@EntryName Varchar(255) = Null,
	@EntryUse Varchar(255) = Null,
	@EntryUsername Varchar(max) = Null,
	@EntryPassword Varchar(Max) = null,
	@EntryConnectionString Varchar(Max) = Null,
	@EntryToken Varchar(Max) = Null,
	@EntryVariable Varchar(Max) = Null,
	@EntryStartDate Date = Null,
	@EntryEndDate Date = Null

As

	Exec [Store].[OpenStoreSymmetricKey]

	If @EntryType = 1
		Begin
			Declare @CredentialsTable Table
			(
				[EntryType] Int,
				[StoreUsername] Varchar(55),
				[EntryKey] Varchar(255),
				[EntryName] Varchar(255),
				[EntryUse] Varchar(255),
				[EntryUsername] Varchar(8000),
				[EntryPassword] Varchar(8000),
				[EntryStartDate] Date,
				[EntryEndDate] Date
			)

			Update 
				[Store].[SecretCredentials]
			Set
				[EntryName] = IIf(IsNull(@EntryName,'') = '', [EntryName], @EntryName),
				[EntryUse] = IIf(IsNull(@EntryUse,'') = '', [EntryUse], @EntryUse),
				[Username] = IIf(IsNull(@EntryUsername,'') = '', [Username], EncryptByKey(Key_guid('StoreKeyA'),@EntryUsername)),
				[Password] = IIf(IsNull(@EntryPassword,'') = '', [Password], EncryptByKey(Key_guid('StoreKeyA'),@EntryPassword)),
				[EntryStartDate] = IIf(IsNull(@EntryStartDate,'1900-01-01') = '1900-01-01',[EntryStartDate], @EntryStartDate),
				[EntryEndDate] = IIf(IsNull(@EntryEndDate,'1900-01-01') = '1900-01-01',[EntryEndDate], @EntryEndDate)
			Output 
				1 As [EntryType],
				[Inserted].[StoreUsername],
				[Inserted].[EntryKey],
				[Inserted].[EntryName],
				[Inserted].[EntryUse],
				Convert(Varchar(8000), DecryptByKey([Inserted].[Username])) As EntryUsername,
				Convert(Varchar(8000), DecryptByKey([Inserted].[Password])) As EntryPassword,
				[Inserted].[EntryStartDate],
				[Inserted].[EntryEndDate]
			Into
				@CredentialsTable
			Where 
				[EntryKey] = @EntryKey And 
				[StoreUsername] = @StoreUsername 

			Select 
				[EntryType],
				[StoreUsername],
				[EntryKey],
				[EntryName],
				[EntryUse],
				[EntryUsername],
				[EntryPassword],
				[EntryStartDate],
				[EntryEndDate]
			From 
				@CredentialsTable
		End 

	Else If @EntryType = 2
		Begin 
			Declare @ConnectionStringTable Table
			(
				[EntryType] Int,
				[StoreUsername] Varchar(55),
				[EntryKey] Varchar(255),
				[EntryName] Varchar(255),
				[EntryUse] Varchar(255),
				[EntryConnectionString] Varchar(8000),
				[EntryStartDate] Date,
				[EntryEndDate] Date
			)

			Update 
				[Store].[SecretConnectionStrings]
			Set
				[EntryName] = IIf(IsNull(@EntryName,'') = '', [EntryName],@EntryName),
				[EntryUse] = IIf(IsNull(@EntryUse,'') = '', [EntryUse], @EntryUse),
				[ConnectionString] = IIf(IsNull(@EntryConnectionString,'') = '', [ConnectionString], EncryptByKey(Key_guid('StoreKeyA'),@EntryConnectionString)),
				[EntryStartDate] = IIf(IsNull(@EntryStartDate,'1900-01-01') = '1900-01-01', [EntryStartDate], @EntryStartDate),
				[EntryEndDate] = IIf(IsNull(@EntryEndDate,'1900-01-01') = '1900-01-01',[EntryEndDate], @EntryEndDate)
			Output 
				2 As [EntryType],
				[Inserted].[StoreUsername],
				[Inserted].[EntryKey],
				[Inserted].[EntryName],
				[Inserted].[EntryUse],
				Convert(Varchar(8000), DecryptByKey([Inserted].[ConnectionString])) As EntryConnectionString,
				[Inserted].[EntryStartDate],
				[Inserted].[EntryEndDate]
			Into 
				@ConnectionStringTable
			Where 
				[EntryKey] = @EntryKey And 
				[StoreUsername] = @StoreUsername

			Select
				[StoreUsername],
				[EntryKey],
				[EntryName],
				[EntryUse],
				[EntryConnectionString],
				[EntryStartDate],
				[EntryEndDate]
			From 
				@ConnectionStringTable
		End 
	Else If @EntryType = 3
		Begin 
			Declare @TokenTable Table
			(
				[EntryType] Int,
				[StoreUsername] Varchar(55),
				[EntryKey] Varchar(255),
				[EntryName] Varchar(255),
				[EntryUse] Varchar(255),
				[EntryToken] Varchar(8000),
				[EntryStartDate] Date,
				[EntryEndDate] Date
			)

			Update 
				[Store].[SecretTokens]
			Set
				[EntryName] = IIf(IsNull(@EntryName,'') = '', [EntryName], @EntryName),
				[EntryUse] = IIf(IsNull(@EntryUse,'') = '', [EntryUse], @EntryUse),
				[Token] = IIf(IsNull(@EntryToken,'') = '', [Token], EncryptByKey(Key_guid('StoreKeyA'), @EntryToken)),
				[EntryStartDate] = IIf(IsNull(@EntryStartDate,'1900-01-01') = '1900-01-01', [EntryStartDate], @EntryStartDate),
				[EntryEndDate] = IIf(IsNull(@EntryEndDate,'1900-01-01') = '1900-01-01', [EntryEndDate], @EntryEndDate)
			Output 
				3 As [EntryType],
				[Inserted].[StoreUsername],
				[Inserted].[EntryKey],
				[Inserted].[EntryName],
				[Inserted].[EntryUse],
				Convert(Varchar(8000), DecryptByKey([Inserted].[Token])) As EntryToken,
				[Inserted].[EntryStartDate],
				[Inserted].[EntryEndDate]
			Into 
				@TokenTable
			Where 
				[EntryKey] = @EntryKey And 
				[StoreUsername] = @StoreUsername

			Select
				[StoreUsername],
				[EntryKey],
				[EntryName],
				[EntryUse],
				[EntryToken],
				[EntryStartDate],
				[EntryEndDate]
			From 
				@TokenTable 
		End 

	Else If @EntryType = 4
		Begin 
			Declare @VariableTable Table
			(
				[EntryType] Int,
				[StoreUsername] Varchar(55),
				[EntryKey] Varchar(255),
				[EntryName] Varchar(255),
				[EntryUse] Varchar(255),
				[EntryVariable] Varchar(8000),
				[EntryStartDate] Date,
				[EntryEndDate] Date
			)

			Update 
				[Store].[SecretVariables]
			Set
				[EntryName] = IIf(IsNull(@EntryName,'') = '', [EntryName], @EntryName),
				[EntryUse] = IIf(IsNull(@EntryUse,'') = '', [EntryUse], @EntryUse),
				[Variable] = IIf(IsNull(@EntryVariable,'') = '', [Variable], EncryptByKey(Key_guid('StoreKeyA'), @EntryVariable)),
				[EntryStartDate] = IIf(IsNull(@EntryStartDate,'1900-01-01') = '1900-01-01', [EntryStartDate], @EntryStartDate),
				[EntryEndDate] = IIf(IsNull(@EntryEndDate,'1900-01-01') = '1900-01-01', [EntryEndDate], @EntryEndDate)
			Output 
				4 As [EntryType],
				[Inserted].[StoreUsername],
				[Inserted].[EntryKey],
				[Inserted].[EntryName],
				[Inserted].[EntryUse],
				Convert(Varchar(8000), DecryptByKey([Inserted].[Variable])) As EntryVariable,
				[Inserted].[EntryStartDate],
				[Inserted].[EntryEndDate]
			Into
				@VariableTable
			Where 
				[EntryKey] = @EntryKey And 
				[StoreUsername] = @StoreUsername

			Select
				[StoreUsername],
				[EntryKey],
				[EntryName],
				[EntryUse],
				[EntryVariable],
				[EntryStartDate],
				[EntryEndDate]
			From 
				@VariableTable
		End

Return
