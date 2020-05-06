Create Procedure [Store].[OpenStoreSymmetricKey]
AS
	Open Symmetric Key StoreKeyA
	Decryption By Password = '$(KeyPassPhrase)'

Return 0
