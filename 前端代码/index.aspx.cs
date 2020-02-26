using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class index : System.Web.UI.Page
{
    public string loginId = "";
    public string loginName = "";
    public string public_token = "";
    public string public_accessIds = "1";

    protected void Page_Load(object sender, EventArgs e)
    {
        string cookieTage = PublicMethod.public_getConfigStr("cookieTage");

        try
        {
            //public_accessIds = "1,2,3,4,5,6,7";

            loginId =  System.Web.HttpContext.Current.Request.Cookies[cookieTage]["pi3djdg001id"];
            loginName =  HttpUtility.UrlDecode( System.Web.HttpContext.Current.Request.Cookies[cookieTage]["pi3djdg001name"]);
            public_token = System.Web.HttpContext.Current.Request.Cookies[cookieTage]["pi3djdg001Token"];

            public_accessIds = System.Web.HttpContext.Current.Request.Cookies[cookieTage]["pi3djdg001accessIds"];
           

        }
        catch
        { 
        }
    }
}