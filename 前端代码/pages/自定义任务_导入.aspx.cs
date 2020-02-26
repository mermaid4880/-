using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class pages_自定义任务_导入 : System.Web.UI.Page
{
    public string public_token = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        string cookieTage = PublicMethod.public_getConfigStr("cookieTage");

        try
        {
            public_token = System.Web.HttpContext.Current.Request.Cookies[cookieTage]["pi3djdg001Token"];
            //public_userId = System.Web.HttpContext.Current.Request.Cookies[cookieTage]["pi3djdg001Token"];
        }
        catch
        {
        }
    }
}