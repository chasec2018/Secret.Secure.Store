Create Procedure [Store].[CreateStoreSecret]
	@StoreUsername varchar(255),
	@EntryType int,
	@EntryName Varchar(255),
	@EntryUse Varchar(255),
	@EntryUsername Varchar(8000) = Null,
	@EntryPassword Varchar(8000) = Null,
	@EntryConnectionString Varchar(8000) = Null,
	@EntryToken Varchar(8000) = Null,
	@EntryVariable Varchar(8000) = Null,
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

			Insert Into [Store].[SecretCredentials]
				(
					[StoreUsername],
					[EntryName],
					[EntryUse],
					[Username],
					[Password],
					[EntryStartDate],
					[EntryEndDate]
				)
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
			Values
				(
					@StoreUsername,
					@EntryName,
					@EntryUse,
					EncryptByKey(Key_guid('StoreKeyA'),@EntryUsername),
					EncryptByKey(Key_guid('StoreKeyA'),@EntryPassword),
					IsNull(@EntryStartDate, GetDate()),
					IsNull(@EntryEndDate,DateAdd(yy,50,GetDate()))
				)

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

			Insert Into [Store].[SecretConnectionStrings]
				(
					[StoreUsername],
					[EntryName],
					[EntryUse],
					[ConnectionString],
					[EntryStartDate],
					[EntryEndDate]
				)
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
			Values
				(
					@StoreUsername,
					@EntryName,
					@EntryUse,
					EncryptByKey(Key_Guid('StoreKeyA'),@EntryConnectionString),
					IsNull(@EntryStartDate, GetDate()),
					IsNull(@EntryEndDate,DateAdd(yy,50,GetDate()))
				)

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

			Insert Into [Store].[SecretTokens]
				(
					[StoreUsername],
					[EntryName],
					[EntryUse],
					[Token],
					[EntryStartDate],
					[EntryEndDate]
				)
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
			Values
				(
					@StoreUsername,
					@EntryName,
					@EntryUse,
					EncryptByKey(Key_Guid('StoreKeyA'),@EntryToken),
					IsNull(@EntryStartDate, GetDate()),
					IsNull(@EntryEndDate,DateAdd(yy,50,GetDate()))
				)
	
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

			Insert Into [Store].[SecretVariables]
				(
					[StoreUsername],
					[EntryName],
					[EntryUse],
					[Variable],
					[EntryStartDate],
					[EntryEndDate]

				)
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
			Values
				(
					@StoreUsername,
					@EntryName,
					@EntryUse,
					ENCRYPTBYKEY(KEY_GUID('StoreKeyA'),@EntryVariable),
					IsNull(@EntryStartDate, GetDate()),
					IsNull(@EntryEndDate,DateAdd(yy,50,GetDate()))
				)

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
