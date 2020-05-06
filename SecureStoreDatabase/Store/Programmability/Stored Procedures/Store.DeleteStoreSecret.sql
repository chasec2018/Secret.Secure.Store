Create Procedure Store.DeleteStoreSecret
	@StoreUsername Varchar(255),
	@EntryKey Varchar(255),
	@EntryType int
As
	
	Exec [Store].[OpenStoreSymmetricKey]


	If @EntryType = 1
		Begin 
			-- Create Variable table to store Temporary Results
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

			-- Delete Actual Results
			Delete From 
				[Store].[SecretCredentials]
			Output
				1 As [EntryType],
				[Deleted].[StoreUsername],
				[Deleted].[EntryKey],
				[Deleted].[EntryName],
				[Deleted].[EntryUse],
				Convert(Varchar(8000), DecryptByKey([Deleted].[Username])) As [EntryUsername],
				Convert(Varchar(8000), DecryptByKey([Deleted].[Password])) As [EntryPassword],
				[Deleted].[EntryStartDate],
				[Deleted].[EntryEndDate]
			Into @CredentialsTable
			Where 
				[EntryKey] = @EntryKey And
				[StoreUsername] = @StoreUsername
			
			-- Return Deletion Results
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
		-- Create Variable table to store Temporary Results
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

			-- Delete Actual Results
			Delete From 
				[Store].[SecretConnectionStrings]				
			Output 
				2 As [EntryType],
				[Deleted].[StoreUsername],
				[Deleted].[EntryKey],
				[Deleted].[EntryName],
				[Deleted].[EntryUse],
				Convert(Varchar(8000), DecryptByKey([Deleted].[ConnectionString])) As [EntryConnectionString],
				[Deleted].[EntryStartDate],
				[Deleted].[EntryEndDate]
			Into @ConnectionStringTable
					
			Where 
				[EntryKey] = @EntryKey And
				[StoreUsername] = @StoreUsername

			-- Return Deletion Results
			Select 
				[EntryType],
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
			-- Create Variable table to store Temporary Results
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

			-- Delete Actual Results
			Delete From 
				[Store].[SecretTokens]
			Output 
				3 As [EntryType],
				[Deleted].[StoreUsername],
				[Deleted].[EntryKey],
				[Deleted].[EntryName],
				[Deleted].[EntryUse],
				Convert(Varchar(8000), DecryptByKey([Deleted].[Token])) As [EntryToken],
				[Deleted].[EntryStartDate],
				[Deleted].[EntryEndDate]
			Into 
				@TokenTable
			Where 
				[EntryKey] = @EntryKey And
				[StoreUsername] = @StoreUsername
				
			-- Return Deletion Results
			Select 
				[EntryType],
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
			-- Create Variable table to store Temporary Results
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

			-- Delete Actual Entry
			Delete From 
				[Store].[SecretVariables]
			Output 
				4 As [EntryType],
				[Deleted].[StoreUsername],
				[Deleted].[EntryKey],
				[Deleted].[EntryName],
				[Deleted].[EntryUse],
				Convert(Varchar(8000), DecryptByKey([Deleted].[Variable])) As [EntryVariable],
				[Deleted].[EntryStartDate],
				[Deleted].[EntryEndDate]
			Into
				@VariableTable
			Where 
				[EntryKey] = @EntryKey And
				[StoreUsername] = @StoreUsername

			Select 
				[EntryType],
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
