using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

/// <summary>
///获取动态级别类信息
/// </summary>
public class GetLevelInfo
{
    #region 获取级别字段
    /// <summary>
    /// 获取级别字段
    /// </summary>
    /// <param name="levFirst">首字母</param>
    /// <returns></returns>
    public static string GetLevelField(string levFirst)
    {
        string LevelField = "";
        switch (levFirst)
        {
            //case "A": LevelField = "Jt_id"; break;
            //case "B": LevelField = "Zgs_id"; break;
            //case "C": LevelField = "Fgs_id"; break;
            //case "D": LevelField = "K_id"; break;
            //case "E": LevelField = "jz_Hrz_id"; break;
            //case "F": LevelField = "jz_Xq_id"; break;
            //case "G": LevelField = "jz_Lh_id"; break;
            //case "H": LevelField = "jz_Dy_id"; break;

            case "A": LevelField = "Jt_id"; break;
            case "B": LevelField = "Zgs_id"; break;
            case "C": LevelField = "Fgs_id"; break;
            case "D": LevelField = "K_id"; break;
            case "E": LevelField = "Hrz_id"; break;
            case "F": LevelField = "Xq_id"; break;
            case "G": LevelField = "Lh_id"; break;
            case "H": LevelField = "Dy_id"; break;
            case "I": LevelField = "House_id"; break;


        }
        return LevelField;
    }
    public static string GetLevelField(char levFirst)
    {
        return GetLevelField(levFirst + "");
    }
    #endregion

    #region 获取级别字段，级别编号
    /// <summary>
    /// 获取级别字段,级别编号
    /// </summary>
    /// <param name="Lv_no">级别编号</param>
    /// <returns></returns>
    public static string GetLevelField1(string Lv_no)
    {
        string LevelField = "";
        switch (Lv_no)
        {
            case "1": LevelField = "Jt_id"; break;
            case "2": LevelField = "Zgs_id"; break;
            case "3": LevelField = "Fgs_id"; break;
            case "4": LevelField = "K_id"; break;
            case "6": LevelField = "Hrz_id"; break;
            case "7": LevelField = "Xq_id"; break;
            case "8": LevelField = "Lh_id"; break;
            case "9": LevelField = "Dy_id"; break;
            case "10": LevelField = "House_id"; break;
        }
        return LevelField;
    }
    #endregion

    #region 获取级别查询语句
    /// <summary>
    /// 获取级别查询语句  去掉 -号 因为在 快捷方式查询的时候 会出现这个情况
    /// </summary>
    /// <param name="Levelstring">级别整个字符串</param>
    /// <returns></returns>
    public static string getLevelSelect(string Levelstring)
    {
        string levFirst = Levelstring.Substring(0, 1);//取首字母
        string returnStr = GetLevelField(levFirst) + " in (" + Levelstring.Replace(levFirst, "").Replace("-","") + ")";
        return returnStr;
    }
    #endregion

    #region 获取某分组级别及以下级别的id,name，用于分组
    /// <summary>
    /// 获取某分组级别及以下级别的id,name，用于分组
    /// </summary>
    /// <param name="Lv_no">级别编号</param>
    /// <returns></returns>
    public static string GetFzlb(string Lv_no)
    {
        string strReturn = "";
        switch (Lv_no)
        {
            case "1": strReturn = "Jt_id,Jt_name"; break;
            case "2": strReturn = "Jt_id,Jt_name,Zgs_id,Zgs_name"; break;
            case "3": strReturn = "Jt_id,Jt_name,Zgs_id,Zgs_name,Fgs_id,Fgs_name"; break;
            case "4": strReturn = "Jt_id,Jt_name,Zgs_id,Zgs_name,Fgs_id,Fgs_name,K_id,K_name"; break;
            //case "5": strReturn = "Hrz_id"; break;//首站
            case "6": strReturn = "Jt_id,Jt_name,Zgs_id,Zgs_name,Fgs_id,Fgs_name,K_id,K_name,Hrz_id,Hrz_name"; break;
            case "7": strReturn = "Jt_id,Jt_name,Zgs_id,Zgs_name,Fgs_id,Fgs_name,K_id,K_name,Hrz_id,Hrz_name,Xq_id,Xq_name"; break;
            case "8": strReturn = "Jt_id,Jt_name,Zgs_id,Zgs_name,Fgs_id,Fgs_name,K_id,K_name,Hrz_id,Hrz_name,Xq_id,Xq_name,Lh_id,Lh_name"; break;
            case "9": strReturn = "Jt_id,Jt_name,Zgs_id,Zgs_name,Fgs_id,Fgs_name,K_id,K_name,Hrz_id,Hrz_name,Xq_id,Xq_name,Lh_id,Lh_name,Dy_id,Dy_name"; break;
            case "10": strReturn = "Jt_id,Jt_name,Zgs_id,Zgs_name,Fgs_id,Fgs_name,K_id,K_name,Hrz_id,Hrz_name,Xq_id,Xq_name,Lh_id,Lh_name,Dy_id,Dy_name,House_id,House_name"; break;
        }
        return strReturn;
    }
    #endregion

    #region 获取级别唯一中文标识的组成
    /// <summary>
    /// 获取级别唯一中文标识的组成
    /// </summary>
    /// <param name="Lv_no">级别编号</param>
    /// <param name="FunctionID">功能编码</param>
    /// <returns></returns>
    public static string GetFzlbField(string Lv_no, string FunctionID)
    {
        string strReturn = "";
        SQLHelper db_helper = new SQLHelper();
        string sql = "select Field_name from Sys_function_field where Function_id =" + FunctionID + " and Field_show=1 and Lv_no<=" + Lv_no + " and Lv_no<>'' and Lv_no is not null order by Lv_no";
        DataTable dt = db_helper.GetDataTable(sql);
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            strReturn += dt.Rows[i]["Field_name"];
            if (i < dt.Rows.Count - 1)
            {
                strReturn += "+";
            }
        }
        return strReturn;
    }
    #endregion

    #region 获取级别唯一中文标识的组成,多页面
    /// <summary>
    /// 获取级别唯一中文标识的组成,多页面
    /// </summary>
    /// <param name="Lv_no">级别编号</param>
    /// <param name="FunctionID">功能编码</param>
    /// <param name="Field_class">字段类别</param>
    /// <returns></returns>
    public static string GetFzlbField(string Lv_no, string FunctionID, string Field_class)
    {
        string strReturn = "";
        SQLHelper db_helper = new SQLHelper();
        string sql = "select Field_name from Sys_function_field where Function_id =" + FunctionID + " and Field_show=1 and Lv_no<=" + Lv_no + " and Lv_no<>'' and Lv_no is not null and Field_class='" + Field_class + "' order by Lv_no";
        DataTable dt = db_helper.GetDataTable(sql);
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            strReturn += dt.Rows[i]["Field_name"];
            if (i < dt.Rows.Count - 1)
            {
                strReturn += "+";
            }
        }
        return strReturn;
    }
    #endregion
}