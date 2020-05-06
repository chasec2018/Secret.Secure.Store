using System;
using System.Data.SqlClient;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace SecureStoreService.Pages.Maintenance
{
    public class MainModel : PageModel
    {



        public void OnGet()
        {
            
        }

        public async Task<ActionResult<string>> GetResult()
        {
            Task task = Task.Run(() =>
            {
                Console.WriteLine("");
            });
            await task;

            return "";
        }
    }
}