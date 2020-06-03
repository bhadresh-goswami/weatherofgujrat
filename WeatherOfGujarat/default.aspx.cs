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
    public partial class _default : System.Web.UI.Page
    {
        static SqlConnection con;

        protected void Page_Load(object sender, EventArgs e)
        {
            con = new SqlConnection(ConfigurationManager.ConnectionStrings["conStr"].ConnectionString);
            if (!IsPostBack)
            {
                fill_dropdownlist();
            }

        }
        public void fill_dropdownlist()
        {
            //District Selection
            SqlDataAdapter adp = new SqlDataAdapter("Select * from District_Master", con);
            DataTable dt = new DataTable();
            adp.Fill(dt);
            ddlDistrict.Items.Clear();
            ddlDistrict.AppendDataBoundItems = true;

            ddlDistrict.DataSource = dt;
            ddlDistrict.DataTextField = "District_Name";
            ddlDistrict.DataValueField = "id";
            ddlDistrict.DataBind();

            ddlDistrict.Items.Insert(0, "Select District");

            //select* from Taluka_Master
            adp = new SqlDataAdapter("Select * from Taluka_Master", con);
            dt = new DataTable();
            adp.Fill(dt);
            ddlTaluka.Items.Clear();
            ddlTaluka.AppendDataBoundItems = true;

            ddlTaluka.DataSource = dt;
            ddlTaluka.DataTextField = "Taluka_Name";
            ddlTaluka.DataValueField = "Taluka_ID";
            ddlTaluka.DataBind();

            ddlTaluka.Items.Insert(0, "Select Taluka");
        }
        [WebMethod()]
        public static string GetData(int districtId)
        {
            SqlDataAdapter adp = new SqlDataAdapter("select * from District_Weather_Details inner join District_Master on District_Master.District_ID = District_Weather_Details.District_ID where District_ID=" + districtId, con);
            DataTable dt = new DataTable();
            adp.Fill(dt);

            string json = "";
            json = DataTableToJSONWithJSONNet(dt);
            return json;
        }
        public static string DataTableToJSONWithJSONNet(DataTable table)
        {
            string JSONString = string.Empty;
            JSONString = JsonConvert.SerializeObject(table);
            return JSONString;
        }
    }
}