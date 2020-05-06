using System;
using System.Data;
using System.Net.Http;
using System.Data.SqlClient;
using System.Collections.Generic;
using System.Threading.Tasks;
using SecureStoreService.Properties;
using Microsoft.AspNetCore.Http;


namespace SecureStoreService.Services
{
    public enum EntryTypes
    {
        Credentials = 1,
        ConnectionString = 2,
        Token = 3,
        Variable = 4
    }

    public class SqlServerRequestHandler
    {
        private protected DataTable _ResultTable;
        private protected Dictionary<string, object> _DictionaryLog;
        private protected SqlConnection _SqlConnection;
       
        public SqlServerRequestHandler()
        {
            _ResultTable = new DataTable();
            _DictionaryLog = new Dictionary<string, object>();
            _SqlConnection = new SqlConnection(Resources.SqlServerConnectionString);
        }

        public SqlConnection SqlConnection
        {
            get
            {
                return _SqlConnection;
            }
        }
        public DataTable ResultTable
        {
            get
            {
                return _ResultTable;
            }
            set
            {
                _ResultTable = value;
            }
        }
        public Dictionary<string,object> DictionaryLog
        {
            get
            {
                return _DictionaryLog;
            }
        }
        public HttpContext RequestContext { get; set; }

        private SqlParameter[] QueryParameters(HttpContext Context)
        {
            List<SqlParameter> Parameters = new List<SqlParameter>();

            string[] QueryKeys =
            {
                "StoreUsername",
                "EntryKey",
                "EntryName",
                "EntryUse",
                "EntryUsername",
                "EntryPassword",
                "EntryConnectionString",
                "EntryToken",
                "EntryVariable",
                "EntryStartDate",
                "EntryEndDate"
            };

            foreach(string QueryKey in QueryKeys)
            {
                if (Context.Request.Query.TryGetValue(QueryKey, out var QueryValue))
                {
                    Parameters.Add(new SqlParameter($"@{QueryKey}", QueryValue.ToString()));
                }
            }
            return Parameters.ToArray();
        }

        public async Task LogRequestAsync(string Method, HttpContext Context)
        {
            try
            {
                SqlConnection.Open();
                SqlCommand command = new SqlCommand()
                {
                    Connection = SqlConnection,
                    CommandType = CommandType.StoredProcedure,
                    CommandText = "[Store].[CreateNewLogEntry]"
                };

                command.Parameters.AddWithValue("@RequestMethod", Method);

                if(Context.Request.Headers.TryGetValue("AccessKey",out var Key))
                    command.Parameters.AddWithValue("@Requester", Key.ToString());
                else
                    command.Parameters.AddWithValue("@Requester", "Unknown Requester");

                string HeaderValue = "";
                string QueryValue = "";

                foreach(var Header in Context.Request.Headers)
                {
                    HeaderValue = string.Concat(HeaderValue, Header);
                }

                foreach (var Query in Context.Request.Query)
                {
                    QueryValue = string.Concat(QueryValue, Query);
                }

                command.Parameters.AddWithValue("@RequestHeader", HeaderValue);
                command.Parameters.AddWithValue("@RequestQuery", QueryValue);

                await command.ExecuteNonQueryAsync().ConfigureAwait(false);
                await SqlConnection.CloseAsync().ConfigureAwait(false);

            }
            catch(Exception exception)
            {
                if(SqlConnection.State.Equals(ConnectionState.Open))
                    await SqlConnection.CloseAsync().ConfigureAwait(false);
            }
        }

        public async Task GetStoreSecretAsync(EntryTypes EntryType, HttpContext Context)
        {
            try
            {
                SqlConnection.Open();
                SqlCommand command = new SqlCommand()
                {
                    Connection = SqlConnection,
                    CommandType = CommandType.StoredProcedure,
                    CommandText = "[Store].[ReturnStoreSecret]"
                };

                command.Parameters.AddWithValue("@EntryType", EntryType.GetHashCode());
                command.Parameters.AddRange(QueryParameters(Context));

                SqlDataReader reader = await command.ExecuteReaderAsync().ConfigureAwait(false);

                if (reader.HasRows)
                    ResultTable.Load(reader);
               
                await reader.CloseAsync().ConfigureAwait(false);
                await reader.DisposeAsync().ConfigureAwait(false);
                await command.DisposeAsync().ConfigureAwait(false);
                await SqlConnection.CloseAsync().ConfigureAwait(false);
            }
            catch (Exception exception)
            {
                if (SqlConnection.State.Equals("Open"))
                    await SqlConnection.CloseAsync();

                DictionaryLog.Add("Exception", exception.HResult);
                DictionaryLog.Add("Exception Message", exception.Message);
            }
        }

        public async Task CreateStoreSecretAsync(EntryTypes EntryType, HttpContext Context)
        {
            try
            {
                SqlConnection.Open();
                SqlCommand command = new SqlCommand()
                {
                    Connection = SqlConnection,
                    CommandType = CommandType.StoredProcedure,
                    CommandText = "[Store].[CreateStoreSecret]"
                };

                command.Parameters.AddWithValue("@EntryType", EntryType.GetHashCode());
                command.Parameters.AddRange(QueryParameters(Context));

                SqlDataReader reader = await command.ExecuteReaderAsync().ConfigureAwait(false);

                if (reader.HasRows)
                    ResultTable.Load(reader);

                await reader.CloseAsync().ConfigureAwait(false);
                await reader.DisposeAsync().ConfigureAwait(false);
                await command.DisposeAsync().ConfigureAwait(false);
                await SqlConnection.CloseAsync().ConfigureAwait(false);
            }
            catch (Exception exception)
            {
                if (SqlConnection.State.Equals("Open"))
                    await SqlConnection.CloseAsync().ConfigureAwait(false);

                DictionaryLog.Add("Exception", exception.HResult);
                DictionaryLog.Add("Exception Message", exception.Message);
            }
        }

        public async Task EditStoreSecretAsync(EntryTypes EntryType, HttpContext Context)
        {
            try
            {
                SqlConnection.Open();
                SqlCommand command = new SqlCommand()
                {
                    Connection = SqlConnection,
                    CommandType = CommandType.StoredProcedure,
                    CommandText = "[Store].[UpdateStoreSecret]"
                };

                command.Parameters.AddWithValue("@EntryType", EntryType.GetHashCode());
                command.Parameters.AddRange(QueryParameters(Context));

                SqlDataReader reader = await command.ExecuteReaderAsync().ConfigureAwait(false);

                if (reader.HasRows)
                    ResultTable.Load(reader);

                await reader.CloseAsync().ConfigureAwait(false);
                await reader.DisposeAsync().ConfigureAwait(false);
                await command.DisposeAsync().ConfigureAwait(false);
                await SqlConnection.CloseAsync().ConfigureAwait(false);
            }
            catch(Exception exception)
            {
                if (SqlConnection.State.Equals("Open"))
                    await SqlConnection.CloseAsync().ConfigureAwait(false);

                DictionaryLog.Add("Exception", exception.HResult);
                DictionaryLog.Add("Exception Message", exception.Message);
            }
        }

        public async Task DeleteStoreSecretAsync(EntryTypes EntryType, HttpContext Context)
        {
            try
            {
                SqlConnection.Open();
                SqlCommand command = new SqlCommand()
                {
                    Connection = SqlConnection,
                    CommandType = CommandType.StoredProcedure,
                    CommandText = "[Store].[DeleteStoreSecret]"
                };

                command.Parameters.AddWithValue("@EntryType", EntryType.GetHashCode());
                command.Parameters.AddRange(QueryParameters(Context));

                SqlDataReader reader = await command.ExecuteReaderAsync().ConfigureAwait(false);

                if (reader.HasRows)
                    ResultTable.Load(reader);
               
                await reader.CloseAsync().ConfigureAwait(false);
                await reader.DisposeAsync().ConfigureAwait(false);
                await command.DisposeAsync().ConfigureAwait(false);
                await SqlConnection.CloseAsync().ConfigureAwait(false);
            }
            catch (Exception exception)
            {
                if (SqlConnection.State.Equals("Open"))
                    await SqlConnection.CloseAsync();

                DictionaryLog.Add("Exception", exception.HResult);
                DictionaryLog.Add("Exception Message", exception.Message);
            }
        }

        public async Task GetAllUserSecretsAsync(HttpContext Context)
        {

            try
            {
                SqlConnection.Open();
                SqlCommand command = new SqlCommand()
                {
                    Connection = SqlConnection,
                    CommandType = CommandType.StoredProcedure,
                    CommandText = "[Store].[ReturnAllUserSecrets]"
                };

                if (Context.Request.Query.TryGetValue("StoreUsername", out var StoreUsername))
                    command.Parameters.AddWithValue("@StoreUsername", StoreUsername.ToString());

                SqlDataReader reader = await command.ExecuteReaderAsync().ConfigureAwait(false);

                if (reader.HasRows)
                    ResultTable.Load(reader);

                await reader.CloseAsync().ConfigureAwait(false);
                await reader.DisposeAsync().ConfigureAwait(false);
                await command.DisposeAsync().ConfigureAwait(false);
                await SqlConnection.CloseAsync().ConfigureAwait(false);
            }
            catch(Exception exception)
            {
                if (SqlConnection.State.Equals("Open"))
                    SqlConnection.Close();

                DictionaryLog.Add("Exception", exception.HResult);
                DictionaryLog.Add("Exception Message", exception.Message);
            }
        }
    }


    public static class SqlServerRequestHandlerExtensions
    {
        // Convert the first Row of Data to a Dictionary(All Data left over is Discarded )
        public static Dictionary<string,string> ToDictionary(this SqlServerRequestHandler Handler)
        {
            Dictionary<string, string> DTable = new Dictionary<string, string>();

            foreach (DataRow Row in Handler.ResultTable.Rows)
            {
                foreach (DataColumn Column in Handler.ResultTable.Columns)
                {
                    DTable.Add(Column.ColumnName, Row[Column].ToString());
                }
                break;
            }
            return DTable;
        }

        public static List<Dictionary<string,string>> ToDictionaryList(this SqlServerRequestHandler Handler)
        {
            List<Dictionary<string, string>> dictionaryList = new List<Dictionary<string, string>>();

            foreach (DataRow Row in Handler.ResultTable.Rows)
            {
                Dictionary<string, string> dictionary = new Dictionary<string, string>();

                foreach (DataColumn Column in Handler.ResultTable.Columns)
                {
                    dictionary.Add(Column.ColumnName, Row[Column].ToString());
                }

                dictionaryList.Add(dictionary);
            }
            return dictionaryList;
        }

        public static bool IsParamsValid(this SqlServerRequestHandler Handler, HttpMethod Method, HttpContext Context)
        {
            bool IsValid = false;
            string[] RequiredParameters;

            if (Method.Equals(HttpMethod.Post))
                RequiredParameters = new string[] { "EntryKey", "StoreUsername", "EntryName", "EntryUse" };
            else
                RequiredParameters = new string[] { "EntryKey", "StoreUsername" };

            foreach (string Parameter in RequiredParameters)
            {
                if (Context.Request.Query.TryGetValue(Parameter, out var ParamValue))
                {
                    if (!ParamValue.ToString().Equals(""))
                        IsValid = true;
                }
            }
            return IsValid;
        }

        public static bool IsExceptionRaised(this SqlServerRequestHandler Handler)
        {
            bool ExceptionRaised = false;

            if (Handler.DictionaryLog.ContainsKey("Exception"))
                ExceptionRaised = true;

            return ExceptionRaised;
        }

        public static bool IsRecordsAffected(this SqlServerRequestHandler Handler)
        {
            bool IsAffected = true;

            if (Handler.ResultTable.Rows.Count.Equals(0))
                IsAffected = false;

            return IsAffected;
        }
    }
}
