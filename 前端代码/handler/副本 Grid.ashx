<%@ WebHandler Language="C#" Class="Grid" %>

using System;
using System.Web;
using System.Reflection;
using GSPT.Common;
using System.Data;
using System.Linq;
using System.Web.SessionState;

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
        //定义公共变量whereCb
        
        string wherea_tree = "";//树结构查询条件
        
        //下面三个是视图使用的
        string wherea_center = "1=1";//中间查询条件
        string wherea_left = "1=1";//左侧查询条件
        string wherea_all = "1=1";//所有条件组合 wherea_center+wherea_left+wherea_tree+wherea_other

        string wherea_other = "1=1";
        
        //以下是存储过程使用的
        string wherea_up_house="1=1";
        string wherea_up_meter = "1=1";

        string wherea_up_other1 = "1=1";
        string wherea_up_other2 = "1=1";
        string wherea_up_other3 = "1=1";
        string wherea_up_other4 = "1=1";
        
        string wherea_up_other5 = "1=1";
        
        //还有些传递成数组的用 |线分隔开 
        System.Collections.Generic.List<string> l_parms = new System.Collections.Generic.List<string>();
        
        
        
        //中间查询条件
        string where = context.Request["where"];
        if (!string.IsNullOrEmpty(where))
        {
            var whereTranslator = new FilterTranslator();
            whereTranslator.Group = GSPT.Common.JSONHelper.FromJson<FilterGroup>(where);
            whereTranslator.Translate();
            //bug对应
            //([gnj] = @p1 and [Center_no] like @p2 and [Mpid] like @p3 and [Floor_pos_name] = @p4 and [Meter_no] like @p5 and [sfbm] like @p6 and [chargeAddr] like @p7 and [Fee_kind_name] = @p8 and [Meter_type_name] = @p9 and [Lh_name] like @p10)
            System.Collections.Generic.IList<FilterRule> fr = whereTranslator.Group.rules;
            for (int i = 0; i < fr.Count; i++)
            {
                string type = fr[i].type;
                string op = get_op_sql(fr[i].op);
                string jxsql = getGridSql(fr[i].field, op, fr[i].value);
                wherea_center += " and " + jxsql;
                if (type == "house")
                {
                    wherea_up_house += " and " + jxsql;
                }
                else if (type == "meter")
                {
                    wherea_up_meter += " and " + jxsql;
                }
                else if (type == "other1")
                {
                    wherea_up_other1 += " and " + jxsql;
                }
                else if (type == "other2")
                {
                    wherea_up_other2 += " and " + jxsql;
                }
                else if (type == "other3")
                {
                    wherea_up_other3 += " and " + jxsql;
                }
                else if (type == "other4")
                {
                    wherea_up_other4 += " and " + jxsql;
                }
                else if (type == "other5")
                {
                    wherea_up_other5 += " and " + jxsql;
                }
                else if (type == "center")
                {
                    wherea_center += " and " + jxsql;
                }
                else
                {
                }
            }
            if (wherea_center != "")
            {
                wherea_center = wherea_center.Replace(";", "','");//这里对应多选下拉框的情况
            }
        }
        
        
        //对应中间查询条件结束-----------------------------------------------------
        
        //对应左侧查询条件开始-----------------------------------------------------
        where = context.Request["where_left"];

        if (!string.IsNullOrEmpty(where))
        {
            var whereTranslator = new FilterTranslator();
            whereTranslator.Group = GSPT.Common.JSONHelper.FromJson<FilterGroup>(where);
            whereTranslator.Translate();
            //bug对应
            //([gnj] = @p1 and [Center_no] like @p2 and [Mpid] like @p3 and [Floor_pos_name] = @p4 and [Meter_no] like @p5 and [sfbm] like @p6 and [chargeAddr] like @p7 and [Fee_kind_name] = @p8 and [Meter_type_name] = @p9 and [Lh_name] like @p10)
            System.Collections.Generic.IList<FilterRule> fr=whereTranslator.Group.rules;
            for (int i = 0; i < fr.Count; i++)
            {
                string type = fr[i].type;
                string op = get_op_sql(fr[i].op);
                string jxsql = getGridSql(fr[i].field, op, fr[i].value);
                wherea_left += " and " + jxsql;
                if (type == "house")
                {
                    wherea_up_house += " and " + jxsql;
                }
                else if (type == "meter")
                {
                    wherea_up_meter += " and " + jxsql;
                }
                else if (type == "other1")
                {
                    wherea_up_other1 += " and " + jxsql;
                }
                else if (type == "other2")
                {
                    wherea_up_other2 += " and " + jxsql;
                }
                else if (type == "other3")
                {
                    wherea_up_other3 += " and " + jxsql;
                }
                else if (type == "other4")
                {
                    wherea_up_other4 += " and " + jxsql;
                }
                else if (type == "other5")
                {
                    wherea_up_other5 += " and " + jxsql;
                }
                else if (type == "center")
                {
                    wherea_center += " and " + jxsql;
                }
                else
                {
                }
            }
            if (wherea_left != "")
            {
                wherea_left = wherea_left.Replace(";", "','");//这里对应多选下拉框的情况
            }

        }        
        //对应左侧查询条件结束-----------------------------------------------------

        wherea_up_house = wherea_up_house.Replace(";", "','");//这里对应多选下拉框的情况
        wherea_up_meter = wherea_up_meter.Replace(";", "','");//这里对应多选下拉框的情况
        wherea_up_other1 = wherea_up_other1.Replace(";", "','");//这里对应多选下拉框的情况
        //处理左侧树
        string where_tree = context.Request["where_tree"];
        if (where_tree != null )
        {
            if (where_tree != "null") {
                if (!string.IsNullOrEmpty(where_tree))
                {
                    where_tree = ReplaceStr.Replace(where_tree);
                }

                wherea_tree = PublicMethod.getTreeSql(where_tree);
            }
            
        }
        

        //公共方法，ShowData
        if(context.Request["ShowData"]!=null)
        {
             string ShowData = context.Request["ShowData"];
             if (ShowData == "0")
             {
                 wherea_other += " and 1=0"; 
             }
        }
        //公共方法，ShowData
        if (context.Request["commandNum"] != null)
        {
            wherea_other += " and commandNum='" + context.Request["commandNum"] + "'";
        }
        //公共方法，ShowData
        if (context.Request["commandNumAndop_man"] != null)
        {
            wherea_other += " and commandNum='" + context.Request["commandNumAndop_man"] + "' and op_man='" + getUsername() + "'";
        }

        //公共方法，是否添加数据权限权限比较
        if (context.Request["dataQX"] != null)
        {
            wherea_tree += " and hrz_id in( select Org_id from Sys_role_data_power where role_id='" + GetDataRoleId() + "' ) ";
        }

        //公共方法，是否添加 按照用户 选择的厂家进行权限过滤
        if (context.Request["facQx"] != null)
        {
            string strPost_id = GetUserPostId();
            if (strPost_id == "" || strPost_id == "0")
            {
            }
            else
            {
                wherea_tree += " and house_id in(select distinct House_id from vw_Yb_house_meter_basic where Meter_id in(select Meter_id from vw_equip_meter_simple where fac_id='" + strPost_id + "')) ";
            }

        }
        //公共方法，是否添加数据权限权限比较
        if (context.Request["op_man"] != null)
        {
            wherea_tree += " and op_man='" + getUsername() + "'";
        }
        //公共方法，
        if (context.Request["Public_meter_idList"] != null)
        {
            string public_meter_idList=context.Request["Public_meter_idList"].ToString();
            if (public_meter_idList != "")
            {
                wherea_tree += " and meter_id in(" + public_meter_idList + ")";
            }
            
        }
        if (context.Request["Public_f_idList"] != null)
        {
            string public_f_idList = context.Request["Public_f_idList"].ToString();
            if (public_f_idList != "")
            {
                wherea_tree += " and f_id in(" + public_f_idList + ")";
            }

        }
        
        //公共方法 通过meter_id 得到 本单元所有单元的 meter_ids 20170107
        if (context.Request["Public_fromMeterid_get_dy_meter_ids"] != null)
        {
            string meter_id = context.Request["Public_fromMeterid_get_dy_meter_ids"].ToString();
            if (meter_id != "")
            {
                wherea_tree += " and meter_id in(select meter_id from vw_Yb_house_meter_basic where House_id in ( select house_id from vw_Public_house_basic where P_id in (select P_id from vw_Public_house_basic where House_id in (select House_id from vw_Yb_house_meter_basic where Meter_id="+meter_id+"))))";
            }

        }

        //公共方法，传递多个参数的问题
        if (context.Request["List_parms"] != null)
        {
            if (!string.IsNullOrEmpty(context.Request["List_parms"].ToString()))
            {
                string str = context.Request["List_parms"].ToString();
                var vArray = str.Split('|');
                for (int i = 0; i < vArray.Length; i++)
                {
                    l_parms.Add(vArray[i]); //统一添加到数组函数中
                }
            }
        }

       
        //公共方法结束---------------------------------------------------------------------------------------------------

        string view = context.Request["view"];
        context.Session["view"] = view;
        string gridName = context.Request["gridName"];
        DataSet ds = new DataSet();
        DataTable dt = new DataTable();
        int TotalPage = 0;
        int totalRecord = 0;
        string returnMsg = "";
        SQLHelper db_helper = new SQLHelper();
        string json = "";
        
        string methodType = context.Request["methodType"];
        if (methodType == "V")
        {
            #region 这里执行视图

            if(view=="")
            {
                
            }
            else
            {
                 wherea_all = "1=1";
                 if (!string.IsNullOrEmpty(wherea_left))
                 {
                     wherea_all += " and " + wherea_left;
                 }
                 if (!string.IsNullOrEmpty(wherea_center))
                 {
                     wherea_all += " and " + wherea_center;
                 }
                 if (!string.IsNullOrEmpty(where_tree))
                 {
                     wherea_all +=  wherea_tree;
                 }
                 if (!string.IsNullOrEmpty(wherea_other))
                 {
                     wherea_all += " and " + wherea_other;
                 }
                 //公共方法，对应直接传过来的where条件
                 if (context.Request["where_str"] != null)
                 {
                     wherea_all += context.Request["where_str"];
                 }
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
                { _pagesize = "20"; }

                System.Collections.Generic.List<Object> l = new System.Collections.Generic.List<object>();
                l.Add("V");
                if (!string.IsNullOrEmpty(sortname))//这里记录住了执行的sql语句
                {
                    string str = "select * from " + view + " where " + wherea_all + " order by " + sortname + " " + sortorder;//保存住本次查询的数据 用于导出 
                    l.Add(str);
                }
                else
                {
                    string str= "select * from " + view + " where " + wherea_all;
                    l.Add(str);
                }
                context.Session["sql_" + gridName + "_" + view] = l;//保存住本次查询的数据 用于导出 
                
                 ds = db_helper.ReturnPageList("ProcDataPaging", view, "*", sortname + " " + sortorder, wherea_all, Convert.ToInt32(_pagesize), Convert.ToInt32(pagenumber1), out TotalPage, out totalRecord);
                dt = new DataTable();
                if (ds != null)
                {
                    if (ds.Tables.Count > 0)
                    {
                        #region
                        dt = ds.Tables[0];
                        #endregion
                    }
                }
                
                string View_json = @"{}";
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
            #endregion
            
        }
        else if (methodType == "U") //一般存储过程  
        {
            #region 这里执行存储过程
            string ParameterNum = context.Request["ParameterNum"];
            System.Data.SqlClient.SqlParameter[] commandParameters = null;
            string param0 = ""; string param1 = ""; string param2 = "";
            string param3 = ""; string param4 = ""; string param5 = "";
            string param6= ""; string param7 = ""; string param8 = "";
            if (ParameterNum == "0")//没有参数的
            { 
                commandParameters = new System.Data.SqlClient.SqlParameter[] { };
            }
            else if (ParameterNum == "1")
            {
                commandParameters = new System.Data.SqlClient.SqlParameter[] 
                { 
                     new System.Data.SqlClient.SqlParameter("@where_tree", SqlDbType.VarChar), 
                };
                commandParameters[0].Value = param0;
               
            }
            else if (ParameterNum == "2")
            {
                commandParameters = new System.Data.SqlClient.SqlParameter[] 
                { 
                     new System.Data.SqlClient.SqlParameter("@where_tree", SqlDbType.VarChar), 
                     new System.Data.SqlClient.SqlParameter("@where_center", SqlDbType.VarChar), 
                };
                commandParameters[0].Value = param0;
                commandParameters[1].Value = param1;
            }
            else if (ParameterNum == "3")
            {
                commandParameters = new System.Data.SqlClient.SqlParameter[] 
                { 
                     new System.Data.SqlClient.SqlParameter("@where_tree", SqlDbType.VarChar), 
                     new System.Data.SqlClient.SqlParameter("@where_left", SqlDbType.VarChar), 
                     new System.Data.SqlClient.SqlParameter("@where_center", SqlDbType.VarChar), 
                };
                commandParameters[0].Value = wherea_tree;
                commandParameters[1].Value = wherea_left;
                commandParameters[2].Value = wherea_center;
            }
            else if (ParameterNum == "4")
            {
                commandParameters = new System.Data.SqlClient.SqlParameter[] 
                { 
                    
                     new System.Data.SqlClient.SqlParameter("@where_tree", SqlDbType.VarChar), 
                     new System.Data.SqlClient.SqlParameter("@where_house", SqlDbType.VarChar), 
                     new System.Data.SqlClient.SqlParameter("@where_meter", SqlDbType.VarChar), 
                     new System.Data.SqlClient.SqlParameter("@where_other1", SqlDbType.VarChar), 
                };
                commandParameters[0].Value = wherea_tree;
                commandParameters[1].Value = wherea_up_house;
                commandParameters[2].Value = wherea_up_meter;
                commandParameters[3].Value = wherea_up_other1;
            }
            else if (ParameterNum == "5")
            {
                commandParameters = new System.Data.SqlClient.SqlParameter[] 
                { 
                     new System.Data.SqlClient.SqlParameter("@where_tree", SqlDbType.VarChar), 
                     new System.Data.SqlClient.SqlParameter("@where_house", SqlDbType.VarChar), 
                     new System.Data.SqlClient.SqlParameter("@where_meter", SqlDbType.VarChar), 
                     new System.Data.SqlClient.SqlParameter("@where_other1", SqlDbType.VarChar), 
                     new System.Data.SqlClient.SqlParameter("@where_other2", SqlDbType.VarChar)
                };
                commandParameters[0].Value = wherea_tree;
                commandParameters[1].Value = wherea_up_house;
                commandParameters[2].Value = wherea_up_meter;
                commandParameters[3].Value = wherea_up_other1;
                commandParameters[4].Value = wherea_up_other2;
            }
            else if (ParameterNum == "6")
            {
                commandParameters = new System.Data.SqlClient.SqlParameter[] 
                { 
                     new System.Data.SqlClient.SqlParameter("@where_tree", SqlDbType.VarChar), 
                     new System.Data.SqlClient.SqlParameter("@where_left", SqlDbType.VarChar), 
                     new System.Data.SqlClient.SqlParameter("@where_center", SqlDbType.VarChar), 
                     new System.Data.SqlClient.SqlParameter("@begindt", SqlDbType.VarChar), 
                     new System.Data.SqlClient.SqlParameter("@param4", SqlDbType.VarChar), 
                };
                commandParameters[0].Value = param0;
                commandParameters[1].Value = param1;
                commandParameters[2].Value = param2;
                commandParameters[3].Value = param3;
                commandParameters[4].Value = param4;
            }
            else if (ParameterNum == "7")
            {
                commandParameters = new System.Data.SqlClient.SqlParameter[] 
                { 
                     new System.Data.SqlClient.SqlParameter("@where_tree", SqlDbType.VarChar), 
                     new System.Data.SqlClient.SqlParameter("@where_house", SqlDbType.VarChar), 
                     new System.Data.SqlClient.SqlParameter("@where_meter", SqlDbType.VarChar), 
                     new System.Data.SqlClient.SqlParameter("@where_other1", SqlDbType.VarChar), 
                     new System.Data.SqlClient.SqlParameter("@where_other2", SqlDbType.VarChar), 
                     new System.Data.SqlClient.SqlParameter("@where_other3", SqlDbType.VarChar), 
                     new System.Data.SqlClient.SqlParameter("@where_other4", SqlDbType.VarChar)
                };
                commandParameters[0].Value = wherea_tree;
                commandParameters[1].Value = wherea_up_house;
                commandParameters[2].Value = wherea_up_meter;
                commandParameters[3].Value = wherea_up_other1;
                commandParameters[4].Value = wherea_up_other2;
                commandParameters[5].Value = wherea_up_other3;
                commandParameters[6].Value = wherea_up_other4;
                
            }
            else if (ParameterNum == "teshu8")
            {
                commandParameters = new System.Data.SqlClient.SqlParameter[] 
                { 
                     new System.Data.SqlClient.SqlParameter("@where_tree", SqlDbType.VarChar), 
                     new System.Data.SqlClient.SqlParameter("@where_house", SqlDbType.VarChar), 
                     new System.Data.SqlClient.SqlParameter("@where_meter", SqlDbType.VarChar), 
                     new System.Data.SqlClient.SqlParameter("@other1", SqlDbType.VarChar), 
                     new System.Data.SqlClient.SqlParameter("@other2", SqlDbType.VarChar), 
                     new System.Data.SqlClient.SqlParameter("@other3", SqlDbType.VarChar), 
                     new System.Data.SqlClient.SqlParameter("@other4", SqlDbType.VarChar), 
                     new System.Data.SqlClient.SqlParameter("@other5", SqlDbType.VarChar)
                };
                commandParameters[0].Value = wherea_tree;
                commandParameters[1].Value = wherea_up_house;
                commandParameters[2].Value = wherea_up_meter;
                commandParameters[3].Value = l_parms[0];
                commandParameters[4].Value = l_parms[1];
                commandParameters[5].Value = l_parms[2];
                commandParameters[6].Value = l_parms[3];
                commandParameters[7].Value = wherea_up_other5;

            }

            System.Collections.Generic.List<Object> l = new System.Collections.Generic.List<object>();
            l.Add("U");
            l.Add(view);
            l.Add(commandParameters);
            context.Session["sql_" + gridName + "_" + view] = l;//保存住本次查询的数据 用于导出 
            
            json = @"{""Rows"":[],""Total"":""0""}";//转变成dll转变
            DataSet ds1 = db_helper.RunProcedure(view, commandParameters, view);
            if (ds1 != null)
            {
                if (ds1.Tables.Count > 0)
                {
                    totalRecord = ds1.Tables[0].Rows.Count;
                    dt = ds1.Tables[0];
                    
                    string pagenumber1 = context.Request["page"];
                    if (context.Request["page"] == null)//异常处理
                    { pagenumber1 = "1"; }
                    string _pagesize = context.Request["pagesize"];
                    if (context.Request["pagesize"] == null)
                    { _pagesize = "20"; }

                    string sortname = context.Request["sortName"];
                    string sortorder = context.Request["sortOrder"];

                    if (!string.IsNullOrEmpty(sortname))
                    {
                        if (!string.IsNullOrEmpty(sortorder))
                        {
                            sortorder = "asc";
                        }
                        dt.DefaultView.Sort = sortname + " " + sortorder;
                        dt = dt.DefaultView.ToTable();
                    }
                    
                    DataTable dtPart = ReplaceStr.DataTable_partDt(dt, Convert.ToInt32(pagenumber1), Convert.ToInt32(_pagesize));
                    Newtonsoft.Json.JsonSerializerSettings js = new Newtonsoft.Json.JsonSerializerSettings();
                    js.DateFormatString = "yyyy-MM-dd HH:mm:ss";
                    string jsontemp = Newtonsoft.Json.JsonConvert.SerializeObject(dtPart, Newtonsoft.Json.Formatting.Indented, js);
                    //json = @"{""Rows"":" + jsontemp + @",""Total"":""" + totalRecord + @"""}";//转变成dll转变
                    int iCode = 0;
                    json = @"{""data"":" + jsontemp + @",""code"":""" + iCode + @""",""count"":""" + totalRecord + @""",""msg"":""" + returnMsg + @"""}";//转变成dll转变
                }
            }
            
            #endregion
        }
        else if (methodType == "UT")//特殊的存储过程执行情况 
        {
            string ParameterNum = context.Request["ParameterNum"];
            
            string sortname = context.Request["sortName"];
            string sortorder = context.Request["sortOrder"];
            
            string pagenumber1 = context.Request["page"];
            if (context.Request["page"] == null)//异常处理
            { pagenumber1 = "1"; }
            string _pagesize = context.Request["pagesize"];
            if (context.Request["pagesize"] == null)
            { _pagesize = "20"; }

            System.Data.SqlClient.SqlParameter[] commandParameters = null;
            DataSet set1 = new DataSet();
            #region 这里执行函数
            if (ParameterNum == "7")
            {
                
                commandParameters = new System.Data.SqlClient.SqlParameter[] 
                { 
                    new System.Data.SqlClient.SqlParameter("@TotalPage", SqlDbType.Int), 
                     new System.Data.SqlClient.SqlParameter("@totalRecord", SqlDbType.Int), 
                     
                     new System.Data.SqlClient.SqlParameter("@where_tree", SqlDbType.VarChar), 
                     new System.Data.SqlClient.SqlParameter("@where_house", SqlDbType.VarChar), 
                     new System.Data.SqlClient.SqlParameter("@where_meter", SqlDbType.VarChar), 
                     new System.Data.SqlClient.SqlParameter("@pageSize", SqlDbType.VarChar), 
                     new System.Data.SqlClient.SqlParameter("@pageIndex", SqlDbType.VarChar), 
                     
                };
                
                commandParameters[0].Direction = ParameterDirection.Output;
                commandParameters[1].Direction = ParameterDirection.Output;
                
                commandParameters[2].Value = wherea_tree;
                commandParameters[3].Value = wherea_up_house;
                commandParameters[4].Value = wherea_up_meter;
                commandParameters[5].Value = _pagesize;
                commandParameters[6].Value = pagenumber1;


                set1 = db_helper.RunProcedure(view, commandParameters, view);
                TotalPage = 0;
                totalRecord = 0;
                TotalPage = (int)commandParameters[0].Value;
                totalRecord = (int)commandParameters[1].Value;
                
            }
            else if (ParameterNum == "8")
            {

                commandParameters = new System.Data.SqlClient.SqlParameter[] 
                { 
                     new System.Data.SqlClient.SqlParameter("@TotalPage", SqlDbType.Int), 
                     new System.Data.SqlClient.SqlParameter("@totalRecord", SqlDbType.Int), 
                     new System.Data.SqlClient.SqlParameter("@returnMsg", SqlDbType.VarChar,500), 
                     
                     new System.Data.SqlClient.SqlParameter("@where_tree", SqlDbType.VarChar), 
                     new System.Data.SqlClient.SqlParameter("@where_house", SqlDbType.VarChar), 
                     new System.Data.SqlClient.SqlParameter("@where_meter", SqlDbType.VarChar), 
                     new System.Data.SqlClient.SqlParameter("@pageSize", SqlDbType.VarChar), 
                     new System.Data.SqlClient.SqlParameter("@pageIndex", SqlDbType.VarChar), 
                    
                };
                commandParameters[0].Direction = ParameterDirection.Output;
                commandParameters[1].Direction = ParameterDirection.Output;
                commandParameters[2].Direction = ParameterDirection.Output;

                commandParameters[3].Value = wherea_tree;
                commandParameters[4].Value = wherea_up_house;
                commandParameters[5].Value = wherea_up_meter;
                commandParameters[6].Value = _pagesize;
                commandParameters[7].Value = pagenumber1;

                set1 = db_helper.RunProcedure(view, commandParameters, view);
                TotalPage = 0;
                totalRecord = 0;
                returnMsg = "";
                TotalPage = (int)commandParameters[0].Value;
                totalRecord = (int)commandParameters[1].Value;
                returnMsg = (string)commandParameters[2].Value;
                
            }
            else if (ParameterNum == "9")
            {

                commandParameters = new System.Data.SqlClient.SqlParameter[] 
                { 
                     new System.Data.SqlClient.SqlParameter("@TotalPage", SqlDbType.Int), 
                     new System.Data.SqlClient.SqlParameter("@totalRecord", SqlDbType.Int), 
                     new System.Data.SqlClient.SqlParameter("@returnMsg", SqlDbType.VarChar,500), 
                     
                     new System.Data.SqlClient.SqlParameter("@where_tree", SqlDbType.VarChar), 
                     new System.Data.SqlClient.SqlParameter("@where_house", SqlDbType.VarChar), 
                     new System.Data.SqlClient.SqlParameter("@where_meter", SqlDbType.VarChar), 
                     new System.Data.SqlClient.SqlParameter("@where_other1", SqlDbType.VarChar), 
                     new System.Data.SqlClient.SqlParameter("@pageSize", SqlDbType.VarChar), 
                     new System.Data.SqlClient.SqlParameter("@pageIndex", SqlDbType.VarChar), 
                    
                };
                commandParameters[0].Direction = ParameterDirection.Output;
                commandParameters[1].Direction = ParameterDirection.Output;
                commandParameters[2].Direction = ParameterDirection.Output;

                commandParameters[3].Value = wherea_tree;
                commandParameters[4].Value = wherea_up_house;
                commandParameters[5].Value = wherea_up_meter;
                commandParameters[6].Value = wherea_up_other1;
                commandParameters[7].Value = _pagesize;
                commandParameters[8].Value = pagenumber1;

                set1 = db_helper.RunProcedure(view, commandParameters, view);
                TotalPage = 0;
                totalRecord = 0;
                returnMsg = "";
                TotalPage = (int)commandParameters[0].Value;
                totalRecord = (int)commandParameters[1].Value;
                returnMsg = (string)commandParameters[2].Value;

            } 
                
            System.Collections.Generic.List<Object> l = new System.Collections.Generic.List<object>();
            l.Add("U");
            l.Add(view + "_notSplitPage");
            l.Add(commandParameters);
            context.Session["sql_" + gridName + "_" + view] = l;//保存住本次查询的数据 用于导出 
            
            if (set1 != null)
            {
                if (set1.Tables.Count > 0)
                {
                    dt = set1.Tables[0];
                   
                    if (!string.IsNullOrEmpty(sortname)) {
                        if (!string.IsNullOrEmpty(sortorder)) {
                            sortorder = "asc";
                        }
                        dt.DefaultView.Sort = sortname + " " + sortorder;
                        dt = dt.DefaultView.ToTable();
                    }

                }
            }
            
            if (dt.Rows.Count > 0)
            {
                
                Newtonsoft.Json.JsonSerializerSettings js = new Newtonsoft.Json.JsonSerializerSettings();
                js.DateFormatString = "yyyy-MM-dd HH:mm:ss";
                string jsontemp = Newtonsoft.Json.JsonConvert.SerializeObject(dt, Newtonsoft.Json.Formatting.Indented, js);
                //json = @"{""Rows"":" + jsontemp + @",""Total"":""" + totalRecord + @""",""returnMsg"":""" + returnMsg + @"""}";//转变成dll转变
                int iCode = 0;
                json = @"{""data"":" + jsontemp + @",""code"":""" + iCode + @""",""count"":""" + totalRecord + @""",""msg"":""" + returnMsg + @"""}";//转变成dll转变
                
            }

            #endregion
        }
        else if (methodType == "F")
        {
            #region 这里执行函数
            
            #endregion
        }
        else
        {
            #region 这里其他情况
            
            #endregion
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
    
    private static string get_op_sql(string op)
    {
        string strReturn="";
        if(op=="equal")
        {
            strReturn="=";
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
            strReturn=op;
        }
        return strReturn;
    }

}