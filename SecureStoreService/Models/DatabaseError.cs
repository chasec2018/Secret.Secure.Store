using System;
using System.Net.Http;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Text.Json;
using Microsoft.AspNetCore.Http;

namespace SecureStoreService.Models
{
    public class DatabaseError<TResults> : IGenericReturnModel
    {
        public DatabaseError(TResults results, HttpContext Context)
        {
            ResponseCode = 5002;
            ResponseType = "Error";
            ResponseMessage = "An Exception occurred while request Entry from Data Server";
            Results = results;
        }

        public int ResponseCode { get; set; }
        public string ResponseType { get; set; }
        public string ResponseMessage { get; set; }
        public TResults Results { get; set; }
        public override string ToString() => JsonSerializer.Serialize<DatabaseError<TResults>>(this);
    }
}
