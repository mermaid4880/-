using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class pages_机器人管理 : System.Web.UI.Page
{
    public string public_token = "";
    public string public_lunxunSeconds = "10000";//默认10秒钟
    protected void Page_Load(object sender, EventArgs e)
    {
        string cookieTage = PublicMethod.public_getConfigStr("cookieTage");

        try
        {
            public_token = System.Web.HttpContext.Current.Request.Cookies[cookieTage]["pi3djdg001Token"];
        }
        catch
        {
        }

        public_lunxunSeconds = PublicMethod.public_getConfigStr("firstPageSeconds");
    }
}