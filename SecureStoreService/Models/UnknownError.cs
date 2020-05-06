using System.Text.Json;

namespace SecureStoreService.Models
{
    public class UnknownError : IGenericReturnModel
    {
        public UnknownError(string Exception)
        {
            ResponseCode = 5006;
            ResponseType = "Error";
            ResponseMessage = "An unknown Exception occurred while processing your request";
            ExceptionMessage = Exception;
        }

        public int ResponseCode { get; set; }
        public string ResponseType { get; set; }
        public string ResponseMessage { get; set; }
        public string ExceptionMessage { get; set; }
        public override string ToString() => JsonSerializer.Serialize<UnknownError>(this);
    }
}
