using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

using Newtonsoft;
using Newtonsoft.Json;


namespace WeatherOfGujarat
{
    public partial class readdata : System.Web.UI.Page
    {
        static SqlConnection con;
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        [WebMethod()]
        public static List<Dictionary<string, string>> GetDataTalukas(int Id)
        {
            string query = "";
            try
            {
                DateTime now = DateTime.Now;
                var startDate = new DateTime(now.Year, now.Month-1, 1);
                var endDate = startDate.AddMonths(1).AddDays(-1).ToString("yyyy-M-dd");
                var strStartDate = startDate.ToString("yyyy-M-dd");
                con = new SqlConnection(ConfigurationManager.ConnectionStrings["conStr"].ConnectionString);

                List<Dictionary<string, string>> data = new List<Dictionary<string, string>>();
                //query = "select * from Taluka_Weather_Details  where Taluka_ID=" + Id + " and Created_Date between '" + strStartDate + "' and '" + endDate + "' order by Created_Date";
                query = "select * from Taluka_Weather_Details  where Taluka_ID=" + Id + " order by Created_Date";
                SqlDataAdapter adp = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                adp.Fill(dt);
                string json = "";
                json = DataTableToJSONWithJSONNet(dt);
                
                List<string> colsname = new List<string>();
                foreach (DataColumn item in dt.Columns)
                {
                    colsname.Add(item.ColumnName);
                }

                foreach (DataRow item in dt.Rows)
                {
                    Dictionary<string, string> row = new Dictionary<string, string>();
                    foreach (var colname in colsname)
                    {
                        row[colname] = item[colname].ToString();
                    }
                    data.Add(row);
                }
                
                return data;
            }
            catch (Exception ex)
            {
                List<Dictionary<string, string>> vs = new List<Dictionary<string, string>>();
                Dictionary<string, string> d = new Dictionary<string, string>();
                d["err"] = ex.Message + "\n"+query;
                vs.Add(d);
                return vs;
            }
        }
        [WebMethod()]
        public static List<Dictionary<string, string>> GetTaluka(int districtId)
        {
            try
            {
                con = new SqlConnection(ConfigurationManager.ConnectionStrings["conStr"].ConnectionString);

                List<Dictionary<string, string>> data = new List<Dictionary<string, string>>();
                SqlDataAdapter adp = new SqlDataAdapter("select * from Taluka_Master where District_Auto_ID=" + districtId, con);
                DataTable dt = new DataTable();
                adp.Fill(dt);
                string json = "";
                json = DataTableToJSONWithJSONNet(dt);

                List<string> colsname = new List<string>();
                foreach (DataColumn item in dt.Columns)
                {
                    colsname.Add(item.ColumnName);
                }

                foreach (DataRow item in dt.Rows)
                {
                    Dictionary<string, string> row = new Dictionary<string, string>();
                    foreach (var colname in colsname)
                    {
                        row[colname] = item[colname].ToString();
                    }
                    data.Add(row);
                }

                return data;
            }
            catch (Exception ex)
            {
                List<Dictionary<string, string>> vs = new List<Dictionary<string, string>>();
                Dictionary<string, string> d = new Dictionary<string, string>();
                d["err"] = ex.Message;
                vs.Add(d);
                return vs;
            }
        }
        public static string DataTableToJSONWithJSONNet(DataTable table)
        {
            string JSONString = string.Empty;
            JSONString = JsonConvert.SerializeObject(table);
            return JSONString;
        }
    }
}