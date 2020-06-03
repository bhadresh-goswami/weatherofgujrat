using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services;

namespace WeatherOfGujarat
{
    /// <summary>
    /// Summary description for retriveinformation
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    // [System.Web.Script.Services.ScriptService]
    public class retriveinformation : System.Web.Services.WebService
    {

        [WebMethod]
        public string GetDataTalukas(int Id)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["conStr"].ConnectionString);
            SqlDataAdapter adp = new SqlDataAdapter("select * from Taluka_Weather_Details where Taluka_ID=" + Id, con);
            DataTable dt = new DataTable();
            adp.Fill(dt);
            string json = "";
            json = DataTableToJSONWithJSONNet(dt);
            return json;
        }
        [WebMethod]
        public string GetTalukas(int districtId)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["conStr"].ConnectionString);
            SqlDataAdapter adp = new SqlDataAdapter("select * from Taluka_Master where District_Auto_ID=" + districtId, con);
            DataTable dt = new DataTable();
            adp.Fill(dt);
            string json = "";
            json = DataTableToJSONWithJSONNet(dt);
            return json;
        }
        public string DataTableToJSONWithJSONNet(DataTable table)
        {
            string JSONString = string.Empty;
            JSONString = JsonConvert.SerializeObject(table);
            return JSONString;
        }
    }
}
