Create Procedure [Store].[ReturnAllUserSecrets]
	@StoreUsername Varchar(255)
As

		Exec [Store].[OpenStoreSymmetricKey]

		Select	
			StoreUsername,
			EntryKey,
			EntryType,
			EntryName,
			EntryUse,
			EntryUsername,
			EntryPassword,
			EntryConnectionString,
			EntryToken,
			EntryVariable,
			EntryStartDate,
			EntryEndDate
		From
			(
					Select 
						1 As EntryType,
						[StoreUsername], 
						[EntryKey],
						[EntryName],
						[EntryUse],
						Convert(Varchar(Max), DecryptByKey([Username])) As EntryUsername,
						Convert(Varchar(Max), DecryptByKey([Password])) As EntryPassword,
						Null As EntryConnectionString,
						Null As EntryToken,
						Null As EntryVariable,
						[EntryStartDate],
						[EntryEndDate]
					From 
						[Store].[SecretCredentials]

				Union All

					Select 
						2 As EntryType,
						[StoreUsername], 
						[EntryKey],
						[EntryName],
						[EntryUse],
						Null As EntryUsername,
						Null As EntryPassword,
						Convert(Varchar(Max), DecryptByKey([ConnectionString])) As EntryConnectionString,
						Null As EntryToken,
						Null As EntryVariable,
						[EntryStartDate],
						[EntryEndDate]
					From 
						[Store].[SecretConnectionStrings]
		

				Union All

					Select 
						3 As EntryType,
						[StoreUsername], 
						[EntryKey],
						[EntryName],
						[EntryUse],
						Null As EntryUsername,
						Null As EntryPassword,
						Null As EntryConnectionString,
						Convert(Varchar(Max), DecryptByKey([Token])) As EntryToken,
						Null As EntryVariable,
						[EntryStartDate],
						[EntryEndDate]
					From 
						[Store].[SecretTokens]

				Union All

					Select 
						4 As EntryType,
						[StoreUsername], 
						[EntryKey],
						[EntryName],
						[EntryUse],
						Null As EntryUsername,
						Null As EntryPassword,
						Null As EntryConnectionString,
						Null As EntryToken,
						Convert(Varchar(Max), DecryptByKey([Variable])) As EntryVariable,
						[EntryStartDate],
						[EntryEndDate]
					From 
						[Store].[SecretVariables]
		
		
			) As StoreSecrests
		Where 
			[StoreUsername] = @StoreUsername
		Order By
			[EntryType] Desc

Return
