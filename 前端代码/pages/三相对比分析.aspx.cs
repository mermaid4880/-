using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class pages_三相对比分析 : System.Web.UI.Page
{
    public string public_userName = "";
    public string public_token = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        string cookieTage = PublicMethod.public_getConfigStr("cookieTage");

        try
        {
            public_token = System.Web.HttpContext.Current.Request.Cookies[cookieTage]["pi3djdg001Token"];
            public_userName = System.Web.HttpContext.Current.Request.Cookies[cookieTage]["pi3djdg001name"];
        }
        catch
        {
        }
    }
}