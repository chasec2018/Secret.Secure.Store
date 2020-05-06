using System.Text.Json;
using Microsoft.AspNetCore.Http;

namespace SecureStoreService.Models
{
    public class RecordUpdated<TResults> : IGenericReturnModel
    {
        public RecordUpdated(TResults results, HttpContext Context)
        {
            ResponseCode = 2006;
            ResponseType = "Success";
            ResponseMessage = "Entry was updated successfully. Please see Results";
            Results = results;
        }

        public int ResponseCode { get; set; }
        public string ResponseType { get; set; }
        public string ResponseMessage { get; set; }
        public TResults Results { get; set; }
        public override string ToString() => JsonSerializer.Serialize<RecordUpdated<TResults>>(this);
    }
}
