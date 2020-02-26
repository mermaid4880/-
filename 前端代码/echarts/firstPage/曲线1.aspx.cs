using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class echarts_firstPage_曲线1 : System.Web.UI.Page
{
    public string height = "0";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["height"] != null)
        {
            height = Request.QueryString["height"].ToString();
        }
    }
}