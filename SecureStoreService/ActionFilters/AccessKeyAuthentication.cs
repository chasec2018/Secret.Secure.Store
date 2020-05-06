using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;
using System.Threading.Tasks;
using SecureStoreService.Properties;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

namespace SecureStoreService.ActionFilters
{
    public class AccessKeyAuthAttribute : Attribute, IAsyncActionFilter
    {
        public async Task OnActionExecutionAsync(ActionExecutingContext context, ActionExecutionDelegate next)
        {
            // Check if AccessKey (Name & Value) is provided within the Header of the request
            if(!context.HttpContext.Request.Headers.TryGetValue("AccessKey", out var InputAccessKey))
            {
                context.Result = new UnauthorizedResult();
                return;
            }

            AccessKeyRecord record = await AccessKeyQueryHandler.FindRecordAsync(InputAccessKey).ConfigureAwait(true);

            if (record.StoreAccessKey.Equals(string.Empty))
            {
                context.Result = new UnauthorizedResult();
                return;
            }

            if (DateTime.Today.Date < record.UserStartDate)
            {
                context.Result = new UnauthorizedResult();
                return;
            }

            if (DateTime.Today.Date < record.UserStartDate)
            {
                context.Result = new UnauthorizedResult();
                return;
            }

            await next();
        }
    }

    public class AccessKeyRecord
    {
        public string StoreAccessKey { get; set; }
        public string StoreUsername { get; set; }
        public string UserFirstName { get; set; }
        public string UserLastName { get; set; }
        public string UserMiddleName { get; set; }
        public DateTime UserStartDate { get; set; }
        public DateTime UserEndDate { get; set; }
    }

    public static class AccessKeyQueryHandler
    {

        public static async Task<AccessKeyRecord> FindRecordAsync(string AccessKey)
        {
            AccessKeyRecord record = new AccessKeyRecord();

            using (SqlConnection connection = new SqlConnection(Resources.SqlServerConnectionString))
            {
                connection.Open();
                SqlCommand command = new SqlCommand()
                {
                    Connection = connection,
                    CommandType = CommandType.StoredProcedure,
                    CommandText = "[Store].[ReturnAccessKey]"
                };

                command.Parameters.AddWithValue("@AccessKey", AccessKey);
                SqlDataReader reader = await command.ExecuteReaderAsync().ConfigureAwait(false);

                if (reader.HasRows)
                {
                    while (await reader.ReadAsync().ConfigureAwait(true))
                    {
                        for (int i = 0; i < reader.FieldCount; i++)
                        {
                            if (reader.GetName(i).Equals("AccessKey"))
                                record.StoreAccessKey = reader[i].ToString();

                            if (reader.GetName(i).Equals("StoreUsername"))
                                record.StoreUsername = reader[i].ToString();

                            if (reader.GetName(i).Equals("FirstName"))
                                record.UserFirstName = reader[i].ToString();

                            if (reader.GetName(i).Equals("LastName"))
                                record.UserLastName = reader[i].ToString();

                            if (reader.GetName(i).Equals("MiddleName"))
                                record.UserMiddleName = reader[i].ToString();

                            if (reader.GetName(i).Equals("AccessStartDate"))
                                record.UserStartDate = DateTime.Parse(reader[i].ToString());

                            if (reader.GetName(i).Equals("AccessEndDate"))
                                record.UserEndDate = DateTime.Parse(reader[i].ToString());

                        }
                    }
                }

                return record;
            }
        }
    }


}
