<%@ WebHandler Language="C#" Class="treeMenu2" %>

using System;
using System.Web;
using System.Data;
using System.Collections.Generic;

public class treeMenu2 : IHttpHandler {

    private static string cookieTage = PublicMethod.public_getConfigStr("cookieTage");
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";

        string Role_id = "0";
        try
        {
            Role_id = DES_En_De.DesDecrypt(context.Request.Cookies[cookieTage]["pi3djdg001pl"]);
        }
        catch
        {
            //context.Response.Redirect("login.aspx");
        }
        SQLHelper db_helper = new SQLHelper();
        string sql = "select top 10 A.Module_id,A.Module_name,A.Ico_addr,A.IsOpened from Sys_module as A left join Sys_menu_module as B " +
                    " on A.Module_id=B.Module_id " +
                    " left join vw_Sys_role_module_qx as C on A.Module_id=C.Module_id " +
                    " where B.Sys_id='1' and C.Role_id="+Role_id+"  and A.Open_mark=1  order by A.Order_no ";
        DataTable dt = db_helper.GetDataTable(sql);
        //System.Threading.Thread.Sleep(10000);
        List<pnode> lp = new List<pnode>();
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            pnode pn = new pnode();
            pn.MenuName = dt.Rows[i]["Module_name"].ToString();
            pn.MenuIcon = dt.Rows[i]["Ico_addr"].ToString();
            pn.IsOpened = dt.Rows[i]["IsOpened"].ToString();//是否开启
            pn.MenuUrl = "";
            string mid = dt.Rows[i]["Module_id"].ToString();
            List<child> lc = new List<child>();
            string sql2 = "select top 20 A.Function_id,A.Function_name,A.Ico_addr,A.Function_addr from Sys_function as A left join "+
                           " vw_Sys_role_function_qx as B on A.Function_id=B.Function_id  " +
                            " where B.Role_id=" + Role_id + " and A.Module_id=" + mid + " and A.Open_mark=1 and A.flag=1 order by  A.Order_no";
            DataTable dt2 = db_helper.GetDataTable(sql2);
            for (int j = 0; j < dt2.Rows.Count; j++)
            {
                child c = new child();
                c.FuncId = dt2.Rows[j]["Function_id"].ToString();
                c.MenuName = dt2.Rows[j]["Function_name"].ToString();
                c.MenuIcon = dt2.Rows[j]["Ico_addr"].ToString();
                c.MenuUrl = dt2.Rows[j]["Function_addr"].ToString() + "?id=" + dt2.Rows[j]["Function_id"].ToString();
                lc.Add(c);
            }
            pn.children = lc;
            lp.Add(pn);
        }
        string json = Newtonsoft.Json.JsonConvert.SerializeObject(lp);
        context.Response.Write(json);
        context.Response.End();
    }
    
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    public class pnode {
        public string MenuName { get; set; }
        public string MenuIcon { get; set; }
        public string IsOpened { get; set; }
        public string MenuUrl { get; set; }
        public List<child> children { get; set; }
    }
    public class child {
        public string FuncId { get; set; }
        public string MenuName { get; set; }
        public string MenuIcon { get; set; }
        public string MenuUrl { get; set; }
    }
    

}