using System;
using SecureStoreService.Models;
using SecureStoreService.Services;
using SecureStoreService.ActionFilters;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Net.Http;

namespace SecureStoreService.Controllers
{
    [AccessKeyAuth]
    [ApiController]
    [Route("Variable/{action}")]
    public class VariableController : ControllerBase
    {
        private readonly ILogger<VariableController> Logger;
        private readonly SqlServerRequestHandler SqlRequestHandler;

        public VariableController(ILogger<VariableController> _Logger, SqlServerRequestHandler _SqlRequestHandler)
        {
            Logger = _Logger;
            SqlRequestHandler = _SqlRequestHandler;
        }

        [HttpGet]
        public async Task<ActionResult<IGenericReturnModel>> Return()
        {
            // Log Requets
            await SqlRequestHandler.LogRequestAsync("GET", HttpContext);

            try
            {
                // Step 1: Validate Argument Requirements
                if (!SqlRequestHandler.IsParamsValid(HttpMethod.Get, HttpContext))
                    return BadRequest(new ArgumentError().ToString());

                // Step 2 : Process Database Request
                await SqlRequestHandler.GetStoreSecretAsync(
                    EntryTypes.Variable,
                    HttpContext);

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
                return Ok(new RecordFound<Dictionary<string, string>>(
                    SqlRequestHandler.ToDictionary(),
                    HttpContext).ToString());
            }
            catch (Exception exception)
            {
                return Conflict(new UnknownError(exception.Message).ToString());
            }
        }

        [HttpPost]
        public async Task<ActionResult<IGenericReturnModel>> Create()
        {
            // Log Requets
            await SqlRequestHandler.LogRequestAsync("POST", HttpContext);

            try
            {
                // Step 1: Validate Argument Requirements
                if (!SqlRequestHandler.IsParamsValid(HttpMethod.Post, HttpContext))
                    return BadRequest(new ArgumentError().ToString());

                // Step 2 : Process Database Request
                await SqlRequestHandler.CreateStoreSecretAsync(
                    EntryTypes.Variable,
                    HttpContext);

                // Step 3: Validate Request Results
                // Validation 1 : Check for Exception Errors
                if (SqlRequestHandler.IsExceptionRaised())
                    return Conflict(new DatabaseError<Dictionary<string, object>>(
                            SqlRequestHandler.DictionaryLog,
                            HttpContext));

                // Return Results
                return Ok(new RecordCreated<Dictionary<string, string>>(
                    SqlRequestHandler.ToDictionary(),
                    HttpContext).ToString());
            }
            catch (Exception exception)
            {
                return Conflict(new UnknownError(exception.Message).ToString());
            }
        }

        [HttpDelete]
        public async Task<ActionResult<IGenericReturnModel>> Remove()
        {
            // Log Requets
            await SqlRequestHandler.LogRequestAsync("DELETE", HttpContext);

            try
            {
                // Validate Required Arguments are provided
                if (!SqlRequestHandler.IsParamsValid(HttpMethod.Delete, HttpContext))
                    return BadRequest(new ArgumentError().ToString());

                // Request Results
                await SqlRequestHandler.DeleteStoreSecretAsync(
                    EntryTypes.Variable,
                    HttpContext);

                // Validation 1 : Check for Exception Errors
                if (SqlRequestHandler.IsExceptionRaised())
                    return Conflict(new DatabaseError<Dictionary<string, object>>(
                            SqlRequestHandler.DictionaryLog,
                            HttpContext));

                // Validation 2 : Check for Null Records
                if (SqlRequestHandler.IsRecordsAffected().Equals(false))
                    return BadRequest(new RecordsNotFound(HttpContext));

                // Return results
                return Ok(new RecordDeleted<Dictionary<string, string>>(
                    SqlRequestHandler.ToDictionary(),
                    HttpContext).ToString());
            }
            catch (Exception exception)
            {
                return Conflict(new UnknownError(exception.Message).ToString());
            }
        }

        [HttpPut]
        public async Task<ActionResult<IGenericReturnModel>> Edit()
        {
            // Log Requets
            await SqlRequestHandler.LogRequestAsync("PUT", HttpContext);

            try
            {
                // Validate Required Arguments are provided
                if (!SqlRequestHandler.IsParamsValid(HttpMethod.Put, HttpContext))
                    return BadRequest(new ArgumentError().ToString());

                // Request Results
                await SqlRequestHandler.EditStoreSecretAsync(
                    EntryTypes.Variable,
                    HttpContext);

                // Validation 1 : Check for Exception Errors
                if (SqlRequestHandler.IsExceptionRaised())
                    return Conflict(new DatabaseError<Dictionary<string, object>>(
                            SqlRequestHandler.DictionaryLog,
                            HttpContext));

                // Validation 2 : Check for Null Records
                if (SqlRequestHandler.IsRecordsAffected().Equals(false))
                    return BadRequest(new RecordsNotFound(HttpContext));

                // Return results
                return Ok(new RecordUpdated<Dictionary<string, string>>(
                    SqlRequestHandler.ToDictionary(),
                    HttpContext).ToString());
            }
            catch (Exception exception)
            {
                return Conflict(new UnknownError(exception.Message).ToString());
            }
        }
    }
}
