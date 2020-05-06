using System.Text.Json;
using Microsoft.AspNetCore.Http;

namespace SecureStoreService.Models
{
    public class RecordFound<TResults> : IGenericReturnModel
    {
        public RecordFound(TResults results, HttpContext Context)
        {
            ResponseCode = 2001;
            ResponseType = "Success";
            ResponseMessage = "Entry was found successfully ";
            Results = results;
        }

        public int ResponseCode { get; set; }
        public string ResponseType { get; set; }
        public string ResponseMessage { get; set; }
        public TResults Results { get; set; }
        public override string ToString() => JsonSerializer.Serialize<RecordFound<TResults>>(this);
    }
}
