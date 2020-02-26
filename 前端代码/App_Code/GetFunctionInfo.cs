using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

/// <summary>
///GetFunctionInfo 的摘要说明
/// </summary>
public class GetFunctionInfo
{


    #region 获取默认每页条数
    /// <summary>
    /// 获取默认每页条数
    /// </summary>
    /// <param name="Function_id">功能码</param>
    /// <returns></returns>
    public static string GetpageSize(string Function_id)
    {
        string strReturn = "";
        SQLHelper db_helper = new SQLHelper();
        string sql = "select pageSize from Sys_function where Function_id='" + Function_id + "'";
        strReturn = db_helper.RunSqlReturn(sql);
        return strReturn;
    }
    #endregion

    #region 默认分页条数选择
    /// <summary>
    /// 默认分页条数选择
    /// </summary>
    /// <param name="Function_id">功能码</param>
    /// <returns></returns>
    public static string GetpageSizeOptions(string Function_id)
    {
        string strReturn = "";
        SQLHelper db_helper = new SQLHelper();
        string sql = "select pageSizeOptions from Sys_function where Function_id='" + Function_id + "'";
        strReturn = db_helper.RunSqlReturn(sql);
        return strReturn;
    }
    #endregion

    #region 获取 查询字段字段
    /// <summary>
    /// 获取页面查询条件的字段 20160413
    /// </summary>
    /// <param name="Function_id">功能码</param>
    /// <param name="User_name">用户名</param>
    /// <param name="Field_class">字段类别</param>
    /// <returns></returns>
    public static string form_select_clear_list(string Function_id, string classType)
    {
        string strReturn = "{";
        SQLHelper db_helper = new SQLHelper();
        string sql = "select * from sys_function_select where flag=1 and isshow=1 and function_id='" + Function_id + "' and classType='" + classType + "' order by field_order";
        DataTable dt = db_helper.GetDataTable(sql);//获取该用户该功能的列表（按显示的，及顺序，先自定义顺序后ID顺序）
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            if (i == 0)
            {
                strReturn += dt.Rows[i]["name"].ToString() + ":\"\"";
            }
            else
            {
                strReturn += "," + dt.Rows[i]["name"].ToString() + ":\"\"";
            }

        }
        strReturn += "}";
        return strReturn;
    }
    #endregion

    #region 获取 查询字段字段
    /// <summary>
    /// 获取页面查询条件的字段 20160413
    /// </summary>
    /// <param name="Function_id">功能码</param>
    /// <param name="User_name">用户名</param>
    /// <param name="Field_class">字段类别</param>
    /// <returns></returns>
    public static string form_select_list(string Function_id, string classType)
    {
        string strReturn = "";
        SQLHelper db_helper = new SQLHelper();
        string sql = "select * from sys_function_select where flag=1 and isshow=1 and function_id='" + Function_id + "' and classType='" + classType + "' order by field_order";
        DataTable dt = db_helper.GetDataTable(sql);//获取该用户该功能的列表（按显示的，及顺序，先自定义顺序后ID顺序）
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            if (dt.Rows[i]["type"] != null)
            {
                string strType = dt.Rows[i]["type"].ToString();
                if (strType == "text")
                {
                    strReturn += " { display: '" + dt.Rows[i]["display"].ToString() + "', name: '" + dt.Rows[i]["name"].ToString()
                   + "', newline: " + dt.Rows[i]["newline"].ToString() + ", labelWidth: " + dt.Rows[i]["labelWidth"].ToString() + ", width: " + dt.Rows[i]["width"].ToString()
                   + ", space: " + dt.Rows[i]["space"].ToString() + ", labelAlign:'" + dt.Rows[i]["labelAlign"].ToString() + "',type: '" + dt.Rows[i]["type"].ToString()
                   + "', cssClass: '" + dt.Rows[i]["cssClass"].ToString() + "', attr: " + dt.Rows[i]["attr"].ToString() + "}";
                }
                else if (strType == "select")
                {
                    strReturn += " { display: '" + dt.Rows[i]["display"].ToString() + "', name: '" + dt.Rows[i]["name"].ToString()
                   + "', newline: " + dt.Rows[i]["newline"].ToString() + ", labelWidth: " + dt.Rows[i]["labelWidth"].ToString() + ", width: " + dt.Rows[i]["width"].ToString()
                   + ", space: " + dt.Rows[i]["space"].ToString() + ", labelAlign:'" + dt.Rows[i]["labelAlign"].ToString() + "',type: '" + dt.Rows[i]["type"].ToString()
                   + "', cssClass: '" + dt.Rows[i]["cssClass"].ToString() + "',comboboxName: '" + dt.Rows[i]["comboboxName"].ToString() + "',options: " + dt.Rows[i]["options"].ToString() + ", attr: " + dt.Rows[i]["attr"].ToString() + "}";
                }
                else if (strType == "date")
                {
                    strReturn += " { display: '" + dt.Rows[i]["display"].ToString() + "', name: '" + dt.Rows[i]["name"].ToString()
                   + "', newline: " + dt.Rows[i]["newline"].ToString() + ", labelWidth: " + dt.Rows[i]["labelWidth"].ToString() + ", width: " + dt.Rows[i]["width"].ToString()
                   + ", space: " + dt.Rows[i]["space"].ToString() + ", labelAlign:'" + dt.Rows[i]["labelAlign"].ToString() + "',type: '" + dt.Rows[i]["type"].ToString()
                   + "', cssClass: '" + dt.Rows[i]["cssClass"].ToString() + "', attr: " + dt.Rows[i]["attr"].ToString() + "}";
                }

                if (i < dt.Rows.Count - 1)
                {
                    strReturn += ",";
                }
            }

        }
        return strReturn;
    }
    #endregion


    #region //新增方法 获取grid中所有元素信息
    public static DataTable GetGridInfoDt(string Function_id,string gridName)
    {
        DataTable dt = new DataTable();
        SQLHelper db_helper = new SQLHelper();
        string sql = "select * from Sys_function_Grid where function_id='" + Function_id + "' and gridName='" + gridName + "'";
        dt = db_helper.GetDataTable(sql);
        return dt;
    }
    #endregion

    #region //新增方法 获取grid中所有元素信息
    public static DataTable GetGridInfoDt(string Function_id,string username, string gridName)
    {
        DataTable dt = new DataTable();
        SQLHelper db_helper = new SQLHelper();
        string sql = "if((select count(*) from Sys_function_Grid_user where function_id='" + Function_id + "' and User_name='" + username + "' and gridName='" + gridName + "')=0) insert into Sys_function_Grid_user  select *,'" + username + "' from Sys_function_Grid where function_id='" + Function_id + "' and gridName='" + gridName + "'";
        sql += " select * from Sys_function_Grid_user where function_id='" + Function_id + "' and User_name='" + username + "' and gridName='" + gridName + "'";
        dt = db_helper.GetDataTable(sql);
        return dt;
    }
    #endregion

    #region 获取按钮列表
    /// <summary>
    /// 获取按钮列表
    /// </summary>
    /// <param name="Function_id">功能码</param>
    /// <param name="Role_id">角色编号</param>
    /// <returns></returns>
    public static string Button_list(string Function_id, string Role_id)
    {
        string strReturn = "";
        SQLHelper db_helper = new SQLHelper();
        string sql = "select Button_name,Button_event,Ico_addr from Vw_role_button where Open_mark=1 and Function_id='" + Function_id + "' and Role_id='" + Role_id + "' order by Order_no";
        DataTable dt = db_helper.GetDataTable(sql);
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            if (dt.Rows[i]["Button_event"] == null || dt.Rows[i]["Button_event"].ToString() == "")
            {
                strReturn += "{ text: '" + dt.Rows[i]["Button_name"] + "', click: toolbarBtnItemClick, img: '../" + dt.Rows[i]["Ico_addr"] + "' },{ line: true }";
            }
            else
            {
                strReturn += "{ text: '" + dt.Rows[i]["Button_name"] + "', click: " + dt.Rows[i]["Button_event"].ToString() + ", img: '../" + dt.Rows[i]["Ico_addr"] + "' },{ line: true }";
            }
            
            if (i < dt.Rows.Count - 1)
            {
                strReturn += ",";
            }
        }
        return strReturn;
    }
    #endregion

    #region 获取按钮列表
    /// <summary>
    /// 获取按钮列表
    /// </summary>
    /// <param name="Function_id">功能码</param>
    /// <param name="Role_id">角色编号</param>
    /// <param name="Button_class">按钮类别</param>
    /// <returns></returns>
    public static string Button_list(string Function_id, string Role_id, string Button_class)
    {
        string strReturn = "";
        SQLHelper db_helper = new SQLHelper();
        string sql = "select Button_name,Button_event,Ico_addr from Vw_role_button where Open_mark=1 and Function_id='" + Function_id + "' and Button_class='" + Button_class + "' and Role_id='" + Role_id + "' order by Order_no";
        DataTable dt = db_helper.GetDataTable(sql);
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            if (dt.Rows[i]["Button_event"] == null || dt.Rows[i]["Button_event"].ToString() == "")
            {
                strReturn += "{ text: '" + dt.Rows[i]["Button_name"] + "', click: toolbarBtnItemClick, img: '../" + dt.Rows[i]["Ico_addr"] + "' },{ line: true }";
            }
            else
            {
                strReturn += "{ text: '" + dt.Rows[i]["Button_name"] + "', click: " + dt.Rows[i]["Button_event"].ToString() + ", img: '../" + dt.Rows[i]["Ico_addr"] + "' },{ line: true }";
            }

            if (i < dt.Rows.Count - 1)
            {
                strReturn += ",";
            }
        }
        return strReturn;
    }
    #endregion
    #region 公共页面获取按钮列表
    /// <summary>
    /// 获取按钮列表
    /// </summary>
    /// <param name="Function_id">功能码</param>
    /// <param name="Role_id">角色编号</param>
    /// <returns></returns>
    public static string Button_list_public(string Function_id, string Role_id)
    {
        //string strReturn = "";
        //SQLHelper db_helper = new SQLHelper();
        //string sql = "select Button_name,Ico_addr from Sys_button where Open_mark=1 and Function_id='" + Function_id + "' order by Order_no";
        //DataTable dt = db_helper.GetDataTable(sql);
        //for (int i = 0; i < dt.Rows.Count; i++)
        //{
        //    strReturn += "{ text: '" + dt.Rows[i]["Button_name"] + "', click: toolbarBtnItemClick, img: '../" + dt.Rows[i]["Ico_addr"] + "' },{ line: true }";
        //    if (i < dt.Rows.Count - 1)
        //    {
        //        strReturn += ",";
        //    }
        //}
        //return strReturn;
        string strReturn = "";
        SQLHelper db_helper = new SQLHelper();
        string sql = "select Button_name,Button_event,Ico_addr from Sys_button where Open_mark=1 and Function_id='" + Function_id + "' order by Order_no";
        DataTable dt = db_helper.GetDataTable(sql);
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            if (dt.Rows[i]["Button_event"] == null || dt.Rows[i]["Button_event"].ToString() == "")
            {
                strReturn += "{ text: '" + dt.Rows[i]["Button_name"] + "', click: toolbarBtnItemClick, img: '../" + dt.Rows[i]["Ico_addr"] + "' },{ line: true }";
            }
            else
            {
                strReturn += "{ text: '" + dt.Rows[i]["Button_name"] + "', click: " + dt.Rows[i]["Button_event"].ToString() + ", img: '../" + dt.Rows[i]["Ico_addr"] + "' },{ line: true }";
            }

            if (i < dt.Rows.Count - 1)
            {
                strReturn += ",";
            }
        }
        return strReturn;
    }
    #endregion

    #region 公共页面获取按钮列表
    /// <summary>
    /// 获取按钮列表
    /// </summary>
    /// <param name="Function_id">功能码</param>
    /// <param name="Role_id">角色编号</param>
    /// <param name="Button_class">按钮类别</param>
    /// <returns></returns>
    public static string Button_list_public(string Function_id, string Role_id, string Button_class)
    {
        string strReturn = "";
        SQLHelper db_helper = new SQLHelper();
        string sql = "select Button_name,Ico_addr from Sys_button where Open_mark=1 and Function_id='" + Function_id + "' and Button_class='" + Button_class + "'  order by Order_no";
        DataTable dt = db_helper.GetDataTable(sql);
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            strReturn += "{ text: '" + dt.Rows[i]["Button_name"] + "', click: toolbarBtnItemClick, img: '../" + dt.Rows[i]["Ico_addr"] + "' },{ line: true }";
            if (i < dt.Rows.Count - 1)
            {
                strReturn += ",";
            }
        }
        return strReturn;
    }
    #endregion

    #region 获取功能名称
    /// <summary>
    /// 获取功能名称
    /// </summary>
    /// <param name="Function_id">功能码</param>
    /// <returns></returns>
    public static string GetFunction_name(string Function_id)
    {
        string strReturn = "";
        SQLHelper db_helper = new SQLHelper();
        string sql = "select Function_name from Sys_function where Function_id='" + Function_id + "'";
        strReturn = db_helper.RunSqlReturn(sql);
        return strReturn;
    }
    #endregion

    #region 获取功能图片
    /// <summary>
    /// 获取功能图片
    /// </summary>
    /// <param name="Function_id">功能码</param>
    /// <returns></returns>
    public static string GetFunction_Ico_addr(string Function_id)
    {
        string strReturn = "";
        SQLHelper db_helper = new SQLHelper();
        string sql = "select Ico_addr from Sys_function where Function_id='" + Function_id + "'";
        strReturn = db_helper.RunSqlReturn(sql);
        return strReturn;
    }
    #endregion

    #region 获取功能修改相关的表名或视图名
    /// <summary>
    /// 获取功能修改相关的表名或视图名
    /// </summary>
    /// <param name="Function_id">功能码</param>
    /// <returns></returns>
    public static string GetTable_name(string Function_id)
    {
        string strReturn = "";
        SQLHelper db_helper = new SQLHelper();
        string sql = "select Table_name from sys_function_grid where Function_id='" + Function_id + "'";
        strReturn = db_helper.RunSqlReturn(sql);
        return strReturn;
    }

    /// <summary>
    /// 获取功能修改相关的表名或视图名
    /// </summary>
    /// <param name="Function_id">功能码</param>
    /// <returns></returns>
    public static string GetTable_name(string Function_id, string gridname)
    {
        string strReturn = "";
        SQLHelper db_helper = new SQLHelper();
        string sql = "";
        if (gridname == "" || gridname == null)
        {
            sql = "select Table_name from sys_function_grid where Function_id='" + Function_id + "'";
        }
        else
        {
            sql = "select Table_name from sys_function_grid where Function_id='" + Function_id + "' and gridName='" + gridname + "'";
        }
        strReturn = db_helper.RunSqlReturn(sql);
        return strReturn;
    }

    #endregion

    

   

    


    #region 获取grid列表的字段
    /// <summary>
    /// 获取grid列表的字段 添加对 Field_class 的判断 2015-04-01 zll
    /// </summary>
    /// <param name="Function_id">功能码</param>
    /// <param name="User_name">用户名</param>
    /// <returns></returns>
    public static string Table_list_public(string Function_id, string User_name)
    {
        string strReturn = "";
        SQLHelper db_helper = new SQLHelper();
        string sql = "insert into Sys_function_field_user " +
            "select *,'" + User_name + "' from Sys_function_field where Field_id not in(select Field_id from Sys_function_field_user where [USER_NAME]='" + User_name + "') and Field_show=1 ";//只更新开放的
        db_helper.RunSqlStr(sql);//所有自定义表格母表的数据移到子表（尚未添加到子表的）
        sql = "select Field_display,Field_name,Field_width,Field_type,Field_align from Sys_function_field_user " +
            "where isnull(Field_class,'')='maingrid' and  Field_show=1 and Function_id=" + Function_id + " and [User_name]='" + User_name + "' order by Field_order,Field_id";
        DataTable dt = db_helper.GetDataTable(sql);//获取该用户该功能的列表（按显示的，及顺序，先自定义顺序后ID顺序）
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            strReturn += "{ display: '" + dt.Rows[i]["Field_display"] + "', name: '" + dt.Rows[i]["Field_name"] + "', width: " + dt.Rows[i]["Field_width"] + ", type: '" + dt.Rows[i]["Field_type"] + "', align: '" + dt.Rows[i]["Field_align"] + "'}";
            if (i < dt.Rows.Count - 1)
            {
                strReturn += ",";
            }
        }
        return strReturn;
    }
    #endregion

    #region 获取grid列表的字段
    /// <summary>
    /// 获取grid列表的字段 添加对 Field_class 的判断 2015-04-01 zll
    /// </summary>
    /// <param name="Function_id">功能码</param>
    /// <param name="User_name">用户名</param>
    /// <returns></returns>
    public static string Table_list_public(string Function_id, string User_name,string Filed_class)
    {
        string strReturn = "";
        SQLHelper db_helper = new SQLHelper();
        string sql = "insert into Sys_function_field_user " +
            "select *,'" + User_name + "' from Sys_function_field where Field_id not in(select Field_id from Sys_function_field_user where [USER_NAME]='" + User_name + "') and Field_show=1 ";//只更新开放的
        db_helper.RunSqlStr(sql);//所有自定义表格母表的数据移到子表（尚未添加到子表的）
        sql = "select Field_display,Field_name,Field_width,Field_type,Field_align from Sys_function_field_user " +
            "where   Field_show=1 and Function_id=" + Function_id + " and [User_name]='" + User_name + "' and Field_class='" + Filed_class + "' order by Field_order,Field_id";
        DataTable dt = db_helper.GetDataTable(sql);//获取该用户该功能的列表（按显示的，及顺序，先自定义顺序后ID顺序）
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            strReturn += "{ display: '" + dt.Rows[i]["Field_display"] + "', name: '" + dt.Rows[i]["Field_name"] + "', width: " + dt.Rows[i]["Field_width"] + ", type: '" + dt.Rows[i]["Field_type"] + "', align: '" + dt.Rows[i]["Field_align"] + "'}";
            if (i < dt.Rows.Count - 1)
            {
                strReturn += ",";
            }
        }
        return strReturn;
    }
    #endregion


    #region 获取grid列表的字段
    /// <summary>
    /// 获取grid列表的字段 添加对 Field_class 的判断 2015-04-01 zll
    /// </summary>
    /// <param name="Function_id">功能码</param>
    /// <param name="User_name">用户名</param>
    /// <returns></returns>
    public static string Table_list(string Function_id, string User_name)
    {
        string strReturn = "";
        SQLHelper db_helper = new SQLHelper();
        string sql = "insert into Sys_function_field_user " +
            "select *,'" + User_name + "' from Sys_function_field where Field_id not in(select Field_id from Sys_function_field_user where [USER_NAME]='" + User_name + "') and Field_show=1 and Function_id in(select Function_id from Vw_sys_user_function where User_name='" + User_name + "')";//只更新开放的
        db_helper.RunSqlStr(sql);//所有自定义表格母表的数据移到子表（尚未添加到子表的）
        sql = "select Field_display,Field_name,Field_width,Field_type,Field_export_locked,Field_align from Sys_function_field_user " +
            "where isnull(Field_class,'maingrid')='maingrid' and  Field_show=1 and Function_id=" + Function_id + " and [User_name]='" + User_name + "' order by Field_order,Field_id";
        DataTable dt = db_helper.GetDataTable(sql);//获取该用户该功能的列表（按显示的，及顺序，先自定义顺序后ID顺序）
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            strReturn += "{ display: '" + dt.Rows[i]["Field_display"] + "', name: '" + dt.Rows[i]["Field_name"] + "', width: " + dt.Rows[i]["Field_width"] + ", type: '" + dt.Rows[i]["Field_type"] + "', align: '" + dt.Rows[i]["Field_align"] + "'}";
            if (i < dt.Rows.Count - 1)
            {
                strReturn += ",";
            }
        }
        return strReturn;
    }
    #endregion

    #region 获取grid列表的字段
    /// <summary>
    /// 获取grid列表的字段
    /// </summary>
    /// <param name="Function_id">功能码</param>
    /// <param name="User_name">用户名</param>
    /// <param name="Field_class">字段类别</param>
    /// <returns></returns>
    public static string Table_list(string Function_id, string User_name, string Field_class)
    {
        string strReturn = "";
        SQLHelper db_helper = new SQLHelper();
        string sql = "insert into Sys_function_field_user " +
            "select *,'" + User_name + "' from Sys_function_field where   Field_id not in(select Field_id from Sys_function_field_user where [USER_NAME]='" + User_name + "') and Field_show=1 and Function_id in(select Function_id from Vw_sys_user_function_qx where User_name='" + User_name + "')";//只更新开放的
        db_helper.RunSqlStr(sql);//所有自定义表格母表的数据移到子表（尚未添加到子表的）
        sql = "select Field_display,Field_name,Field_width,Field_type,Field_align from Sys_function_field_user " +
            "where Field_show=1 and Function_id=" + Function_id + " and Field_class='" + Field_class + "' and [User_name]='" + User_name + "' order by Field_order,Field_id";
        DataTable dt = db_helper.GetDataTable(sql);//获取该用户该功能的列表（按显示的，及顺序，先自定义顺序后ID顺序）
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            strReturn += "{ display: '" + dt.Rows[i]["Field_display"] + "', name: '" + dt.Rows[i]["Field_name"] + "', width: " + dt.Rows[i]["Field_width"] + ", type: '" + dt.Rows[i]["Field_type"] + "', align: '" + dt.Rows[i]["Field_align"] + "'}";
            if (i < dt.Rows.Count - 1)
            {
                strReturn += ",";
            }
        }
        return strReturn;
    }
    #endregion

    #region 获取grid列表的字段，带连接的
    /// <summary>
    /// 获取grid列表的字段，带连接的
    /// </summary>
    /// <param name="Function_id">功能码</param>
    /// <param name="User_name">用户名</param>
    /// <param name="Field_class">字段类别</param>
    /// <returns></returns>
    public static string Table_list1(string Function_id, string User_name, string Field_class)
    {
        string strReturn = "";
        string fieldName = "";
        SQLHelper db_helper = new SQLHelper();
        string sql = "insert into Sys_function_field_user " +
            "select *,'" + User_name + "' from Sys_function_field where Field_id not in(select Field_id from Sys_function_field_user where [USER_NAME]='" + User_name + "') and Field_show=1 and Function_id in(select Function_id from Vw_sys_user_function where User_name='" + User_name + "')";//只更新开放的
        db_helper.RunSqlStr(sql);//所有自定义表格母表的数据移到子表（尚未添加到子表的）
        sql = "select Field_display,Field_name,Field_width,Field_type,Field_align from Sys_function_field_user " +
            "where Field_show=1 and Function_id=" + Function_id + " and Field_class='" + Field_class + "' and [User_name]='" + User_name + "' order by Field_order,Field_id";
        DataTable dt = db_helper.GetDataTable(sql);//获取该用户该功能的列表（按显示的，及顺序，先自定义顺序后ID顺序）
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            strReturn += "{ display: '" + dt.Rows[i]["Field_display"] + "', name: '" + dt.Rows[i]["Field_name"] + "', width: " + dt.Rows[i]["Field_width"] + ", type: '" + dt.Rows[i]["Field_type"] + "', align: '" + dt.Rows[i]["Field_align"] + "'";
            if (Function_id == "45")
            {
                fieldName = dt.Rows[i]["Field_name"].ToString();
                if (fieldName == "zhs" || fieldName == "gnhs" || fieldName == "tghs" || fieldName == "rzbhs1" || fieldName == "rzbhs2" || fieldName == "rzbhs3" || fieldName == "rzbhs4" || fieldName == "rzbhs5" || fieldName == "rzbhs6" || fieldName == "tgrzbhs1" || fieldName == "tgrzbhs2")
                {
                    strReturn += ",render: function (rowdata, rowindex, value) {return '<a href=\"#\" style=\"color: Blue\" onclick=\"showDetailA(' +\"'\"+ rowindex +\"'\"+ ','+\"'" + fieldName + "'\"+')\">' + value + '</a>';}}";
                }
                else { strReturn += "}"; }
            }
            else { strReturn += "}"; }
            if (i < dt.Rows.Count - 1) { strReturn += ","; }
        }
        return strReturn;
    }
    #endregion

    #region 是否有权限
    /// <summary>
    ///是否有权限
    /// </summary>
    /// <param name="Function_id">功能码</param>
    /// <param name="User_name">用户名</param>
    /// <returns></returns>
    public static int HavePower(string Function_id, string User_name)
    {
        int strReturn = 0;
        SQLHelper db_helper = new SQLHelper();
        string sql = "select count(1) from Vw_sys_user_function_qx where User_name='" + User_name + "' and Function_id=" + Function_id + " and Open_mark=1";
        strReturn = Convert.ToInt32(db_helper.RunSqlReturn(sql));//验证用户是否有开放的权限        
        return strReturn;
    }
    #endregion

    #region 获取grid列表的字段,用于导出,普通单页面
    /// <summary>
    /// 获取grid列表的字段,用于导出,普通单页面
    /// </summary>
    /// <param name="Function_id">功能码</param>
    /// <param name="User_name">用户名</param>
    /// <returns></returns>
    public static DataTable Table_info(string Function_id, string User_name)
    {
        SQLHelper db_helper = new SQLHelper();
        string sql = "insert into Sys_function_field_user " +
            "select *,'" + User_name + "' from Sys_function_field where Field_id not in(select Field_id from Sys_function_field_user)";
        db_helper.RunSqlStr(sql);//所有自定义表格母表的数据移到子表（尚未添加到子表的）
        sql = "select Field_display,Field_name,Field_width,Field_type,Field_export_locked,Field_align from Sys_function_field_user " +
            "where Field_show=1 and Function_id=" + Function_id + " and [User_name]='" + User_name + "' and isnull(Field_class,'')='maingrid' order by Field_order,Field_id";
        DataTable dt = db_helper.GetDataTable(sql);//获取该用户该功能的列表（按显示的，及顺序，先自定义顺序后ID顺序）        
        return dt;
    }
    #endregion

    #region 获取grid列表的字段,用于导出,普通单页面
    /// <summary>
    /// 获取grid列表的字段,用于导出,普通单页面
    /// </summary>
    /// <param name="Function_id">功能码</param>
    /// <param name="User_name">用户名</param>
    /// <returns></returns>
    public static DataTable Table_info_showid(string Function_id, string User_name)
    {
        SQLHelper db_helper = new SQLHelper();
        string sql = "insert into Sys_function_field_user " +
            "select *,'" + User_name + "' from Sys_function_field where Function_id=" + Function_id + " and Field_id not in(select Field_id from Sys_function_field_user where Function_id=" + Function_id + ")";
        db_helper.RunSqlStr(sql);//所有自定义表格母表的数据移到子表（尚未添加到子表的）
        sql = "select Field_display,Field_name,Field_width,Field_type,Field_align from Sys_function_field_user " +
            "where Function_id=" + Function_id + " and [User_name]='" + User_name + "' and Field_show=1 order by Field_order,Field_id";
        DataTable dt = db_helper.GetDataTable(sql);//获取该用户该功能的列表（按显示的，及顺序，先自定义顺序后ID顺序）        
        return dt;
    }
    #endregion

    #region 获取grid列表的字段,用于导出，分组单页面
    /// <summary>
    /// 获取grid列表的字段,用于导出，分组单页面
    /// </summary>
    /// <param name="Function_id">功能码</param>
    /// <param name="User_name">用户名</param>
    /// <param name="Fzlb">分组类别号，只获取该级别及以上级别的字段</param>
    /// <returns></returns>
    public static DataTable Table_info1(string Function_id, string User_name, string Fzlb)
    {
        SQLHelper db_helper = new SQLHelper();
        string sql = "insert into Sys_function_field_user " +
            "select *,'" + User_name + "' from Sys_function_field where Field_id not in(select Field_id from Sys_function_field_user)";
        db_helper.RunSqlStr(sql);//所有自定义表格母表的数据移到子表（尚未添加到子表的）
        sql = "select Field_display,Field_name,Field_width,Field_type,Field_align from Sys_function_field_user " +
            "where Field_show=1 and Function_id=" + Function_id + " and [User_name]='" + User_name + "' and (Lv_no is null or Lv_no='' or Lv_no<=" + Fzlb + ") order by Field_order,Field_id";
        DataTable dt = db_helper.GetDataTable(sql);//获取该用户该功能的列表（按显示的，及顺序，先自定义顺序后ID顺序）        
        return dt;
    }
    #endregion

    #region 获取grid列表的字段,用于导出,普通多页面
    /// <summary>
    /// 获取grid列表的字段,用于导出,普通多页面
    /// </summary>
    /// <param name="Function_id">功能码</param>
    /// <param name="User_name">用户名</param>
    /// <param name="Field_class">字段类别</param>
    /// <returns></returns>
    public static DataTable Table_info(string Function_id, string User_name, string Field_class)
    {
        SQLHelper db_helper = new SQLHelper();
        string sql = "insert into Sys_function_field_user " +
            "select *,'" + User_name + "' from Sys_function_field where Field_id not in(select Field_id from Sys_function_field_user)";
        db_helper.RunSqlStr(sql);//所有自定义表格母表的数据移到子表（尚未添加到子表的）
        sql = "select Field_display,Field_name,Field_width,Field_type,Field_export_locked,Field_align from Sys_function_field_user " +
            "where  Field_show=1 and Function_id=" + Function_id + " and Field_class='" + Field_class + "' and [User_name]='" + User_name + "' order by Field_order,Field_id";
        DataTable dt = db_helper.GetDataTable(sql);//获取该用户该功能的列表（按显示的，及顺序，先自定义顺序后ID顺序）        
        return dt;
    }
    #endregion

    #region 获取grid列表的字段,用于导出,普通多页面
    /// <summary>
    /// 获取grid列表的字段,用于导出,普通多页面
    /// </summary>
    /// <param name="Function_id">功能码</param>
    /// <param name="User_name">用户名</param>
    /// <param name="Field_class">字段类别</param>
    /// <returns></returns>
    public static DataTable Table_info_showid(string Function_id, string User_name, string Field_class)
    {
        SQLHelper db_helper = new SQLHelper();
        string sql = "insert into Sys_function_field_user " +
            "select *,'" + User_name + "' from Sys_function_field where Function_id=" + Function_id + " and Field_id not in(select Field_id from Sys_function_field_user where Function_id=" + Function_id +")";
        db_helper.RunSqlStr(sql);//所有自定义表格母表的数据移到子表（尚未添加到子表的）
        sql = "select Field_display,Field_name,Field_width,Field_type,Field_align from Sys_function_field_user " +
            "where Function_id=" + Function_id + " and Field_class='" + Field_class + "' and [User_name]='" + User_name + "' and Field_show=1 order by Field_order,Field_id";
        DataTable dt = db_helper.GetDataTable(sql);//获取该用户该功能的列表（按显示的，及顺序，先自定义顺序后ID顺序）        
        return dt;
    }
    #endregion



    #region 获取grid列表的字段,用于导出，分组多页面
    /// <summary>
    /// 获取grid列表的字段,用于导出，分组多页面
    /// </summary>
    /// <param name="Function_id">功能码</param>
    /// <param name="User_name">用户名</param>
    /// <param name="Fzlb">分组类别号，只获取该级别及以上级别的字段</param>
    /// <param name="Field_class">字段类别</param>
    /// <returns></returns>
    public static DataTable Table_info1(string Function_id, string User_name, string Fzlb, string Field_class)
    {
        SQLHelper db_helper = new SQLHelper();
        string sql = "insert into Sys_function_field_user " +
            "select *,'" + User_name + "' from Sys_function_field where Field_id not in(select Field_id from Sys_function_field_user)";
        db_helper.RunSqlStr(sql);//所有自定义表格母表的数据移到子表（尚未添加到子表的）
        sql = "select Field_display,Field_name,Field_width,Field_type,Field_align from Sys_function_field_user " +
            "where Field_show=1 and Function_id=" + Function_id + " and [User_name]='" + User_name + "' and (Lv_no is null or Lv_no='' or Lv_no<=" + Fzlb + ") and Field_class='" + Field_class + "' order by Field_order,Field_id";
        DataTable dt = db_helper.GetDataTable(sql);//获取该用户该功能的列表（按显示的，及顺序，先自定义顺序后ID顺序）        
        return dt;
    }
    #endregion

    #region 获取最小抄表点
    /// <summary>
    /// 获取最小抄表点
    /// </summary>
    /// <returns></returns>
    public static string Get_Min_cbsj()
    {
        string strReturn = "";
        SQLHelper db_helper = new SQLHelper();
        string sql = "select min(Cjq_time) from Yb_Cb_Time";
        strReturn = db_helper.RunSqlReturn(sql);
        return strReturn;
    }
    #endregion

    #region 获取最大抄表点
    /// <summary>
    /// 获取最大抄表点
    /// </summary>
    /// <returns></returns>
    public static string Get_Max_cbsj()
    {
        string strReturn = "";
        SQLHelper db_helper = new SQLHelper();
        string sql = "select max(Cjq_time) from Yb_Cb_Time";
        strReturn = db_helper.RunSqlReturn(sql);
        return strReturn;
    }
    #endregion

    #region 获取最大住户级别
    /// <summary>
    /// 获取最大住户级别
    /// </summary>
    /// <returns></returns>
    public static string Get_Max_zhjb()
    {
        string strReturn = "";
        SQLHelper db_helper = new SQLHelper();
        string sql = "select Lv_no from Vw_Public_house_level where Lv_no=(select Sys_value from Sys_config where Sys_code='zhjb')";
        strReturn = db_helper.RunSqlReturn(sql);
        return strReturn;
    }
    #endregion

    #region 获取表单上级模块菜单名
    public static string GetModuleName(string funciton_id)
    {
        SQLHelper db_helper = new SQLHelper();
        string sql = "select Module_name from  Sys_module where Module_id=(select Module_id from Sys_function where Function_id="+funciton_id+") ";
        string str = db_helper.RunSqlReturn(sql);
        return str;
    }
    #endregion
}