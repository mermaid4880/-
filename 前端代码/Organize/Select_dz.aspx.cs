using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Organize_Select_dz : System.Web.UI.Page
{
    public string Function_id = "0";
    public string p_level = "0";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["id"] != null)
        {
            Function_id = Request.QueryString["id"].ToString();
        }
        if (Request.QueryString["p_level"] != null)
        {
            p_level = Request.QueryString["p_level"].ToString();
        }
    }
}