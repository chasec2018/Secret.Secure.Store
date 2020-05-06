using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using SecureStoreService.Properties;

namespace SecureStoreService.Identitiy
{
    public class Authentication 
    {

        private ClaimsPrincipal Principal = new ClaimsPrincipal();
        


        public async Task ADAuthenticate()
        {
            
        }

        public async Task DbAuthentication()
        {
            using(SqlConnection connection = new SqlConnection(Resources.SqlServerConnectionString))
            {



                List<Claim> SqlServerClaims = new List<Claim>
                {
                    new Claim("",""),
                    new Claim("","")
                };

                ClaimsIdentity Identity = new ClaimsIdentity(SqlServerClaims, "");


                Principal.AddIdentity(Identity);


            }
        }

    }
}
