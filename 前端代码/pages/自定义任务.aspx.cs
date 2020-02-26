using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class pages_自定义任务 : System.Web.UI.Page
{
    public string public_token = "";
    //public string public_userId = "";
    public string public_type = "1";//通过类型 架构页面 默认1  全面巡检
    public string public_miniType = "1";
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
        if (Request.QueryString["type"] != null)
        {
            public_type = Request.QueryString["type"].ToString();
        }
        if (Request.QueryString["miniType"] != null)
        {
            public_miniType = Request.QueryString["miniType"].ToString();
        }
    }
}