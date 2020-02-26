<%@ WebHandler Language="C#" Class="InterFace" %>

using System;
using System.Web;
using Newtonsoft.Json.Linq;

public class InterFace : IHttpHandler
{


    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string method = context.Request["method"];
        string strReturn = "";
        if (method == "httpGetToken")
        {

            strReturn = httpGetToken(context);
        }
        else if (method == "http_getMethod")
        {

            strReturn = http_getMethod(context);
        }
        else if (method == "http_PostMethod")
        {

            strReturn = http_PostMethod(context);
        }

        else if (method == "http_PutMethod")
        {

            strReturn = http_PutMethod(context);
        }
        else if (method == "http_DelMethod")
        {

            strReturn = http_DeleteMethod(context);
        }


        else if (method == "http_PostMethod")
        {

            strReturn = http_PostMethod(context);
        }


        else if (method == "http_getGridMethod")
        {

            strReturn = http_getGridMethod(context);
        }

        else if (method == "http_getGridMethod_expend")
        {

            strReturn = http_getGridMethod_expend(context);
        }
        else if (method == "http_getGridMethod_expend2")
        {

            strReturn = http_getGridMethod_expend2(context);
        }
        else if (method == "login")
        {

            strReturn = login(context);
        }
        else if (method == "doTask")
        {

            strReturn = doTask(context);
        }
        else if (method == "getTaskTempletList")
        {
            strReturn = getTaskTempletList(context);
        }
        else if (method == "createTaskTempletList")
        {
            strReturn = createTaskTempletList(context);
        }
        else if (method == "robotmotion")
        {
            strReturn = robotmotion(context);
        }
        else if (method == "getTaskListByMonth")
        {
            strReturn = getTaskListByMonth(context);
        }
        else if (method == "delTask")
        {
            strReturn = delTask(context);
        }
        else if (method == "getTaskListByConditions")
        {
            strReturn = getTaskListByConditions(context);
        }
        else if (method == "getTaskStates")
        {
            strReturn = getTaskStates(context);
        }
        else if (method == "getSystemWarningInfo")
        {
            strReturn = getSystemWarningInfo(context);
        }
        else if (method == "getDeviceWarningInfo")
        {
            strReturn = getDeviceWarningInfo(context);
        }
        else if (method == "getTaskStatistics")
        {
            strReturn = getTaskStatistics(context);
        }

        context.Response.Write(strReturn);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="MethodUrl">/areas</param>
    /// <param name="Authorization">Authorization:Bearer+token </param>
    /// <param name="values"></param>
    /// <returns></returns>
    private string login(HttpContext context)
    {
        string username = context.Request["username"].ToString();
        string password = context.Request["password"].ToString();
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
            strReturn = html;
        }


        return strReturn;

    }
    /// <summary>
    /// 任务执行
    /// </summary>
    /// <param name="context"></param>
    /// <returns></returns>
    private string doTask(HttpContext context)
    {
        string Authorization = context.Request["token"].ToString();
        Authorization = "Authorization:Bearer " + Authorization;
        //taskType
        //qmxj(全面巡检)、lxxj(例行巡检)、hwxj(红外巡检)、ywcb(油位抄表)、blz(避雷针)、sfyl(sf压力)、yyb(液压表抄录)、wzzt（位置状态识别）、lltq（恶劣天气巡检）、qxxj
        string taskType = context.Request["taskType"].ToString();
        //机器人id
        string robotId = context.Request["robotId"].ToString();
        string taskId = context.Request["taskId"].ToString();
        //任务类型 立即执行任务 doTaskTempletNow；定期执行任务 doTaskTempletRegular1；周期执行任务doTaskTempletRegular2
        string doTaskType = context.Request["doTaskType"].ToString();
        string strReturn = "";//是否可以获取 token
                              //立即执行任务
        string url = PublicMethod.Public_GetWebConfigStr("interFaceUrl") + "/doTaskNow";
        System.Collections.Generic.List<string> l = new System.Collections.Generic.List<string>();
        System.Net.CookieContainer cs = new System.Net.CookieContainer();
        HttpHeader_new hd = new HttpHeader_new();
        l.Add(Authorization);
        hd.l_strp = l;
        string postData = "";
        //定期执行任务
        if (doTaskType.Equals("doTaskTempletRegular1"))
        {
            url = PublicMethod.Public_GetWebConfigStr("interFaceUrl") + "/setTaskRegular";
            //执行时间
            string doTime = context.Request["robotId"].ToString();
            postData = "taskType=" + taskType + "&robotId=" + robotId + "&doTime=" + doTime;
        }
        //周期执行任务
        else if (doTaskType.Equals("doTaskTempletRegular2"))
        {
            url = PublicMethod.Public_GetWebConfigStr("interFaceUrl") + "/setTaskCycle";
            //执行时间
            string doTime = context.Request["robotId"].ToString();
            //间隔类型
            string spaceType = context.Request["spaceType"].ToString();
            postData = "taskType=" + taskType + "&robotId=" + robotId + "&doTime=" + doTime + "&spaceType=" + spaceType;
        }
        //string postData = "username=" + username + "&password=" + password;
        string html = HTMLHelper_new.GetHtml_Post(url, postData, hd, cs);

        if (!string.IsNullOrEmpty(html))
        {
            strReturn = html;
        }


        return strReturn;
    }
    /// <summary>
    /// 读取巡检任务模板列表
    /// </summary>
    /// <param name="context"></param>
    /// <returns></returns>
    private string getTaskTempletList(HttpContext context)
    {

        string MethodUrl = "/getTaskTempletList";
        string Authorization = context.Request["token"].ToString();
        string taskType = context.Request["taskType"].ToString();
        Authorization = "Authorization:Bearer " + Authorization;
        string strReturn = "";//是否可以获取 token
        string url = PublicMethod.Public_GetWebConfigStr("interFaceUrl") + MethodUrl;
        System.Collections.Generic.List<string> l = new System.Collections.Generic.List<string>();
        System.Net.CookieContainer cs = new System.Net.CookieContainer();
        l.Add(Authorization);
        HttpHeader_new hd = new HttpHeader_new();
        hd.l_strp = l;
        string postData = "taskType=" + taskType;
        string html = HTMLHelper_new.GetHtml_Post(url, postData, hd, cs);

        if (!string.IsNullOrEmpty(html))
        {
            strReturn = html;
        }


        return strReturn;
    }
    /// <summary>
    /// 删除任务
    /// </summary>
    /// <param name="context"></param>
    /// <returns></returns>
    private string delTask(HttpContext context)
    {
        string MethodUrl = "/delTask";
        string Authorization = context.Request["token"].ToString();
        string taskId = context.Request["taskId"].ToString();
        Authorization = "Authorization:Bearer " + Authorization;
        string strReturn = "";//是否可以获取 token
        string url = PublicMethod.Public_GetWebConfigStr("interFaceUrl") + MethodUrl;
        System.Collections.Generic.List<string> l = new System.Collections.Generic.List<string>();
        System.Net.CookieContainer cs = new System.Net.CookieContainer();
        l.Add(Authorization);
        HttpHeader_new hd = new HttpHeader_new();
        hd.l_strp = l;
        string postData = "taskId=" + taskId;
        string html = HTMLHelper_new.GetHtml_Post(url, postData, hd, cs);

        if (!string.IsNullOrEmpty(html))
        {
            strReturn = html;
        }


        return strReturn;
    }
    /// <summary>
    /// 保存新增巡检任务模板
    /// </summary>
    /// <param name="context"></param>
    /// <returns></returns>
    private string createTaskTempletList(HttpContext context)
    {
        string MethodUrl = "/createTaskTempletList";
        string Authorization = context.Request["token"].ToString();
        string meters = context.Request["meters"].ToString();
        string taskName = context.Request["taskName"].ToString();
        string taskType = context.Request["taskType"].ToString();
        Authorization = "Authorization:Bearer " + Authorization;
        string strReturn = "";//是否可以获取 token
        string url = PublicMethod.Public_GetWebConfigStr("interFaceUrl") + MethodUrl;
        System.Collections.Generic.List<string> l = new System.Collections.Generic.List<string>();
        System.Net.CookieContainer cs = new System.Net.CookieContainer();
        l.Add(Authorization);
        HttpHeader_new hd = new HttpHeader_new();
        hd.l_strp = l;
        string postData = "taskName=" + taskName + "&meters=" + meters + "&taskType=" + taskType;
        string html = HTMLHelper_new.GetHtml_Post(url, postData, hd, cs);

        if (!string.IsNullOrEmpty(html))
        {
            strReturn = html;
        }


        return strReturn;
    }
    /// <summary>
    /// 按月获取任务列表
    /// </summary>
    /// <param name="context"></param>
    /// <returns></returns>
    private string getTaskListByMonth(HttpContext context)
    {

        string MethodUrl = "/getTaskListByMonth";
        string Authorization = context.Request["token"].ToString();
        string month = context.Request["month"].ToString();
        Authorization = "Authorization:Bearer " + Authorization;
        string strReturn = "";//是否可以获取 token
        string url = PublicMethod.Public_GetWebConfigStr("interFaceUrl") + MethodUrl;
        System.Collections.Generic.List<string> l = new System.Collections.Generic.List<string>();
        System.Net.CookieContainer cs = new System.Net.CookieContainer();
        l.Add(Authorization);
        HttpHeader_new hd = new HttpHeader_new();
        hd.l_strp = l;
        string postData = "month=" + month;
        string html = HTMLHelper_new.GetHtml_Post(url, postData, hd, cs);

        if (!string.IsNullOrEmpty(html))
        {
            strReturn = html;
        }


        return strReturn;
    }
    /// <summary>
    /// 按条件查询任务列表
    /// </summary>
    /// <param name="context"></param>
    /// <returns></returns>
    private string getTaskListByConditions(HttpContext context)
    {

        string MethodUrl = "/getTaskListByConditions";
        string Authorization = context.Request["token"].ToString();
        //
        string taskName = context.Request["taskName"].ToString();
        string states = context.Request["states"].ToString();
        string beginTime = context.Request["beginTime"].ToString();
        string endTime = context.Request["endTime"].ToString();

        Authorization = "Authorization:Bearer " + Authorization;
        string strReturn = "";//是否可以获取 token
        string url = PublicMethod.Public_GetWebConfigStr("interFaceUrl") + MethodUrl;
        System.Collections.Generic.List<string> l = new System.Collections.Generic.List<string>();
        System.Net.CookieContainer cs = new System.Net.CookieContainer();
        l.Add(Authorization);
        HttpHeader_new hd = new HttpHeader_new();
        hd.l_strp = l;
        string postData = "taskName=" + taskName + "&states=" + states + "&beginTime=" + beginTime + "&endTime=" + endTime;
        string html = HTMLHelper_new.GetHtml_Post(url, postData, hd, cs);

        if (!string.IsNullOrEmpty(html))
        {
            strReturn = html;
        }


        return strReturn;
    }
    /// <summary>
    /// 实时信息
    /// </summary>
    /// <param name="context"></param>
    /// <returns></returns>
    private string getTaskStates(HttpContext context)
    {

        string MethodUrl = "/getTaskStates";
        string Authorization = context.Request["token"].ToString();
        //
        string robotId = context.Request["robotId"].ToString();

        Authorization = "Authorization:Bearer " + Authorization;
        string strReturn = "";//是否可以获取 token
        string url = PublicMethod.Public_GetWebConfigStr("interFaceUrl") + MethodUrl;
        System.Collections.Generic.List<string> l = new System.Collections.Generic.List<string>();
        System.Net.CookieContainer cs = new System.Net.CookieContainer();
        l.Add(Authorization);
        HttpHeader_new hd = new HttpHeader_new();
        hd.l_strp = l;
        string postData = "robotId=" + robotId;
        string html = HTMLHelper_new.GetHtml_Post(url, postData, hd, cs);

        if (!string.IsNullOrEmpty(html))
        {
            strReturn = html;
        }


        return strReturn;
    }
    /// <summary>
    /// 系统告警信息
    /// </summary>
    /// <param name="context"></param>
    /// <returns></returns>
    private string getSystemWarningInfo(HttpContext context)
    {

        string MethodUrl = "/getSystemWarningInfo";
        string Authorization = context.Request["token"].ToString();
        //
        string robotId = context.Request["robotId"].ToString();

        Authorization = "Authorization:Bearer " + Authorization;
        string strReturn = "";//是否可以获取 token
        string url = PublicMethod.Public_GetWebConfigStr("interFaceUrl") + MethodUrl;
        System.Collections.Generic.List<string> l = new System.Collections.Generic.List<string>();
        System.Net.CookieContainer cs = new System.Net.CookieContainer();
        l.Add(Authorization);
        HttpHeader_new hd = new HttpHeader_new();
        hd.l_strp = l;
        string postData = "robotId=" + robotId;
        string html = HTMLHelper_new.GetHtml_Post(url, postData, hd, cs);

        if (!string.IsNullOrEmpty(html))
        {
            strReturn = html;
        }


        return strReturn;
    }
    /// <summary>
    /// 设备告警信息
    /// </summary>
    /// <param name="context"></param>
    /// <returns></returns>
    private string getDeviceWarningInfo(HttpContext context)
    {

        string MethodUrl = "/getDeviceWarningInfo";
        string Authorization = context.Request["token"].ToString();
        //
        string robotId = context.Request["robotId"].ToString();

        Authorization = "Authorization:Bearer " + Authorization;
        string strReturn = "";//是否可以获取 token
        string url = PublicMethod.Public_GetWebConfigStr("interFaceUrl") + MethodUrl;
        System.Collections.Generic.List<string> l = new System.Collections.Generic.List<string>();
        System.Net.CookieContainer cs = new System.Net.CookieContainer();
        l.Add(Authorization);
        HttpHeader_new hd = new HttpHeader_new();
        hd.l_strp = l;
        string postData = "robotId=" + robotId;
        string html = HTMLHelper_new.GetHtml_Post(url, postData, hd, cs);

        if (!string.IsNullOrEmpty(html))
        {
            strReturn = html;
        }


        return strReturn;
    }
    /// <summary>
    /// 任务状况统计信息
    /// </summary>
    /// <param name="context"></param>
    /// <returns></returns>
    private string getTaskStatistics(HttpContext context)
    {

        string MethodUrl = "/getTaskStatistics";
        string Authorization = context.Request["token"].ToString();
        //
        string robotId = context.Request["robotId"].ToString();

        Authorization = "Authorization:Bearer " + Authorization;
        string strReturn = "";//是否可以获取 token
        string url = PublicMethod.Public_GetWebConfigStr("interFaceUrl") + MethodUrl;
        System.Collections.Generic.List<string> l = new System.Collections.Generic.List<string>();
        System.Net.CookieContainer cs = new System.Net.CookieContainer();
        l.Add(Authorization);
        HttpHeader_new hd = new HttpHeader_new();
        hd.l_strp = l;
        string postData = "robotId=" + robotId;
        string html = HTMLHelper_new.GetHtml_Post(url, postData, hd, cs);

        if (!string.IsNullOrEmpty(html))
        {
            strReturn = html;
        }
        return strReturn;
    }

    /// <summary>
    /// 机器人运动控制
    /// </summary>
    /// <param name="context"></param>
    /// <returns></returns>
    private string robotmotion(HttpContext context)
    {
        string MethodUrl = "/robot-motion";
        string Authorization = context.Request["token"].ToString();
        string operation = context.Request["operation"].ToString();
        string speed = context.Request["speed"].ToString();

        Authorization = "Authorization:Bearer " + Authorization;
        string strReturn = "";//是否可以获取 token
        string url = PublicMethod.Public_GetWebConfigStr("interFaceUrl") + MethodUrl;
        System.Collections.Generic.List<string> l = new System.Collections.Generic.List<string>();
        System.Net.CookieContainer cs = new System.Net.CookieContainer();
        l.Add(Authorization);
        HttpHeader_new hd = new HttpHeader_new();
        hd.l_strp = l;
        string postData = "operation=" + operation + "&speed=" + speed;
        string html = HTMLHelper_new.GetHtml_Post(url, postData, hd, cs);

        if (!string.IsNullOrEmpty(html))
        {
            strReturn = html;
        }


        return strReturn;
    }
    /// <summary>
    /// 
    /// </summary>
    /// <param name="MethodUrl">/areas</param>
    /// <param name="Authorization">Authorization:Bearer+token </param>
    /// <param name="values"></param>
    /// <returns></returns>
    private string http_getMethod(HttpContext context)
    {
        string MethodUrl = context.Request["MethodUrl"].ToString();
        string Authorization = context.Request["token"].ToString();
        Authorization = "Authorization:Bearer " + Authorization;
        string strReturn = "";//是否可以获取 token
        string url = PublicMethod.Public_GetWebConfigStr("interFaceUrl") + MethodUrl;
        System.Collections.Generic.List<string> l = new System.Collections.Generic.List<string>();
        System.Net.CookieContainer cs = new System.Net.CookieContainer();
        l.Add(Authorization);
        HttpHeader_new hd = new HttpHeader_new();
        hd.l_strp = l;
        string html = HTMLHelper_new.GetHtml(url, hd, cs);

        if (!string.IsNullOrEmpty(html))
        {
            ////针对 破解一次
            //try
            //{
            //    JObject jo= JObject.Parse(html);
            //    if (jo["data"] == null)
            //    {
            //        strReturn = html;
            //    }
            //    else {
            //        strReturn = Newtonsoft.Json.JsonConvert.SerializeObject(jo["data"]);//拆开
            //    }
            //}
            //catch { 
            //}
            strReturn = html;
        }


        return strReturn;

    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="MethodUrl">/areas</param>
    /// <param name="Authorization">Authorization:Bearer+token </param>
    /// <param name="values"></param>
    /// <returns></returns>
    private string http_getGridMethod(HttpContext context)
    {
        httpReturnGridJson hgj = new httpReturnGridJson();

        string MethodUrl = context.Request["MethodUrl"].ToString();
        string Authorization = context.Request["token"].ToString();
        Authorization = "Authorization:Bearer " + Authorization;

        string url = PublicMethod.Public_GetWebConfigStr("interFaceUrl") + MethodUrl;
        System.Collections.Generic.List<string> l = new System.Collections.Generic.List<string>();
        System.Net.CookieContainer cs = new System.Net.CookieContainer();
        l.Add(Authorization);
        HttpHeader_new hd = new HttpHeader_new();
        hd.l_strp = l;
        string html = HTMLHelper_new.GetHtml(url, hd, cs);

        if (!string.IsNullOrEmpty(html))
        {
            try
            {
                JObject jo = JObject.Parse(html);
                if (jo["success"].ToString() == "true")
                {
                    if (jo["data"] != null)
                    {
                        if (jo["data"]["list"] != null)
                        {
                            html = jo["data"]["list"].ToString();
                            JArray ja = JArray.Parse(html);
                            hgj.success = bool.Parse(jo["success"].ToString());
                            hgj.detail = jo["detail"].ToString();
                            hgj.Total = ja.Count;
                            hgj.Rows = ja;
                        }
                        else
                        {
                            string[] strArray = { };
                            hgj.success = bool.Parse(jo["success"].ToString()) ;
                            hgj.detail = jo["detail"].ToString();
                            hgj.Total = 0;
                            hgj.Rows = strArray;
                        }
                    }
                    else
                    {
                        string[] strArray = { };
                        hgj.success = bool.Parse(jo["success"].ToString()) ;
                        hgj.detail = jo["detail"].ToString();
                        hgj.Total = 0;
                        hgj.Rows = strArray;
                    }
                }
                else
                {
                    string[] strArray = { };
                    hgj.success = bool.Parse(jo["success"].ToString()) ;
                    hgj.detail = jo["detail"].ToString();
                    hgj.Total = 0;
                    hgj.Rows = strArray;
                }

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
            hgj.success = false;
            hgj.detail = "返回数据为空";
            hgj.Total = 0;
            hgj.Rows = strArray;
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(hgj);

    }



    /// <summary>
    /// 从 http_getGridMethod 扩展来的 ，针对 接口类型
    /// {"total":1,"list":[{"uid":null,"taskName":null,"time":null,"status":null}]}
    /// </summary>
    /// <param name="MethodUrl">/areas</param>
    /// <param name="Authorization">Authorization:Bearer+token </param>
    /// <param name="values"></param>
    /// <returns></returns>
    private string http_getGridMethod_expend(HttpContext context)
    {
        httpReturnGridJson hgj = new httpReturnGridJson();

        string MethodUrl = context.Request["MethodUrl"].ToString();
        string Authorization = context.Request["token"].ToString();
        Authorization = "Authorization:Bearer " + Authorization;

        string ListName = context.Request["ListName"].ToString();

        string url = PublicMethod.Public_GetWebConfigStr("interFaceUrl") + MethodUrl;
        System.Collections.Generic.List<string> l = new System.Collections.Generic.List<string>();
        System.Net.CookieContainer cs = new System.Net.CookieContainer();
        l.Add(Authorization);
        HttpHeader_new hd = new HttpHeader_new();
        hd.l_strp = l;
        string html = HTMLHelper_new.GetHtml(url, hd, cs);

        if (!string.IsNullOrEmpty(html))
        {
            try
            {
                JObject jo = JObject.Parse(html);
                if (jo["success"].ToString().ToLower() == "true")
                {
                    if (jo["data"] != null)
                    {
                        if (jo["data"][ListName] != null)
                        {
                            string listname = jo["data"][ListName].ToString() ;
                            //html = jo["data"][ListName].ToString();
                            //JObject o = JObject.Parse(listname);
                            JArray ja = JArray.Parse(listname);
                            hgj.Total = ja.Count;
                            hgj.Rows = ja;
                            hgj.success = true;
                        }
                        else
                        {
                            string[] strArray = {};
                            hgj.success = bool.Parse(jo["success"].ToString()) ;
                            hgj.detail = jo["detail"].ToString();
                            hgj.Total = 0;
                            hgj.Rows = strArray;
                        }
                    }
                    else
                    {
                        string[] strArray = { };
                        hgj.success = bool.Parse(jo["success"].ToString()) ;
                        hgj.detail = jo["detail"].ToString();
                        hgj.Total = 0;
                        hgj.Rows = strArray;
                    }

                }
                else
                {
                    string[] strArray = { };
                    hgj.success = bool.Parse(jo["success"].ToString()) ;
                    hgj.detail = jo["detail"].ToString();
                    hgj.Total = 0;
                    hgj.Rows = strArray;
                }

            }
            catch (Exception ex)
            {
                string[] strArray = { };
                hgj.success = false;
                hgj.detail ="返回数据格式有误";
                hgj.Total = 0;
                hgj.Rows = strArray;
            }
        }
        else
        {
            string[] strArray = {};
            hgj.success = false;
            hgj.detail ="返回数据为空";
            hgj.Total = 0;
            hgj.Rows = strArray;
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(hgj);

    }


    private string http_getGridMethod_expend2(HttpContext context)
    {
        httpReturnGridJson hgj = new httpReturnGridJson();

        string MethodUrl = context.Request["MethodUrl"].ToString();
        string Authorization = context.Request["token"].ToString();
        Authorization = "Authorization:Bearer " + Authorization;

        //string ListName = context.Request["ListName"].ToString();

        string url = PublicMethod.Public_GetWebConfigStr("interFaceUrl") + MethodUrl;
        System.Collections.Generic.List<string> l = new System.Collections.Generic.List<string>();
        System.Net.CookieContainer cs = new System.Net.CookieContainer();
        l.Add(Authorization);
        HttpHeader_new hd = new HttpHeader_new();
        hd.l_strp = l;
        string html = HTMLHelper_new.GetHtml(url, hd, cs);

        if (!string.IsNullOrEmpty(html))
        {
            try
            {
                JObject jo = JObject.Parse(html);
                if (jo["success"].ToString().ToLower() == "true")
                {
                    if (jo["data"] != null)
                    {
                        string listname = jo["data"].ToString() ;
                        //html = jo["data"][ListName].ToString();
                        //JObject o = JObject.Parse(listname);
                        JArray ja = JArray.Parse(listname);
                        hgj.Total = ja.Count;
                        hgj.Rows = ja;
                        hgj.success = true;
                    }
                    else
                    {
                        string[] strArray = {};
                        hgj.success = bool.Parse(jo["success"].ToString()) ;
                        hgj.detail = jo["detail"].ToString();
                        hgj.Total = 0;
                        hgj.Rows = strArray;
                    }
                }
                else
                {
                    string[] strArray = { };
                    hgj.success = bool.Parse(jo["success"].ToString()) ;
                    hgj.detail = jo["detail"].ToString();
                    hgj.Total = 0;
                    hgj.Rows = strArray;
                }

            }
            catch (Exception ex)
            {
                string[] strArray = { };
                hgj.success = false;
                hgj.detail ="返回数据格式有误";
                hgj.Total = 0;
                hgj.Rows = strArray;
            }
        }
        else
        {
            string[] strArray = {};
            hgj.success = false;
            hgj.detail ="返回数据为空";
            hgj.Total = 0;
            hgj.Rows = strArray;
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(hgj);

    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="MethodUrl">/areas</param>
    /// <param name="Authorization">Authorization:Bearer+token </param>
    /// <param name="values"></param>
    /// <returns></returns>
    private string http_PostMethod(HttpContext context)
    {


        string MethodUrl = context.Request["MethodUrl"].ToString();
        string Authorization = context.Request["token"].ToString();
        Authorization = "Authorization:Bearer " + Authorization;
        string postData = context.Request["postData"].ToString();
        string strReturn = "";//是否可以获取 token
        string url = PublicMethod.Public_GetWebConfigStr("interFaceUrl") + MethodUrl;
        System.Collections.Generic.List<string> l = new System.Collections.Generic.List<string>();
        System.Net.CookieContainer cs = new System.Net.CookieContainer();
        l.Add(Authorization);
        l.Add("Content-Type:application/x-www-form-urlencoded");
        l.Add("Accept:*/*");
        HttpHeader_new hd = new HttpHeader_new();
        hd.l_strp = l;
        string html = HTMLHelper_new.GetHtml_Post(url, postData, hd, cs);

        if (!string.IsNullOrEmpty(html))
        {
            strReturn = html;
        }


        return strReturn;

    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="MethodUrl">/areas</param>
    /// <param name="Authorization">Authorization:Bearer+token </param>
    /// <param name="values"></param>
    /// <returns></returns>
    private string http_PutMethod(HttpContext context)
    {
        string MethodUrl = context.Request["MethodUrl"].ToString();
        string Authorization = "Content-Type:application/x-www-form-urlencoded ";
        string postData = context.Request["postData"].ToString();
        string strReturn = "";//是否可以获取 token
        string url = PublicMethod.Public_GetWebConfigStr("interFaceUrl") + MethodUrl;
        System.Collections.Generic.List<string> l = new System.Collections.Generic.List<string>();
        System.Net.CookieContainer cs = new System.Net.CookieContainer();
        l.Add(Authorization);
        HttpHeader_new hd = new HttpHeader_new();
        hd.l_strp = l;
        string html = HTMLHelper_new.GetHtml_Put(url, postData, hd, cs);

        if (!string.IsNullOrEmpty(html))
        {
            strReturn = html;
        }


        return strReturn;

    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="MethodUrl">/areas</param>
    /// <param name="Authorization">Authorization:Bearer+token </param>
    /// <param name="values"></param>
    /// <returns></returns>
    private string http_DeleteMethod(HttpContext context)
    {
        string MethodUrl = context.Request["MethodUrl"].ToString();
        string Authorization = context.Request["token"].ToString();
        Authorization = "Authorization:Bearer " + Authorization;
        string strReturn = "";//是否可以获取 token
        string url = PublicMethod.Public_GetWebConfigStr("interFaceUrl") + MethodUrl;
        System.Collections.Generic.List<string> l = new System.Collections.Generic.List<string>();
        System.Net.CookieContainer cs = new System.Net.CookieContainer();
        l.Add(Authorization);
        HttpHeader_new hd = new HttpHeader_new();
        hd.l_strp = l;
        string html = HTMLHelper_new.GetHtml_DELETE(url, hd, cs);

        if (!string.IsNullOrEmpty(html))
        {
            strReturn = html;
        }


        return strReturn;

    }




    private string httpGetToken(HttpContext content)
    {
        string strReturn = "";//是否可以获取 token
        string url = PublicMethod.Public_GetWebConfigStr("interFaceUrl") + "/users/login";
        System.Collections.Generic.List<string> l = new System.Collections.Generic.List<string>();
        System.Net.CookieContainer cs = new System.Net.CookieContainer();
        l.Add("Content-Type:application/x-www-form-urlencoded");
        HttpHeader_new hd = new HttpHeader_new();
        hd.l_strp = l;
        string postData = "username=mozhichao&password=123";
        string html = HTMLHelper_new.GetHtml_Post(url, postData, hd, cs);
        if (string.IsNullOrEmpty(html))
        {

        }
        else
        {
            try
            {
                JObject o = JObject.Parse(html);
                strReturn = o["token"].ToString();
            }
            catch (Exception ex)
            {

            }


        }
        return strReturn;
    }

    private string httpGetMethod(string token, string url, string data)
    {
        string strReturn = "";
        return strReturn;
    }
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}