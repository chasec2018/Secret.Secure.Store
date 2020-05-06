using System;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.UI;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using SecureStoreService.Areas.Identity.Data;
using SecureStoreService.Data;

[assembly: HostingStartup(typeof(SecureStoreService.Areas.Identity.IdentityHostingStartup))]
namespace SecureStoreService.Areas.Identity
{
    public class IdentityHostingStartup : IHostingStartup
    {
        public void Configure(IWebHostBuilder builder)
        {
            builder.ConfigureServices((context, services) => {
                services.AddDbContext<SecureStoreServiceContext>(options =>
                    options.UseSqlServer(
                        context.Configuration.GetConnectionString("SecureStoreServiceContextConnection")));

                services.AddDefaultIdentity<SecureStoreServiceUser>(options => options.SignIn.RequireConfirmedAccount = true)
                    .AddEntityFrameworkStores<SecureStoreServiceContext>();
            });
        }
    }
}