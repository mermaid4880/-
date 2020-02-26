<%@ WebHandler Language="C#" Class="sendCommand" %>

using System;
using System.Web;
using System.Net.Sockets;
using System.Net;
using System.Data;
using System.Web.SessionState;
using System.Threading;


public class sendCommand : IHttpHandler,IReadOnlySessionState {


    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string type = context.Request["type"];
        string strReturn = "";
        if (type == "sendCommandTextWithCommandNum")// 根据server_clientCommand 中的 CommandNum 发送消息
        {
            string commandText = context.Request["commandText"];
            string commandNum = context.Request["commandNum"];
            strReturn = For_send_Msg(commandText, commandNum);//发送命令通道
        }
        else if (type == "sendCommandTextWithCommandNum_new")// 从 tb_center_ip 表中 deviceType中区分查询那个ip和端口
        {
            string commandText = context.Request["commandText"];
            string DeviceType = context.Request["DeviceType"];
            string commandNum = context.Request["commandNum"];
            strReturn = For_send_Msg_new(commandText, DeviceType, commandNum);//发送命令通道
        }

        context.Response.Write(strReturn);
    }


    private static string For_send_Msg_new(string commandText, string DeviceType, string commandNum)
    {
        string strReturn = "该采集器未配置client_connect_ip和client_connect_port";

        string strSql = "select distinct client_connect_ip,client_connect_port from tb_center_ip where device_type_id='" + DeviceType + "' and flag=1 and  center_id in(select device_no from server_clientCommand where commandNum='" + commandNum + "' )";

        DataSet ds = new DataSet();
        SQLHelper sh = new SQLHelper();
        try
        {
            ds = sh.GetDataSet(strSql);
        }
        catch
        {
            ds = null;
        }
        if (ds != null)
        {
            if (ds.Tables.Count > 0)
            {
                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    if (PublicMethod.RunSnippet(ds.Tables[0].Rows[i][0].ToString()))
                    {
                        strReturn = SendCmd(commandText, ds.Tables[0].Rows[i][0].ToString(), ds.Tables[0].Rows[i][1].ToString());//发送命令通道
                        if (strReturn != "1")
                        {
                            break;
                        }
                    }
                    else
                    {
                        strReturn = "client_connect_ip配置不正确！";
                        break;
                    }

                }
            }

        }

        return strReturn;

    }
    
    private static string For_send_Msg(string commandText, string commandNum)
    {
        string strReturn = "该采集器未配置client_connect_ip和client_connect_port";

        string strSql = "select distinct client_connect_ip,client_connect_port from equip_center where center_id in(select device_no from server_clientCommand where commandNum='" + commandNum + "') ";
        
        DataSet ds = new DataSet();
        SQLHelper sh = new SQLHelper();
        try
        {
            ds = sh.GetDataSet(strSql);
        }
        catch
        {
            ds = null;
        }
        if (ds != null)
        {
            if (ds.Tables.Count > 0)
            {
                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    if (PublicMethod.RunSnippet(ds.Tables[0].Rows[i][0].ToString()))
                    {
                        strReturn = SendCmd(commandText, ds.Tables[0].Rows[i][0].ToString(), ds.Tables[0].Rows[i][1].ToString());//发送命令通道
                        if (strReturn != "1")
                        {
                            break;
                        }
                    }
                    else
                    {
                        strReturn = "client_connect_ip配置不正确！";
                        break;
                    }

                }
            }

        }

        return strReturn;

    }
    
    //基本方法
    static Socket socketClient;
    public static string SendCmd(string sendstring, string ip, string port)
    {
        string requestStr = "5";//定义返回值

        //sendstring += (Convert.ToInt32(level) + 1) + "^" + selectnode;//组织命令格式，协议格式
        //DEER:1^等级^ID号
        //sendstring = "DEER:1^1001^1^1";

        string returnLink = "";
        returnLink = linkserver(ip, port);//建立连接
        if (returnLink == "success")
        {
            byte[] sendstr = System.Text.Encoding.ASCII.GetBytes(sendstring);
            sendinfo(sendstr, sendstr.Length);//发送命令
            byte[] reXML = new byte[1024];//定义接收数据变量//开始出问题
            //socketClient.
            try
            {
                socketClient.Receive(reXML);//接收数据
                string re = System.Text.Encoding.ASCII.GetString(reXML);//解析
                socketClient.Shutdown(SocketShutdown.Both);
                socketClient.Close();//关闭对象
                if (re.IndexOf("OK") >= 0)
                {
                    //requestStr = "2";//成功//需要更新服务器状态
                    requestStr = "1";//成功//需要更新服务器状态

                }
                else if (re.IndexOf("ERROR") > 0)
                {
                    requestStr = "服务端返回Error";//失败
                }
                else
                {
                    requestStr = "服务端发生未知情况";//服务端未启动，暂时没用
                }
            }
            catch (Exception ex)
            {
                requestStr = ex.Message;//服务端未启动，暂时没用
            }
        }
        else
        {
            requestStr = "与服务端建立连接失败";//建立连接失败
        }

        return requestStr;
    }

    public static void sendinfo(byte[] byteStr, int sendlength)
    {
        try
        {
            socketClient.Send(byteStr, sendlength, 0);
        }
        catch (Exception ce)
        {
        }
    }
  
    private static string linkserver(string ip, string portNo)
    {

        string rltstr = "";
        if (ip == "" || portNo == "")
        {
            return "";
        }
        socketClient = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
        IPAddress myIP = IPAddress.Parse(ip);
        IPEndPoint ipEty = new IPEndPoint(myIP, Convert.ToInt32(portNo));
        try
        {
            socketClient.ReceiveTimeout = 20000;//设置超时,20秒
            socketClient.Connect(ipEty);
            rltstr = "success";
        }
        catch (Exception ex)
        {
            rltstr = "fail";
        }
        return rltstr;
    }
    public bool IsReusable {
        get {
            return false;
        }
    }

}