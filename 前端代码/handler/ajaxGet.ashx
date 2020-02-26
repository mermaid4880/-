<%@ WebHandler Language="C#" Class="ajaxGet" %>

using System;
using System.Web;
using System.Data;

public class ajaxGet : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
       context.Response.ContentType = "text/plain";
        string strReturn = "[]";
        string method = context.Request["method"];
        if (!string.IsNullOrEmpty(method))
        {
            if (method == "public_UP_method_tuxing")
            {
                string produceName = context.Request["produceName"];
                strReturn = public_UP_method(produceName);
            }
            
        }
        context.Response.Write(strReturn);
    }

    
    
    private string public_UP_method(string procedureName)
    {
        System.Data.SqlClient.SqlParameter[] commandParameters = new System.Data.SqlClient.SqlParameter[] { };
        string json = @"{""Rows"":[],""Total"":""0""}";//转变成dll转变
        SQLHelper db_helper = new SQLHelper();
        int totalRecord = 0;
        System.Data.DataSet ds1 = db_helper.RunProcedure(procedureName, commandParameters, procedureName);
        if (ds1 != null)
        {
            totalRecord = ds1.Tables[0].Rows.Count;
            DataTable dt = ds1.Tables[0];
            Newtonsoft.Json.JsonSerializerSettings js = new Newtonsoft.Json.JsonSerializerSettings();
            js.DateFormatString = "yyyy-MM-dd HH:mm:ss";
            string jsontemp = Newtonsoft.Json.JsonConvert.SerializeObject(dt, Newtonsoft.Json.Formatting.Indented, js);
            json = @"{""Rows"":" + jsontemp + @",""Total"":""" + totalRecord + @"""}";//转变成dll转变
        }

        return json;
    }
    public bool IsReusable {
        get {
            return false;
        }
    }

}