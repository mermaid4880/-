using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class 主预览_webVideo1 : System.Web.UI.Page
{

    public string ip, iPrototocol, port, username, psw;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["ip"] != null) {
            ip = Request.QueryString["ip"];
        }

        if (Request.QueryString["iPrototocol"] != null)
        {
            iPrototocol = Request.QueryString["iPrototocol"];
        }

        if (Request.QueryString["port"] != null)
        {
            port = Request.QueryString["port"];
        }

        if (Request.QueryString["username"] != null)
        {
            username = Request.QueryString["username"];
        }
        if (Request.QueryString["psw"] != null)
        {
            psw = Request.QueryString["psw"];
        }

    }
}