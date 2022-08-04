using Microsoft.Identity.Client;
using Microsoft.JSInterop;

namespace AzureMaps.Service
{
    public static class AuthService
    {
        private const string AuthorityFormat = "https://login.microsoftonline.com/{0}/oauth2/v2.0";
        private const string MSGraphScope = "https://atlas.microsoft.com/.default";
        static string objTenantID;
        static string objAadAppId;
        static string objAppKey;

        internal static void SetAuthSettings(IConfigurationSection AzureMaps)
        {
            objTenantID = AzureMaps.GetValue<string>("AadTenant");
            objAadAppId = AzureMaps.GetValue<string>("AadAppId");
            objAppKey = AzureMaps.GetValue<string>("AppKey");
        }

        [JSInvokable]
        public static async Task<string> GetAccessToken()
        {
            IConfidentialClientApplication daemonClient;

            daemonClient = ConfidentialClientApplicationBuilder.Create(objAadAppId)
                .WithAuthority(string.Format(AuthorityFormat, objTenantID))
                .WithClientSecret(objAppKey)
                .Build();

            AuthenticationResult authResult =
            await daemonClient.AcquireTokenForClient(new[] { MSGraphScope }).ExecuteAsync();

            return authResult.AccessToken;
        }
    }
}
