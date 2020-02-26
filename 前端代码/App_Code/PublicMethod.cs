using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text.RegularExpressions;
using System.Net;
using System.Net.Sockets;
using System.Data;




/// <summary>
///PublicMethod 的摘要说明
/// </summary>
public class PublicMethod
{
    

   
    

	public PublicMethod()
	{
		//
		//TODO: 在此处添加构造函数逻辑
		//

	}

    /// <summary>
    /// 通过右侧树获取 sql
    /// </summary>
    /// <param name="where1"> C1,C2|D1 </param>
    /// <returns></returns>
    public static string getTreeSql(string where1)
    {
        string wherea = "";

        if (where1.Replace(@"|", "") == "")
        {
            wherea = " and 1=0";
        }
        else
        {
            where1 = ReplaceStr.Replace(where1);
            string[] LvArray = where1.Split('|');//级别分割，9级
            wherea = wherea + " and(";
            for (int i = 0; i < LvArray.Length; i++)//循环每级
            {
                if (LvArray[i].Length > 0)
                {
                    wherea = wherea + GetLevelInfo.getLevelSelect(LvArray[i]) + " or ";
                }
            }
            if (where1.Length > 3)
            {
                wherea = wherea.Substring(0, wherea.Length - 3) + ")";
            }
        }

        return wherea;
    }

    public static string getTreeSql_all(string where1)
    {
        string wherea = "";

        if (where1.Replace(@"|", "") == "")
        {
            wherea = " and 1=1";
        }
        else
        {
            where1 = ReplaceStr.Replace(where1);
            string[] LvArray = where1.Split('|');//级别分割，9级
            wherea = wherea + " and(";
            for (int i = 0; i < LvArray.Length; i++)//循环每级
            {
                if (LvArray[i].Length > 0)
                {
                    wherea = wherea + GetLevelInfo.getLevelSelect(LvArray[i]) + " or ";
                }
            }
            if (where1.Length > 3)
            {
                wherea = wherea.Substring(0, wherea.Length - 3) + ")";
            }
        }

        return wherea;
    }

    public static string getTreeSql_2018(string where1)
    {
        string strReturn = "";
        if (!string.IsNullOrEmpty(where1))
        {
            strReturn = " and (1=0 ";
            string[] strArray = where1.Split(',');
            for (int i = 0; i < strArray.Length; i++) { 
                strReturn+=" or "+GetLevelInfo.GetLevelField(strArray[i].Substring(0,1))+"='"+strArray[i].Substring(1)+"'";
            }
            strReturn += ")";
        }
        return strReturn;
    }

    /// <summary>
    /// 得到 config中配置的数据
    /// </summary>
    /// <returns></returns>
    public static string public_getConfigStr(string key)
    {
        string strReturn = "";
        try
        {
            strReturn = System.Configuration.ConfigurationManager.AppSettings[key];
        }
        catch(Exception ex)
        {
            strReturn = "";
        }
        return strReturn;
    }

    /// <summary>
    /// 得到随机数方法
    /// </summary>
    /// <returns></returns>
    public static string public_getRadNum()
    {
        Random ran = new Random();
        string strReturn = System.DateTime.Now.ToString("yyyyMMddHHmmss") + ran.Next(1, 9999).ToString();
        return strReturn;
    }
    /// <summary>
    /// 得到随机数方法
    /// </summary>
    /// <returns></returns>
    public static string public_getRadNum(string type)
    {
        Random ran = new Random();
        string strReturn = type+System.DateTime.Now.ToString("yyyyMMddHHmmss") + ran.Next(1, 9999).ToString();
        return strReturn;
    }
    

    /// <summary>
    /// 是否为日期型字符串
    /// </summary>
    /// <param name="StrSource">日期字符串(2008-05-08)</param>
    /// <returns></returns>
    public static bool IsDate(string StrSource)
    {
        bool b = false;
        try
        {
            DateTime dt = DateTime.Parse(StrSource);
            b = true;
        }
        catch
        { 
        }
        return b;
        //return Regex.IsMatch(StrSource, @"^((((1[6-9]|[2-9]\d)\d{2})-(0?[13578]|1[02])-(0?[1-9]|[12]\d|3[01]))|(((1[6-9]|[2-9]\d)\d{2})-(0?[13456789]|1[012])-(0?[1-9]|[12]\d|30))|(((1[6-9]|[2-9]\d)\d{2})-0?2-(0?[1-9]|1\d|2[0-9]))|(((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))-0?2-29-))$");
    }

    /// <summary>
    /// 是否为时间型字符串
    /// </summary>
    /// <param name="source">时间字符串(15:00:00)</param>
    /// <returns></returns>
    public static bool IsTime(string StrSource)
    {
        return Regex.IsMatch(StrSource, @"^((20|21|22|23|[0-1]?\d):[0-5]?\d:[0-5]?\d)$");
    }

    /// <summary>
    /// 是否为日期+时间型字符串
    /// </summary>
    /// <param name="source"></param>
    /// <returns></returns>
    public static bool IsDateTime(string StrSource)
    {
        if (StrSource == "")
        {
            return false;
        }
        return Regex.IsMatch(StrSource, @"^(((((1[6-9]|[2-9]\d)\d{2})-(0?[13578]|1[02])-(0?[1-9]|[12]\d|3[01]))|(((1[6-9]|[2-9]\d)\d{2})-(0?[13456789]|1[012])-(0?[1-9]|[12]\d|30))|(((1[6-9]|[2-9]\d)\d{2})-0?2-(0?[1-9]|1\d|2[0-8]))|(((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))-0?2-29-)) (20|21|22|23|[0-1]?\d):[0-5]?\d:[0-5]?\d)$");
    }



    //是否是整数
    public static bool IsInt(string StrSource)
    {
        if (StrSource == "")
        {
            return false;
        }

       return Regex.IsMatch(StrSource, @"^[0-9]*$");
        
    }

    //是否是浮点型
    public static bool IsFloat(string StrSource)
    {
        if (StrSource == "")
        {
            return false;
        }
        return Regex.IsMatch(StrSource, @"^((-{0,1}[0-9]+[\\.]?[0-9]+)|-{0,1}[0-9])$");
    }


    public static bool checkStringInArray(string str,string strList)
    {
        bool b = false;
        string[] strArray = strList.Split(',');
        if(strArray.Length>0)
        {
            for (int i = 0; i < strArray.Length; i++)
            {
                if (str == strArray[i])
                {
                    b = true;
                    break;
                }
                
            }
        }
        return b;
    }
    /// <summary>
    /// 返回webconfig中配置 <add key="i_shangjibiao_index" value="17" />
    /// </summary>
    /// <returns></returns>
    public static int Public_return_execl_shangjibiao_postion()
    {
        string str_i_shangjibiao_postion = System.Configuration.ConfigurationManager.AppSettings["i_shangjibiao_index"];
        int i_shangjibiao_postion = 17;
        try
        {
            i_shangjibiao_postion = int.Parse(str_i_shangjibiao_postion);
        }
        catch
        { }
        return i_shangjibiao_postion;
    }

    /// <summary>
    /// 返回webconfig中配置 <add key="i_shangjibiao_index" value="17" />
    /// </summary>
    /// <returns></returns>
    public static string Public_GetWebConfigStr(string key)
    {
        string strReturn = "";
        try
        {
            strReturn = System.Configuration.ConfigurationManager.AppSettings[key];
        }
        catch
        { }
        return strReturn;
    }

    /// <summary>
    /// 获取客户端IP地址
    /// </summary>
    /// <returns></returns>
    public static string GetIPAddress()
    {
        string user_IP = string.Empty;
        if (System.Web.HttpContext.Current.Request.ServerVariables["HTTP_VIA"] != null)
        {
            if (System.Web.HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"] != null)
            {
                user_IP = System.Web.HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"].ToString();
            }
            else
            {
                user_IP = System.Web.HttpContext.Current.Request.UserHostAddress;
            }
        }
        else
        {
            user_IP = System.Web.HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString();
        }
        return user_IP;
    }

    
    /// <summary>
    /// 判断有效的ip
    /// </summary>
    /// <param name="ip"></param>
    /// <returns></returns>
    public static bool RunSnippet(string ip)
    {
        Regex rx = new Regex(@"((?:(?:25[0-5]|2[0-4]\d|((1\d{2})|([1-9]?\d)))\.){3}(?:25[0-5]|2[0-4]\d|((1\d{2})|([1-9]?\d))))");
        if (rx.IsMatch(ip))
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    
    /// <summary>
    /// dt 排序
    /// </summary>
    /// <param name="dt"></param>
    /// <param name="sortname"></param>
    /// <param name="sortorder"></param>
    /// <returns></returns>
    public static DataTable Public_getSorcDt(DataTable dt, string sortname, string sortorder)
    {
        DataTable dt2 = new DataTable();
        if (dt != null)
        {
            if (sortname != "")
            {
                if (sortorder == "")
                {
                    sortorder = " asc";
                }

                 DataView dv = dt.DefaultView; 
                dv.Sort = sortname+" "+sortorder;
                dt2 = dv.ToTable();
            }
        }
       
        return dt2;
    }
    /// <summary>
    /// 得到命令随机码 RZ2016022344511111221
    /// </summary>
    /// <returns></returns>
    public static string getRadNum(string strType)
    {
        Random ran = new Random();
        string strReturn = strType + System.DateTime.Now.ToString("yyyyMMddHHmmss") + ran.Next(1000, 9999).ToString();
        return strReturn;
    }

    /// <summary>
    /// 得到热表新的流水编码 RZ2016022344511111221
    /// </summary>
    /// <returns></returns>
    public static string getMeterNewLsh(string meter_id,string azDate)
    {
        Random ran = new Random();
        string strsql = "";
        string strReturn = meter_id + azDate + ran.Next(1000, 9999).ToString();
        return strReturn;
    }

    /// <summary>
    /// 得到两个时间点相差的是 毫秒数
    /// </summary>
    /// <returns></returns>
    public static int getDateTime_RunTime(DateTime dt_begin,DateTime dt_end,string type)
    {
        int iReturn = 0;
        TimeSpan ts = dt_end - dt_begin;
        if (type == "Seconds")
        {
            iReturn = ts.Seconds;
        }
        else
        {
            iReturn = ts.Milliseconds;//毫秒默认毫秒
        }
        return iReturn;
    }

   

}