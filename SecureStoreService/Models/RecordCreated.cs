using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.Json;
using System.Threading.Tasks;

namespace SecureStoreService.Models
{
    public class RecordCreated<TResults> : IGenericReturnModel
    {
        public RecordCreated(TResults results, HttpContext Context)
        {
            ResponseCode = 2001;
            ResponseType = "Success";
            ResponseMessage = "The Entry was created successfully";
            Results = results;
        }

        public int ResponseCode { get; set; }
        public string ResponseType { get; set; }
        public string ResponseMessage { get; set; }
        public TResults Results { get; set; }
        public override string ToString() => JsonSerializer.Serialize<RecordCreated<TResults>>(this);
    }
}
