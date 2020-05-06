﻿/*
Deployment script for SecureStore

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar KeyPassPhrase "SamplePassphrase123#"
:setvar DatabaseName "SecureStore"
:setvar DefaultFilePrefix "SecureStore"
:setvar DefaultDataPath "C:\Users\chase\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\ASSIMALIGN.LOCDEV\"
:setvar DefaultLogPath "C:\Users\chase\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\ASSIMALIGN.LOCDEV\"

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET QUERY_STORE (CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 367)) 
            WITH ROLLBACK IMMEDIATE;
    END


GO
PRINT N'Creating [Store]...';


GO
CREATE SCHEMA [Store]
    AUTHORIZATION [dbo];


GO
PRINT N'Creating [StoreKeyA]...';


GO
CREATE SYMMETRIC KEY [StoreKeyA]
    AUTHORIZATION [dbo]
    WITH ALGORITHM = AES_256
    ENCRYPTION BY PASSWORD = N'$(KeyPassPhrase)';


GO
PRINT N'Creating [Store].[SecretVariables]...';


GO
CREATE TABLE [Store].[SecretVariables] (
    [StoreUsername]  VARCHAR (55)     NOT NULL,
    [EntryKey]       VARCHAR (255)    NOT NULL,
    [EntryName]      VARCHAR (255)    NOT NULL,
    [EntryUse]       VARCHAR (255)    NOT NULL,
    [Variable]       VARBINARY (8000) NOT NULL,
    [EntryStartDate] DATE             NOT NULL,
    [EntryEndDate]   DATE             NOT NULL,
    [CreationDate]   DATE             NOT NULL,
    [CreationTime]   TIME (6)         NOT NULL,
    CONSTRAINT [PrimaryKeyVariableKey] PRIMARY KEY CLUSTERED ([EntryKey] ASC),
    CONSTRAINT [UniqueUserVariablesName] UNIQUE NONCLUSTERED ([StoreUsername] ASC, [EntryName] ASC)
);


GO
PRINT N'Creating [Store].[SecretTokens]...';


GO
CREATE TABLE [Store].[SecretTokens] (
    [StoreUsername]  VARCHAR (55)     NOT NULL,
    [EntryKey]       VARCHAR (255)    NOT NULL,
    [EntryName]      VARCHAR (255)    NOT NULL,
    [EntryUse]       VARCHAR (255)    NOT NULL,
    [Token]          VARBINARY (8000) NOT NULL,
    [EntryStartDate] DATE             NOT NULL,
    [EntryEndDate]   DATE             NOT NULL,
    [CreationDate]   DATE             NOT NULL,
    [CreationTime]   TIME (6)         NOT NULL,
    CONSTRAINT [PrimaryKeyTokenKey] PRIMARY KEY CLUSTERED ([EntryKey] ASC),
    CONSTRAINT [UniqueUserTokensName] UNIQUE NONCLUSTERED ([StoreUsername] ASC, [EntryName] ASC)
);


GO
PRINT N'Creating [Store].[SecretCredentials]...';


GO
CREATE TABLE [Store].[SecretCredentials] (
    [StoreUsername]  VARCHAR (55)     NOT NULL,
    [EntryKey]       VARCHAR (255)    NOT NULL,
    [EntryName]      VARCHAR (255)    NOT NULL,
    [EntryUse]       VARCHAR (255)    NOT NULL,
    [Username]       VARBINARY (8000) NOT NULL,
    [Password]       VARBINARY (8000) NOT NULL,
    [EntryStartDate] DATE             NOT NULL,
    [EntryEndDate]   DATE             NOT NULL,
    [CreationDate]   DATE             NOT NULL,
    [CreationTime]   TIME (6)         NOT NULL,
    CONSTRAINT [PrimaryKeyCredentialsKey] PRIMARY KEY CLUSTERED ([EntryKey] ASC),
    CONSTRAINT [UniqueUserCredentialsName] UNIQUE NONCLUSTERED ([StoreUsername] ASC, [EntryName] ASC)
);


GO
PRINT N'Creating [Store].[SecretConnectionStrings]...';


GO
CREATE TABLE [Store].[SecretConnectionStrings] (
    [StoreUsername]    VARCHAR (55)     NOT NULL,
    [EntryKey]         VARCHAR (255)    NOT NULL,
    [EntryName]        VARCHAR (255)    NOT NULL,
    [EntryUse]         VARCHAR (255)    NOT NULL,
    [ConnectionString] VARBINARY (8000) NOT NULL,
    [EntryStartDate]   DATE             NOT NULL,
    [EntryEndDate]     DATE             NOT NULL,
    [CreationDate]     DATE             NOT NULL,
    [CreationTime]     TIME (6)         NOT NULL,
    CONSTRAINT [PrimaryKeyConnectionStringKey] PRIMARY KEY CLUSTERED ([EntryKey] ASC),
    CONSTRAINT [UniqueUserConnectionStringName] UNIQUE NONCLUSTERED ([StoreUsername] ASC, [EntryName] ASC)
);


GO
PRINT N'Creating [Store].[SecretClientRequestLog]...';


GO
CREATE TABLE [Store].[SecretClientRequestLog] (
    [RequestID]     BIGINT        IDENTITY (1000, 1) NOT NULL,
    [RequestDate]   DATE          NOT NULL,
    [RequestTime]   TIME (6)      NOT NULL,
    [Requester]     VARCHAR (55)  NOT NULL,
    [RequestMethod] VARCHAR (25)  NOT NULL,
    [RequestHeader] VARCHAR (MAX) NOT NULL,
    [RequestQuery]  VARCHAR (MAX) NOT NULL,
    CONSTRAINT [PrimaryKeyRequest] PRIMARY KEY CLUSTERED ([RequestID] ASC, [RequestDate] ASC, [RequestTime] ASC, [Requester] ASC, [RequestMethod] ASC)
);


GO
PRINT N'Creating [Store].[AccessKeys]...';


GO
CREATE TABLE [Store].[AccessKeys] (
    [StoreAccessKey]  VARBINARY (900) NOT NULL,
    [StoreUsername]   VARCHAR (55)    NOT NULL,
    [FirstName]       VARCHAR (55)    NULL,
    [LastName]        VARCHAR (55)    NULL,
    [MiddleName]      VARCHAR (55)    NULL,
    [AccessStartDate] DATE            NOT NULL,
    [AccessEndDate]   DATE            NOT NULL,
    [CreationDate]    DATE            NOT NULL,
    [CreationTime]    TIME (6)        NOT NULL,
    CONSTRAINT [PrimaryKeyStoreUsername] PRIMARY KEY CLUSTERED ([StoreUsername] ASC),
    CONSTRAINT [UniqueAccessKeyConstraint] UNIQUE NONCLUSTERED ([StoreAccessKey] ASC)
);


GO
PRINT N'Creating unnamed constraint on [Store].[SecretVariables]...';


GO
ALTER TABLE [Store].[SecretVariables]
    ADD DEFAULT GetDate() FOR [EntryStartDate];


GO
PRINT N'Creating unnamed constraint on [Store].[SecretVariables]...';


GO
ALTER TABLE [Store].[SecretVariables]
    ADD DEFAULT DateAdd(yy,50,GetDate()) FOR [EntryEndDate];


GO
PRINT N'Creating unnamed constraint on [Store].[SecretVariables]...';


GO
ALTER TABLE [Store].[SecretVariables]
    ADD DEFAULT GetDate() FOR [CreationDate];


GO
PRINT N'Creating unnamed constraint on [Store].[SecretVariables]...';


GO
ALTER TABLE [Store].[SecretVariables]
    ADD DEFAULT Convert(Time(6),GetDate()) FOR [CreationTime];


GO
PRINT N'Creating unnamed constraint on [Store].[SecretTokens]...';


GO
ALTER TABLE [Store].[SecretTokens]
    ADD DEFAULT GetDate() FOR [EntryStartDate];


GO
PRINT N'Creating unnamed constraint on [Store].[SecretTokens]...';


GO
ALTER TABLE [Store].[SecretTokens]
    ADD DEFAULT DateAdd(yy,50,GetDate()) FOR [EntryEndDate];


GO
PRINT N'Creating unnamed constraint on [Store].[SecretTokens]...';


GO
ALTER TABLE [Store].[SecretTokens]
    ADD DEFAULT GetDate() FOR [CreationDate];


GO
PRINT N'Creating unnamed constraint on [Store].[SecretTokens]...';


GO
ALTER TABLE [Store].[SecretTokens]
    ADD DEFAULT Convert(Time(6),GetDate()) FOR [CreationTime];


GO
PRINT N'Creating unnamed constraint on [Store].[SecretCredentials]...';


GO
ALTER TABLE [Store].[SecretCredentials]
    ADD DEFAULT GetDate() FOR [EntryStartDate];


GO
PRINT N'Creating unnamed constraint on [Store].[SecretCredentials]...';


GO
ALTER TABLE [Store].[SecretCredentials]
    ADD DEFAULT DateAdd(yy,50,GetDate()) FOR [EntryEndDate];


GO
PRINT N'Creating unnamed constraint on [Store].[SecretCredentials]...';


GO
ALTER TABLE [Store].[SecretCredentials]
    ADD DEFAULT GetDate() FOR [CreationDate];


GO
PRINT N'Creating unnamed constraint on [Store].[SecretCredentials]...';


GO
ALTER TABLE [Store].[SecretCredentials]
    ADD DEFAULT Convert(Time(6),Current_TimeStamp) FOR [CreationTime];


GO
PRINT N'Creating unnamed constraint on [Store].[SecretConnectionStrings]...';


GO
ALTER TABLE [Store].[SecretConnectionStrings]
    ADD DEFAULT GetDate() FOR [EntryStartDate];


GO
PRINT N'Creating unnamed constraint on [Store].[SecretConnectionStrings]...';


GO
ALTER TABLE [Store].[SecretConnectionStrings]
    ADD DEFAULT DateAdd(yy,50,GetDate()) FOR [EntryEndDate];


GO
PRINT N'Creating unnamed constraint on [Store].[SecretConnectionStrings]...';


GO
ALTER TABLE [Store].[SecretConnectionStrings]
    ADD DEFAULT GetDate() FOR [CreationDate];


GO
PRINT N'Creating unnamed constraint on [Store].[SecretConnectionStrings]...';


GO
ALTER TABLE [Store].[SecretConnectionStrings]
    ADD DEFAULT Convert(Time(6),GetDate()) FOR [CreationTime];


GO
PRINT N'Creating unnamed constraint on [Store].[SecretClientRequestLog]...';


GO
ALTER TABLE [Store].[SecretClientRequestLog]
    ADD DEFAULT GetDate() FOR [RequestDate];


GO
PRINT N'Creating unnamed constraint on [Store].[SecretClientRequestLog]...';


GO
ALTER TABLE [Store].[SecretClientRequestLog]
    ADD DEFAULT Convert(Time(6), Current_TimeStamp) FOR [RequestTime];


GO
PRINT N'Creating unnamed constraint on [Store].[AccessKeys]...';


GO
ALTER TABLE [Store].[AccessKeys]
    ADD DEFAULT GetDate() FOR [AccessStartDate];


GO
PRINT N'Creating unnamed constraint on [Store].[AccessKeys]...';


GO
ALTER TABLE [Store].[AccessKeys]
    ADD DEFAULT DateAdd(yy,50,GetDate()) FOR [AccessEndDate];


GO
PRINT N'Creating unnamed constraint on [Store].[AccessKeys]...';


GO
ALTER TABLE [Store].[AccessKeys]
    ADD DEFAULT GetDate() FOR [CreationDate];


GO
PRINT N'Creating unnamed constraint on [Store].[AccessKeys]...';


GO
ALTER TABLE [Store].[AccessKeys]
    ADD DEFAULT Convert(Time(6),Current_TimeStamp) FOR [CreationTime];


GO
PRINT N'Creating [Store].[ForeignKeyUsernameAD]...';


GO
ALTER TABLE [Store].[SecretVariables] WITH NOCHECK
    ADD CONSTRAINT [ForeignKeyUsernameAD] FOREIGN KEY ([StoreUsername]) REFERENCES [Store].[AccessKeys] ([StoreUsername]) ON DELETE CASCADE ON UPDATE CASCADE;


GO
PRINT N'Creating [Store].[ForeignKeyUsernameA]...';


GO
ALTER TABLE [Store].[SecretTokens] WITH NOCHECK
    ADD CONSTRAINT [ForeignKeyUsernameA] FOREIGN KEY ([StoreUsername]) REFERENCES [Store].[AccessKeys] ([StoreUsername]) ON DELETE CASCADE ON UPDATE CASCADE;


GO
PRINT N'Creating [Store].[ForeignKeyUsernameAA]...';


GO
ALTER TABLE [Store].[SecretCredentials] WITH NOCHECK
    ADD CONSTRAINT [ForeignKeyUsernameAA] FOREIGN KEY ([StoreUsername]) REFERENCES [Store].[AccessKeys] ([StoreUsername]) ON DELETE CASCADE ON UPDATE CASCADE;


GO
PRINT N'Creating [Store].[ForeignKeyUsernameAB]...';


GO
ALTER TABLE [Store].[SecretConnectionStrings] WITH NOCHECK
    ADD CONSTRAINT [ForeignKeyUsernameAB] FOREIGN KEY ([StoreUsername]) REFERENCES [Store].[AccessKeys] ([StoreUsername]) ON DELETE CASCADE ON UPDATE CASCADE;


GO
PRINT N'Creating [Store].[CheckRequestType]...';


GO
ALTER TABLE [Store].[SecretClientRequestLog] WITH NOCHECK
    ADD CONSTRAINT [CheckRequestType] CHECK ([RequestMethod]='GET' Or [RequestMethod] = 'POST' Or [RequestMethod] = 'PUT' Or [RequestMethod] = 'DELETE');


GO
PRINT N'Creating [Store].[EntireStoreSecretSet]...';


GO
Create View Store.EntireStoreSecretSet
As
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
GO
PRINT N'Creating [Store].[StoreKey]...';


GO
Create Function [Store].[StoreKey]()
Returns Varchar(255)
As
Begin

	Declare @year Varchar(5);
	Declare @monthday Varchar(10);
	Declare @timestamp Varchar(10)

		Set @year = concat('y',format(getdate(), 'yy'))
		Set @monthday = concat('m',format(getdate(),'mm'),'d',Format(getdate(),'dd'))
		Set @timestamp = format(current_timestamp,'hhmmss')

	Return Upper(Concat(@year, '-',@monthday, '-',@timestamp))
End
GO
PRINT N'Creating unnamed constraint on [Store].[SecretVariables]...';


GO
ALTER TABLE [Store].[SecretVariables]
    ADD DEFAULT [Store].[StoreKey]() FOR [EntryKey];


GO
PRINT N'Creating unnamed constraint on [Store].[SecretTokens]...';


GO
ALTER TABLE [Store].[SecretTokens]
    ADD DEFAULT [Store].[StoreKey]() FOR [EntryKey];


GO
PRINT N'Creating unnamed constraint on [Store].[SecretCredentials]...';


GO
ALTER TABLE [Store].[SecretCredentials]
    ADD DEFAULT [Store].[StoreKey]() FOR [EntryKey];


GO
PRINT N'Creating unnamed constraint on [Store].[SecretConnectionStrings]...';


GO
ALTER TABLE [Store].[SecretConnectionStrings]
    ADD DEFAULT [Store].[StoreKey]() FOR [EntryKey];


GO
PRINT N'Creating [Store].[OpenStoreSymmetricKey]...';


GO
Create Procedure [Store].[OpenStoreSymmetricKey]
AS
	Open Symmetric Key StoreKeyA
	Decryption By Password = '$(KeyPassPhrase)'

Return 0
GO
PRINT N'Creating [Store].[ReturnErrorInformation]...';


GO
Create Procedure Store.ReturnErrorInformation  
As
Select  
    'Error' As ErrorResponse
    ,Error_Number() AS ErrorNumber  
    ,Error_Severity() AS ErrorSeverity  
    ,Error_State() AS ErrorState  
    ,Error_Procedure() AS ErrorProcedure  
    ,Error_Line() AS ErrorLine  
    ,Error_Message() AS ErrorMessage;
GO
PRINT N'Creating [Store].[ChangeSymmetricKeyPassphrase]...';


GO
Create Procedure [Store].[ChangeSymmetricKeyPassphrase]
	@OldPassphrase Varchar(255),
	@NewPassphrase Varchar(255)
As
Begin

	Declare @step_one Varchar(Max)
	Declare @step_two Varchar(Max)
	Declare @step_thr Varchar(max)

	Exec [Store].[OpenStoreSymmetricKey]

	Set @step_one =	'Alter Symmetric Key StoreKeyA
					 Add Encryption By Password = ''' + @NewPassphrase + ''''

	Set @step_two = 'Alter Symmetric Key StoreKeyA
					 Drop Encryption By Password = ''' + @OldPassphrase + ''''

	Set @step_thr = 'Alter Procedure [Store].[OpenStoreSymmetricKey]
					 As
						Open Symmetric Key StoreKeyA
						Decryption By Password = ''' + @NewPassphrase + '''
					Return 0'

	Exec (@step_one)
	Exec (@step_two)
	Exec (@step_thr)

End
Return 0
GO
PRINT N'Creating [Store].[CreateNewAccessKey]...';


GO
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
GO
PRINT N'Creating [Store].[DeleteStoreSecret]...';


GO
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
GO
PRINT N'Creating [Store].[UpdateStoreSecret]...';


GO
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
				@VariableTable
		End

Return
GO
PRINT N'Creating [Store].[ReturnStoreSecret]...';


GO
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
GO
PRINT N'Creating [Store].[ReturnAllUserSecrets]...';


GO
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
GO
PRINT N'Creating [Store].[ReturnAccessKey]...';


GO
Create Procedure [Store].[ReturnAccessKey]
	@AccessKey Varchar(Max)
As

		Exec [Store].[OpenStoreSymmetricKey]

		Select
			DecryptByKey([StoreAccessKey]) As AccessKey,
			[StoreUsername],
			[FirstName],
			[LastName],
			[MiddleName],
			[AccessStartDate],
			[AccessEndDate]
		From 
			[Store].[AccessKeys]
		Where 
			[StoreAccessKey] = @AccessKey

Return
GO
PRINT N'Creating [Store].[CreateStoreSecret]...';


GO
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
				@TokenTable
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
GO
PRINT N'Creating [Store].[CreateNewLogEntry]...';


GO
Create Procedure [Store].[CreateNewLogEntry]
	@RequestMethod Varchar(25),
	@Requester Varchar(55),
	@RequestHeader Varchar(Max),
	@RequestQuery Varchar(Max)
As
	
	Begin Try
		Insert Into [Store].[SecretClientRequestLog]
			(
				[RequestDate],
				[RequestTime],
				[Requester],
				[RequestMethod],
				[RequestHeader],
				[RequestQuery]
			)
		Values
			(
				GetDate(),
				Convert(Time(6),Current_Timestamp),
				@Requester,
				@RequestMethod,
				@RequestHeader,
				@RequestQuery
			)
	End Try

	Begin Catch 
		Execute [Store].[ReturnErrorInformation];
	End Catch

Return 0
GO
PRINT N'Checking existing data against newly created constraints';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [Store].[SecretVariables] WITH CHECK CHECK CONSTRAINT [ForeignKeyUsernameAD];

ALTER TABLE [Store].[SecretTokens] WITH CHECK CHECK CONSTRAINT [ForeignKeyUsernameA];

ALTER TABLE [Store].[SecretCredentials] WITH CHECK CHECK CONSTRAINT [ForeignKeyUsernameAA];

ALTER TABLE [Store].[SecretConnectionStrings] WITH CHECK CHECK CONSTRAINT [ForeignKeyUsernameAB];

ALTER TABLE [Store].[SecretClientRequestLog] WITH CHECK CHECK CONSTRAINT [CheckRequestType];


GO
PRINT N'Update complete.';


GO
