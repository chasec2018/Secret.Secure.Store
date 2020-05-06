using System.Text.Json;
using Microsoft.AspNetCore.Http;

namespace SecureStoreService.Models
{
    public class RecordsNotFound : IGenericReturnModel
    {
        public RecordsNotFound(HttpContext context)
        {
            ResponseCode = 5003;
            ResponseType = "Error";
            ResponseMessage = "No Record was found for the given Entry Key";

            if (context.Request.Query.TryGetValue("EntryKey", out var entry))
                EntryRequested = entry;

            if (context.Request.Query.TryGetValue("StoreUsername", out var user))
                RequestedBy = user;
        }


        public int ResponseCode { get; set; }
        public string ResponseType { get; set; }
        public string ResponseMessage { get; set; }
        public string RequestedBy { get; set; }
        public string EntryRequested { get; set; }
        public override string ToString() => JsonSerializer.Serialize<RecordsNotFound>(this);
    }
}
