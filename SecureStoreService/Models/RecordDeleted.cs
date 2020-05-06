using Microsoft.AspNetCore.Http;
using System.Text.Json;


namespace SecureStoreService.Models
{
    public class RecordDeleted<TResults> : IGenericReturnModel
    {
        public RecordDeleted(TResults results, HttpContext Context)
        {
            ResponseCode = 2001;
            ResponseType = "Success";
            ResponseMessage = "Entry was deleted successfully";
            Results = results;
        }

        public int ResponseCode { get; set; }
        public string ResponseType { get; set; }
        public string ResponseMessage { get; set; }
        public TResults Results { get; set; }
        public override string ToString() => JsonSerializer.Serialize<RecordDeleted<TResults>>(this);

    }
}
