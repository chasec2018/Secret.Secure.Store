Create Procedure [Store].[ReturnStoreSecret]
	@StoreUsername Varchar(255),
	@EntryKey Varchar(255),
	@EntryType Int
As

		Exec [Store].[OpenStoreSymmetricKey]

		If @EntryType = 1
			Begin 
				Select 
					1 As EntryType,
					[StoreUsername], 
					[EntryKey],
					[EntryName],
					[EntryUse],
					Convert(Varchar(Max), DecryptByKey([Username])) As EntryUsername,
					Convert(Varchar(Max), DecryptByKey([Password])) As EntryPassword,
					[EntryStartDate],
					[EntryEndDate]
				From 
					[Store].[SecretCredentials]
				Where 
					[StoreUsername] = @StoreUsername And 
					[EntryKey] = @EntryKey
			End

		Else If @EntryType = 2
			Begin
				Select 
					2 As EntryType,
					[StoreUsername],
					[EntryKey],
					[EntryName],
					[EntryUse],
					Convert(Varchar(Max), DecryptByKey([ConnectionString])) As EntryConnectionString,
					[EntryStartDate],
					[EntryEndDate]
				From 
					[Store].[SecretConnectionStrings]
				Where 
					[StoreUsername] = @StoreUsername And 
					[EntryKey] = @EntryKey
			End

		Else If @EntryType = 3
			Begin 
				Select 
					3 As EntryType,
					[StoreUsername],
					[EntryKey],
					[EntryName],
					[EntryUse],
					Convert(Varchar(Max), DecryptByKey(Token)) As EntryToken,
					[EntryStartDate],
					[EntryEndDate]
				From 
					[Store].[SecretTokens]
				Where 
					[StoreUsername] = @StoreUsername And 
					[EntryKey] = @EntryKey
			End
		Else If @EntryType = 4
			Begin 
				Select 
					4 As EntryType,
					[StoreUsername],
					[EntryKey],
					[EntryName],
					[EntryUse],
					Convert(Varchar(Max), DecryptByKey(Variable)) As EntryVariable,
					[EntryStartDate],
					[EntryEndDate]
				From 
					[Store].[SecretVariables]
				Where 
					[StoreUsername] = @StoreUsername And 
					[EntryKey] = @EntryKey
			End 
	
Return
