<%@ WebHandler Language="C#" Class="Grid" %>

using System;
using System.Web;
using System.Reflection;

using System.Data;
using System.Linq;
using System.Web.SessionState;

using Newtonsoft.Json.Linq;//微软json

public class Grid : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        //System.Web.HttpContext.Current.Request.Cookies["z3y0ylpxgg05"].Expires = DateTime.Now.AddHours(10);//修改有效时间是10分钟
        context.Response.ContentType = "text/plain";
        var json = GetGridJSON(context);
        context.Response.Write(json);
        context.Response.End();
    }


    private static string getUsername()
    {
        string userName = "";
        try
        {
            userName = System.Web.HttpContext.Current.Request.Cookies["z3y0ylpxgg05"]["d5hgj5jk7sfa"];
            userName = DES_En_De.DesDecrypt(userName);
        }
        catch { 
        }
        return userName;
    }
    //得到我的数据权限
    private static string GetDataRoleId()
    {
        string DataRoleId = "0";
        try
        {
            DataRoleId = System.Web.HttpContext.Current.Request.Cookies["z3y0ylpxgg05"]["pi3djdg001dataRole"];
            DataRoleId = DES_En_De.DesDecrypt(DataRoleId);
        }
        catch
        {
        }
        return DataRoleId;
    }

    //得到我的数据权限
    private static string GetUserPostId()
    {
        string DataRoleId = "0";
        try
        {
            DataRoleId = System.Web.HttpContext.Current.Request.Cookies["z3y0ylpxgg05"]["pi3djdg001Post_id"];
            DataRoleId = DES_En_De.DesDecrypt(DataRoleId);
        }
        catch
        {
        }
        return DataRoleId;
    }
    
    
    public static string GetGridJSON(HttpContext context)
    {
        string json = "[]";

        string where_left_tree = "";
        string where_center = "";//中间查询的json
        string wherea_all = "1=1";//这是组合后的总查询条件
        string gridName = "";

        #region //这里处理树结构 where_left
        if (!string.IsNullOrEmpty(context.Request["where_left"]))
        {

            //这里进行
            where_left_tree = PublicMethod.getTreeSql_all(context.Request["where_left"].Trim());

            wherea_all += where_left_tree;
        }

        #endregion
        
        
        #region //这里处理json条件
        if (!string.IsNullOrEmpty(context.Request["where_center"])) {

           string jsonStr = context.Request["where_center"].Trim();
           //这里应该是个数组
           JArray ja = JArray.Parse(jsonStr);

           for (var i = 0; i < ja.Count; i++) {

               JObject o = (JObject)ja[i];
               where_center += get_op_Sql(o["name"].ToString(), o["value"].ToString(), o["op"].ToString());
               
           }

           wherea_all = wherea_all + where_center;
            
        }
        
        
        
        #endregion

        #region 这里处理一些特殊的查询
        if (!string.IsNullOrEmpty(context.Request["commandNum"]))
        {

            //这里进行
            wherea_all += " and commandNum='" + context.Request["commandNum"] .ToString()+"'";
        }
        #endregion 

        string view = context.Request["view"];
        string methodType = context.Request["methodType"];
        DataSet ds = new DataSet();
        SQLHelper db_helper = new SQLHelper();
        if (methodType.ToLower() == "v")
        {
            
            int TotalPage = 0;
            int totalRecord = 0;
            string returnMsg = "";
            
            string sortname = context.Request["sortName"];
            string sortorder = context.Request["sortOrder"];
            if (string.IsNullOrEmpty(sortorder))
            {
                sortorder = "asc";
            }
            string pagenumber1 = context.Request["page"];
            if (context.Request["page"] == null)//异常处理
            { pagenumber1 = "1"; }
            string _pagesize = context.Request["limit"];
            if (context.Request["limit"] == null)
            { _pagesize = "30"; }

            System.Collections.Generic.List<Object> l = new System.Collections.Generic.List<object>();
            l.Add("V");
            if (!string.IsNullOrEmpty(sortname))//这里记录住了执行的sql语句
            {
                string str = "select * from " + view + " where " + wherea_all + " order by " + sortname + " " + sortorder;//保存住本次查询的数据 用于导出 
                l.Add(str);
            }
            else
            {
                string str = "select * from " + view + " where " + wherea_all;
                l.Add(str);
            }
            context.Session["sql_" + gridName + "_" + view] = l;//保存住本次查询的数据 用于导出 

            ds = db_helper.ReturnPageList("ProcDataPaging", view, "*", sortname + " " + sortorder
                , wherea_all, Convert.ToInt32(_pagesize), Convert.ToInt32(pagenumber1), out TotalPage, out totalRecord);
            DataTable dt = new DataTable();
            if (ds != null)
            {
                if (ds.Tables.Count > 0)
                {
                    #region
                    dt = ds.Tables[0];
                    #endregion
                }
            }

            string View_json = "{\"data\":[],\"code\":0,\"count\":0,\"msg\":\"\"}";//转变成dll转变
            context.Session["dt_" + gridName + "_" + view] = dt;//保存住本次查询的数据 用于导出 
            if (dt.Rows.Count > 0)
            {
                Newtonsoft.Json.JsonSerializerSettings js = new Newtonsoft.Json.JsonSerializerSettings();
                js.DateFormatString = "yyyy-MM-dd HH:mm:ss";
                string jsontemp = Newtonsoft.Json.JsonConvert.SerializeObject(dt, Newtonsoft.Json.Formatting.Indented, js);
                //View_json = @"{""Rows"":" + jsontemp + @",""Total"":""" + totalRecord + @"""}";//转变成dll转变
                int iCode = 0;
                View_json = @"{""data"":" + jsontemp + @",""code"":""" + iCode + @""",""count"":""" + totalRecord + @""",""msg"":""" + returnMsg + @"""}";//转变成dll转变
            }
            //这里是通过存储过程分页的
            return View_json;    
        }
        else if (view.ToLower() == "u")
        {

        }
        else if (view.ToLower() == "ut")
        {

        }
        
        return json;
    }
   
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

    private static string getGridSql(string filedName,string op,object value)
    {
        string strReturn = "";
        if (op.Trim() == "in")
        {
            strReturn = filedName + " " + op + " ('" + value + "')";
            strReturn = strReturn.Replace(',', ';');
        }
        else
        {
            strReturn = filedName + " " + op + "'" + value + "'"; 
        }
        return strReturn;
    }
    /// <summary>
    /// 
    /// </summary>
    /// <param name="type"></param>
    /// <returns></returns>
    private static string get_op(string op)
    {
        string strReturn="";
        op = op.ToLower();
        if(op=="equal")
        {
            strReturn="=";
        }
        else if (op == "like")
        {
            strReturn = "like";
        }
        else if(op=="greaterorequal")
        {
            strReturn=">=";
        }
        else if(op=="greater")
        {
            strReturn=">";
        }
        else if(op=="lessorequal")
        {
            strReturn="<=";
        }
        else if(op=="less")
        {
            strReturn="<";
        }
        else
        {
            strReturn="=";
        }
        return strReturn;
    }

    private static string get_op_Sql(string name,string value ,string op)
    {
        string strReturn = "";
        op = op.ToLower();
        if (op == "equal")
        {
            strReturn = " and " + name + " = '" + value + "'";
        }
        else if (op == "like")
        {
            strReturn = " and " + name + " like '%" + value + "%'";
        }
        else if (op == "llike")
        {
            strReturn = " and " + name + " like '%" + value + "'";
        }
        else if (op == "rlike")
        {
            strReturn = " and " + name + " like '" + value + "%'";
        }
            
        else if (op == "greaterorequal")
        {
            strReturn = " and " + name + " >= '" + value+"'";
        }
        else if (op == "greater")
        {
            strReturn = " and " + name + " > '" + value + "'";
        }
        else if (op == "lessorequal")
        {
            strReturn = " and " + name + " < '" + value + "'";
        }
        else if (op == "less")
        {
            strReturn = " and " + name + " < '" + value + "'";
        }
        else if (op == "noequal")
        {
            strReturn = " and " + name + " != '" + value + "'";
        }
        return strReturn;
    }
}