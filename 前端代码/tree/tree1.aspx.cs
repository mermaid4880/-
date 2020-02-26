using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Data;

public partial class tree_tree1 : System.Web.UI.Page
{
    public StringBuilder seriesDataMenu = new StringBuilder();
    protected void Page_Load(object sender, EventArgs e)
    {

        int iTreeLevel = int.Parse(PublicMethod.public_getConfigStr("treeShowLevel"));

        string sql = "";
        SQLHelper sh = new SQLHelper();
        string icon = "../lib/silkicons/1_Equip_jzq.png";
        seriesDataMenu.Append("[");


        seriesDataMenu.AppendFormat("{{name:'{0}',no:'A{1}',icon:'{2}',pId:'0',open:true}},", "监控点1","1", icon);
        seriesDataMenu.AppendFormat("{{name:'{0}',no:'A{1}',icon:'{2}',pId:'0',open:true}},", "监控点2", "1", icon);




        seriesDataMenu.Append("]");
    }
}