using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;

public partial class tree_MenuTree : System.Web.UI.Page
{
    public StringBuilder seriesDataMenu = new StringBuilder();

    protected void Page_Load(object sender, EventArgs e)
    {
        List<menuTreeClass> l = new List<menuTreeClass>();

        /*
        机器人管理
        任务管理
        实时监控
        巡检结果确认
        巡检结果分析
        用户设置
        机器人系统调试维护
         */
        menuTreeClass mtc = new menuTreeClass();
        mtc.no = "0";
        mtc.name = "机器人管理系统";
        mtc.pId = "";
        mtc.open = true;
        mtc.isParent = true;
        mtc.icon = "../lib/silkicons/1_CbManage.png";
        l.Add(mtc);
        #region
        menuTreeClass mtc1 = new menuTreeClass();
        mtc1.no = "10";
        mtc1.name = "机器人管理";
        mtc1.pId = "0";
        mtc1.open = true;
        mtc1.isParent = false;
        mtc1.icon = "../lib/silkicons/1_Sys_user.png";
        l.Add(mtc1);
        menuTreeClass mtc2 = new menuTreeClass();
        mtc2.no = "20";
        mtc2.name = "任务管理";
        mtc2.pId = "0";
        mtc2.open = true;
        mtc2.isParent = false;
        mtc2.icon = "../lib/silkicons/1_Yb_hot_index_statistics.png";
        l.Add(mtc2);
        menuTreeClass mtc3 = new menuTreeClass();
        mtc3.no = "30";
        mtc3.name = "实时监控";
        mtc3.pId = "0";
        mtc3.open = true;
        mtc3.isParent = false;
        mtc3.icon = "../lib/silkicons/1_qx.png";
        l.Add(mtc3);
        menuTreeClass mtc4= new menuTreeClass();
        mtc4.no = "40";
        mtc4.name = "巡检结果确认";
        mtc4.pId = "0";
        mtc4.open = true;
        mtc4.isParent = false;
        mtc4.icon = "../lib/silkicons/1_Statistics.png";
        l.Add(mtc4);
        menuTreeClass mtc5 = new menuTreeClass();
        mtc5.no = "50";
        mtc5.name = "巡检结果分析";
        mtc5.pId = "0";
        mtc5.open = true;
        mtc5.isParent = false;
        mtc5.icon = "../lib/silkicons/cd_go.png";
        l.Add(mtc5);
        menuTreeClass mtc6 = new menuTreeClass();
        mtc6.no = "60";
        mtc6.name = "用户设置";
        mtc6.pId = "0";
        mtc6.open = true;
        mtc6.isParent = false;
        mtc6.icon = "../lib/silkicons/color_swatch.png";
        l.Add(mtc6);

        menuTreeClass mtc7 = new menuTreeClass();
        mtc7.no = "70";
        mtc7.name = "机器人系统调试维护";
        mtc7.pId = "0";
        mtc7.open = true;
        mtc7.isParent = false;
        mtc7.icon = "../lib/silkicons/cog_add.png";
        l.Add(mtc7);



        #endregion

        seriesDataMenu.Append(Newtonsoft.Json.JsonConvert.SerializeObject(l));


    }
}

class menuTreeClass {

    public string no
    {
        get;
        set;
    }
    public string name
    {
        get;
        set;
    }
    public string pId
    {
        get;
        set;
    }
    public string icon
    {
        get;
        set;
    }
    public bool open
    {
        get;
        set;
    }
    public bool isParent
    {
        get;
        set;
    }
    
}