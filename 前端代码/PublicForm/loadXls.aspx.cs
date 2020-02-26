using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class PublicForm_loadXls : System.Web.UI.Page
{
    public string public_execlInfo = "{}";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["execlInfo"] != null && Request.QueryString["execlInfo"].ToString() != "")
        {
            public_execlInfo = Request.QueryString["execlInfo"];

        }
        else {
            //excelClass ec = new excelClass();
            //ec.excelName = "没有生成文件";
            //ec.excelTitle = "没有文件可以下载";
            //ec.excelUrl = "#";
            //public_execlInfo = Newtonsoft.Json.JsonConvert.SerializeObject(ec);
        }
        

    }
}

//private class excelClass {

//    public string excelName
//    {
//        get;
//        set;
//    }

//    public string excelUrl
//    {
//        get;
//        set;
//    }
//    public string excelTitle
//    {
//        get;
//        set;
//    }

//}
