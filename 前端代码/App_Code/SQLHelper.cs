using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;

/// <summary>
///SQLHelper 的摘要说明
/// </summary>
public class SQLHelper
{
    private string SqlConnectionString = string.Empty;
    private SqlConnection cn;  //创建数据库SQL连接
    private SqlDataReader sdr; //创建SQL数据读取器
    private SqlCommand cmd;       //创建SQL命令对象       
    private readonly string RETURNVALUE = "RETURNVALUE";
    private static string p_file = "";
    private static string p_pageInfo = "";

    private int commandSqlTimeout = 0;//执行sql语句最长等待时间

    public SQLHelper()
    {
        SqlConnectionString = ConfigurationManager.ConnectionStrings["robot_db"].ConnectionString;
    }

    public SQLHelper(string filename, string pageinfo)
    {
        p_file = filename;
        p_pageInfo = pageinfo;
    }

    /// <summary>
    /// 实例化数据连接字符串
    /// </summary>
    /// <returns>返回数据连接字符串</returns>
    public SqlConnection GetConn()
    {
        SqlConnection cn = new SqlConnection(SqlConnectionString);
        return cn;
    }
    /// <summary>
    /// 返回数据连接字符串
    /// </summary>
    /// <returns></returns>
    public string GetConnStr()
    {
        return SqlConnectionString;
    }

    /// <summary>
    /// 打开数据库连接
    /// </summary>
    public void Open()
    {
        #region
        try
        {
            cn = new SqlConnection(SqlConnectionString);
            cn.Open();
        }
        catch (Exception ex)
        {
            //WriteLog.SaveTextToFile(DateTime.Now.ToString() + ": Open Connection Fail: \n" + ex.Message + "\n", p_file, p_pageInfo);
            writeTxtCls wtc = new writeTxtCls();
            wtc.writeTxtToFile("\r\n[" + System.DateTime.Now.ToString() + "]执行Open()发生问题：" + ex.Message);
        }
        #endregion
    }
    /// <summary>
    /// 测试数据库连接是否正常
    /// </summary>
    public void test()
    {
        cn = new SqlConnection(SqlConnectionString);
        cn.Open();
    }
    /// <summary>
    /// 关闭数据库连接
    /// </summary>
    public void Close()
    {
        #region
        if (cn != null)
        {
            cn.Close();
            cn.Dispose();
        }
        #endregion
    }

    #region sql语句
    /// <summary>
    /// 获得SqlDataReader对象 使用完须关闭DataReader,关闭数据库连接
    /// </summary>
    /// <param name="strSql">sql语句</param>
    /// <returns></returns>
    public SqlDataReader GetDataReader(string strSql)
    {
        #region
        try
        {
            Open();
            cmd = new SqlCommand(strSql, cn);
            sdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);
        }
        catch (Exception ex)
        {
            //WriteLog.SaveTextToFile(DateTime.Now.ToString() + ": GetDataReader()+" + strSql + ": \n" + ex.Message + "\n", p_file, p_pageInfo);
        }

        return sdr;
        #endregion
    }

    /// <summary>
    /// 获得DataTable对象 使用完须关闭DataTable,关闭数据库连接
    /// </summary>
    /// <param name="strSql">sql语句</param>
    /// <returns></returns>
    public DataTable GetDataTable(string strSql)
    {
        #region
        Open();
        SqlDataAdapter da = new SqlDataAdapter(strSql, cn);
        da.SelectCommand.CommandTimeout = commandSqlTimeout;//李光耀添加
        DataTable dt = new DataTable();
        try
        {
            ///读取数据

            da.Fill(dt);
        }
        catch (Exception ex)
        {
            //WriteLog.SaveTextToFile(DateTime.Now.ToString() + ": GetDataTable()+" + strSql + ": \n" + E.Message + "\n", p_file, p_pageInfo);
            writeTxtCls wtc = new writeTxtCls();
            wtc.writeTxtToFile("\r\n[" + System.DateTime.Now.ToString() + "]执行GetDataTable方法[" + strSql + "]语句发生问题：" + ex.Message);
        }
        finally
        {
            ///关闭数据库的连接
            Close();
        }
        return dt;

        #endregion
    }

    /// <summary>
    /// 获得DataSet对象 使用完须关闭DataSet,关闭数据库连接
    /// </summary>
    /// <param name="strSql">sql语句</param>
    /// <returns></returns>
    public DataSet GetDataSet(string strSql)
    {
        #region
        Open();
        cmd = new SqlCommand(strSql, cn);
        cmd.CommandTimeout = commandSqlTimeout;//这里修改成无等待时间
        SqlDataAdapter da = new SqlDataAdapter(cmd);
        DataSet dt = new DataSet();
        try
        {
            ///读取数据
            da.Fill(dt);
        }
        catch (Exception ex)
        {
            //WriteLog.SaveTextToFile(DateTime.Now.ToString() + ": GetDataTable()+" + strSql + ": \n" + E.Message + "\n", p_file, p_pageInfo);
            writeTxtCls wtc = new writeTxtCls();
            wtc.writeTxtToFile("\r\n[" + System.DateTime.Now.ToString() + "]执行GetDataSet方法[" + strSql + "]语句发生问题：" + ex.Message);
        }
        finally
        {
            ///关闭数据库的连接
            Close();
        }
        return dt;
        #endregion
    }

    /// <summary>
    /// 执行SQL不返回任何值
    /// </summary>
    /// <param name="strSql"></param>
    public void RunSqlStr(string strSql)
    {
        #region 执行SQL不返回任何值
        try
        {
            Open();
            cmd = new SqlCommand(strSql, cn);
            cmd.CommandTimeout = commandSqlTimeout;
            cmd.ExecuteNonQuery();
        }
        catch (Exception ex)
        {
            //WriteLog.SaveTextToFile(DateTime.Now.ToString() + ": RunSqlStr()+" + strSql + ": \n" + E.Message + "\n", p_file, p_pageInfo);
            writeTxtCls wtc = new writeTxtCls();
            wtc.writeTxtToFile("\r\n[" + System.DateTime.Now.ToString() + "]执行RunSqlStr方法[" + strSql + "]语句发生问题：" + ex.Message);
        }
        finally
        {
            Close();
        }
        #endregion
    }

    /// <summary>
    /// 执行SQL返回影响的行数
    /// </summary>
    /// <param name="strSql"></param>
    public int RunSqlInt(string strSql)
    {
        #region 执行SQL返回影响的行数
        int i = 0;
        try
        {
            Open();
            cmd = new SqlCommand(strSql, cn);
            cmd.CommandTimeout = commandSqlTimeout;
            i = cmd.ExecuteNonQuery();

        }
        catch (Exception E)
        {
            //WriteLog.SaveTextToFile(DateTime.Now.ToString() + ": RunSqlInt()+" + strSql + ": \n" + E.Message + "\n", p_file, p_pageInfo);
            writeTxtCls wtc = new writeTxtCls();
            wtc.writeTxtToFile("\r\n[" + System.DateTime.Now.ToString() + "]执行RunSqlInt方法[" + strSql + "]语句发生问题：" + E.Message);
        }
        finally
        {
            Close();
        }
        return i;
        #endregion
    }

    /// <summary>
    /// 执行sql 返回 RunSqlReturn_class 对象
    /// </summary>
    /// <param name="strSql"></param>
    public RunSqlReturn_class RunSql_getObjClass(string strSql)
    {
        #region 执行SQL返回影响的行数
        RunSqlReturn_class rc = new RunSqlReturn_class();
        try
        {
            Open();
            cmd = new SqlCommand(strSql, cn);
            cmd.CommandTimeout = commandSqlTimeout;
            rc.iReturn = cmd.ExecuteNonQuery();

        }
        catch (Exception E)
        {
            //WriteLog.SaveTextToFile(DateTime.Now.ToString() + ": RunSqlInt()+" + strSql + ": \n" + E.Message + "\n", p_file, p_pageInfo);
            rc.Message = E.Message;
            writeTxtCls wtc = new writeTxtCls();
            wtc.writeTxtToFile("\r\n[" + System.DateTime.Now.ToString() + "]执行RunSql_getObjClass方法[" + strSql + "]语句发生问题：" + E.Message);
        }
        finally
        {
            Close();
        }
        return rc;
        #endregion
    }
    /// <summary>
    /// 执行带参数的SQL返回影响的行数
    /// </summary>
    /// <param name="strSql"></param>
    public int RunSqlInt(string strSql, SqlParameter[] parms)
    {
        #region 执行带参数SQL返回影响的行数
        int i = 0;
        try
        {
            Open();
            //cmd = new SqlCommand(strSql, cn);
            //cmd.CommandTimeout = 0;
            cmd = new SqlCommand(strSql, cn);
            foreach (SqlParameter p in parms)
            {
                cmd.Parameters.Add(p);
            }
            cmd.CommandType = CommandType.Text;
            cmd.CommandTimeout = commandSqlTimeout;
            i = cmd.ExecuteNonQuery();
            cmd.Parameters.Clear();
        }
        catch (Exception E)
        {
            //WriteLog.SaveTextToFile(DateTime.Now.ToString() + ": RunSqlInt()+" + strSql + ": \n" + E.Message + "\n", p_file, p_pageInfo);
            writeTxtCls wtc = new writeTxtCls();
            wtc.writeTxtToFile("\r\n[" + System.DateTime.Now.ToString() + "]执行RunSqlInt方法[" + strSql + "]语句发生问题：" + E.Message);
        }
        finally
        {
            Close();
        }
        return i;
        #endregion
    }


    //HXM cmd.ExecuteScalar();返回结果集中的首行首列 
    public int RunSqlNo(string strSql)
    {
        int i = 0;
        try
        {
            Open();
            cmd = new SqlCommand(strSql, cn);
            cmd.CommandTimeout = commandSqlTimeout;
            i = Convert.ToInt32(cmd.ExecuteScalar());
        }
        catch(Exception ex)
        {
            writeTxtCls wtc = new writeTxtCls();
            wtc.writeTxtToFile("\r\n[" + System.DateTime.Now.ToString() + "]执行RunSqlInt方法[" + strSql + "]语句发生问题：" + ex.Message);
        }
        finally
        {
            Close();
        }
        return i;
    }

    /// <summary>
    /// HXM 根据P_EntrustMaster中的EMR_ID字段返回与之对应的PMR_PLANID的值
    /// </summary>
    /// <param name="strSql"></param>
    /// <returns></returns>
    public string RunSqlPlanID(string strSql)
    {
        string planID = null;
        try
        {
            Open();
            cmd = new SqlCommand(strSql, cn);
            planID = cmd.ExecuteScalar().ToString();
        }
        catch (Exception ex)
        {
            writeTxtCls wtc = new writeTxtCls();
            wtc.writeTxtToFile("\r\n[" + System.DateTime.Now.ToString() + "]执行RunSqlPlanID方法[" + strSql + "]语句发生问题：" + ex.Message);
        }
        finally
        {
            Close();
        }
        return planID;
    }

    /// <summary>
    /// 执行多条SQL语句,类似事务
    /// </summary>
    /// <param name="SQLStringList"></param>
    public void ExecuteSqlTran(string[] SQLStringList)
    {
        Open();
        SqlCommand cmd = new SqlCommand();
        cmd.Connection = cn;
        SqlTransaction tx = cn.BeginTransaction();
        cmd.Transaction = tx;
        try
        {
            for (int n = 0; n < SQLStringList.Length; n++)
            {
                string strsql = SQLStringList[n].ToString();
                if (strsql.Trim().Length > 1)
                {
                    cmd.CommandText = strsql;
                    cmd.ExecuteNonQuery();
                }
            }
            tx.Commit();
        }
        catch (System.Data.SqlClient.SqlException E)
        {
            writeTxtCls wtc = new writeTxtCls();
            wtc.writeTxtToFile("\r\n[" + System.DateTime.Now.ToString() + "]执行ExecuteSqlTran语句发生问题：" + E.Message);
            tx.Rollback();
            throw new Exception(E.Message);

        }
        finally
        {
            Close();
        }
    }

    /// <summary>
    /// 执行SQL语句，并返回第一行第一列结果
    /// </summary>
    /// <param name="strSql">SQL语句</param>
    /// <returns></returns>
    public string RunSqlReturn(string strSql)
    {
        #region
        string strReturn = "";
        Open();
        try
        {
            cmd = new SqlCommand(strSql, cn);
            cmd.CommandTimeout = commandSqlTimeout;
            strReturn = cmd.ExecuteScalar().ToString();
        }
        catch (Exception E)
        {
            writeTxtCls wtc = new writeTxtCls();
            wtc.writeTxtToFile("\r\n[" + System.DateTime.Now.ToString() + "]执行RunSqlReturn方法[" + strSql + "]语句发生问题：" + E.Message);
            //WriteLog.SaveTextToFile(DateTime.Now.ToString() + ": RunSqlReturn()+" + strSql + ": \n" + E.Message + "\n", p_file, p_pageInfo);
        }
        Close();
        return strReturn;
        #endregion
    }

    /// <summary>
    /// 执行SQL语句，并返回第一行第一列结果
    /// </summary>
    /// <param name="strSql">SQL语句</param>
    /// <returns></returns>
    public string RunSqlReturn(string strSql, SqlParameter[] prams)
    {
        #region
        string strReturn = "";
        Open();
        try
        {
            cmd = CreateSQLCommand(strSql, prams);
            strReturn = cmd.ExecuteScalar().ToString();

        }
        catch (Exception E)
        {
            writeTxtCls wtc = new writeTxtCls();
            wtc.writeTxtToFile("\r\n[" + System.DateTime.Now.ToString() + "]执行RunSqlReturn方法[" + strSql + "]语句发生问题：" + E.Message);
            //WriteLog.SaveTextToFile(DateTime.Now.ToString() + ": RunSqlReturn()+" + strSql + ": \n" + E.Message + "\n", p_file, p_pageInfo);
        }
        return strReturn;
        #endregion
    }

    /// <summary>
    /// 创建一个SqlDataAdapter对象，用此来执行SQL语句
    /// </summary>
    /// <param name="cmdText">SQL语句</param>
    /// <param name="prams">SQL语句所需参数</param>
    /// <returns>返回SqlDataAdapter对象</returns>
    private SqlDataAdapter CreateSQLDataAdapter(string cmdText, SqlParameter[] prams)
    {
        ///打开数据库连接
        Open();
        ///设置SqlDataAdapter对象
        SqlDataAdapter da = new SqlDataAdapter(cmdText, cn);
        ///添加把存储过程的参数
        if (prams != null)
        {
            foreach (SqlParameter parameter in prams)
            {
                da.SelectCommand.Parameters.Add(parameter);
            }
        }
        ///添加返回参数ReturnValue
        da.SelectCommand.Parameters.Add(
            new SqlParameter(RETURNVALUE, SqlDbType.Int, 4, ParameterDirection.ReturnValue,
            false, 0, 0, string.Empty, DataRowVersion.Default, null));

        ///返回创建的SqlDataAdapter对象
        return da;
    }

    /// <summary>
    /// 创建一个SqlCommand对象以此来执行存储过程
    /// </summary>
    /// <param name="cmdText">SQL语句</param>
    /// <param name="prams">SQL语句所需参数</param>
    /// <returns>返回SqlCommand对象</returns>
    private SqlCommand CreateSQLCommand(string cmdText, SqlParameter[] prams)
    {
        ///打开数据库连接
        Open();
        SqlTransaction tx = cn.BeginTransaction();
        ///设置Command
        ///
        SqlCommand cmd = new SqlCommand(cmdText, cn);
        cmd.Transaction = tx;
        ///添加把存储过程的参数
        if (prams != null)
        {
            foreach (SqlParameter parameter in prams)
            {
                cmd.Parameters.Add(parameter);
            }
        }

        ///添加返回参数ReturnValue
        cmd.Parameters.Add(
            new SqlParameter(RETURNVALUE, SqlDbType.Int, 4, ParameterDirection.ReturnValue,
            false, 0, 0, string.Empty, DataRowVersion.Default, null));

        ///返回创建的SqlCommand对象
        return cmd;
    }

    public string GetReturnString(string p_SqlString)
    {
        try
        {
            Open();
            SqlDataAdapter l_DataAdapter = new SqlDataAdapter(p_SqlString, cn);
            System.Data.DataTable l_DataTable = new System.Data.DataTable();
            l_DataAdapter.Fill(l_DataTable);
            l_DataAdapter.Dispose();
            if (cn.State == ConnectionState.Open)
            {
                Close();
            }
            if (l_DataTable.Rows.Count > 0)
            {
                string l_count = l_DataTable.Rows[0].ItemArray.GetValue(0).ToString();
                l_DataTable.Dispose();
                return l_count;
            }
            else
            {
                return "";
            }
        }
        catch(Exception E)
        {
            writeTxtCls wtc = new writeTxtCls();
            wtc.writeTxtToFile("\r\n[" + System.DateTime.Now.ToString() + "]执行RunSqlReturn方法[" + p_SqlString + "]语句发生问题：" + E.Message);
            return "";
        }
    }
    #endregion

    #region 存储过程


    /// <summary> 
    /// 创建一个SqlCommand对象以此来执行存储过程 
    /// </summary> 
    /// <param name="procName">存储过程的名称</param> 
    /// <param name="prams">存储过程所需参数</param> 
    /// <returns>返回SqlCommand对象</returns> 
    private SqlCommand CreateProcCommand(string procName, SqlParameter[] prams)
    {
        ///打开数据库连接 
        Open();

        ///设置Command 
        SqlCommand cmd = new SqlCommand(procName, cn);
        cmd.CommandType = CommandType.StoredProcedure;

        ///添加把存储过程的参数 
        if (prams != null)
        {
            foreach (SqlParameter parameter in prams)
            {
                cmd.Parameters.Add(parameter);
            }
        }

        ///添加返回参数ReturnValue 
        //cmd.Parameters.Add(
        //new SqlParameter(RETURNVALUE, SqlDbType.Int, 4, ParameterDirection.ReturnValue,
        //false, 0, 0, string.Empty, DataRowVersion.Default, null));

        ///返回创建的SqlCommand对象 
        return cmd;
    }



    /// <summary> 
    /// 创建一个SqlDataAdapter对象，用此来执行存储过程 
    /// </summary> 
    /// <param name="procName">存储过程的名称</param> 
    /// <param name="prams">存储过程所需参数</param> 
    /// <returns>返回SqlDataAdapter对象</returns> 
    private SqlDataAdapter CreateProcDataAdapter(string procName, SqlParameter[] prams)
    {
        ///打开数据库连接 
        Open();

        ///设置SqlDataAdapter对象 
        SqlDataAdapter da = new SqlDataAdapter(procName, cn);
        da.SelectCommand.CommandType = CommandType.StoredProcedure;

        ///添加把存储过程的参数 
        if (prams != null)
        {
            foreach (SqlParameter parameter in prams)
            {
                da.SelectCommand.Parameters.Add(parameter);
            }
        }

        ///添加返回参数ReturnValue 
        da.SelectCommand.Parameters.Add(
            new SqlParameter(RETURNVALUE, SqlDbType.Int, 4, ParameterDirection.ReturnValue,
            false, 0, 0, string.Empty, DataRowVersion.Default, null));

        ///返回创建的SqlDataAdapter对象 
        return da;
    }


    /// <summary> 
    /// 生成存储过程参数 
    /// </summary> 
    /// <param name="ParamName">存储过程名称</param> 
    /// <param name="DbType">参数类型</param> 
    /// <param name="Size">参数大小</param> 
    /// <param name="Direction">参数方向</param> 
    /// <param name="Value">参数值</param> 
    /// <returns>新的 parameter 对象</returns> 
    public SqlParameter CreateParam(string ParamName, SqlDbType DbType, Int32 Size, ParameterDirection Direction, object Value)
    {
        SqlParameter param;

        ///当参数大小为0时，不使用该参数大小值 
        if (Size > 0)
        {
            param = new SqlParameter(ParamName, DbType, Size);
        }
        else
        {
            ///当参数大小为0时，不使用该参数大小值 
            param = new SqlParameter(ParamName, DbType);
        }

        ///创建输出类型的参数 
        param.Direction = Direction;
        if (!(Direction == ParameterDirection.Output && Value == null))
        {
            param.Value = Value;
        }

        ///返回创建的参数 
        return param;
    }

    /// <summary> 
    /// 传入输入参数 
    /// </summary> 
    /// <param name="ParamName">存储过程名称</param> 
    /// <param name="DbType">参数类型</param></param> 
    /// <param name="Size">参数大小</param> 
    /// <param name="Value">参数值</param> 
    /// <returns>新的parameter 对象</returns> 
    public SqlParameter CreateInParam(string ParamName, SqlDbType DbType, int Size, object Value)
    {
        return CreateParam(ParamName, DbType, Size, ParameterDirection.Input, Value);
    }

    /// <summary> 
    /// 传入返回值参数 
    /// </summary> 
    /// <param name="ParamName">存储过程名称</param> 
    /// <param name="DbType">参数类型</param> 
    /// <param name="Size">参数大小</param> 
    /// <returns>新的 parameter 对象</returns> 
    public SqlParameter CreateOutParam(string ParamName, SqlDbType DbType, int Size)
    {
        return CreateParam(ParamName, DbType, Size, ParameterDirection.Output, null);
    }

    /// <summary> 
    /// 传入返回值参数 
    /// </summary> 
    /// <param name="ParamName">存储过程名称</param> 
    /// <param name="DbType">参数类型</param> 
    /// <param name="Size">参数大小</param> 
    /// <returns>新的 parameter 对象</returns> 
    public SqlParameter CreateReturnParam(string ParamName, SqlDbType DbType, int Size)
    {
        return CreateParam(ParamName, DbType, Size, ParameterDirection.ReturnValue, null);
    }



    #region 执行无参数存储过程，返回DataTable
    /// <summary> 
    /// 执行无参数存储过程，返回DataTable 
    /// </summary> 
    /// <param name="procName"></param> 
    /// <returns></returns> 
    public DataTable GetProcDataTable(string procName)
    {
        #region
        DataSet ds = new DataSet();
        DataTable dt = new DataTable();
        try
        {
            ///读取数据
            RunProc(procName, ref ds);
            dt = ds.Tables[0];
        }
        catch (Exception E)
        {
            //WriteLog.SaveTextToFile(DateTime.Now.ToString() + ": GetProcDataTable+" + "" + ": \n" + E.Message + "\n", p_file, p_pageInfo);
        }
        return dt;

        #endregion
    }

    /// <summary>
    /// 执行有参数存储过程，返回DataTable
    /// </summary>
    /// <param name="procName"></param>
    /// <param name="prams"></param>
    /// <returns></returns>
    public DataTable GetProcDataTable(string procName, SqlParameter[] prams)
    {
        #region
        DataSet ds = new DataSet();
        DataTable dt = new DataTable();
        try
        {
            ///读取数据
            RunProc(procName, prams, ref ds);
            dt = ds.Tables[0];
        }
        catch (Exception E)
        {
            //WriteLog.SaveTextToFile(DateTime.Now.ToString() + ": GetProcDataTable+" + "" + ": \n" + E.Message + "\n", p_file, p_pageInfo);
        }
        return dt;

        #endregion
    }
    #endregion

    /// <summary> 
    /// 执行存储过程 
    /// </summary> 
    /// <param name="procName">存储过程的名称</param> 
    /// <returns>返回存储过程返回值</returns> 
    public int RunProc(string procName)
    {
        SqlCommand cmd = CreateProcCommand(procName, null);
        cmd.CommandTimeout = commandSqlTimeout;//一秒
        int iRet;
        try
        {
            cmd.Parameters.Add("@RETURN_VALUE", "").Direction = ParameterDirection.ReturnValue;
            ///执行存储过程 
            cmd.ExecuteNonQuery();
        }
        catch (Exception ex)
        {
            ///记录错误日志 
            //WriteLog.SaveTextToFile(DateTime.Now.ToString() + ": RunProc()+" + procName + ": \n" + ex.Message + "\n", p_file, p_pageInfo);
            writeTxtCls wtc = new writeTxtCls();
            wtc.writeTxtToFile("\r\n[" + System.DateTime.Now.ToString() + "]执行RunProc方法[" + procName + "]语句发生问题：" + ex.Message);
        }
        finally
        {
            ///关闭数据库的连接 
            Close();
        }
        iRet = (int)cmd.Parameters["@RETURN_VALUE"].Value;
        ///返回存储过程的参数值 
        return iRet;
    }

    /// <summary> 
    /// 执行存储过程 
    /// </summary> 
    /// <param name="procName">存储过程名称</param> 
    /// <param name="prams">存储过程所需参数</param> 
    /// <returns>返回存储过程返回值</returns> 
    public int RunProc(string procName, SqlParameter[] prams)
    {
        SqlCommand cmd = CreateProcCommand(procName, prams);
        int iRet;
        try
        {
            cmd.Parameters.Add("@RETURN_VALUE", "").Direction = ParameterDirection.ReturnValue;
            cmd.CommandTimeout = commandSqlTimeout;
            ///执行存储过程 
            cmd.ExecuteNonQuery();
        }
        catch (Exception ex)
        {
            ///记录错误日志 
            //WriteLog.SaveTextToFile(DateTime.Now.ToString() + ": RunProc()+" + procName + ": \n" + ex.Message + "\n", p_file, p_pageInfo);
            writeTxtCls wtc = new writeTxtCls();
            wtc.writeTxtToFile("\r\n[" + System.DateTime.Now.ToString() + "]执行RunProc方法[" + procName + "]语句发生问题：" + ex.Message);
        }
        finally
        {
            ///关闭数据库的连接 
            Close();
        }

        ///返回存储过程的参数值 
        iRet = (int)cmd.Parameters["@RETURN_VALUE"].Value;
        ///返回存储过程的参数值 
        return iRet;
    }
    public void myRunProc(string procName, SqlParameter[] prams)
    {
        SqlCommand cmd = CreateProcCommand(procName, prams);
        try
        {
            ///执行存储过程 
            ///
            cmd.CommandTimeout = commandSqlTimeout;
            cmd.ExecuteNonQuery();
        }
        catch (Exception ex)
        {
            writeTxtCls wtc = new writeTxtCls();
            wtc.writeTxtToFile("\r\n[" + System.DateTime.Now.ToString() + "]执行myRunProc方法[" + procName + "]语句发生问题：" + ex.Message);
            ///记录错误日志 
            //WriteLog.SaveTextToFile(DateTime.Now.ToString() + ": RunProc()+" + procName + ": \n" + ex.Message + "\n", p_file, p_pageInfo);
        }
        finally
        {
            ///关闭数据库的连接 
            Close();
        }
    }

    /// <summary> 
    /// 执行存储过程 
    /// </summary> 
    /// <param name="procName">存储过程的名称</param> 
    /// <param name="dataReader">返回存储过程返回值</param> 
    public void RunProc(string procName, out SqlDataReader dataReader)
    {
        ///创建Command 
        SqlCommand cmd = CreateProcCommand(procName, null);
        cmd.CommandTimeout = commandSqlTimeout;
        try
        {
            ///读取数据 
            dataReader = cmd.ExecuteReader(CommandBehavior.CloseConnection);
        }
        catch (Exception ex)
        {
            writeTxtCls wtc = new writeTxtCls();
            wtc.writeTxtToFile("\r\n[" + System.DateTime.Now.ToString() + "]执行RunProc方法[" + procName + "]语句发生问题：" + ex.Message);
            dataReader = null;
            ///记录错误日志 
            //WriteLog.SaveTextToFile(DateTime.Now.ToString() + ": RunProc()+" + procName + ": \n" + ex.Message + "\n", p_file, p_pageInfo);
        }
    }

    /// <summary> 
    /// 执行存储过程 
    /// </summary> 
    /// <param name="procName">存储过程的名称</param> 
    /// <param name="prams">存储过程所需参数</param> 
    /// <param name="dataSet">返回DataReader对象</param> 
    public void RunProc(string procName, SqlParameter[] prams, out SqlDataReader dataReader)
    {
        ///创建Command 
        SqlCommand cmd = CreateProcCommand(procName, prams);
        cmd.CommandTimeout = commandSqlTimeout;
        try
        {
            ///读取数据 
            dataReader = cmd.ExecuteReader(CommandBehavior.CloseConnection);
        }
        catch (Exception ex)
        {
            writeTxtCls wtc = new writeTxtCls();
            wtc.writeTxtToFile("\r\n[" + System.DateTime.Now.ToString() + "]执行RunProc方法[" + procName + "]语句发生问题：" + ex.Message);
            dataReader = null;
            ///记录错误日志 
            //WriteLog.SaveTextToFile(DateTime.Now.ToString() + ": RunProc()+" + procName + ": \n" + ex.Message + "\n", p_file, p_pageInfo);
        }
    }

    /// <summary> 
    /// 执行存储过程 
    /// </summary> 
    /// <param name="procName">存储过程的名称</param> 
    /// <param name="dataSet">返回DataSet对象</param> 
    public void RunProc(string procName, ref DataSet dataSet)
    {
        if (dataSet == null)
        {
            dataSet = new DataSet();
        }
        ///创建SqlDataAdapter 
        SqlDataAdapter da = CreateProcDataAdapter(procName, null);

        try
        {
            ///读取数据 
            da.Fill(dataSet);
        }
        catch (Exception ex)
        {
            writeTxtCls wtc = new writeTxtCls();
            wtc.writeTxtToFile("\r\n[" + System.DateTime.Now.ToString() + "]执行RunProc方法[" + procName + "]语句发生问题：" + ex.Message);
            ///记录错误日志 
            //WriteLog.SaveTextToFile(DateTime.Now.ToString() + ": RunProc()+" + procName + ": \n" + ex.Message + "\n", p_file, p_pageInfo);
        }
        finally
        {
            ///关闭数据库的连接 
            Close();
        }
    }

    /// <summary> 
    /// 执行存储过程 
    /// </summary> 
    /// <param name="procName">存储过程的名称</param> 
    /// <param name="prams">存储过程所需参数</param> 
    /// <param name="dataSet">返回DataSet对象</param> 
    public void RunProc(string procName, SqlParameter[] prams, ref DataSet dataSet)
    {
        if (dataSet == null)
        {
            dataSet = new DataSet();
        }
        ///创建SqlDataAdapter 
        SqlDataAdapter da = CreateProcDataAdapter(procName, prams);

        try
        {
            ///读取数据 
            da.Fill(dataSet);
        }
        catch (Exception ex)
        {
            writeTxtCls wtc = new writeTxtCls();
            wtc.writeTxtToFile("\r\n[" + System.DateTime.Now.ToString() + "]执行RunProc方法[" + procName + "]语句发生问题：" + ex.Message);
            ///记录错误日志 
            //WriteLog.SaveTextToFile(DateTime.Now.ToString() + ": RunProc()+" + procName + ": \n" + ex.Message + "\n", p_file, p_pageInfo);
        }
        finally
        {
            ///关闭数据库的连接 
            Close();
        }
    }
    #endregion

    #region 事务处理
    /// <summary>
    /// 执行一条计算查询结果语句，返回查询结果（object）。
    /// </summary>
    /// <param name="SQLString">计算查询结果语句</param>
    /// <returns>查询结果（object）</returns>
    public object GetSingle(string SQLString, params SqlParameter[] cmdParms)
    {
        using (SqlConnection connection = new SqlConnection(SqlConnectionString))
        {
            using (SqlCommand cmd = new SqlCommand())
            {
                try
                {
                    PrepareCommand(cmd, connection, null, SQLString, cmdParms);
                    object obj = cmd.ExecuteScalar();
                    cmd.Parameters.Clear();
                    if ((Object.Equals(obj, null)) || (Object.Equals(obj, System.DBNull.Value)))
                    {
                        return null;
                    }
                    else
                    {
                        return obj;
                    }
                }
                catch (System.Data.SqlClient.SqlException e)
                {
                    throw e;
                }
            }
        }
    }

    /// <summary>
    /// 执行多条SQL语句，实现数据库事务。
    /// </summary>
    /// <param name="SQLStringList">SQL语句的哈希表（key为sql语句，value是该语句的SqlParameter[]）</param>
    public static int ExecuteSqlTranWithIndentity(Hashtable SQLStringList)
    {
        int flag = 0;
        using (SqlConnection conn = new SqlConnection("server=192.168.1.28;database=rlsfXH;uid=sa;pwd=2326;pooling=false"))
        {
            Hashtable ht_CT_50010 = new Hashtable();
            Hashtable ht_CT_50011 = new Hashtable();
            Hashtable ht_CT_50012 = new Hashtable();
            Hashtable ht_CT_50013 = new Hashtable();
            foreach (DictionaryEntry myDE in SQLStringList)
            {
                if (myDE.Key.ToString().Contains("CT_50010"))
                {
                    ht_CT_50010.Add(myDE.Key.ToString(), myDE.Value);
                }
                if (myDE.Key.ToString().Contains("CT_50011"))
                {
                    ht_CT_50011.Add(myDE.Key.ToString(), myDE.Value);
                }
                if (myDE.Key.ToString().Contains("CT_50012"))
                {
                    ht_CT_50012.Add(myDE.Key.ToString(), myDE.Value);
                }
                if (myDE.Key.ToString().Contains("CT_50013"))
                {
                    ht_CT_50013.Add(myDE.Key.ToString(), myDE.Value);
                }
            }
            conn.Open();
            using (SqlTransaction trans = conn.BeginTransaction())
            {
                SqlCommand cmd = new SqlCommand();
                try
                {
                    int indentity = 0;
                    foreach (DictionaryEntry myDE in ht_CT_50010)
                    {
                        string cmdText = myDE.Key.ToString();
                        SqlParameter[] cmdParms = (SqlParameter[])myDE.Value;
                        foreach (SqlParameter q in cmdParms)
                        {
                            if (q.Direction == ParameterDirection.InputOutput)
                            {
                                q.Value = indentity;
                            }
                        }
                        PrepareCommand(cmd, conn, trans, cmdText, cmdParms);
                        int val = cmd.ExecuteNonQuery();
                        foreach (SqlParameter q in cmdParms)
                        {
                            if (q.Direction == ParameterDirection.Output)
                            {
                                indentity = Convert.ToInt32(q.Value);
                            }
                        }
                        cmd.Parameters.Clear();
                    }
                    foreach (DictionaryEntry myDE in ht_CT_50011)
                    {
                        string cmdText = myDE.Key.ToString();
                        SqlParameter[] cmdParms = (SqlParameter[])myDE.Value;
                        foreach (SqlParameter q in cmdParms)
                        {
                            if (q.Direction == ParameterDirection.InputOutput)
                            {
                                q.Value = indentity;
                            }
                        }
                        PrepareCommand(cmd, conn, trans, cmdText, cmdParms);
                        int val = cmd.ExecuteNonQuery();
                        foreach (SqlParameter q in cmdParms)
                        {
                            if (q.Direction == ParameterDirection.Output)
                            {
                                indentity = Convert.ToInt32(q.Value);
                            }
                        }
                        cmd.Parameters.Clear();
                    }
                    foreach (DictionaryEntry myDE in ht_CT_50012)
                    {
                        string cmdText = myDE.Key.ToString();
                        SqlParameter[] cmdParms = (SqlParameter[])myDE.Value;
                        foreach (SqlParameter q in cmdParms)
                        {
                            if (q.Direction == ParameterDirection.InputOutput)
                            {
                                q.Value = indentity;
                            }
                        }
                        PrepareCommand(cmd, conn, trans, cmdText, cmdParms);
                        int val = cmd.ExecuteNonQuery();
                        foreach (SqlParameter q in cmdParms)
                        {
                            if (q.Direction == ParameterDirection.Output)
                            {
                                indentity = Convert.ToInt32(q.Value);
                            }
                        }
                        cmd.Parameters.Clear();
                    }
                    foreach (DictionaryEntry myDE in ht_CT_50013)
                    {
                        string cmdText = myDE.Key.ToString();
                        SqlParameter[] cmdParms = (SqlParameter[])myDE.Value;
                        foreach (SqlParameter q in cmdParms)
                        {
                            if (q.Direction == ParameterDirection.InputOutput)
                            {
                                q.Value = indentity;
                            }
                        }
                        PrepareCommand(cmd, conn, trans, cmdText, cmdParms);
                        int val = cmd.ExecuteNonQuery();
                        foreach (SqlParameter q in cmdParms)
                        {
                            if (q.Direction == ParameterDirection.Output)
                            {
                                indentity = Convert.ToInt32(q.Value);
                            }
                        }
                        cmd.Parameters.Clear();
                    }
                    trans.Commit();
                    flag = 1;
                }
                catch
                {
                    trans.Rollback();
                    throw;
                }
            }
        }
        return flag;
    }

    /// <summary>
    /// 执行多条SQL语句，实现数据库事务。
    /// </summary>
    /// <param name="SQLStringList">SQL语句的哈希表（key为sql语句，value是该语句的SqlParameter[]）</param>
    public static int ExecuteSqlTran(Hashtable SQLStringList)
    {
        int flag = 0;
        using (SqlConnection conn = new SqlConnection("server=192.168.1.28;database=rlsfXH;uid=sa;pwd=2326;pooling=false"))
        {
            conn.Open();
            using (SqlTransaction trans = conn.BeginTransaction())
            {
                SqlCommand cmd = new SqlCommand();
                try
                {
                    //循环
                    foreach (DictionaryEntry myDE in SQLStringList)
                    {
                        string cmdText = myDE.Key.ToString();
                        SqlParameter[] cmdParms = (SqlParameter[])myDE.Value;
                        PrepareCommand(cmd, conn, trans, cmdText, cmdParms);
                        int val = cmd.ExecuteNonQuery();
                        cmd.Parameters.Clear();
                    }
                    trans.Commit();
                    flag = 1;
                }
                catch
                {
                    trans.Rollback();
                    throw;
                }
            }
        }
        return flag;
    }

    /// <summary>
    /// 执行多条SQL语句，实现数据库事务。
    /// </summary>
    /// <param name="SQLStringList">多条SQL语句</param>        
    public static int ExecuteSqlTran(List<String> SQLStringList)
    {
        using (SqlConnection conn = new SqlConnection("server=192.168.1.28;database=rlsfXH;uid=sa;pwd=2326;pooling=false"))
        {
            conn.Open();
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = conn;
            SqlTransaction tx = conn.BeginTransaction();
            cmd.Transaction = tx;
            try
            {
                int count = 0;
                for (int n = 0; n < SQLStringList.Count; n++)
                {
                    string strsql = SQLStringList[n];
                    if (strsql.Trim().Length > 1)
                    {
                        cmd.CommandText = strsql;
                        count += cmd.ExecuteNonQuery();
                    }
                }
                tx.Commit();
                return count;
            }
            catch
            {
                tx.Rollback();
                return 0;
            }
        }
    }

    private static void PrepareCommand(SqlCommand cmd, SqlConnection conn, SqlTransaction trans, string cmdText, SqlParameter[] cmdParms)
    {
        if (conn.State != ConnectionState.Open)
            conn.Open();
        cmd.Connection = conn;
        cmd.CommandText = cmdText;
        if (trans != null)
            cmd.Transaction = trans;
        cmd.CommandType = CommandType.Text;//cmdType;
        if (cmdParms != null)
        {


            foreach (SqlParameter parameter in cmdParms)
            {
                if ((parameter.Direction == ParameterDirection.InputOutput || parameter.Direction == ParameterDirection.Input) &&
                    (parameter.Value == null))
                {
                    parameter.Value = DBNull.Value;
                }
                cmd.Parameters.Add(parameter);
            }
        }
    }
    #endregion

    #region 分页存储过程相关
    /// <summary>
    /// 分页存储过程 返回DataSet数据集
    /// </summary>
    /// <param name="procName">存储过程名</param>
    /// <param name="TableName">表名</param>
    /// <param name="Fields">z</param>
    /// <param name="OrderField">排序字段(必须!支持多字段)</param>
    /// <param name="sqlWhere">条件语句(不用加where) </param>
    /// <param name="pageSize">每页多少条记录</param>
    /// <param name="pageIndex">指定当前为第几页</param>
    /// <param name="TotalPage">返回总页数</param>
    /// <returns>返回DataSet数据集</returns>
    public DataSet ReturnPageList(string procName, string TableName, string Fields, string OrderField, string sqlWhere, int pageSize, int pageIndex,
         out int TotalPage, out int totalRecord)
    {
        SqlParameter[] commandParameters = new SqlParameter[] 
         { 
             new SqlParameter("@TableName", SqlDbType.NVarChar), 
             new SqlParameter("@Fields", SqlDbType.NVarChar),
             new SqlParameter("@OrderField", SqlDbType.NVarChar),
             new SqlParameter("@sqlWhere", SqlDbType.NVarChar), 
             new SqlParameter("@pageSize", SqlDbType.Int),
             new SqlParameter("@pageIndex", SqlDbType.Int), 
             new SqlParameter("@TotalPage", SqlDbType.Int,4),
             new SqlParameter("@totalRecord", SqlDbType.Int,4)
         };
        commandParameters[0].Value = TableName;
        commandParameters[1].Value = (Fields == null) ? "*" : Fields;
        commandParameters[2].Value = OrderField;
        commandParameters[3].Value = (sqlWhere == null) ? "" : sqlWhere;
        commandParameters[4].Value = (pageSize == 0) ? 10 : pageSize;
        commandParameters[5].Value = pageIndex;
        commandParameters[6].Direction = ParameterDirection.Output;
        commandParameters[7].Direction = ParameterDirection.Output;
        DataSet set1 = RunProcedure(procName, commandParameters, TableName);
        TotalPage = 0;
        totalRecord = 0;
        TotalPage = (int)commandParameters[6].Value;
        totalRecord = (int)commandParameters[7].Value;

        return set1;
    }

    public DataSet RunProcedure(string storedProcName, IDataParameter[] parameters, string tableName)
    {
        using (SqlConnection conn = new SqlConnection(SqlConnectionString))
        {
            conn.Open();
            DataSet dataSet = new DataSet();
            //if (Connection.State != System.Data.ConnectionState.Open)
            //{
            //    Connection.Open();
            //}
            //Connection.Open();
            
            SqlDataAdapter sqlDA = new SqlDataAdapter();
            sqlDA.SelectCommand = BuildQueryCommand(conn, storedProcName, parameters);
            try
            {
                sqlDA.Fill(dataSet, tableName);
            }
            catch (Exception ex)
            {

                writeTxtCls wtc = new writeTxtCls();
                wtc.writeTxtToFile("\r\n[" + System.DateTime.Now.ToString() + "]执行RunProcedure方法[" + storedProcName + "]语句发生问题：" + ex.Message);
            }
            finally
            {
                sqlDA.SelectCommand.Parameters.Clear();
            }
            //Connection.Close();
            return dataSet;
        }
    }
    public DataSet RunProcedure_longtime(string storedProcName, IDataParameter[] parameters, string tableName)
    {
        using (SqlConnection conn = new SqlConnection(SqlConnectionString))
        {
            conn.Open();
            DataSet dataSet = new DataSet();
            //if (Connection.State != System.Data.ConnectionState.Open)
            //{
            //    Connection.Open();
            //}
            //Connection.Open();

            SqlDataAdapter sqlDA = new SqlDataAdapter();
            sqlDA.SelectCommand = BuildQueryCommand(conn, storedProcName, parameters);
            sqlDA.SelectCommand.CommandTimeout = commandSqlTimeout;//这里修改成无等待时间;
            try
            {
                sqlDA.Fill(dataSet, tableName);
            }
            catch (Exception ex)
            {

                writeTxtCls wtc = new writeTxtCls();
                wtc.writeTxtToFile("\r\n[" + System.DateTime.Now.ToString() + "]执行RunProcedure方法[" + storedProcName + "]语句发生问题：" + ex.Message);
            }
            finally
            {
                sqlDA.SelectCommand.Parameters.Clear();
            }
            //Connection.Close();
            return dataSet;
        }
    }
    private SqlCommand BuildQueryCommand(SqlConnection connection, string storedProcName, IDataParameter[] parameters)
    {
        SqlCommand command = new SqlCommand(storedProcName, connection);
        command.CommandType = CommandType.StoredProcedure;
        command.CommandTimeout = commandSqlTimeout;//这里修改一下执行存储过程不超限
        foreach (SqlParameter parameter in parameters)
        {
            if (parameter != null)
            {
                // 检查未分配值的输出参数,将其分配以DBNull.Value.
                if ((parameter.Direction == ParameterDirection.InputOutput || parameter.Direction == ParameterDirection.Input) &&
                    (parameter.Value == null))
                {
                    parameter.Value = DBNull.Value;
                }
                command.Parameters.Add(parameter);
            }
        }
        return command;
    }
    #endregion

    #region DataTable的Select方法
    public DataTable SelectDT(DataTable SourceTable, params string[] FieldNames)
    {
        object[] lastValues;
        DataTable newTable;
        DataRow[] orderedRows;
        if (FieldNames == null || FieldNames.Length == 0)
            throw new ArgumentNullException("FieldNames");
        lastValues = new object[FieldNames.Length];
        newTable = new DataTable();
        foreach (string fieldName in FieldNames)
            newTable.Columns.Add(fieldName, SourceTable.Columns[fieldName].DataType);
        orderedRows = SourceTable.Select("", string.Join(",", FieldNames));
        foreach (DataRow row in orderedRows)
        {
            if (!fieldValuesAreEqual(lastValues, row, FieldNames))
            {
                newTable.Rows.Add(createRowClone(row, newTable.NewRow(), FieldNames));
                //newTable.Rows.Add(row);
                setLastValues(lastValues, row, FieldNames);
            }
        }
        return newTable;
    }
    private bool fieldValuesAreEqual(object[] lastValues, DataRow currentRow, string[] fieldNames)
    {
        bool areEqual = true;
        for (int i = 0; i < fieldNames.Length; i++)
        {
            if (lastValues[i] == null || !lastValues[i].Equals(currentRow[fieldNames[i]]))
            {
                areEqual = false;
                break;
            }
        }
        return areEqual;
    }
    private DataRow createRowClone(DataRow sourceRow, DataRow newRow, string[] fieldNames)
    {
        foreach (string field in fieldNames)
            newRow[field] = sourceRow[field];
        return newRow;
    }
    private void setLastValues(object[] lastValues, DataRow sourceRow, string[] fieldNames)
    {
        for (int i = 0; i < fieldNames.Length; i++)
            lastValues[i] = sourceRow[fieldNames[i]];
    }
    #endregion

    #region DataTable2Json
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
                jsonBuilder.Append(dt.Rows[i][j].ToString());
                jsonBuilder.Append("\",");
            }
            jsonBuilder.Remove(jsonBuilder.Length - 1, 1);
            jsonBuilder.Append("},");
        }
        if (dt.Rows.Count > 0)
        {
            jsonBuilder.Remove(jsonBuilder.Length - 1, 1);
        }
        jsonBuilder.Append("]");
        return jsonBuilder.ToString();
    }
    #endregion

    /// <summary>
    /// 插入大批量数据的方法 
    /// </summary>
    /// <param name="dt">数据集合</param>
    /// <param name="strSqlTablename"></param>
    /// <param name="dicList"></param>
    public int DataTableToSQLServer(DataTable dt, string strSqlTablename, Dictionary<String, String> dicList)
    {
        int iReturn = 0;
        using (SqlConnection destinationConnection = new SqlConnection(SqlConnectionString))
        {
            destinationConnection.Open();

            using (SqlBulkCopy bulkCopy = new SqlBulkCopy(destinationConnection))
            {

                try
                {

                    //bulkCopy.DestinationTableName = "T_EIInformation";//要插入的表的表明
                    //bulkCopy.ColumnMappings.Add("Email", "Email");//映射字段名 DataTable列名 ,数据库 对应的列名
                    //bulkCopy.ColumnMappings.Add("author", "author");
                    //bulkCopy.ColumnMappings.Add("Title", "Title");
                    //bulkCopy.ColumnMappings.Add("Type", "Type");
                    //bulkCopy.ColumnMappings.Add("confName", "confName");
                    //bulkCopy.ColumnMappings.Add("Language", "Language");
                    //bulkCopy.ColumnMappings.Add("Publicationyear", "Publicationyear");
                    //bulkCopy.ColumnMappings.Add("Conferencelocation", "Conferencelocation");

                    bulkCopy.DestinationTableName = strSqlTablename;
                    if (dicList.Count > 0)
                    {
                        foreach (var dic in dicList)
                        {
                            bulkCopy.ColumnMappings.Add(dic.Key, dic.Value);
                        }
                    }
                    bulkCopy.WriteToServer(dt);
                    iReturn = dt.Rows.Count;
                }
                catch (Exception ex)
                {
                    writeTxtCls wtc = new writeTxtCls();
                    wtc.writeTxtToFile("\r\n[" + System.DateTime.Now.ToString() + "]执行DataTableToSQLServer方法[" + strSqlTablename + "]语句发生问题：" + ex.Message);
                    iReturn = -1;
                    Console.WriteLine(ex.Message);
                }
                finally
                {
                }
            }


        }
        return iReturn;
    }



    /// <summary>
    /// 获得DataSet对象 使用完须关闭DataSet,关闭数据库连接
    /// </summary>
    /// <param name="strSql">sql语句</param>
    /// <returns></returns>
    public DataSet GetDataSet_throw(string strSql)
    {
        #region
        Open();
        cmd = new SqlCommand(strSql, cn);
        cmd.CommandTimeout = commandSqlTimeout;//这里修改成无等待时间
        SqlDataAdapter da = new SqlDataAdapter(cmd);
        DataSet dt = new DataSet();
        try
        {
            ///读取数据
            da.Fill(dt);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        finally
        {
            ///关闭数据库的连接
            Close();
        }
        return dt;
        #endregion
    }
}