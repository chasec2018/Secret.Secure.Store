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
