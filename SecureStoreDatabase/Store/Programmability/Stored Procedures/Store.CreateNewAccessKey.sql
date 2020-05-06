Create Procedure [Store].[CreateNewAccessKey]
	@FirstName Varchar(55),
	@LastName Varchar(55),
	@MiddleName Varchar(55) = Null,
	@StoreUsername Varchar(55),
	@AccessStartDate  Date = Null,
	@AccessEndDate Date = Null
As
Begin

	-- Open Symmetric Key
	Exec [Store].[OpenStoreSymmetricKey]

	
	Declare @AccessKeyEntry Table
	(
		[StoreAccessKey] Varbinary(900),
		[StoreUsername] Varchar(55),
		[FirstName] Varchar(55),
		[LastName] Varchar(55),
		[MiddleName] Varchar(55),
		[AccessStartDate] Date,
		[AccessEndDate] Date
	)

	Insert Into [Store].[AccessKeys]
		(
			[StoreAccessKey],
			[StoreUsername],
			[FirstName],
			[LastName],
			[MiddleName],
			[AccessStartDate],
			[AccessEndDate]
		)
	Output
		[Inserted].[StoreAccessKey],
		[Inserted].[StoreUsername],
		[Inserted].[FirstName],
		[Inserted].[LastName],
		[Inserted].[MiddleName],
		[Inserted].[AccessStartDate],
		[Inserted].[AccessEndDate]
	Into 
		@AccessKeyEntry
	Values 
	(
		EncryptByKey(Key_Guid('StoreKeyA'), Convert(Varchar(255),NewID())),
		@StoreUsername,
		@FirstName,
		@LastName,
		IsNull(@MiddleName, 'NA'),
		IsNull(@AccessStartDate, GetDate()),
		IsNull(@AccessEndDate, DateAdd(yy,50,GetDate()))
	)

	Select 
		Convert(Varchar(900), DecryptByKey([StoreAccessKey])) As StoreeAccessKey,
		[StoreUsername],
		[FirstName],
		[LastName],
		[MiddleName],
		[AccessStartDate],
		[AccessEndDate]
	From 
		@AccessKeyEntry

End
Return
