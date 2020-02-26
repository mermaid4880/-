<%@ WebHandler Language="C#" Class="select" %>

using System;
using System.Web;
using System.Reflection;
using System.Data;
using System.Text;

public class select : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        var json = GetGridJSON(context);
        context.Response.Write(json);
        context.Response.End();
    }

    public static string GetGridJSON(HttpContext context)
    {
        string view = context.Request["view"];
        string idfield =context.Request["idfield"];
        string textfield = context.Request["textfield"];
        
        SQLHelper db_helper = new SQLHelper();
        
        string sql = "Select " + idfield + " as [id]," + textfield + " text from " + view;
        if (!string.IsNullOrEmpty(textfield)) {

            sql += " where len(" + textfield + ")>0";
        }
        
        if (context.Request["SelId"] != null && context.Request["SelId"] != "" && context.Request["Field"] != null && context.Request["Field"] != "")
        {
            string SelId = ReplaceStr.Replace(context.Request["SelId"]);//联动查询条件
            string Field = ReplaceStr.Replace(context.Request["Field"]);//联动查询字段 
            sql = sql + " and " + Field + "='" + SelId + "'";
        }
        if (context.Request["SelId1"] != null && context.Request["SelId1"] != "" && context.Request["Field1"] != null && context.Request["Field1"] != "")
        {
            string SelId1 = ReplaceStr.Replace(context.Request["SelId1"]);//联动查询条件
            string Field1 = ReplaceStr.Replace(context.Request["Field1"]);//联动查询字段 
            sql = sql + " and " + Field1 + " like '%" + SelId1 + "%'";
        }

        if (context.Request["orderName"] != null)
        {
            sql = sql + " order by " + context.Request["orderName"];
        }
        
        
        DataTable dt = new DataTable();
        dt = db_helper.GetDataTable(sql);
        string json = "";
        if (dt.Rows.Count > 0)
        {
            //json = ReplaceStr.DataTable2Json(dt);
            Newtonsoft.Json.JsonSerializerSettings js = new Newtonsoft.Json.JsonSerializerSettings();
            js.DateFormatString = "yyyy-MM-dd HH:mm:ss";
            json = Newtonsoft.Json.JsonConvert.SerializeObject(dt, Newtonsoft.Json.Formatting.Indented, js);
        }
        else
        {
            json = "[]";
        }
        return json;
    }

    public bool IsReusable { get { return false; } }
}