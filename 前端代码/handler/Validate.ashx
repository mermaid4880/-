<%@ WebHandler Language="C#" Class="Validate" %>

using System;
using System.Web;
using System.Data;
using System.Web.SessionState;

public class Validate : IHttpHandler,IRequiresSessionState
{
    private static string cookieTage = PublicMethod.public_getConfigStr("cookieTage");
    
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        try
        {
            if (context.Request.Params["Action"] == "Exist")
                ValidateExist();
            if (context.Request.Params["Action"] == "Login")
                ValidateLogin();
            if (context.Request.Params["Action"] == "autoLogin")
                ValidateAutoLogin();
        }
        catch (Exception err)
        {
            context.Response.Write("3");
        }
        context.Response.End();
    }

    string getUserId()
    {
        string UserId = "";
        try { UserId = System.Web.HttpContext.Current.Request.Cookies[cookieTage]["pi3djdg001id"]; }
        catch
        {
            UserId = "0";//表示异常
        }
        return UserId;
    }
    string getReal_name()
    {
        string UserId = "";
        try { 
            UserId = System.Web.HttpContext.Current.Request.Cookies[cookieTage]["pi3djdg001name"];
            UserId = HttpUtility.UrlDecode(UserId);
        }
        catch
        {
            UserId = "0";//表示异常
        }
        return UserId;
    }
    
    
    void ValidateExist()
    {
        //跳出去
        //插入日志
        SQLHelper db_helper = new SQLHelper();
        var vKeyid = PublicMethod.getRadNum("ki");
        string  sql = "insert into Sys_rizhi(keyid,User_id,Real_name,Op_time,Rz_type,Rz_content)";
        sql += " values('" + vKeyid + "','" + getUserId() +"','" + getReal_name() + "',getdate(),'系统退出','系统退出')";
        db_helper.RunSqlStr(sql);
        
        HttpContext.Current.Response.Cookies[cookieTage].Expires = DateTime.Now.AddHours(-1);
        System.Web.HttpContext.Current.Response.Write("1");
    }
    #region 登录验证
    void ValidateLogin()
    {
        var context = System.Web.HttpContext.Current;
        string username = context.Request.Params["username"];
        string password = context.Request.Params["password"];
        string Pwdsave = context.Request.Params["OutHours"];
        context.Response.Write(UserLogin(username, password, Pwdsave));
    }
    #endregion

    #region 自动登录验证
    void ValidateAutoLogin()
    {
        var context = System.Web.HttpContext.Current;
        string username = context.Request.Params["username"];
        string password = context.Request.Params["password"];
        string Pwdsave = context.Request.Params["OutHours"];
        context.Response.Write(UserLogin(username, password, Pwdsave));
    }
    #endregion

    /// <summary>  
    /// 获取时间戳  
    /// </summary>  
    /// <returns></returns>  
    public static string GetTimeStamp()
    {
        TimeSpan ts = DateTime.UtcNow - new DateTime(1970, 1, 1, 0, 0, 0, 0);
        return Convert.ToInt64(ts.TotalMilliseconds).ToString();
    }  
    
   
    

    public static string UserLogin(string username, string password, string Pwdsave)
    {
        //替换后多次加密后验证
        string strReturn = "";//是否可以获取 token
        string url = PublicMethod.Public_GetWebConfigStr("interFaceUrl") + "/users/login";
        System.Collections.Generic.List<string> l = new System.Collections.Generic.List<string>();
        System.Net.CookieContainer cs = new System.Net.CookieContainer();
        HttpHeader_new hd = new HttpHeader_new();
        l.Add("Content-Type:application/x-www-form-urlencoded");
        hd.l_strp = l;
        string postData = "username=" + username + "&password=" + password;
        string html = HTMLHelper_new.GetHtml_Post(url, postData, hd, cs);

        if (!string.IsNullOrEmpty(html))
        {
            //strReturn = html;
            try{
                Newtonsoft.Json.Linq.JObject o = Newtonsoft.Json.Linq.JObject.Parse(html);
                if (o["success"].ToString().ToLower() == "true")
                {
                    strReturn = "10";
                    HttpContext.Current.Response.Cookies[cookieTage]["pi3djdg001UserId"] = o["data"]["userMessage"]["userId"].ToString();
                    HttpContext.Current.Response.Cookies[cookieTage]["pi3djdg001name"] = HttpUtility.UrlEncode(o["data"]["userMessage"]["name"].ToString()
                        , System.Text.Encoding.GetEncoding("UTF-8"));//记录登陆用户名称
                    HttpContext.Current.Response.Cookies[cookieTage]["pi3djdg001Token"] = o["data"]["token"].ToString();

                    HttpContext.Current.Response.Cookies[cookieTage]["pi3djdg001accessIds"] = o["data"]["userMessage"]["accessIds"].ToString();
                    
                }
                else {
                    strReturn = "20";
                    
                }
            }
            catch
            {
                strReturn = "30";
            }
            
        }
        else
        {
            strReturn = "40"; //没有获取到信息 
        }
        
        
        return strReturn;
    }
    public static void AddCookie(HttpCookie cookie)
    {
        HttpResponse response = HttpContext.Current.Response;
        if (response != null)
        {
            cookie.HttpOnly = true;
            cookie.Path = "/";
            response.AppendCookie(cookie);
        }
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}