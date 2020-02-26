<%@ WebHandler Language="C#" Class="loadGrid" %>

using System;
using System.Web;

using Newtonsoft.Json.Linq;//微软json

public class loadGrid : IHttpHandler {

    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        var json = GetGridJSON(context);
        context.Response.Write(json);
        context.Response.End();
    }


    public static string GetGridJSON(HttpContext context)
    {
        string json = "[\"Total\":0,\"Rows\":[]]";
        string public_token = "";
        string cookieTage = PublicMethod.public_getConfigStr("cookieTage");
        try
        {
            public_token = System.Web.HttpContext.Current.Request.Cookies[cookieTage]["pi3djdg001Token"];
        }
        catch
        {
        }

        string view = context.Request["view"];
        if (view == "http_getGridMethod_expend")
        {
            string Urlparam1 = "";//这里是默认加到后面的
            if (context.Request["param1"] != null)
            {
                string para1 = context.Request["param1"].ToString();
                JArray ja = JArray.Parse(para1);
                foreach (var o in ja) {

                    Urlparam1 += "&" + o["key"].ToString() + "=" + o["value"].ToString();

                }
            }


            //这种支持
            /*
             
             http_getGridMethod_expend
             {total:4,list:[{},{},....]}
             */
            //这里是视图
            string sortname = context.Request["sortName"];
            string sortorder = context.Request["sortOrder"];
            if (string.IsNullOrEmpty(sortorder))
            {
                sortorder = "asc";
            }
            string pagenumber1 = context.Request["page"];
            if (context.Request["page"] == null)//异常处理
            { pagenumber1 = "1"; }
            string _pagesize = context.Request["pagesize"];
            if (context.Request["pagesize"] == null)
            { _pagesize = "30"; }

            string methodName = context.Request["methodName"];
            string postUrl = "";

            if (methodName == "detectionDatas")
            {
                postUrl = "/detectionDatas?pageNum=" + pagenumber1 + "&pageSize=" + _pagesize + "&orderBy=" + sortname + Urlparam1;
            }
            else if (methodName == "taskTemplates")
            {
                postUrl = "/taskTemplates?&pageNum=" + pagenumber1 + "&pageSize=" + _pagesize + "&orderBy=" + sortname + Urlparam1;
            }
            else if (methodName == "taskPlans")
            {
                postUrl = "/taskPlans?&pageNum=" + pagenumber1 + "&pageSize=" + _pagesize + "&orderBy=" + sortname + Urlparam1;
            }



            string Authorization = "Authorization:Bearer " + public_token;
            string url = PublicMethod.Public_GetWebConfigStr("interFaceUrl") + postUrl;
            System.Collections.Generic.List<string> l = new System.Collections.Generic.List<string>();
            System.Net.CookieContainer cs = new System.Net.CookieContainer();
            l.Add(Authorization);
            HttpHeader_new hd = new HttpHeader_new();
            hd.l_strp = l;
            string html = HTMLHelper_new.GetHtml(url, hd, cs);
            if (!string.IsNullOrEmpty(html))
            {
                httpReturnGridJson hgj = new httpReturnGridJson();
                try
                {
                    JObject o = JObject.Parse(html);
                    JArray ja = JArray.Parse(o["data"]["list"].ToString());
                    hgj.success = bool.Parse(o["success"].ToString());
                    hgj.detail = o["detail"].ToString();
                    hgj.Total = int.Parse(o["data"]["total"].ToString());
                    hgj.Rows = ja;
                }
                catch (Exception ex)
                {
                    string[] strArray = { };
                    hgj.success = false;
                    hgj.detail = "返回数据格式有误";
                    hgj.Total = 0;
                    hgj.Rows = strArray;
                }
                json = Newtonsoft.Json.JsonConvert.SerializeObject(hgj);

            }


        }
        else if (view == "http_getGridMethod")
        {
            string Urlparam1 = "";//这里是默认加到后面的
            if (context.Request["param1"] != null)
            {
                string para1 = context.Request["param1"].ToString();
                JArray ja = JArray.Parse(para1);
                foreach (var o in ja)
                {
                    Urlparam1 += "&" + o["key"].ToString() + "=" + o["value"].ToString();
                }
            }


            //这种支持
            /*
             
                [{},{},....]
             */
            //这里是视图
            string sortname = context.Request["sortName"];
            string sortorder = context.Request["sortOrder"];
            if (string.IsNullOrEmpty(sortorder))
            {
                sortorder = "asc";
            }
            string pagenumber1 = context.Request["page"];
            if (context.Request["page"] == null)//异常处理
            { pagenumber1 = "1"; }
            string _pagesize = context.Request["pagesize"];
            if (context.Request["pagesize"] == null)
            { _pagesize = "30"; }

            string methodName = context.Request["methodName"];
            string postUrl = "";

            if (methodName == "detectionDatas")
            {
                postUrl = "/taskFinishs/1/detectionDatas?status=&pageNum=" + pagenumber1 + "&pageSize=" + _pagesize + "&orderBy=" + sortname + Urlparam1;
            }
            else if (methodName == "detectionDatas22")
            {
                postUrl = "/taskFinishs/1/detectionDatas?status=&pageNum=" + pagenumber1 + "&pageSize=" + _pagesize + "&orderBy=" + sortname + Urlparam1;
            }
            else if (methodName == "taskTemplates")
            {
                postUrl = "/taskFinishs/1/detectionDatas?status=&pageNum=" + pagenumber1 + "&pageSize=" + _pagesize + "&orderBy=" + sortname + Urlparam1;
            }
            else if (methodName == "unusual")
            {
                postUrl = "/meters/detectionDatas/latest?pageNum=" + pagenumber1 + "&pageSize=" + _pagesize + "&orderBy=" + sortname + Urlparam1;
            }
            else if (methodName == "taskReport")
            {
                postUrl = "/taskFinish/search/timeAndTypes?&pageNum=" + pagenumber1 + "&pageSize=" + _pagesize + "&orderBy=" + sortname + Urlparam1;
            }
            else if (methodName == "getUser")
            {
                postUrl = "/users?&pageNum=" + pagenumber1 + "&pageSize=" + _pagesize + "&orderBy=" + sortname + Urlparam1;
            }

            string Authorization = "Authorization:Bearer " + public_token;
            string url = PublicMethod.Public_GetWebConfigStr("interFaceUrl") + postUrl;
            System.Collections.Generic.List<string> l = new System.Collections.Generic.List<string>();
            System.Net.CookieContainer cs = new System.Net.CookieContainer();
            l.Add(Authorization);
            HttpHeader_new hd = new HttpHeader_new();
            hd.l_strp = l;
            string html = HTMLHelper_new.GetHtml(url, hd, cs);

            httpReturnGridJson hgj = new httpReturnGridJson();
            if (!string.IsNullOrEmpty(html))
            {

                try
                {
                    JObject o = JObject.Parse(html);
                    JArray ja = JArray.Parse(o["data"].ToString());
                    hgj.success = bool.Parse(o["success"].ToString());
                    hgj.detail = o["detail"].ToString();
                    hgj.Total = ja.Count;
                    hgj.Rows = ja;
                }
                catch (Exception ex)
                {
                    string[] strArray = { };
                    hgj.success = false;
                    hgj.detail = "返回数据格式有误";
                    hgj.Total = 0;
                    hgj.Rows = strArray;
                }
            }
            else
            {
                string[] strArray = { };
                hgj.success = true;
                hgj.detail = "返回数据格式有误";
                hgj.Total = 0;
                hgj.Rows = strArray;
            }
            json = Newtonsoft.Json.JsonConvert.SerializeObject(hgj);

        }
        return json;
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}