<%@ WebHandler Language="C#" Class="deer_cb_Interface" %>

using System;
using System.Web;

public class deer_cb_Interface : IHttpHandler {

    private static string default_Role_id = "1";
    private static string default_data_Role_id = "1";

    private static string default_usedpsw = "deer@2017";
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string strReturn = "";
        string method = context.Request["method"];
        if (!string.IsNullOrEmpty(method))
        {
            if (method == "Public_getHtml")
            {
                string strUrl = context.Request["url"];
                strReturn = Public_getHtml(strUrl);
            }
            else if (method == "Public_postHtml")
            {
                string strUrl = context.Request["url"];
                string postData = context.Request["postData"];
                strReturn = Public_postHtml(strUrl, postData);
            }
            
        }
        context.Response.Write(strReturn);
    }

    //这里是执行接口


    private string Public_getHtml(string url)
    {
        string strReturn = "";
        string url_header = PublicMethod.public_getConfigStr("interfacUrl");
        url = url_header + "/" + url;
        strReturn=HTMLHelper_new.GetHtml(url,null,null);
        return strReturn;
    }

    private string Public_postHtml(string url,string postdata)
    {
        string strReturn = "";
        string url_header = PublicMethod.public_getConfigStr("interfacUrl");
        url = url_header + "?" + url;
        strReturn = HTMLHelper_new.GetHtml_Post(url, postdata, null, null);
        return strReturn;
    }
    
    public bool IsReusable {
        get {
            return false;
        }
    }

}