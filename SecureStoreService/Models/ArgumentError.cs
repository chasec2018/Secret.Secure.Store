
using System.Text.Json;

namespace SecureStoreService.Models
{
    public class ArgumentError : IGenericReturnModel
    {
        public ArgumentError()
        {
            ResponseCode = 5001;
            ResponseType = "Error";
            ResponseMessage = "Invalid arguments where applied";
        }

        public int ResponseCode { get; set; }
        public string ResponseType { get; set; }
        public string ResponseMessage { get; set; }
        public override string ToString() => JsonSerializer.Serialize<ArgumentError>(this);
    }
}
