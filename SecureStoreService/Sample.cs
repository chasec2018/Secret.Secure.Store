using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;

namespace SecureStoreService
{
    public class Sample
    {

        public void Smaple(HttpContext context)
        {
            var v = context.Request.Cookies[""];
            
        }
    }
}
