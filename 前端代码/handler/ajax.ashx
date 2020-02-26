<%@ WebHandler Language="C#" Class="ajax" %>

using System;
using System.Web;
using System.Data;
using Newtonsoft.Json.Linq;//微软json

using System.Collections.Generic;

public class ajax : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string strReturn = "[]";

        string typeName = context.Request["typeName"];
        string method = context.Request["method"];

        if (typeName.ToLower() == "public")
        {
            if (method == "public_add_db")
            {
                strReturn = public_add_db(context);
            }
            else if (method == "public_update_db")
            {
                strReturn = public_update_db(context);
            }
            else if (method == "public_del_db")
            {
                strReturn = public_del_db(context);
            }
        }
        else if (typeName.ToLower() == "login")
        {
            if (method == "public_add_db")
            {
                strReturn = OpenSys_user(context);
            }
            else if (method == "CloseSys_user")
            {
                strReturn = CloseSys_user(context);
            }
            else if (method == "UpdatePwd")
            {
                strReturn = UpdatePwd(context);
            }

        }

        else if (typeName.ToLower() == "equip_f")
        {
            if (method == "public_add_f")
            {
                strReturn = public_add_f(context);
            }
            else if (method == "public_update_f")
            {
                strReturn = public_update_f(context);
            }
            else if (method == "public_del_f")
            {
                strReturn = public_del_f(context);
            }

        }
        else
        {

        }
        context.Response.Write(strReturn);
    }

    private string UpdatePwd(HttpContext context)
    {
        string strReturn = "{\"code\":\"#code#\",\"msg\":\"#msg#\"}";
        string msg = "";
        int count = 0;
        string tableName = context.Request["tableName"];
        string User_id = context.Request["User_id"];
        string Pwd = context.Request["Pwd"];
        SQLHelper sh =new SQLHelper ();
        if (!string.IsNullOrEmpty(User_id) && !string.IsNullOrEmpty(Pwd)) {
            try
            {
                string sql = "update " + tableName + " set Pwd='" + DES_En_De.DesEncrypt(DES_En_De.UserMd5(ReplaceStr.Replace(Pwd))) + "' where User_id=" + User_id;
                count = sh.RunSqlInt(sql);
            }
            catch (Exception ex)
            {
                msg = ex.Message;
                strReturn = strReturn.Replace("#code#", "-1");
                strReturn = strReturn.Replace("#msg#", msg);
            }
            if (count > 0)
            {
                strReturn = strReturn.Replace("#code#", "1");
                strReturn = strReturn.Replace("#msg#", count.ToString());
            }
            else
            {
                strReturn = strReturn.Replace("#code#", "0");
                strReturn = strReturn.Replace("#msg#", "修改失败");
            }
        
        }
        return strReturn;
    }
        
    
    /// <summary>
    /// 禁用用户
    /// </summary>
    /// <param name="context"></param>
    /// <returns></returns>
    #region 禁用用户
    private string CloseSys_user(HttpContext context) { 
        string strReturn ="{\"code\":\"#code#\",\"msg\":\"#msg#\"}";
        string msg = "";
        int count = 0;
        string tableName = context.Request["tableName"];
        string User_id = context.Request["User_id"];
        if (!string.IsNullOrEmpty(User_id))
        {
            try
            {
                string sqlstr = "update " + tableName + " set Open_Mark=0 where User_id =" + User_id;
                SQLHelper sh = new SQLHelper();
                count = sh.RunSqlInt(sqlstr);
            }
            catch (Exception ex)
            {

                msg = ex.Message;
                strReturn = strReturn.Replace("#code#", "-1");
                strReturn = strReturn.Replace("#msg#", msg);
            }
            if (count > 0)
            {
                strReturn = strReturn.Replace("#code#", "1");
                strReturn = strReturn.Replace("#msg#", count.ToString());
            }
            else
            {
                strReturn = strReturn.Replace("#code#", "0");
                strReturn = strReturn.Replace("#msg#", "禁用失败");
            }
        }
            
        return strReturn;
    
    }
    #endregion
    /// <summary>
    /// 登录用户开启
    /// </summary>
    /// <param name="context"></param>
    /// <returns></returns>
    #region 登录用户开启
    private string OpenSys_user(HttpContext context)
    {
        
        string strReturn = "{\"code\":\"#code#\",\"msg\":\"#msg#\"}";
        string msg = "";
        int count = 0;
        string tableName = context.Request["tableName"];
        string User_id = context.Request["User_id"];
        if (!string.IsNullOrEmpty(User_id)) {
            try
            {
                string sqlstr ="update "+tableName+" set Open_Mark=1 where User_id ="+User_id +" select @@RowCount";
                SQLHelper sh = new SQLHelper();
                count = sh.RunSqlInt(sqlstr);
                
            }
            catch (Exception ex)
            {
                msg = ex.Message;
                strReturn = strReturn.Replace("#code#", "-1");
                strReturn = strReturn.Replace("#msg#", msg);
            }
            if (count > 0)
            {
                strReturn = strReturn.Replace("#code#", "1");
                strReturn = strReturn.Replace("#msg#", count.ToString());
            }
            else
            {
                strReturn = strReturn.Replace("#code#", "0");
                strReturn = strReturn.Replace("#msg#", "启用失败");
            }
        
        }
        return strReturn;
    
    }
    #endregion
    //添加数据记录
    private string public_add_db(HttpContext context)
    {
        string strReturn = "{\"code\":\"#code#\",\"msg\":\"#msg#\"}";
        string msg="";
        string tableName = context.Request["tableName"];
        string sqlJson = context.Request["sqlJson"];
        
        //string function_id = context.Request["function_id"];
        
        if (!string.IsNullOrEmpty(tableName) && !string.IsNullOrEmpty(sqlJson))
        {
            //拼接sql
            string strSqlconditon = " (";
            string strSqlValue = " values(";

            //[{"name":"zgs_id@form","value":"0","op":"keyId"},{"name":"zgs_name@form","value":"2","op":"keyValue"},{"name":"jt_id@form","value":"2","op":"keyValue"},{"name":"Order_no@form","value":"3","op":"putong"},{"name":"Remarks@form","value":"4","op":"putong"}]
            JArray ja = JArray.Parse(sqlJson);

            //先判断是否有需要比对 数据重复的字段
            Dictionary<string, string> dicEquList = new Dictionary<string, string>();
            
            for (var i = 0; i < ja.Count; i++) {

                JObject o = (JObject)ja[i];
                string name = o["name"].ToString().Replace("@form", "");//替换掉
                string value=o["value"].ToString();//替换掉
                string op=o["op"].ToString();//替换掉
                if (op== "keyId")
                {
                    
                }
                else if (op == "keyValue")
                {
                    dicEquList.Add(name, value);
                    strSqlconditon += name + ",";
                    strSqlValue += "'" + value + "',";
                }
                else {
                    strSqlconditon += name + ",";
                    strSqlValue += "'" + value + "',";
                }
            }

            if (checkTableHas(tableName, dicEquList)) {
                strReturn = strReturn.Replace("#code#", "2");
                strReturn = strReturn.Replace("#msg#", "已存在！");
                return strReturn;
            }

            if (strSqlconditon != "") {
                strSqlconditon = strSqlconditon.Substring(0, strSqlconditon.Length - 1);//剔除最后一个,
            }
            if (strSqlValue != "")
            {
                strSqlValue = strSqlValue.Substring(0, strSqlValue.Length - 1);//剔除最后一个,
            }
            strSqlconditon += ")";
            strSqlValue += ")";
            string strSql = "insert into " + tableName + strSqlconditon + strSqlValue;
            strSql += " select @@identity ";
            SQLHelper sh = new SQLHelper();
            DataSet ds = new DataSet();
            try
            {
                ds = sh.GetDataSet(strSql);
            }
            catch (Exception ex)
            {
                ds = null;
                msg = ex.Message;
            }
            if (ds != null)
            {
                if (ds.Tables.Count > 0)
                {
                    strReturn = strReturn.Replace("#code#", "1");
                    strReturn = strReturn.Replace("#msg#", ds.Tables[0].Rows[0][0].ToString());
                }
                else
                {
                    strReturn = strReturn.Replace("#code#", "0");
                    strReturn = strReturn.Replace("#msg#", "添加失败");
                }
            }
            else
            {
                strReturn = strReturn.Replace("#code#", "-1");
                strReturn = strReturn.Replace("#msg#", msg);
            }
            
        }
        
        return strReturn;
    }

    //更新数据记录
    private string public_update_db(HttpContext context)
    {
        string strReturn = "{\"code\":\"#code#\",\"msg\":\"#msg#\"}";
        string msg = "";
        string tableName = context.Request["tableName"];
        string sqlJson = context.Request["sqlJson"];
        if (!string.IsNullOrEmpty(tableName) && !string.IsNullOrEmpty(sqlJson))
        {
            //拼接sql
            string strSqlconditon = " ";
            string strSqlValue = " ";

            //[{"name":"zgs_id@form","value":"0","op":"keyId"},{"name":"zgs_name@form","value":"2","op":"keyValue"},{"name":"jt_id@form","value":"2","op":"keyValue"},{"name":"Order_no@form","value":"3","op":"putong"},{"name":"Remarks@form","value":"4","op":"putong"}]
            JArray ja = JArray.Parse(sqlJson);

            //先判断是否有需要比对 数据重复的字段
            Dictionary<string, string> dicEquList = new Dictionary<string, string>();

            //先判断是否有需要比对 数据重复的字段
            Dictionary<string, string> dicNoEquList = new Dictionary<string, string>();
            
            string where="";
            for (var i = 0; i < ja.Count; i++)
            {

                JObject o = (JObject)ja[i];
                string name = o["name"].ToString().Replace("@form", "");//替换掉
                string value = o["value"].ToString();//替换掉
                string op = o["op"].ToString();//替换掉
                if (op == "keyId")
                {
                    dicNoEquList.Add(name, value);
                    where+=" and "+name+"='"+value+"'";
                }
                else if (op == "keyValue")
                {
                    dicEquList.Add(name, value);
                    strSqlconditon += "," + name + "='" + value + "'";
                }
                else
                {
                    strSqlconditon += "," + name + "='" + value + "'";
                }
            }

            if (checkTableHas(tableName, dicEquList,dicNoEquList))
            {
                strReturn = strReturn.Replace("#code#", "2");
                strReturn = strReturn.Replace("#msg#", "已存在！");
                return strReturn;
            }

            string strSql = "update " + tableName + " set updateDate=getdate()" + strSqlconditon + " where 1=1 " + where;
            strSql += " select @@rowcount ";
            SQLHelper sh = new SQLHelper();
            DataSet ds = new DataSet();
            try
            {
                ds = sh.GetDataSet(strSql);
            }
            catch (Exception ex)
            {
                ds = null;
                msg = ex.Message;
            }
            if (ds != null)
            {
                if (ds.Tables.Count > 0)
                {
                    strReturn = strReturn.Replace("#code#", "1");
                    strReturn = strReturn.Replace("#msg#", ds.Tables[0].Rows[0][0].ToString());
                }
                else
                {
                    strReturn = strReturn.Replace("#code#", "0");
                    strReturn = strReturn.Replace("#msg#", "添加失败");
                }
            }
            else
            {
                strReturn = strReturn.Replace("#code#", "-1");
                strReturn = strReturn.Replace("#msg#", msg);
            }

        }

        return strReturn;
    }

    //删除
    private string public_del_db(HttpContext context)
    {
        string strReturn = "{\"code\":\"#code#\",\"msg\":\"#msg#\"}";
        string msg = "";
        string tableName = context.Request["tableName"];
        string sqlKey = context.Request["sqlKey"];
        string sqlValue = context.Request["sqlValue"];
        if (!string.IsNullOrEmpty(tableName) && !string.IsNullOrEmpty(sqlKey) && !string.IsNullOrEmpty(sqlValue))
        {
            string strSql = "update " + tableName + " set flag=-100,updateDate=getdate() where " + sqlKey + " in(" + sqlValue + ")";
            strSql += " select @@ROWCOUNT";
            SQLHelper sh = new SQLHelper();
            DataSet ds = new DataSet();
            try
            {
                ds = sh.GetDataSet(strSql);
            }
            catch (Exception ex)
            {
                ds = null;
                msg = ex.Message;
            }
            if (ds != null)
            {
                if (ds.Tables.Count > 0)
                {
                    strReturn = strReturn.Replace("#code#", "1");//更新成功
                    strReturn = strReturn.Replace("#msg#", ds.Tables[0].Rows[0][0].ToString());
                }
                else
                {
                    strReturn = strReturn.Replace("#code#", "0");
                    strReturn = strReturn.Replace("#msg#", "删除失败");
                }
            }
            else
            {
                strReturn = strReturn.Replace("#code#", "-1");
                strReturn = strReturn.Replace("#msg#", msg);
            }
          
        }
        else
        {
            strReturn = strReturn.Replace("#code#", "0");
            strReturn = strReturn.Replace("#msg#", "删除条件不能为空！"); 
        }
        return strReturn;
    }
    
    /*********************************************************************************************************************/

    //添加数据记录
    private string public_add_f(HttpContext context)
    {
        string strReturn = "{\"code\":\"#code#\",\"msg\":\"#msg#\"}";
        string msg = "";
        string tableName = context.Request["tableName"];
        string sqlJson = context.Request["sqlJson"];
        string dy_id = context.Request["dy_id"];
        string p_level = context.Request["p_level"];

        //string function_id = context.Request["function_id"];

        if (!string.IsNullOrEmpty(tableName) && !string.IsNullOrEmpty(sqlJson))
        {
            //拼接sql
            string strSqlconditon = " (";
            string strSqlValue = " values(";

            JObject jo = JObject.Parse(sqlJson);
            if (jo != null)
            {

                //先判断是否有需要比对 数据重复的字段
                Dictionary<string, string> dicEquList = new Dictionary<string, string>();
                foreach (var o in jo)
                {
                    if (o.Key.ToString().IndexOf("@comparisonEqu") > 0)
                    {
                        string[] strArray = o.Key.Split('@');//注意这里进行拆分
                        dicEquList.Add(strArray[0], o.Value.ToString());
                    }
                }
                //这里进行比对
                if (checkTableHas(tableName, dicEquList))
                {
                    //数据已经存在
                    strReturn = strReturn.Replace("#code#", "10");
                    strReturn = strReturn.Replace("#msg#", "数据已经存在了");
                }
                else
                {
                    //数据不存在，继续插入
                    foreach (var o in jo)
                    {
                        if (o.Key.ToString().IndexOf("@identity") > 0)//这里是主键，不需要处理
                        {

                        }
                        else if (o.Key.ToString().IndexOf("Dy_name") >= 0)//这里是单元，不需要处理
                        {

                        }
                        else if (o.Key.ToString().IndexOf("P_level") >= 0)//这里是层级，不需要处理
                        {

                        }
                        else
                        {
                            string[] strArray = o.Key.Split('@');
                            if (strArray.Length > 1)
                            {
                                strSqlconditon += strArray[0] + ",";
                                strSqlValue += "'" + o.Value + "',";
                            }
                            else
                            {
                                strSqlconditon += o.Key + ",";
                                strSqlValue += "'" + o.Value + "',";
                            }
                        }
                    }
                    strSqlconditon = strSqlconditon.Substring(0, strSqlconditon.Length - 1);//剔除最后一个,
                    strSqlValue = strSqlValue.Substring(0, strSqlValue.Length - 1);//剔除最后一个,
                    strSqlconditon += ")";
                    strSqlValue += ")";
                    string strSql = "insert into " + tableName + strSqlconditon + strSqlValue;
                    strSql += " select @@identity ";
                    strSql += " insert into yb_f_postion(f_id,p_level,postion_id,ftbl,flag,createDate) values( @@identity,'" + p_level + "','" + dy_id + "',1,1,getdate()) ";
                    
                    SQLHelper sh = new SQLHelper();
                    DataSet ds = new DataSet();
                    try
                    {
                        ds = sh.GetDataSet(strSql);
                    }
                    catch (Exception ex)
                    {
                        ds = null;
                        msg = ex.Message;
                    }
                    if (ds != null)
                    {
                        if (ds.Tables.Count > 0)
                        {
                            strReturn = strReturn.Replace("#code#", "1");
                            strReturn = strReturn.Replace("#msg#", ds.Tables[0].Rows[0][0].ToString());
                        }
                        else
                        {
                            strReturn = strReturn.Replace("#code#", "0");
                            strReturn = strReturn.Replace("#msg#", "添加失败");
                        }
                    }
                    else
                    {
                        strReturn = strReturn.Replace("#code#", "-1");
                        strReturn = strReturn.Replace("#msg#", msg);
                    }
                }

            }

        }

        return strReturn;
    }

    //更新数据记录
    private string public_update_f(HttpContext context)
    {
        string strReturn = "{\"code\":\"#code#\",\"msg\":\"#msg#\"}";
        string msg = "";
        string tableName = context.Request["tableName"];
        string sqlJson = context.Request["sqlJson"];
        string dy_id = context.Request["dy_id"];
        string p_level = context.Request["p_level"];
        if (!string.IsNullOrEmpty(tableName) && !string.IsNullOrEmpty(sqlJson))
        {

            JObject jo = JObject.Parse(sqlJson);
            if (jo != null)
            {

                //先判断是否有需要比对 数据重复的字段
                Dictionary<string, string> dicEquList = new Dictionary<string, string>();
                foreach (var o in jo)
                {
                    if (o.Key.ToString().IndexOf("@comparisonEqu") > 0)
                    {
                        string[] strArray = o.Key.Split('@');//注意这里进行拆分
                        dicEquList.Add(strArray[0], o.Value.ToString());
                    }
                }
                //先判断是否有需要比对 数据重复的字段
                Dictionary<string, string> dicNoEquList = new Dictionary<string, string>();
                foreach (var o in jo)
                {
                    if (o.Key.ToString().IndexOf("@comparisonNoEqu") > 0)
                    {
                        string[] strArray = o.Key.Split('@');//注意这里进行拆分
                        dicNoEquList.Add(strArray[0], o.Value.ToString());
                    }
                }
                //这里进行比对
                if (checkTableHas(tableName, dicEquList, dicNoEquList))
                {
                    //数据已经存在
                    strReturn = strReturn.Replace("#code#", "10");
                    strReturn = strReturn.Replace("#msg#", "数据已经存在了");
                }
                else
                {
                    //数据不存在，开始进行更新
                    string sqlWhere = "";
                    //拼接sql
                    string strSqlconditon = " ";


                    foreach (var o in jo)
                    {
                        if (o.Key.ToString().IndexOf("@identity") > 0)//这里是主键，不需要处理
                        {
                            string[] strArray = o.Key.Split('@');
                            sqlWhere += " and " + strArray[0] + "='" + o.Value.ToString() + "'";
                        }
                        else if (o.Key.ToString().IndexOf("Dy_name") >= 0)//这里是单元，不需要处理
                        {

                        }
                        else if (o.Key.ToString().IndexOf("P_level") >= 0)//这里是层级，不需要处理
                        {

                        }
                        else
                        {
                            string[] strArray = o.Key.Split('@');
                            string oValue = o.Value.ToString().Trim();
                            if (string.IsNullOrEmpty(oValue))
                            {
                                strSqlconditon += " ," + strArray[0] + "=null";
                            }
                            else
                            {
                                strSqlconditon += " ," + strArray[0] + "='" + o.Value.ToString() + "'";
                            }

                        }
                    }

                    if (string.IsNullOrEmpty(sqlWhere))
                    {
                        strReturn = strReturn.Replace("#code#", "0");
                        strReturn = strReturn.Replace("#msg#", "更新条件不能为空！");
                    }
                    else
                    {
                        string strSql = "update " + tableName + " set UpdateDate=GETDATE()" + strSqlconditon + " where 1=1 " + sqlWhere;
                        if (dy_id == "0") ///每次更新阀信息时 dy_id变为0  这里判断是0  就不更新dy_id
                        {
                            strSql += " update yb_f_postion set UpdateDate=GETDATE() where f_id in (select f_id from equip_f where 1=1 " + sqlWhere + " )";
                        }
                        else
                        {
                            strSql += " update yb_f_postion set p_level='" + p_level + "', postion_id='" + dy_id + "',UpdateDate=GETDATE() where f_id in (select f_id from equip_f where 1=1 " + sqlWhere + " )";
                        }
                        
                        //strSql += " update yb_f_postion set postion_id='" + dy_id + "',UpdateDate=GETDATE() where f_id in (select f_id from equip_f where 1=1 " + sqlWhere + " )";
                        strSql += " select @@rowcount ";
                        SQLHelper sh = new SQLHelper();
                        DataSet ds = new DataSet();
                        try
                        {
                            ds = sh.GetDataSet(strSql);
                        }
                        catch (Exception ex)
                        {
                            ds = null;
                            msg = ex.Message;
                        }
                        if (ds != null)
                        {
                            if (ds.Tables.Count > 0)
                            {
                                strReturn = strReturn.Replace("#code#", "1");//更新成功
                                strReturn = strReturn.Replace("#msg#", ds.Tables[0].Rows[0][0].ToString());
                            }
                            else
                            {
                                strReturn = strReturn.Replace("#code#", "0");
                                strReturn = strReturn.Replace("#msg#", "更新失败");
                            }
                        }
                        else
                        {
                            strReturn = strReturn.Replace("#code#", "-1");
                            strReturn = strReturn.Replace("#msg#", msg);
                        }
                    }
                }

            }
        }

        return strReturn;
    }

    //删除
    private string public_del_f(HttpContext context)
    {
        string strReturn = "{\"code\":\"#code#\",\"msg\":\"#msg#\"}";
        string msg = "";
        string tableName = context.Request["tableName"];
        string sqlJson = context.Request["sqlJson"];
        if (!string.IsNullOrEmpty(tableName) && !string.IsNullOrEmpty(sqlJson))
        {
            JArray ja = JArray.Parse(sqlJson);
            if (ja != null)
            {
                string strSql = "";
                string sqlWhere = "";
                string sqlColunmName = "";
                foreach (var j in ja)
                {
                    foreach (var o in (JObject)j)
                    {
                        if (o.Key.ToString().IndexOf("@identity") > 0)//这里是主键，不需要处理
                        {
                            string[] strArray = o.Key.Split('@');
                            sqlColunmName = strArray[0];
                            sqlWhere += o.Value.ToString() + ",";
                        }
                    }


                }
                if (string.IsNullOrEmpty(sqlWhere))
                {
                    strReturn = strReturn.Replace("#code#", "0");
                    strReturn = strReturn.Replace("#msg#", "删除条件不能为空！");
                }
                else
                {
                    sqlWhere = sqlWhere.Substring(0, sqlWhere.Length - 1);//去掉最后一个逗号
                    strSql = "update " + tableName + " set flag=-100,updateDate=getdate() where " + sqlColunmName + " in(" + sqlWhere + ")";

                    strSql += " update yb_f_postion set flag=-100,updateDate=getdate() where f_id in ( select f_id from equip_f where " + sqlColunmName + " in(" + sqlWhere + ")  ) ";
                    strSql += " select @@ROWCOUNT";
                    SQLHelper sh = new SQLHelper();
                    DataSet ds = new DataSet();
                    try
                    {
                        ds = sh.GetDataSet(strSql);
                    }
                    catch (Exception ex)
                    {
                        ds = null;
                        msg = ex.Message;
                    }
                    if (ds != null)
                    {
                        if (ds.Tables.Count > 0)
                        {
                            strReturn = strReturn.Replace("#code#", "1");//更新成功
                            strReturn = strReturn.Replace("#msg#", ds.Tables[0].Rows[0][0].ToString());
                        }
                        else
                        {
                            strReturn = strReturn.Replace("#code#", "0");
                            strReturn = strReturn.Replace("#msg#", "删除失败");
                        }
                    }
                    else
                    {
                        strReturn = strReturn.Replace("#code#", "-1");
                        strReturn = strReturn.Replace("#msg#", msg);
                    }
                }
            }

        }
        else
        {
            strReturn = strReturn.Replace("#code#", "0");
            strReturn = strReturn.Replace("#msg#", "删除条件不能为空！");
        }
        return strReturn;
    }
    
    
    /******************************************************************************************************************/

    //
    
    private bool checkTableHas(string tableName, Dictionary<string, string> myDic)
    {
        bool bHas = false;

        if (myDic.Count > 0 && tableName!="")
        {
            string strSql = "select top 1 * from " + tableName + " with(nolock) where 1=1 and flag=1";
            foreach (var dic in myDic)
            {
                strSql += " and " + dic.Key + "='" + dic.Value + "'";
            }
            SQLHelper sh = new SQLHelper();
            DataTable dt = new DataTable();
            try
            {
                dt = sh.GetDataTable(strSql);
            }
            catch
            {
                dt = null;
            }
            if (dt.Rows.Count > 0)
            {
                bHas = true; 
            }
        }

        return bHas;
    }

    private bool checkTableHas(string tableName, Dictionary<string, string> EquDic, Dictionary<string, string> noEquDic)
    {
        bool bHas = false;

        if (EquDic.Count > 0 && tableName != "" && noEquDic.Count > 0)
        {
            string strSql = "select top 1 * from " + tableName + " with(nolock) where 1=1";
            foreach (var dic in EquDic)
            {
                strSql += " and " + dic.Key + "='" + dic.Value + "'";
            }

            foreach (var dic in noEquDic)
            {
                strSql += " and " + dic.Key + "<>'" + dic.Value + "'";
            }
            
            SQLHelper sh = new SQLHelper();
            DataTable dt = new DataTable();
            try
            {
                dt = sh.GetDataTable(strSql);
            }
            catch
            {
                dt = null;
            }
            if (dt.Rows.Count > 0)
            {
                bHas = true;
            }
        }

        return bHas;
    }
    
    public bool IsReusable {
        get {
            return false;
        }
    }

}