using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Text;

/// <summary>
///字符串替换函数，防注入
/// </summary>
public static class ReplaceStr
{
    public static string Replace(string str)
    {
        #region 防注入
        str = str.Trim();
        str = str.Replace("'", "''");
        str = str.Replace(";--", "");
        str = str.Replace("=", "");
        str = str.Replace("and", "");
        str = str.Replace("exec", "");
        str = str.Replace("insert", "");
        str = str.Replace("select", "");
        str = str.Replace("delete", "");
        str = str.Replace("update", "");
        str = str.Replace("chr", "");
        str = str.Replace("mid", "");
        str = str.Replace("master", "");
        str = str.Replace("or", "");
        str = str.Replace("truncate", "");
        str = str.Replace("char", "");
        str = str.Replace("declare", "");
        str = str.Replace("join", "");
        str = str.Replace("count", "");
        str = str.Replace("*", "");
        str = str.Replace("%", "");
        str = str.Replace("union", "");
        return str;
        #endregion
    }

    #region datatable转换为json数据
    public static string DataTable2Json(DataTable dt)
    {
        StringBuilder jsonBuilder = new StringBuilder();
        jsonBuilder.Append("[");
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            jsonBuilder.Append("{");
            for (int j = 0; j < dt.Columns.Count; j++)
            {
                jsonBuilder.Append("\"");
                jsonBuilder.Append(dt.Columns[j].ColumnName);
                jsonBuilder.Append("\":\"");
                jsonBuilder.Append(replaceDoubleTosingle(dt.Rows[i][j].ToString()));
                jsonBuilder.Append("\",");
            }
            jsonBuilder.Remove(jsonBuilder.Length - 1, 1);
            jsonBuilder.Append("},");
        }
        jsonBuilder.Remove(jsonBuilder.Length - 1, 1);
        jsonBuilder.Append("]");
        return jsonBuilder.ToString();
    }
    #endregion

    #region datatable转换为json数据 并进行分页
    public static string DataTable2Json(DataTable dt,int index,int pageSize)
    {
        StringBuilder jsonBuilder = new StringBuilder();
        jsonBuilder.Append("[");
        int iBeginIndex = 1;
        int iEndIndex = pageSize;
        if (index > 1)
        {
            iBeginIndex = (index - 1) * pageSize + 1;
            iEndIndex = index * pageSize;
        }
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            if ((i + 1) >= iBeginIndex && (i + 1) <= iEndIndex) //这里进行主动分页
            {
                jsonBuilder.Append("{");
                for (int j = 0; j < dt.Columns.Count; j++)
                {
                    jsonBuilder.Append("\"");
                    jsonBuilder.Append(dt.Columns[j].ColumnName);
                    jsonBuilder.Append("\":\"");
                    jsonBuilder.Append(replaceDoubleTosingle(dt.Rows[i][j].ToString()));
                    jsonBuilder.Append("\",");
                }
                jsonBuilder.Remove(jsonBuilder.Length - 1, 1);
                jsonBuilder.Append("},");
            }
            
        }
        jsonBuilder.Remove(jsonBuilder.Length - 1, 1);
        jsonBuilder.Append("]");
        return jsonBuilder.ToString();
    }
    #endregion

    #region datatable转换为分页获取部分dt
    public static DataTable DataTable_partDt(DataTable dt, int index, int pageSize)
    {
        DataTable dtResult = new DataTable();
        dtResult = dt.Copy();
        dtResult.Rows.Clear();
        int iBeginIndex = 1;
        int iEndIndex = pageSize;
        if (index > 1)
        {
            iBeginIndex = (index - 1) * pageSize + 1;
            iEndIndex = index * pageSize;
        }
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            if ((i + 1) >= iBeginIndex && (i + 1) <= iEndIndex) //这里进行主动分页
            {
                DataRow dr = dtResult.NewRow();
                dr.ItemArray = dt.Rows[i].ItemArray;
                dtResult.Rows.Add(dr);
            }

        }

        return dtResult;
    }
    #endregion


    #region 返回时间段差值,小时
    /// <summary>
    /// 返回时间段差值,小时
    /// </summary>
    /// <param name="dateBegin">开始时间</param>
    /// <param name="dateEnd">结束时间</param>
    /// <returns>返回小时</returns>
    public static int ExecDateDiff(DateTime dateBegin, DateTime dateEnd)
    {
        TimeSpan ts1 = new TimeSpan(dateBegin.Ticks);
        TimeSpan ts2 = new TimeSpan(dateEnd.Ticks);
        TimeSpan ts3 = ts1.Subtract(ts2).Duration();
        //你想转的格式
        return Convert.ToInt32(ts3.TotalHours);
    }
    #endregion

    #region 把字符串中双引号，替换成单引号
    public static string replaceDoubleTosingle(string strText)
    {
        return strText.Replace("\"", "'");
    }
    #endregion
}