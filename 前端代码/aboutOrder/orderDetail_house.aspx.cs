using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class aboutOrder_orderDetail_house : System.Web.UI.Page
{
    public string commandNum = "";
    public string orderClass = "1";

    protected void Page_Load(object sender, EventArgs e)
    {
        commandNum = Request.QueryString["commandNum"];
        orderClass = Request.QueryString["orderClass"];
    }
}