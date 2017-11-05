using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Web;

namespace TMAAT_WebAPI.Resources
{
    public class BasicAuthFilter : System.Web.Http.Filters.AuthorizationFilterAttribute
    {
        public override void OnAuthorization(System.Web.Http.Controllers.HttpActionContext actionContext) {
            try {
                var authTokenValues = actionContext.Request.Headers.GetValues("Auth-Token");
                var authToken = "";
                DateTime expires = new DateTime(0);

                if (authTokenValues == null)
                {
                    actionContext.Response = new System.Net.Http.HttpResponseMessage(System.Net.HttpStatusCode.Unauthorized);
                }
                else
                {
                    authToken = authTokenValues.First();
                }
                using (var conn = new MySqlConnection("Uid = manager;" +
                                                   "Pwd = rdelatable; Server = 127.0.0.1;" +
                                                   "Database = tmaat_db;"))
                {
                    conn.Open();
                    //grab details from db
                    string sql0 = "SELECT * FROM csrauthtoken WHERE token = @token";
                    MySqlCommand cmd0 = new MySqlCommand(sql0, conn);
                    cmd0.Parameters.AddWithValue("@token", authToken);
                    cmd0.Prepare();
                    var rdr = cmd0.ExecuteReader();
                    while (rdr.Read())
                    {
                        expires = (DateTime)rdr["expires"];
                    }
                    conn.Close();
                }
                //check if token is still valid
                if (expires <= DateTime.Now)
                {
                    actionContext.Response = new System.Net.Http.HttpResponseMessage(System.Net.HttpStatusCode.Unauthorized);
                }

                base.OnAuthorization(actionContext);
            }
            catch(Exception e) {
                var err = new HttpResponseMessage(HttpStatusCode.InternalServerError);
                err.ReasonPhrase = e.Message.Replace("\n", "").Replace("\r", "") + new StackTrace(e, true).GetFrame(0).GetFileLineNumber();
                actionContext.Response = err;
            }
        }
    }
}