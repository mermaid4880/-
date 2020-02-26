<%@ WebHandler Language="C#" Class="set_f_order" %>

using System;
using System.Web;

public class set_f_order : IHttpHandler {

    ///公共情况进行定义开始-------------------------------------------------------------------------------------------------
    //保存到历史，并删除 server_clientCommand 的条件
    private string public_delete_TJ = " (op_result='成功' or (datediff(day,op_dt,getdate())>=7) )";
    private static string cookieTage = PublicMethod.public_getConfigStr("cookieTage");
    
    //指定 哪些类型的厂家 要通过集中器操作 
    private string jzq_fac_code = "'xintian','other'";//只有采集器厂家是这里面的都用集中器id ，并且设备类型 是集中器

    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string strReturn = "";
        string method = context.Request["method"];
        if (method == "readMeterData")
        {
            string TreeId = context.Request["TreeId"];
            strReturn = readMeterData(TreeId);
        }
        if (method == "set_f_order")
        {
            string f_idList = context.Request["f_idList"];
            string orderType = context.Request["orderType"];
            string orderContent = context.Request["orderContent"];
            strReturn = set_f_orderMethod(f_idList, orderType, orderContent);
        }
        //查询命令中热表所有的数量
        else if (method == "getCommandAllCount")
        {
            string commandNum = context.Request["commandNum"];
            string type = context.Request["type"];
            strReturn = getCommandAllCount(commandNum, type);
        }

        //查询命令中已获取的热表的数量
        else if (method == "getHasReadCommandCount")
        {
            string commandNum = context.Request["commandNum"];
            string type = context.Request["type"];
            strReturn = getHasReadCommandCount(commandNum, type);
        }
       

        context.Response.Write(strReturn);
    }

    private string set_f_orderMethod(string f_idList,  string orderType, string orderContent)
    {

        string strReturn = "";
        if (f_idList.Length >0)
        {


            string User_name = "";//取得用户名
            try { User_name = DES_En_De.DesDecrypt(System.Web.HttpContext.Current.Request.Cookies[cookieTage]["d5hgj5jk7sfa"]); }
            catch { }

            string commandNum = PublicMethod.public_getRadNum();

            string strSql = "";

            //string device_type = "4";
            //if (Key >= 'I' && Key <= 'L')
            //{
            //    device_type = "1";
            //}

            string ip = PublicMethod.GetIPAddress();

            strSql = " insert into server_clientCommand_log(id, op_man, op_dt, ip, sockert, wr_set, pro_st, fac_code, device_type, device_no, set_content, op_result, op_result_demo, return_dt, meter_id_list, isRead, mpid, type,analyze_type, createDate,commandNum) select id, op_man, op_dt, ip, sockert, wr_set, pro_st, fac_code, device_type, device_no, set_content, op_result, op_result_demo, return_dt, meter_id_list, isRead, mpid, type,analyze_type,getdate(),commandNum from server_clientCommand where  1=1 and " + public_delete_TJ + " and  op_man='" + User_name + "'";
            strSql += " delete server_clientCommand  where     op_man='" + User_name + "'";

            string wr_set = "2";
            if (orderType == "1") {
                wr_set = "1";
            }

            //插入 server表
            strSql += " insert into server_clientCommand(op_man, op_dt, ip, wr_set, pro_st, fac_code, device_type, device_no, set_content, op_result, isRead, mpid, analyze_type, commandNum, f_code, processname)";
            strSql += " select '" + User_name + "',GETDATE(),'" + ip + "'," + wr_set + "," + orderType + ",fac_code,2,center_id,'" + orderContent + "','未知',0,mpid,analyze_type,'" + commandNum + "',F_code,'ewph' from vw_equip_f_SendOrder where 1=1 and f_id in(" + f_idList + ")";


            strSql += " delete Server_Manual_f_info where  op_man='" + User_name + "' insert into Server_Manual_f_info(f_id, f_type_id, Center_id, Mpid, f_no,commandNum,op_man) select distinct f_id, f_type_id, Center_id, Mpid, f_no,'" + commandNum + "','" + User_name + "' from dbo.vw_equip_f_SendOrder where f_id in(" + f_idList + ")";
            strSql += " select '" + commandNum + "'";


            //这里执行strSql
            SQLHelper db = new SQLHelper();
            strReturn = db.GetSingle(strSql).ToString();
        }

        return strReturn;
    }
    //发送指令到数据库 返回影响了多少条数据库
    public string readMeterData(string f_idList)
    {
        string strReturn = "";
        if (f_idList.Length > 1)
        {


            string User_name = "";//取得用户名
            try { User_name = DES_En_De.DesDecrypt(System.Web.HttpContext.Current.Request.Cookies[cookieTage]["d5hgj5jk7sfa"]); }
            catch { }

            string commandNum = PublicMethod.public_getRadNum();
            
            string strSql = "";

            //string device_type = "4";
            //if (Key >= 'I' && Key <= 'L')
            //{
            //    device_type = "1";
            //}

            string ip = PublicMethod.GetIPAddress();

            strSql = " insert into server_clientCommand_log(id, op_man, op_dt, ip, sockert, wr_set, pro_st, fac_code, device_type, device_no, set_content, op_result, op_result_demo, return_dt, meter_id_list, isRead, mpid, type,analyze_type, createDate,commandNum) select id, op_man, op_dt, ip, sockert, wr_set, pro_st, fac_code, device_type, device_no, set_content, op_result, op_result_demo, return_dt, meter_id_list, isRead, mpid, type,analyze_type,getdate(),commandNum from server_clientCommand where  1=1 and " + public_delete_TJ + " and  op_man='" + User_name + "'";
            strSql += " delete server_clientCommand  where     op_man='" + User_name + "'";


            //插入 server表
            strSql += " insert into server_clientCommand(op_man, op_dt, ip, wr_set, pro_st, fac_code, device_type, device_no, set_content, op_result, isRead, mpid, analyze_type, commandNum, f_code, processname)";
            strSql += " select '" + User_name + "',GETDATE(),'" + ip + "',1,1,fac_code,2,center_id,'','未知',0,mpid,analyze_type,'" + commandNum + "',F_code,'ewph' from vw_equip_f_SendOrder where 1=1 and f_id in(" + f_idList + ")";


            strSql += " delete Server_Manual_f_info where  op_man='" + User_name + "' insert into Server_Manual_f_info(f_id, f_type_id, Center_id, Mpid, f_no,commandNum,op_man) select distinct f_id, f_type_id, Center_id, Mpid, f_no,'" + commandNum + "','" + User_name + "' from dbo.vw_equip_f_SendOrder where f_id in(" + f_idList + ")";
            strSql += " select '" + commandNum + "'";


            //这里执行strSql
            SQLHelper db = new SQLHelper();
            strReturn = db.GetSingle(strSql).ToString();
        }

        return strReturn;
    }


    private string getHasReadCommandCount(string commandNum, string type)
    {
        //返回格式
        string strReturn = "0";
        string strSql = "select count(*) from server_clientCommand where commandNum='" + commandNum + "' and op_result<>'未知'";
        if (type == "1")//读取阀
        {
            strSql = "select COUNT(*) from Server_Manual_F_info where commandNum='" + commandNum + "' and Txzt_id<>'40'";
        }


        SQLHelper db = new SQLHelper();
        try
        {
            strReturn = db.GetSingle(strSql).ToString();
        }
        catch
        { }
        return strReturn;
    }



    //读取所有的热表数据 ABC
    private string getCommandAllCount(string commandNum, string type)
    {
        //返回格式
        string strReturn = "0";



        string strSql = "";
        //strSql += " select count(*) from dbo.split((select top 1 meter_id_list from server_clientCommand where  ip='" + PublicMethod.GetIPAddress() + "' order by op_dt desc ),',')";
        if (type == "1")
        {
            string User_name = "";//取得用户名
            try { User_name = DES_En_De.DesDecrypt(System.Web.HttpContext.Current.Request.Cookies["z3y0ylpxgg05"]["d5hgj5jk7sfa"]); }
            catch { }
            strSql = " select count(*) from Server_Manual_f_info where op_man='" + User_name + "'";
        }
        else
        {
            strSql = "select count(*) from server_clientCommand where commandNum='" + commandNum + "'";
        }
        //string strSql = "select count(*) from server_clientCommand where commandNum='" + commandNum + "'";
        SQLHelper db = new SQLHelper();
        try
        {
            strReturn = db.GetSingle(strSql).ToString();
        }
        catch
        { }
        return strReturn;
    }
    
    public bool IsReusable {
        get {
            return false;
        }
    }

}