Create Procedure [Store].[ReturnAccessKey]
	@AccessKey Varchar(Max)
As

		Exec [Store].[OpenStoreSymmetricKey]

		Select
			Convert(Varchar(900), DecryptByKey([StoreAccessKey])) As AccessKey,
			[StoreUsername],
			[FirstName],
			[LastName],
			[MiddleName],
			[AccessStartDate],
			[AccessEndDate]
		From 
			[Store].[AccessKeys]
		Where 
			Convert(Varchar(900), DecryptByKey([StoreAccessKey])) = @AccessKey

Return
