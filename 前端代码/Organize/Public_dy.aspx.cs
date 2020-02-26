using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Organize_Public_dy : System.Web.UI.Page
{
    public string Function_id = "0";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["id"] != null)
        {
            Function_id = Request.QueryString["id"].ToString();
        }
    }
}