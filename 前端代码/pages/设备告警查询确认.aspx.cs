using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class pages_设备告警查询确认 : System.Web.UI.Page
{
    public string public_token = "";
    public string public_userName = "";//用户名称
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