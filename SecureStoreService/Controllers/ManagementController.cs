using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using SecureStoreService.Models;
using SecureStoreService.Services;
using SecureStoreService.ActionFilters;
using System.Net.Http;

namespace SecureStoreService.Controllers
{
    [AccessKeyAuth]
    [ApiController]
    [Route("Management/{action}")]
    public class ManagementController : ControllerBase
    {
        private readonly ILogger<ManagementController> Logger;
        private readonly SqlServerRequestHandler SqlRequestHandler;

        public ManagementController(ILogger<ManagementController> _Logger, SqlServerRequestHandler _SqlRequestHandler)
        {
            Logger = _Logger;
            SqlRequestHandler = _SqlRequestHandler;
        }

        [HttpGet]
        public async Task<ActionResult<IGenericReturnModel>> ReturnAllSecrets()
        {
            // Log Requets
            await SqlRequestHandler.LogRequestAsync("GET", HttpContext);

            try
            {
                // Step 2 : Process Database Request
                await SqlRequestHandler.GetAllUserSecretsAsync(HttpContext).ConfigureAwait(false);

                // Step 3: Validate Request Results
                // Validation 1 : Check for Exception Errors
                if (SqlRequestHandler.IsExceptionRaised())
                    return Conflict(new DatabaseError<Dictionary<string, object>>(
                            SqlRequestHandler.DictionaryLog,
                            HttpContext));

                // Validation 2 : Check for Null Records
                if (SqlRequestHandler.IsRecordsAffected().Equals(false))
                    return BadRequest(new RecordsNotFound(HttpContext));

                // Return Results from Database
                return Ok(new RecordFound<List<Dictionary<string, string>>>(
                    SqlRequestHandler.ToDictionaryList(),
                    HttpContext).ToString());
            }
            catch (Exception exception)
            {
                return Conflict(new UnknownError(exception.Message).ToString());
            }
        }
    }
}