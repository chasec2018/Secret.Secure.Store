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
