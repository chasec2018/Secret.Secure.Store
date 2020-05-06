namespace SecureStoreService.Models
{
    public interface IGenericReturnModel
    {
        int ResponseCode { get; set; }
        string ResponseType { get; set; }
        string ResponseMessage { get; set; }
        string ToString();
    }
}
